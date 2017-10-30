//
//  LFPackInfoViewController.m
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/10/25.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFPackInfoViewController.h"
#import "LFPackSuccessViewController.h"
#import "LFMineAddressViewController.h"
#import "LFBuyModels.h"
@interface LFPackInfoViewController ()
////////////////////////////////-------地址------/////////////////////
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;////////////
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;//////////
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;/////////////
/////////////////////////////////////////////////////////////////////
@property (weak, nonatomic) IBOutlet UILabel *selectAddressLabel;


//////////////////////////////-------商品------//////////////////////
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;///
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;///////////
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;///////////
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;////////////
////////////////////////////////////////////////////////////////////

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (nonatomic, strong) LFAddressModel * addressModel;




@end

@implementation LFPackInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self _requestAddressList];
    
    
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:self.goodsModel.goodsUrl]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@", self.goodsModel.goodsName];
//    self.brandLabel.text = [NSString stringWithFormat:@"%@", self.goodsModel.good];
//    self.sizeLabel.text = [NSString stringWithFormat:@"%@", self.goodsModel.];
    
    
    [self setupNavigationBar];
}


///  设置自定义导航条
- (void)setupNavigationBar {
    @weakify(self);
    NSString * title = @"寄回盒子";
    self.ts_navgationBar = [TSNavigationBar navWithTitle:title backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}



- (IBAction)packBox:(id)sender {
    if (!self.addressModel) {
        SVShowError(@"请选择地址");
    }
    
    [self requestPackBoxData];
}

- (IBAction)selectAddress:(UIButton *)sender {
    LFMineAddressViewController * controller = [[LFMineAddressViewController alloc] init];
    controller.didSelectedAddressBlock = ^(LFAddressModel *model) {
        [self _setupAddress:model];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

///  请求默认地址
- (void)_requestAddressList {
    
    NSString * url = @"address/addressList.htm?";
    LFParameter * parameter = [LFParameter new];
    parameter.defaultStatus = @"1";
    
    [parameter appendBaseParam];
    
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        if ([(NSArray *)request[@"jsonAddressList"] count] == 0) {
            self.nameLabel.text = @"";
            self.addressLabel.text = @"";
            self.phoneLabel.text = @"";
            self.selectAddressLabel.text = @"请选择地址";
        } else {
            self.addressModel = [LFAddressModel yy_modelWithJSON:[(NSArray *)request[@"jsonAddressList"] firstObject]];
            NSLog(@"%@", self.addressModel.contact);
            [self _setupAddress:self.addressModel];
        }
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
}


- (void)requestPackBoxData {
    //普通订单, 租赁订单,
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    NSString * url =@"order/application.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.user_id = dic[@"user_id"];
    paeme.type = @"2";
    paeme.remark = @"打包";
    paeme.price = @"";
    paeme.keyword = self.goodsModel.goodsId;//
    paeme.addressId = self.addressModel.addressId;
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] == 200) {
            LFPackSuccessViewController *packVC = [[LFPackSuccessViewController alloc] init];
            packVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:packVC animated:YES];
        } else {
            SVShowError(request[@"msg"]);
        }
    } failBlock:^(NSError *error) {
        SLLog(error);
    }];
}

- (void)_setupAddress:(LFAddressModel *)model {
    self.selectAddressLabel.text = @"";
    self.nameLabel.text = [NSString stringWithFormat:@"寄件人: %@", model.contactName];
    self.phoneLabel.text = model.contact;
    self.addressLabel.text = model.address;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
