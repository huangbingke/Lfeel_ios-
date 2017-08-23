//
//  LFChangePassWorldViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/22.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFChangePassWorldViewController.h"

@interface LFChangePassWorldViewController ()

@property (weak, nonatomic) IBOutlet UITextField *pwdTextFei;
@property (weak, nonatomic) IBOutlet UITextField *NewPwdTextF;
@property (weak, nonatomic) IBOutlet UITextField *NewPwdTextF1;

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




- (IBAction)TapSelectSaveBtn:(id)sender {
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
    paeme.mobilePhone = @"13298368875";
    paeme.smsCode = @"123456";
    
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













@end
