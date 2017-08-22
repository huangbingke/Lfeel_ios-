//
//  LFLeiBaiPayVC2.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/5/1.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFLeiBaiPayVC2.h"
#import "LFLeiBaiPayView.h"
#import "LFPayResultVC.h"

@interface LFLeiBaiPayVC2 ()
//<UITableViewDelegate, UITableViewDataSource>
//@property (nonatomic,   weak) UITableView * tableView;
///  <#Description#>
@property (nonatomic,   weak) LFLeiBaiPayView2 * payView;
@end

@implementation LFLeiBaiPayVC2

#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    
    [self setupNavigationBar];
}

///  初始化子控件
- (void)setupSubViews {
    
    UIScrollView * scrollView = [UIScrollView defaultScrollView];
    [self.view addSubview:scrollView];
    
    LFLeiBaiPayView2 * payView = [LFLeiBaiPayView2 creatView];
    payView.frame = Rect(0, 0, kScreenWidth, Fit(payView.height));
    [scrollView addSubview:payView];
    self.payView = payView;
    
    @weakify(self);
    [payView setDidSendVerifyBlock:^{
        @strongify(self);
        [self _requestVerify];
    } sureBlock:^{
        @strongify(self);
        [self.view endEditing:YES];
        [self _requestPay];
    }];
    
    scrollView.contentSize = Size(0, payView.maxY);
}

///  设置自定义导航条
- (void)setupNavigationBar {
    @weakify(self);
    NSString * title = @"分期付款";
    self.ts_navgationBar = [TSNavigationBar navWithTitle:title backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Actions


#pragma mark - Networking
/// 请求验证码
- (void)_requestVerify {
    
    NSString * url = @"login/gainCode.htm?";
    LFParameter * parameter = [LFParameter new];
    parameter.mobilePhone = self.payView.phone.text;
    [parameter appendBaseParam];
    
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        
        [self.payView.sendVerifyBtn countDownWithTime:60 title:@"获取验证码" countDownTitle:@"s" backgroundColor:HexColorInt32_t(E8BE64) disabledColor:HexColorInt32_t(E8BE64)];
        
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];

}

///  请求乐百分支付
- (void)_requestPay {
    /*
     accNo	卡号	string
     cvn	svn号	string
     idCard	身份证号	string
     loginKey	登陆KEY	string
     name	姓名	string
     orderId	订单ID	string
     phone	卡预留手机号	string
     smsCode	验证码	string
     txnAmt	金额单位分	string
     txnTerms	分期8或者12	string
     validDate	有效期1012	string	对应10月12
     */
    NSString * url = @"lbPay/lbStages.htm?";
    LFParameter * parameter = [LFParameter new];
    parameter.phone = self.payView.phone.text;
    parameter.accNo = self.payView.cardNum.text;
    parameter.cvn = self.payView.cnv2.text;
    parameter.idCard = self.payView.identifyCardID.text;
    parameter.name = self.payView.name.text;
        parameter.validDate = [NSString stringWithFormat:@"%@%@", self.payView.month.text, self.payView.year.text];
//    parameter.phone = @"13298368875";
//    parameter.accNo = @"370248476988912";
//    parameter.cvn = @"245";
//    parameter.idCard = @"330201199608164112";
//    parameter.name = @"李刚";
//    parameter.validDate = @"0722";
    
    parameter.smsCode = self.payView.verify.text;
    parameter.orderId = self.payModel.order_id;
    parameter.txnAmt = self.payModel.price;
    parameter.txnTerms = [NSString stringWithFormat:@"%zd", self.payModel.stageCount];
    
    [parameter appendBaseParam];
    
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
       NSString *dateStr = [self timeWithTimeIntervalString:[NSString stringWithFormat:@"%@", request[@"orderTime"]]];
        LFPayResultVC * controller = [[LFPayResultVC alloc] init];
        controller.orderInfo = @{
                                 @"totalPrice" : stringWithDouble(self.payModel.price.doubleValue / 100),
                                 @"orderCode"  : self.payModel.order_sn,
                                 @"orderTime" : dateStr
                                 };
        controller.success = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
}
#pragma mark - Delegate

@end
