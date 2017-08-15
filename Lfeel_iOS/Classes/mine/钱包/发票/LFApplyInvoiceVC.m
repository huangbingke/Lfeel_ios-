//
//  LFApplyInvoiceVC.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/4/16.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFApplyInvoiceVC.h"
#import "LFMineAddressViewController.h"
#import "LFSettleCenterView.h"

@interface LFApplyInvoiceVC ()
//<UITableViewDelegate, UITableViewDataSource>
//@property (nonatomic,   weak) UITableView * tableView;
@property (weak, nonatomic) IBOutlet UIView *container;

@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UIView *typeView;

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *titles;

@property (weak, nonatomic) IBOutlet UITextField *contact;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIView *addressView;

@end

@implementation LFApplyInvoiceVC {
    NSInteger _selectedType;
    LFAddressModel * _selectedAddress;
}

#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    
    [self setupNavigationBar];
    
}

///  初始化子控件
- (void)setupSubViews {
    _selectedType = -1;
    self.account.text = [NSString stringWithFormat:@"%@",self.totalPrice];
    // 点击类型
    @weakify(self);
    UITapGestureRecognizer * typeTap = [UITapGestureRecognizer new];
    [typeTap.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        [LFSelectedInvoiceTypeView showWithCompleteHandle:^(NSInteger payType) {
            self->_selectedType = payType;
            NSArray * arr = @[@"开具公司发票", @"开具个人发票"];
            self.type.text = arr[payType];
            self.type.hidden = NO;
        } selectedType:self->_selectedType];
        
    }];
    [self.typeView addGestureRecognizer:typeTap];
    
    
    // 点击地址
    UITapGestureRecognizer * addressTap = [UITapGestureRecognizer new];
    [addressTap.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        LFMineAddressViewController * controller = [[LFMineAddressViewController alloc] init];
        controller.didSelectedAddressBlock = ^(LFAddressModel *address) {
            self.address.text = address.address;
            self.address.hidden = NO;
            self->_selectedAddress = address;
        };
        [self.navigationController pushViewController:controller animated:YES];
    }];
    [self.addressView addGestureRecognizer:addressTap];
    
    
}

///  设置自定义导航条
- (void)setupNavigationBar {
    @weakify(self);
    NSString * title = @"申请发票";
    self.ts_navgationBar = [TSNavigationBar navWithTitle:title backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Actions
/// 点击确定
- (IBAction)_didClickSubmit:(id)sender {
    
    SLAssert(self.account.hasText, @"请输入发票金额");
    SLAssert(_selectedType != -1, @"请选择发票类型");
    
    SLAssert(self.name.hasText, @"请输入发票项目");
    SLAssert(self.titles.hasText, @"请输入发票抬头");
    
    SLAssert(self.contact.hasText, @"请输入联系人");
    SLAssert(self.phone.hasText, @"请输入手机号码");
    SLVerifyPhone(self.phone.text, @"手机号码格式不正确");
    SLAssert(_selectedAddress != nil, @"请选择收货地址");
    /*areaId	地址ID	string
     invoiceName	发票抬头	string
     invoiceType	发票类型	string	1=个人 2=公司
     loginKey	登陆KEY	string
     orderIds	订单ID，勾选了多个以;隔开	string
     prom	项目	string
     telName	联系人	string
     telephone	联系方式	string
     totalPrice	总价	string	*/
    NSString * url = @"personal/applyInvoiceList.htm?";
    LFParameter * parameter = [LFParameter new];
    parameter.areaId = _selectedAddress.addressId;
    parameter.invoiceName = self.titles.text;
    parameter.invoiceType = _selectedType == 0 ? @"2" : @"1";
    parameter.prom = self.name.text;
    parameter.telName = self.contact.text;
    parameter.telephone = self.phone.text;
    parameter.totalPrice = self.totalPrice;
    parameter.orderIds = self.IDs;
    
    [parameter appendBaseParam];
    
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        
        SVShowSuccess(request[@"msg"]);
        BLOCK_SAFE_RUN(self.vBlock);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];

}


#pragma mark - Networking


#pragma mark - Delegate

#pragma mark - Private


#pragma mark - Public


#pragma mark - Getter\Setter

@end
