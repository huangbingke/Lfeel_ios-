//
//  SLRemoteNotificationManager.m
//  DaChengWaiMaiMerchant
//
//  Created by Seven Lv on 16/5/20.
//  Copyright © 2016年 Seven Lv. All rights reserved.
//

#import "SLRemoteNotificationManager.h"
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

static NSString * const kDidReceiveRemoteNotification = @"_didReceiveRemoteNotification";
static DictionaryBlcok remoteHandle_ = nil;

@interface SLRemoteNotificationManager ()<JPUSHRegisterDelegate>

@end

@implementation SLRemoteNotificationManager

+ (void)setupWithOption:(NSDictionary *)launchingOption appKey:(NSString *)appKey {
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:[self self]];
    
    
#if DEBUD
    BOOL isProduction = NO;
#else
    BOOL isProduction = NO;
#endif
    
    [JPUSHService setupWithOption:launchingOption
                           appKey:appKey
                          channel:@"Publish channel"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didReceiveRemoteNotification:) name:kDidReceiveRemoteNotification object:nil];
    
    
}

+ (void)handleRemoteNotification:(void (^)(NSDictionary *))handle {
    remoteHandle_ = [handle copy];
}

///  收到推送通知
+ (void)_didReceiveRemoteNotification:(NSNotification *)notification {
    NSDictionary * userInfo = notification.object;
    !remoteHandle_ ? : remoteHandle_(userInfo);
}

+ (void)setTags:(NSArray *)tags alias:(NSString *)alias {
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kJPFNetworkDidLoginNotification object:nil] subscribeNext:^(id x) {
        [JPUSHService setTags:[NSSet setWithArray:tags] alias:alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            SLLog2(@"设置alias\tag成功  %@-%@-%@", @(iResCode), iTags, iAlias);
        }];
    }];
}

+ (void)clearTagsAndAlias {
    [JPUSHService setTags:[NSSet set] alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        SLLog(@"清除成功");
    }];
}

// iOS 10 Support
+ (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidReceiveRemoteNotification object:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
+ (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidReceiveRemoteNotification object:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}
@end

@implementation AppDelegate (SLRemoteNotificationManager)

#if TARGET_OS_IPHONE      // 真机
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    SLLog(@"注册DeviceToken成功");
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidReceiveRemoteNotification object:userInfo];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    SLLog(@"注册DeviceToken失败");
}


#endif
@end
