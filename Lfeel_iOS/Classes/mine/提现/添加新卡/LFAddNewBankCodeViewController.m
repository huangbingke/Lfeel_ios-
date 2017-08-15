//
//  LFAddNewBankCodeViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFAddNewBankCodeViewController.h"
#import "LFBankListViewController.h"

@interface LFAddNewBankCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UIView *viffiyCode;
@property (weak, nonatomic) IBOutlet UITextField *banknameTextF;
@property (weak, nonatomic) IBOutlet UIButton *BtnCode;

@property (weak, nonatomic) IBOutlet UITextField *codeBankNumber;
@property (weak, nonatomic) IBOutlet UITextField *vifftyCode;

@end

@implementation LFAddNewBankCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    
}
/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    
    @weakify(self);
    
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"添加银行卡" backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (IBAction)TapCodeBtn:(id)sender {
    
    [self vifftyBtn];
    [self _requestSendVerify:self.BtnCode];
    
}

#pragma mark - 网络请求
///  请求验证码
- (void)_requestSendVerify:(UIButton *)sender {
    NSString * url = @"login/gainCode.htm?";
    LFParameter * params = [LFParameter new];
    params.mobilePhone = self.phoneText.text;
    [TSNetworking POSTWithURL:url paramsModel:params completeBlock:^(NSDictionary *request) {
        SLLog2(@"request :%@",request);
        [sender countDownWithTime:60 title:@"重新获取" countDownTitle:@"s重新获取" backgroundColor:[UIColor whiteColor] disabledColor:HexColorInt32_t(C20D20)];
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
    
}


-(void)vifftyBtn{
    SLVerifyText(self.userName.text.length, @"请输入持卡人姓名");
    SLVerifyText(self.codeBankNumber.text.length, @"请输入卡号");
    SLVerifyText(self.banknameTextF.text.length, @"请选择银行名称");
    SLVerifyText(self.phoneText.text.length, @"请输入手机号");
}


- (IBAction)TapSelectBankBtn:(id)sender {
    SLLog2(@"选择银行");
    LFBankListViewController * bank = [[LFBankListViewController alloc]init];
    @weakify(self);
    bank.didSelectBankName =^(NSString *string){
        @strongify(self);
        self.banknameTextF.text =string;
    };
    [self.navigationController pushViewController:bank animated:YES];
    
}

- (IBAction)TapAddBankBtn:(id)sender {
    [self vifftyBtn];
    SLVerifyText(self.vifftyCode.text.length, @"请输入验证码");
    NSString *url = @"personal/addUserBank.htm?";
    LFParameter * parme = [LFParameter new];
    parme.accountName= self.userName.text;
    parme.accountNo = self.codeBankNumber.text;
    parme.bankFullName = self.banknameTextF.text;
    parme.loginKey = user_loginKey;
    
    [TSNetworking POSTWithURL:url paramsModel:parme completeBlock:^(NSDictionary *request) {
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        
        
        [self.navigationController popViewControllerAnimated:YES];
       
        if (self.didRefreshbank) {
            self.didRefreshbank();
        }
        
        
        
    } failBlock:^(NSError *error) {
        
    }];

}

@end
