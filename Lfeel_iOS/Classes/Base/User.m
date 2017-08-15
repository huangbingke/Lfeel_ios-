//
//  User.m
//
//  Created by Seven on 15/9/8.
//  Copyright (c) 2015年 Toocms. All rights reserved.
//

#import "User.h"
#import "AppDelegate.h"

static User * _user = nil;

@implementation SLUserInfo

@end

@implementation LFUserInfo

@end

@implementation User

+ (instancetype)sharedUser
{
    if (_user == nil) {
        _user = [[self alloc] init];
    }
    return _user;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _user = [super allocWithZone:zone];
    });
    return _user;
}

+ (BOOL)saveUserInfomation:(NSDictionary *)userInfo {
    
    if (!userInfo) return NO;
    
    SLUserInfo * info = [SLUserInfo yy_modelWithJSON:userInfo];
    [User sharedUser]->_userInfo = info;
    if (USER.userInfo.loginKey.length) {
        [[User sharedUser] setLogin:YES];
    }
    // 沙盒路径
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.plist"];
    SLLog(path);
    // 是否保存成功
    return [info.yy_modelToJSONObject writeToFile:path atomically:YES];
}

+ (BOOL)saveCenterUserInfomation:(NSDictionary *)userInfo {
    
    if (!userInfo) return NO;
    
    LFUserInfo * info = [LFUserInfo yy_modelWithJSON:userInfo];
    [User sharedUser]->_lfuserinfo = info;
    // 沙盒路径
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CenteruserInfo.plist"];
    SLLog(path);
    // 是否保存成功
    return [info.yy_modelToJSONObject writeToFile:path atomically:YES];
}




+ (void)configUser {
    
    // 用户信息路径
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.plist"];
    SLLog(path);
    NSDictionary * d = [NSDictionary dictionaryWithContentsOfFile:path];

    // 登录信息
    if ([d count]) {
        SLUserInfo * info = [SLUserInfo yy_modelWithJSON:d];
        [User sharedUser]->_userInfo = info;
        if (USER.userInfo.loginKey.length) {
            [User sharedUser].login = YES;
        }
    }
}

+ (void)configCenterUser {
    
    // 用户信息路径
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CenteruserInfo.plist"];
    SLLog(path);
    NSDictionary * d = [NSDictionary dictionaryWithContentsOfFile:path];
    
    // 登录信息
    if ([d count]) {
        LFUserInfo * info = [LFUserInfo yy_modelWithJSON:d];
        [User sharedUser]->_lfuserinfo = info;
        if (USER.userInfo.loginKey.length) {
            [User sharedUser].login = YES;
        }
    }
}




+ (BOOL)removeCenterUserInfomation {
    
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CenteruserInfo.plist"];
    
    NSFileManager * manager = [NSFileManager defaultManager];
    
    // 判断文件路径是否存在
    if (![manager fileExistsAtPath:path]) {
        return NO;
    }
    
    [User sharedUser]->_lfuserinfo = nil;
    [User sharedUser].login = NO;
    
    // 删除文件
    return [manager removeItemAtPath:path error:nil];
}


+ (BOOL)removeUserInfomation {
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.plist"];
    
    NSFileManager * manager = [NSFileManager defaultManager];
    
    // 判断文件路径是否存在
    if (![manager fileExistsAtPath:path]) {
        return NO;
    }
    
    [User sharedUser]->_userInfo = nil;
    [User sharedUser].login = NO;
    
    // 删除文件
    return [manager removeItemAtPath:path error:nil];
}

+ (void)removeUseDefaultsForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///  保存对象到userDefaults
+ (void)saveUseDefaultsOjbect:(id)obj forKey:(NSString *)key {
    
    [self removeUseDefaultsForKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///  从userDefaults获取对象
+ (id)getUseDefaultsOjbectForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (NSString *)getDeviceId
{
    static NSString * uuid = nil;
    if (uuid) return uuid;
    NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
    NSString * currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
    currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    uuid = [currentDeviceUUIDStr lowercaseString];
    
    return uuid;
}

void setStatusBarLightContent(BOOL isNeedLight) {
    
    UIApplication * app = [UIApplication sharedApplication];
    if (isNeedLight) {
        if (app.statusBarStyle == UIStatusBarStyleDefault) {
            app.statusBarStyle = UIStatusBarStyleLightContent;
        }
    } else {
        if (app.statusBarStyle == UIStatusBarStyleLightContent) {
            app.statusBarStyle = UIStatusBarStyleDefault;
        }
    }
}

@end

