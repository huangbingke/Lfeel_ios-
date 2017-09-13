//
//  LFLoginViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/23.
//  Copyright © 2017年 Seven. All rights reserved.
//


#import "LFLoginViewController.h"//
#import "LFSecurityViewController.h"
#import "LFForgetViewController.h"
#import "LFRegisterViewController.h"
#import "LFThirdView.h"
#import <UMSocialCore/UMSocialCore.h>

@interface LFLoginViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UITextField *iphoneText;
@property (weak, nonatomic) IBOutlet UITextField *passWordText;

@end

@implementation LFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setupNavigationBar];
    [self.scrollView rm_fitAllConstraint];
 
    [IQKeyboardManager sharedManager].enable = true;
    
    UIView * bgView = [[UIView alloc]initWithFrame:Rect(0, Fit(400), kScreenWidth, Fit(Fit(140)))];
    bgView.backgroundColor = [UIColor whiteColor];
    
    [self.container addSubview:bgView];
    
    
    
//    LFThirdView * thirdView = [LFThirdView creatViewFromNib];
//    thirdView.frame = Rect(0, 0, bgView.width, Fit(bgView.height));
//    [bgView addSubview:thirdView];
//    thirdView.didClickThirdBtnBlock = ^(NSInteger index) {
//        UMSocialPlatformType type[] = {UMSocialPlatformType_WechatSession, UMSocialPlatformType_QQ};
//        
//        [[UMSocialManager defaultManager] getUserInfoWithPlatform:type[index] currentViewController:self completion:^(id result, NSError *error) {
//            if (error) {
//                return ;
//            }
//            UMSocialUserInfoResponse *userinfo = result;
//            SLLog(userinfo.name);
//            SLLog(userinfo.iconurl);
//            SLLog(userinfo.gender);
//            NSString * type = @"1";
//            if (index == 0) {
//                type = @"2";
//            }
//            [self _requestThirdLogin:userinfo type:type];
//        }];
//    };
}


/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    
    @weakify(self);
    NSString * title = @"登录";
    self.ts_navgationBar = [TSNavigationBar navWithTitle:title backAction:^{
        @strongify(self);
        if (self.presentingViewController) {
            VoidBlcok vb = nil;
            if (self.needPopToRootVC) {
                UITabBarController * tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                UINavigationController * nav = (UINavigationController *)tabbar.selectedViewController;
                [nav popToRootViewControllerAnimated:NO];
                tabbar.selectedIndex = 0;
            }
            [self dismissViewControllerAnimated:YES completion:vb];
        } else {
            if (self.needPopToRootVC) {
                [self.navigationController popToRootViewControllerAnimated:NO];
                UITabBarController * tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                tabbar.selectedIndex = 0;
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}


#pragma mark - Action
- (IBAction)TapDidLogin:(id)sender {
    [self.view endEditing:YES];
    SLAssert(self.iphoneText.hasText, @"请输入手机号码")
    SLVerifyPhone(self.iphoneText.text, @"手机号码格式不正确");
    SLAssert(self.passWordText.hasText, @"请输入密码");
    
    [self HttpRequestLogin];
    
}

#pragma mark - 验证码登录
- (IBAction)LFSecurityLogin:(id)sender {
    LFSecurityViewController * security = [[LFSecurityViewController alloc]init];
    [self.navigationController pushViewController:security animated:YES];
}
//忘记密码
- (IBAction)forgetPassWorld:(id)sender {
    SLLog2(@"忘记密码");
    LFForgetViewController * forget = [[LFForgetViewController alloc]init];
    [self.navigationController pushViewController:forget animated:YES];
}
//注册
- (IBAction)tapRegisterBtn:(id)sender {
    LFRegisterViewController * Register = [[LFRegisterViewController alloc]init];
    Register.userPassBlock = ^(NSString *username, NSString *password) {
        self.iphoneText.text = username;
        self.passWordText.text = password;
    };
    [self.navigationController pushViewController:Register animated:YES];
}


-(void)HttpRequestLogin{
    NSString * url =@"login/login.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.mobilePhone = self.iphoneText.text;
    paeme.passWord = self.passWordText.text; //
    paeme.type = @"1";//1=密码登录；2=验证码登录
    
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue]==200) {
            [self removeUserInfo];
//            NSLog(@"~~~~~~%@", [User getUseDefaultsOjbectForKey:KLogin_Info]);
            [User saveUseDefaultsOjbect:request forKey:KLogin_Info];
            [User saveUserInfomation:request];
            [User saveUseDefaultsOjbect:request[@"isVip"] forKey:kVipStatus];
//            NSLog(@"++++++%@", [User getUseDefaultsOjbectForKey:KLogin_Info]);
            
            [User saveUseDefaultsOjbect:request[@"parent_id"] forKey:kParent_id];

            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            SVShowError(request[@"msg"]);
        }
        
    } failBlock:^(NSError *error) {
        NSLog(@"--------------------------------- >>>>>>>>>>>>>>> %@", error);
        SLShowNetworkFail;
    }];
}




///  三方登录
- (void)_requestThirdLogin:(UMSocialUserInfoResponse *)info type:(NSString *)type {
//    String third_id, String user_account,String sex,String photo_url,String userName
    NSString * url =@"login/third_login.htm?";
    LFParameter *parameter = [LFParameter new];
    parameter.third_id = type;
    parameter.user_account = info.openid;
    parameter.sex = ([info.gender isEqualToString:@"m"] || [info.gender isEqualToString:@"男"]) ?  @"1" : @"0";
    parameter.photo_url = info.iconurl;
    parameter.userName = info.name;
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue]==200) {
            if ([request[@"isBangMobile"] boolValue]) {
                [User saveUserInfomation:request];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                LFSecurityViewController * controller = [[LFSecurityViewController alloc] init];
                controller.bind = YES;
                controller.loginKey = request[@"loginKey"];
                [self.navigationController pushViewController:controller animated:YES];
            }
        } else {
            SVShowError(request[@"msg"]);
        }
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
    }];
}

@end
