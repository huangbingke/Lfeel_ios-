//
//  User.h
//  NBG
//
//  Created by Seven on 16/1/12.
//  Copyright © 2016年 Seven Lv. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 定义没有返回值的block
typedef void (^VoidBlcok)(void);

/// 定义带一个NSDictionary参数的block
///
/// @param dict NSDictionary
typedef void (^DictionaryBlcok)(NSDictionary *dict);

/// 定义带一个array参数的block
///
/// @param array NSArray
typedef void (^ArrayBlcok)(NSArray *array);

/// 定义带一个NSString参数的block
///
/// @param string NSString
typedef void (^StringBlcok)(NSString *string);




@interface LFUserInfo : NSObject
@property (nonatomic,   copy) NSString * hipline;
@property (nonatomic,   copy) NSString * userIoc;
@property (nonatomic,   copy) NSString * sex;
@property (nonatomic,   copy) NSString * customerPhone;
@property (nonatomic,   copy) NSString * identification;
@property (nonatomic,   copy) NSString * weight;
@property (nonatomic,   copy) NSString * size;
@property (nonatomic,   copy) NSString * userName;
@property (nonatomic,   copy) NSString * birthday;
@property (nonatomic,   copy) NSString * bust;
@property (nonatomic,   copy) NSString * height;
@property (nonatomic,   copy) NSString * integral;
@property (nonatomic,   copy) NSString * phoneMoble;
@property (nonatomic,   copy) NSString * nickname;
@property (nonatomic,   copy) NSString * waist;

@end




@interface SLUserInfo : NSObject

///  loginKey
@property (nonatomic,   copy) NSString * loginKey;


@end

@interface User : NSObject
@property (nonatomic, assign, getter=isLogin) BOOL login;
@property (readonly,  strong) SLUserInfo * userInfo;
@property (readonly,  strong) LFUserInfo * lfuserinfo;
@property (nonatomic, assign, getter=isNeedRefreshOrder) BOOL needRefreshOrder;
+ (NSString *)getDeviceId;
+ (instancetype)sharedUser;

///  用户是否登录
+ (void)configUser;
+ (void)configCenterUser ;

///  保存用户信息（登录状态）
+ (BOOL)saveUserInfomation:(NSDictionary *)userInfo;
///  个人中心信息
+ (BOOL)saveCenterUserInfomation:(NSDictionary *)userInfo;


///  删除用户信息 （退出登录状态）
+ (BOOL)removeUserInfomation;
+ (BOOL)removeCenterUserInfomation;

#pragma mark - UserDefault
///  移除userDefaults key对应的object
+ (void)removeUseDefaultsForKey:(NSString *)key;

///  保存对象到userDefaults
+ (void)saveUseDefaultsOjbect:(id)obj forKey:(NSString *)key;

///  从userDefaults获取对象
+ (id)getUseDefaultsOjbectForKey:(NSString *)key;

///  设置导航条白色
///
///  @param isNeedLight  YES 需要设置成白色， 反之NO
UIKIT_EXTERN void setStatusBarLightContent(BOOL isNeedLight);
@end

 
