//
//  LFAddressViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFAddressViewController.h"
#import "LFNewAddRessHeaderView.h"
#import "TSAddressPickerView.h"
#import "LFAddressModel.h"

@interface LFAddressViewController ()
@property (nonatomic, strong) LFNewAddRessHeaderView * headerView;
@property (nonatomic,   copy) NSDictionary * addressDict;
@end

@implementation LFAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self CreateView];

}

/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    
    @weakify(self);
    
    self.ts_navgationBar = [TSNavigationBar navWithTitle:self.address ? @"编辑地址" : @"新增地址" backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}
-(void)CreateView{
    
    
    UIScrollView *scro = [[UIScrollView alloc]init];
    [self.view addSubview:scro];
    
    
    UIView * contentView  = [[UIView alloc]init];
    [scro addSubview:contentView];
    
    self.headerView = [LFNewAddRessHeaderView creatViewFromNib];
    @weakify(self);
    self.headerView.didClickProvinceBlock = ^{
        @strongify(self);
        [self.view endEditing:YES];
        TSAddressPickerView * pickerView = [TSAddressPickerView addressPickerView];
        pickerView.resultBlock = ^(NSDictionary * dict) {
            self.addressDict = [dict copy];
            LFProvince * p = dict[@"province"];
            LFCity * c = dict[@"city"];
            LFRegion * d = dict[@"district"];
            NSString * t = [NSString stringWithFormat:@"%@%@%@", p.provinceName, c.cityName, d.regionName];
            self.headerView.address = t;
        };
        [self.view addSubview:pickerView];
        
    };
    [contentView addSubview:self.headerView];
    if (self.address) {
        self.headerView.name.text = self.address.contactName;
        self.headerView.phone.text = self.address.contact;
        self.headerView.detail.text = self.address.address;
        self.headerView.province.text = [TSAddressPickerView addressForCityId:self.address.cityId];
        self.headerView.province.hidden = NO;
    }
    
    UIButton * button = [UIButton buttonWithTitle:@"保存地址" titleColor:HexColorInt32_t(c00d23) backgroundColor:HexColorInt32_t(f1f1f1) font:13 image:@"" frame:CGRectZero];
    [self.view addSubview:button];
    
    button.borderColor = HexColorInt32_t(C00D23);
    button.borderWidth = 1;
    [button addTarget:self action:@selector(TapSaveAddressBtn)];
    
    [scro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(64);
        make.bottom.offset(-64);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(scro);
        make.height.equalTo(scro);
        make.top.offset(0);
        make.left.offset(0);
        make.bottom.offset(0);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.width.mas_equalTo(kScreenWidth);
        make.bottom.offset(0);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.mas_equalTo(Fit375(40));
        make.bottom.offset(-Fit375(15));
    }];


    
}


-(void)TapSaveAddressBtn {
    
    SLAssert(self.headerView.name.hasText, @"请填写收货人姓名");
    SLAssert(self.headerView.phone.hasText, @"请填写手机号码");
    SLAssert([self.headerView.phone.text validateMobile], @"请填写手机号码");
    if (self.address == nil) {
        SLAssert(self.addressDict != nil, @"请选择省市区");
    }
    SLAssert(self.headerView.detail.hasText, @"请填写详细地址");
    
    SLLog2(@"保存地址");
    /*areaInfo	详细地址	string	@mock=详细地址
     cityId	城市ID	string	@mock=城市ID
     loginKey		string	@mock=00fa95958febf957bf48ce2aebde71db
     telephone	联系电话	string	@mock=联系电话
     trueName	姓名	string	@mock=叶莫*/
    
    NSString * url = !self.address ? @"address/addAddress.htm" : @"address/updateAddress.htm?";
    LFParameter * parameter = [LFParameter new];
    parameter.areaInfo = self.headerView.detail.text;
//    parameter.areaInfo = [NSString stringWithFormat:@"%@%@", self.headerView.address, self.headerView.detail.text];
    LFCity * c = self.addressDict[@"city"];
    parameter.cityId = c.cityId ? : self.address.cityId;
    parameter.telephone = self.headerView.phone.text;
    parameter.trueName = self.headerView.name.text;;
    parameter.addressId = self.address ? self.address.addressId : nil;
    [parameter appendBaseParam];
    
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        SVShowSuccess((!self.address ? @"添加成功" : @"修改成功"));
        BLOCK_SAFE_RUN(self.vBlock);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
}
- (void)dealloc {
    
}
 @end
