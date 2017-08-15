//
//  SLRemoteNotificationManager.h
//  DaChengWaiMaiMerchant
//
//  Created by Seven Lv on 16/5/20.
//  Copyright © 2016年 Seven Lv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface SLRemoteNotificationManager : NSObject

///  设置JPush
///
///  @param launchingOption appDelegate 程序入口传入的字典
///  @param appKey          appKey
+ (void)setupWithOption:(NSDictionary *)launchingOption appKey:(NSString *)appKey;

///  收到远程推送
///
///  @param handle 回调
+ (void)handleRemoteNotification:(void(^)(NSDictionary *userInfo))handle;

///  设置tag和别名，只设置一个可以传空
+ (void)setTags:(NSArray *)tags alias:(NSString *)alias;

///  清除tag和别名
+ (void)clearTagsAndAlias;
@end


@interface AppDelegate (SLRemoteNotificationManager)

@end
