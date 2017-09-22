//
//  AppDelegate.m
//  Lfeel_iOS
//
//  Created by apple on 2017/2/22.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "SLGuideVC.h"
#import "APPAplicktion.h"
#import "BaseNavigationController.h"
#import "SVProgressHUD+SL.h"
#import "LFAddressModel.h"
#import "BeeCloud.h"
#import "WXApi.h"
#import "PLeakSniffer.h"
#import <UMSocialCore/UMSocialCore.h>
#import <SobotKit/SobotKit.h>

#import <UserNotifications/UserNotifications.h>

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
static char kScreenShotViewMove[] = "screenShotViewMove";

@interface AppDelegate ()<UNUserNotificationCenterDelegate, UIApplicationDelegate>

@end

@implementation AppDelegate

+ (AppDelegate *)sharedDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [IQKeyboardManager sharedManager].enable = true;
    [User configUser];
    [User configCenterUser];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setupRootViewcontroller];
    [self ts_setupSVProgress];
    
    [self _configPayInfo];
    [self _setupUmeng];
    
    [self ZCServiceApplication:application];
    
    return YES;
}


- (void)ZCServiceApplication:(UIApplication *)application {
    //  初始化智齿客服，会建立长连接通道，监听服务端消息（建议启动应用时调用，没有发起过咨询不会浪费资源，至少转一次人工才有效果）
    [[ZCLibClient getZCLibClient] initZCIMCaht];
    // ReceivedMessageBlock 未读消息数， obj 当前消息  unRead 未读消息数
    [ZCLibClient getZCLibClient].receivedBlock=^(id obj,int unRead){
        NSLog(@"****************************未读消息数量：%d,%@",unRead,obj);
    };
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10")) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert |UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) { NSLog(@"%@", settings); }]; } else {
                    // 点击不允许
                    NSLog(@"注册失败");
                }
                
            if (!error) {
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }else{
        [self registerPush:application];
    }
    
    // 获取APPKEY
    NSString *APPKEY = @"8266c1ca81574caab451099dda19fcc1";
    [[ZCLibClient getZCLibClient].libInitInfo setAppKey:APPKEY];
    [[ZCLibClient getZCLibClient] setIsDebugMode:NO];
    [ZCSobot setShowDebug:NO];
}

-(void)registerPush:(UIApplication *)application{
//    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //IOS8
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        
        [application registerUserNotificationSettings:notiSettings];
        
    } else{ // ios7
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge                                       |UIRemoteNotificationTypeSound                                      |UIRemoteNotificationTypeAlert)];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken{
//    NSLog(@"---Token--%@", pToken);
    // 注册token
    [[ZCLibClient getZCLibClient] setToken:pToken];
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
//    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    
    //功能：可设置是否在应用内弹出通知
    completionHandler(UNNotificationPresentationOptionAlert);
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
//    NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
//    
//    NSLog(@"userInfo == %@\n%@",userInfo,message);
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
//    NSLog(@"Regist fail%@",error);
}
//点击推送消息后回调
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
//    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
}

- (void)setupRootViewcontroller {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
//    
//    [User configUser];
//
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        
        [User saveUseDefaultsOjbect:@"1" forKey:@"isfirstStart"];
        
        self.flagIndex = 1;
        self.window.rootViewController = [SLGuideVC new];
    }else{
//        NSLog(@"不是第一次启动");
        [User saveUseDefaultsOjbect:@"0" forKey:@"isfirstStart"];
        self.flagIndex = 0;
//        APPAplicktion * main = [[APPAplicktion alloc] init];
        MainViewController * main = [MainViewController new];
        self.window.rootViewController = main;
        [self setupScreenView];
    }

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;;
    [UIApplication sharedApplication].statusBarHidden = NO;
}


///  截屏view
- (void)setupScreenView {
    
    self.screenShotView = [[TSScreenShotView alloc] initWithFrame:CGRectMake(0, 0, self.window.size.width, self.window.size.height)];
    
    self.screenShotView.hidden = YES;
    [self.window insertSubview:self.screenShotView atIndex:0];
    
    // 添加监听
    [self ts_addObserver];
}

/// 添加监听
- (void)ts_addObserver {
    [self.window.rootViewController.view addObserver:self
                                          forKeyPath:@"transform"
                                             options:NSKeyValueObservingOptionNew
                                             context:kScreenShotViewMove];
}



/// 移除监听
- (void)ts_removeObserver {
    [self.window.rootViewController.view removeObserver:self forKeyPath:@"transform"];
}

/// 监听接收
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (context == kScreenShotViewMove) {
        NSValue *value  = [change objectForKey:NSKeyValueChangeNewKey];
        CGAffineTransform newTransform = [value CGAffineTransformValue];
        [self.screenShotView showEffectChange:CGPointMake(newTransform.tx, 0) ];
    }
}
- (void)_setupUmeng {
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"58307cfa82b63559950012b3"];
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx49ee5406f2ae4192" appSecret:@"1b064bf13ad7abe92ca4833b969ee2dd" redirectURL:nil];

    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106089815" appSecret:@"Iv8uHHcFXDUIhYG7" redirectURL:@"http://redirect_url=open.weibo.com/apps/1970404034/privilege/oauth"];
    
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1970404034"  appSecret:@"44e236b1717ca5a1d13a62a6bd0edf7e" redirectURL:@"http://redirect_url=open.weibo.com/apps/1970404034/privilege/oauth"];
}
///  配置支付参数
- (void)_configPayInfo {
    /*
     public static String KTestAppID = "e63f942b-738e-4097-bcd8-17485344d83e";
     public static String kTestAppSecret = "db8dc2aa-7be5-489e-b3d5-75dc0ee0eeb2";
     public static String kTestTestSecret = "e35f2f64-f65a-4ef5-81ac-a787cd5ba328";
     public static String kTestMasterSecret = "1e057917-a9cf-4518-a74d-3e76a2b0b953"; */
    /*
     如果使用BeeCloud控制台的APP Secret初始化，代表初始化生产环境；
     如果使用BeeCloud控制台的Test Secret初始化，代表初始化沙箱测试环境;
     测试账号 appid: c5d1cba1-5e3f-4ba0-941d-9b0a371fe719
     appSecret: 39a7a518-9ac8-4a9e-87bc-7885f33cf18c
     testSecret: 4bfdd244-574d-4bf3-b034-0c751ed34fee
     由于支付宝的政策原因，测试账号的支付宝支付不能在生产环境中使用，带来不便，敬请原谅！
     ApplePay 不支持模拟器运行；
     */
    [BeeCloud initWithAppID:@"e63f942b-738e-4097-bcd8-17485344d83e" andAppSecret:@"db8dc2aa-7be5-489e-b3d5-75dc0ee0eeb2"];

    //初始化微信官方APP支付
    [BeeCloud initWeChatPay:@"wx49ee5406f2ae4192"];
    
    
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if (![BeeCloud handleOpenUrl:url]) {
        //handle其他类型的url
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    return YES;
}

//iOS9之后官方推荐用此方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    NSLog(@"options %@", options);
    if (![BeeCloud handleOpenUrl:url]) {
        //handle其他类型的url
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    return YES;
}
@end
