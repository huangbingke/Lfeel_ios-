//
//  LFLeiBaiPayVC3.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/5/1.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFLeiBaiPayVC3.h"
#import "LFLeiBaiPayView.h"
#import "LFLeiBaiPayVC2.h"
#import "LFPayResultVC.h"

@interface LFLeiBaiPayVC3 ()
@property (nonatomic,   weak) LFLeiBaiPayView3 * payView;
@end

@implementation LFLeiBaiPayVC3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    
    [self setupNavigationBar];
}

///  初始化子控件
- (void)setupSubViews {
    
    UIScrollView * scrollView = [UIScrollView defaultScrollView];
    [self.view addSubview:scrollView];
    
    LFLeiBaiPayView3 * payView = [LFLeiBaiPayView3 creatView];
    payView.frame = Rect(0, 0, kScreenWidth, Fit(payView.height));
    payView.bankCardList = self.payModel.bankCardList.copy;
    [scrollView addSubview:payView];
    self.payView = payView;
    
    @weakify(self);
    [payView setDidSendVerifyBlock:^{
        @strongify(self);
        SLAssert(self.payView.phone.hasText, @"请输入手机号");
        [self _requestVerify];
    } sureBlock:^{
        @strongify(self);
        
        [self.view endEditing:YES];
        [self _requestPay];
    } addNewCardBlock:^{
        LFLeiBaiPayVC2 * controller = [[LFLeiBaiPayVC2 alloc] init];
        controller.payModel = self.payModel;
        [self.navigationController pushViewController:controller animated:YES];
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
    parameter.accNo = self.payView.selectedCard.accNo;
    parameter.cvn = self.payView.cnv2.text;
    parameter.idCard = self.payView.selectedCard.idCard;
    parameter.name = self.payView.selectedCard.name;
    parameter.smsCode = self.payView.verify.text;
    parameter.orderId = self.payModel.order_id;
    parameter.txnAmt = self.payModel.price;
    parameter.txnTerms = [NSString stringWithFormat:@"%zd", self.payModel.stageCount];
    parameter.validDate = [NSString stringWithFormat:@"%@%@", self.payView.month.text, self.payView.year.text];
    
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

#pragma mark - Private


#pragma mark - Public


#pragma mark - Getter\Setter

@end
