//
//  LFPayHelper.h
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/19.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PayType) {
    PayTypeLeiBaiFen = 0,
    PayTypeAlipay,
    PayTypeWeChat,
    PayTypeUnipay
};

@interface LFPayHelper : NSObject

/**
 支付

 @param type 类型
 @param priceFen 金额(单位分)
 @param no 订单编号
 @param vc 从哪个控制器弹出
 */
+ (void)payWithType:(PayType)type price:(NSString *)priceFen orderNum:(NSString *)no showInViewController:(UIViewController *)vc completionHandle:(void(^)(BOOL success, NSString *msg))com;

@end
