//
//  SLShareHelper.m
//  PocketJC
//
//  Created by Seven Lv on 16/11/22.
//  Copyright © 2016年 CHY. All rights reserved.
//

#import "SLShareHelper.h"

@implementation SLShareHelper

+ (void)shareTitle:(NSString *)title desc:(NSString *)desc url:(NSString *)url image:(id)image Plantform:(UMSocialPlatformType)type callBack:(void (^)(BOOL success))block {
    
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:image];
    //设置网页地址
    shareObject.webpageUrl = url;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            BLOCK_SAFE_RUN(block, NO);
        } else {
            BLOCK_SAFE_RUN(block, YES);
        }
    }];
    
}

@end
