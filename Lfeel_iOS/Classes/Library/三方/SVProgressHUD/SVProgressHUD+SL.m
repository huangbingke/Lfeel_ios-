//
//  SVProgressHUD+SL.m
//  svprogress
//
//  Created by Seven on 15/7/28.
//  Copyright (c) 2015年 toocms. All rights reserved.
//

#import "SVProgressHUD+SL.h"

@implementation SVProgressHUD (SL)
+ (void)showSuccess:(NSString *)success
{
    [SVProgressHUD showSuccessWithStatus:success];
}

+ (void)showError:(NSString *)error
{
    [SVProgressHUD showInfoWithStatus:error];
}

+ (void)showStatus:(NSString *)status
{
    [SVProgressHUD showWithStatus:status];
}


@end

@implementation AppDelegate (SV)

- (void)ts_setupSVProgress {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setCornerRadius:5];
}

@end
