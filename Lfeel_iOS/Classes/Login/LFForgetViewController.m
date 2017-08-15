//
//  LFForgetViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/23.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFForgetViewController.h"

@interface LFForgetViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextf;
@property (weak, nonatomic) IBOutlet UITextField *viffTextF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *newtextF;

@property (weak, nonatomic) IBOutlet UITextField *pwdTextF;
@end

@implementation LFForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self.contentView rm_fitAllConstraint];
}

/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    
    @weakify(self);
    
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"忘记密码" backAction:^{
        @strongify(self);
       [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (IBAction)TapSeleceCode:(UIButton*)sender {
    SLAssert(self.phoneTextf.hasText, @"请输入手机号码");
    SLVerifyPhone(self.phoneTextf.text, @"手机号码格式不正确");
    [self _requestSendVerify:sender];
    
}

#pragma mark - 网络请求
///  请求验证码
- (void)_requestSendVerify:(UIButton *)sender {
    
    
    
    NSString * url = @"login/gainCode.htm";
    LFParameter * params = [LFParameter new];
    params.mobilePhone = self.phoneTextf.text;
    [TSNetworking POSTWithURL:url paramsModel:params completeBlock:^(NSDictionary *request) {
        SLLog2(@"request :%@",request);
        
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        SVShowSuccess(request[@"msg"]);
        [sender countDownWithTime:60 title:@"重新获取" countDownTitle:@"s重新获取" backgroundColor:[UIColor whiteColor] disabledColor:HexColorInt32_t(C20D20)];
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
    
}


- (IBAction)TapSaveBtn:(id)sender {
   
    [self.view endEditing:YES];
    
    SLVerifyText(self.phoneTextf.text.length , @"请输入手机号码");
    SLVerifyPhone(self.phoneTextf.text, @"手机号码格式不正确");
    SLVerifyText(self.viffTextF.text.length , @"请输入验证码");
    SLVerifyText(self.pwdTextF.text.length , @"请输入密码");
    SLVerifyText(self.newtextF.text.length , @"请输入新密码");
    
    
    if (![self.newtextF.text isEqualToString:self.pwdTextF.text]) {
        SVShowError(@"两次密码不一致");
        return;
    }
 
    
    
    NSString * url =@"login/forgotPassword.htm";
    LFParameter *paeme = [LFParameter new];
    paeme.mobilePhone = self.phoneTextf.text;
    paeme.nPassWord = self.newtextF.text;
    paeme.smsCode = self.viffTextF.text;
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        
        if ([request[@"result"] integerValue]!= 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        SVShowSuccess(request[@"msg"]);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
    }];
}



@end
