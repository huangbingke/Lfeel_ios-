//
//  SLShareHelper.h
//  PocketJC
//
//  Created by Seven Lv on 16/11/22.
//  Copyright © 2016年 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>

@interface SLShareHelper : NSObject

+ (void)shareTitle:(NSString *)title desc:(NSString *)desc url:(NSString *)url image:(id)image Plantform:(UMSocialPlatformType)type callBack:(void (^)(BOOL success))block;

@end
