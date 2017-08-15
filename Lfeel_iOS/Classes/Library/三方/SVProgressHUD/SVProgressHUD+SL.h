 //
//  SVProgressHUD+SL.h
//  svprogress
//
//  Created by Seven on 15/7/28.
//  Copyright (c) 2015年 toocms. All rights reserved.
//

#import "SVProgressHUD.h"
#import "AppDelegate.h"

@interface SVProgressHUD (SL)

/** 
 * 显示成功信息
 */
+ (void)showSuccess:(NSString *)success;
/**
 * 显示错误信息
 */
+ (void)showError:(NSString *)error;
/**
 * 显示状态条
 */
+ (void)showStatus:(NSString *)status;

@end

@interface AppDelegate (SV)
- (void)ts_setupSVProgress;
@end
