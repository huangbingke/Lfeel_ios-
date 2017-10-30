//
//  LFSecurityViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/23.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFSecurityViewController.h"

@interface LFSecurityViewController ()
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PhoneTopConstraint;
///验证信息
@property (weak, nonatomic) IBOutlet UILabel *verifyLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *iphoneText;
@property (weak, nonatomic) IBOutlet UITextField *VifftyCodeText;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LFSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupNavigationBar];
    self.verifyLabel.text = @"点击获取验证码";
    self.messageView.hidden = YES;
    [self.PhoneTopConstraint setConstant:0];
    
    //18688402893
//    self.iphoneText.text = @"13298368875";
//    self.iphoneText.text = @"18688402893";
//    self.iphoneText.text = @"15627284287";
//    self.VifftyCodeText.text = @"1234";
    
}
/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    
    @weakify(self);
    NSString * title = @"登 录";
//    if (self.isBind) {
//        title = @"绑定手机";
//        self.loginBtn.title = @"确定";
//    }
    self.ts_navgationBar = [TSNavigationBar navWithTitle:title backAction:^{
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}
- (IBAction)TapSelectLogin:(id)sender {
    [self.view endEditing:YES];
    SLVerifyPhone(self.iphoneText.text, @"请输入正确的手机号码");
    SLVerifyText(self.VifftyCodeText.text,  @"请输入验证码");

//    if (self.isBind) {
//        [self _requestBindData];
//        return;
//    }
//    [self HttpRequestLogin];
    [self requestSmsCodeLogin];
}
- (IBAction)selecteTapVerifyBtn:(UIButton *)sender {
    
    SLVerifyPhone(self.iphoneText.text, @"请输入正确的手机号码");
    [self _requestSendVerify:sender];
 
}


#pragma mark - 网络请求
///  请求验证码
- (void)_requestSendVerify:(UIButton *)sender {
    NSString * url = @"login/gainCode.htm";
    LFParameter * params = [LFParameter new];
    params.mobilePhone = self.iphoneText.text;
    [TSNetworking POSTWithURL:url paramsModel:params completeBlock:^(NSDictionary *request) {
        SLLog2(@"request :%@",request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        
        self.messageView.hidden = NO;
        [self.PhoneTopConstraint setConstant:Fit375(40)];
        [sender countDownWithTime:60 title:@"重新获取" countDownTitle:@"s重新获取" backgroundColor:[UIColor whiteColor] disabledColor:HexColorInt32_t(C20D20)];
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
    
}


/**
 验证码登录
 */
- (void)requestSmsCodeLogin {
    LFParameter *paeme = [LFParameter new];
    paeme.mobilePhone = self.iphoneText.text;
    paeme.passWord = self.VifftyCodeText.text;
    paeme.type = @"2";//1=密码登录；2=验证码登录
    [TSNetworking POSTWithURL:@"login/login.htm?" paramsModel:paeme completeBlock:^(NSDictionary *request) {
        NSLog(@"%@", request);
        if ([request[@"result"] integerValue] == 200) {
            [self removeUserInfo];
            //  NSLog(@"~~~~~~%@", [User getUseDefaultsOjbectForKey:KLogin_Info]);
//            [User saveUseDefaultsOjbect:request forKey:KLogin_Info];
//            [User saveUserInfomation:request];
//            [User saveUseDefaultsOjbect:request[@"isVip"] forKey:kVipStatus];
//            [User saveUseDefaultsOjbect:request[@"parent_id"] forKey:kParent_id];
            
            [User saveUseDefaultsOjbect:request forKey:KLogin_Info];
            [User saveUserInfomation:request];
            [User saveUseDefaultsOjbect:request[@"isVip"] forKey:kVipStatus];
            [User saveUseDefaultsOjbect:request[@"parent_id"] forKey:kParent_id];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            SVShowError(request[@"msg"]);
        }
        
    } failBlock:^(NSError *error) {
//        NSLog(@"")
    }];
    
}




//-(void)HttpRequestLogin{
//    NSString * url =@"login/login.htm?";
//    LFParameter *paeme = [LFParameter new];
//    paeme.mobilePhone = self.iphoneText.text;
//    paeme.passWord = self.VifftyCodeText.text; //
//    paeme.type = @"2";//1=密码登录；2=验证码登录
//    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
//        
//        SLLog2(@"requess :%@", request);
//        
//        if ([request[@"result"] integerValue]==200) {
//            [User saveUserInfomation:request];
//            [self dismissViewControllerAnimated:YES completion:nil];
//        } else {
//            SVShowError(request[@"msg"]);
//        }
//        
//    } failBlock:^(NSError *error) {
//        SLShowNetworkFail;
//    }];
//}
//
/////  绑定手机
//- (void)_requestBindData {
//    NSString * url =@"login/mobile_bind.htm?";
//    LFParameter *paeme = [LFParameter new];
//    paeme.mobilePhone = self.iphoneText.text;
//    paeme.smsCode = self.VifftyCodeText.text;
//    paeme.loginKey = self.loginKey;
//    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
//        
//        SLLog2(@"requess :%@", request);
//        
//        if ([request[@"result"] integerValue]==200) {
//            [User saveUserInfomation:@{@"loginKey" : self.loginKey}];
//            [self dismissViewControllerAnimated:YES completion:nil];
//        } else {
//            SVShowError(request[@"msg"]);
//        }
//        
//    } failBlock:^(NSError *error) {
//        SLShowNetworkFail;
//    }];
//    
//}

@end
