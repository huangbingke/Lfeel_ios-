//
//  LFChangePassWorldViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/22.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFChangePassWorldViewController.h"

@interface LFChangePassWorldViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextF;
@property (weak, nonatomic) IBOutlet UITextField *viffCodeTextF;

@property (weak, nonatomic) IBOutlet UITextField *pwdTextFei;
@property (weak, nonatomic) IBOutlet UITextField *NewPwdTextF;
@property (weak, nonatomic) IBOutlet UITextField *NewPwdTextF1;
@property (weak, nonatomic) IBOutlet UIButton *ViffBtn;

@end

@implementation LFChangePassWorldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];

}
/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    @weakify(self);
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"修改密码" backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated: YES];
    }];
}

- (IBAction)TapSelectCode:(UIButton *)sender {
    SLVerifyText(self.phoneTextF.text.length, @"请输入手机号码");
    [self _requestSendVerify:sender];
}


- (IBAction)TapSelectSaveBtn:(id)sender {
    SLVerifyText(self.phoneTextF.text.length, @"请输入手机号码");
    SLVerifyText(self.viffCodeTextF.text.length, @"请输入验证码");
    SLVerifyText(self.pwdTextFei.text.length, @"请输入密码");
    SLVerifyText(self.NewPwdTextF.text.length, @"请输入新密码");
    SLVerifyText(self.NewPwdTextF1.text.length, @"请再次输入新密码");
    if (![self.NewPwdTextF.text isEqualToString:self.NewPwdTextF1.text]) {
        SVShowError(@"两次密码输入不一致");
        return;
    }
    [self HttpRequestChangePassword];
    
}








-(void)HttpRequestChangePassword{
    NSString * url =@"login/changePassword.htm";
    LFParameter *paeme = [LFParameter new];
    paeme.oldPassWord = self.pwdTextFei.text;
    paeme.nPassWord = self.NewPwdTextF1.text;
    paeme.mobilePhone = self.phoneTextF.text;
    paeme.smsCode = self.viffCodeTextF.text;
    
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
        
    } failBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 网络请求
///  请求验证码
- (void)_requestSendVerify:(UIButton *)sender {
    NSString * url = @"login/gainCode.htm";
    LFParameter * params = [LFParameter new];
    params.mobilePhone = self.phoneTextF.text;
    [TSNetworking POSTWithURL:url paramsModel:params completeBlock:^(NSDictionary *request) {
        SLLog2(@"request :%@",request);
        [sender countDownWithTime:60 title:@"重新获取" countDownTitle:@"s重新获取" backgroundColor:[UIColor whiteColor] disabledColor:HexColorInt32_t(C20D20)];
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
    
}











@end
