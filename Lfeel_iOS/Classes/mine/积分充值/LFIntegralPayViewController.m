//
//  LFIntegralPayViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFIntegralPayViewController.h"
#import "LFPayModule.h"
#import "LFMoneyList.h"
#import "LFSettleCenterView.h"
#import "LFPayResultVC.h"
#import "LFSettleCenterVC.h"

@interface LFIntegralPayViewController ()
///  <#Description#>
@property (nonatomic, strong) LFMoneyList * list;
@end

@implementation LFIntegralPayViewController
{ NSInteger payType1;
    NSString *amount1;
    NSString * select;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    select = @"";
    payType1 = 0;
    [self setupNavigationBar];
    [self CreateView];
    [self.list settitleLebelText:@"支付宝"] ;
    
}
/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    
    @weakify(self);
    
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"积分充值" backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

-(void)CreateView{
    UIScrollView * scro = [[UIScrollView alloc]initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-64)];
    scro.backgroundColor = HexColorInt32_t(f1f1f1);
    [self.view addSubview:scro];
    
    LFPayModule * paymodule = [LFPayModule creatViewFromNib];
    paymodule.frame =    Rect(0, Fit375(11), kScreenWidth, Fit375(88));
    @weakify(self);
    paymodule.didSelectAmount =^(NSString * amount){
        @strongify(self);
        self -> amount1 = amount;
    };
    [scro addSubview:paymodule];
    
    LFMoneyList * list = [LFMoneyList creatViewFromNib];
    list.frame = Rect(0 , CGRectGetMaxY(paymodule.frame)+Fit375(10), kScreenWidth, Fit375(45));

    self.list = list;
    list.didClickSelectedText =^{
        @strongify(self);
        self  -> select = @"1";
        [self TapSelectPay];
    };
    [scro addSubview:list];
    
    
    UIButton * subimtBtn = [[UIButton alloc]initWithFrame:Rect(Fit375(14) , scro.height-Fit375(33)-Fit375(36), kScreenWidth-Fit375(28), Fit375(36))];
    subimtBtn.backgroundColor = HexColorInt32_t(f1f1f1);
    [subimtBtn setTitle:@"确认充值"];
    [subimtBtn setTitleColor:HexColorInt32_t(C00D23)];
    subimtBtn.borderColor = HexColorInt32_t(C00D23);
    subimtBtn.borderWidth = 1;
    [subimtBtn addTarget:self action:@selector(TapSelectSubimitPay)];
    
    [scro addSubview:subimtBtn];
    
    
}

-(void)TapSelectPay{
    [self.view endEditing:YES];
    [LFSettleCenterSelectPayTypeView showWithCompleteHandle:^(PayType payType) {
        self ->payType1 = payType;
        NSArray * arr = @[@"信用卡分期", @"支付宝", @"微信支付", @"银联支付"];
        [self.list settitleLebelText:arr[payType1 + 1]] ;
        SLLog(payType);
    } selectedType:payType1 + 1 needFenQing:NO];
    
    

}

-(void)TapSelectSubimitPay{
 
    [self.view endEditing:YES];
    SLVerifyText(amount1.length, @"请输入金额");
    SLVerifyText(select.length, @"请选择支付方式");
    
    [self HTTPRequest];
}

-(void)HTTPRequest{
    NSString * url =@"personal/integralRecharge.htm?";
    LFParameter *paeme = [LFParameter new];
    NSArray * arr = @[@"1", @"2", @"3"];
    paeme.payType = arr[payType1];
    paeme.loginKey = user_loginKey;
    paeme.amount = amount1;
    @weakify(self);
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        @strongify(self);
        SLLog(request);
        if ([request[@"result"]integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        [self pay:request];
    } failBlock:^(NSError *error) {
        SLLog(error);
    }];
}


-(void)pay:(NSDictionary *)dict{
    NSString *  orderCode  = dict[@"orderCode"];
    NSString * totalPrice  = dict[@"totalPrice"];
    NSString * priceFen = stringWithInteger(totalPrice.doubleValue * 100);
    [LFPayHelper payWithType:payType1 + 1 price:priceFen orderNum:orderCode showInViewController:self completionHandle:^(BOOL success, NSString *msg) {
        if (success) {
            SVShowSuccess(@"充值成功");
            BLOCK_SAFE_RUN(self.vBlock);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            SVShowSuccess(@"充值失败");
        }
    }];
}
@end
