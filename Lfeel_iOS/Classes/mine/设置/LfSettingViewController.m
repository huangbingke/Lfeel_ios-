//
//  LfSettingViewController.m
//  Lfeel_iOS
//
//  Created by 陈泓羽 on 17/3/14.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LfSettingViewController.h"
#import "SLImagePickerController.h"
#import "LFDelegateViewController.h"
#import "LFChangePassWorldViewController.h"
#import "LFAboutMyViewController.h"
#import <UMSocialCore/UMSocialCore.h>

@interface LfSettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *clearLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation LfSettingViewController{
    NSString * CacheSize;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self.contentView rm_fitAllConstraint];
    [self countCacheSize];
    if (!user_is_login ) {
        SLLog2(@"没有登录");
        self.loginBtn.hidden = YES;
    }else{
        SLLog2(@"登录");
        self.loginBtn.hidden = NO;
    }
    
    NSString * version = NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"V%@", version];
    
}
/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    @weakify(self);
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"设置" backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated: YES];
    }];
}

#pragma mark - 初始化UI
-(void)countCacheSize{
    [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        NSUInteger kb = 1024;
        NSUInteger mb = 1024 * 1024;
        if (totalSize < mb) {
            CacheSize  = [NSString stringWithFormat:@"%luKB", totalSize / kb];
        } else {
            CacheSize = [NSString stringWithFormat:@"%.1fMB", (double)totalSize / mb];
        }
        
        self.clearLabel.text = [NSString stringWithFormat:@"%@",CacheSize];
        
    }];
    
}


- (IBAction)TapClaer:(id)sender {
    SLLog2(@"清理内存");
    
    if ([self.clearLabel.text isEqualToString:@"0kb"]) {
        SVShowError(@"没有缓存");
        return;
    }
    
    [UIAlertView alertWithTitle:@"提示" message:@"确认清除缓存吗" cancelButtonTitle:@"取消" OtherButtonsArray:@[@"确定"] clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[[SDWebImageManager sharedManager] imageCache] clearDiskOnCompletion:^{
            }];
            [[SDWebImageManager sharedManager].imageCache clearDisk];
            SVShowSuccess(@"清除成功");
            self.clearLabel.text = @"";
        }
    }];

}

- (IBAction)TapChangePWD:(id)sender {
    SLLog2(@"修改密码");
    LFChangePassWorldViewController * change = [[LFChangePassWorldViewController alloc]init];
    
    [self.navigationController pushViewController:change animated:YES];
    
}

- (IBAction)TapAboutmine:(id)sender {
    SLLog2(@"关于我们");
    LFAboutMyViewController * about = [[LFAboutMyViewController alloc]init
                                       ];
    [self.navigationController pushViewController:about animated:YES];
}
- (IBAction)TapAttentionBtn:(id)sender {
    SLLog2(@"注意事项");
    LFDelegateViewController * delegate = [[LFDelegateViewController alloc]init];
    delegate.selectType = @"2";
    [self.navigationController pushViewController:delegate animated:YES];
}


- (IBAction)TapFeedbackBtn:(id)sender {
    SLLog2(@"意见反馈");
    LFDelegateViewController * delegate = [[LFDelegateViewController alloc]init];
    delegate.selectType = @"3";
    [self.navigationController pushViewController:delegate animated:YES];
}

- (IBAction)TapCenterDelegate:(id)sender {
    SLLog2(@"服务协议");
    LFDelegateViewController * delegate = [[LFDelegateViewController alloc]init];
    delegate.selectType = @"1";
    [self.navigationController pushViewController:delegate animated:YES];
}

- (IBAction)TapSelectCheckoutLogin:(id)sender {
    SLLog2(@"退出登录");
    [UIAlertView alertWithTitle:@"提示" message:@"确认退出登录" cancelButtonTitle:@"取消" OtherButtonsArray:@[@"确定"] clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self removeUserInfo];
            [User removeUseDefaultsForKey:kSMRZ];
            [User removeUseDefaultsForKey:kVipStatus];
            [User removeUseDefaultsForKey:kParent_id];

            // 移除三方授权
            [[UMSocialManager defaultManager] cancelAuthWithPlatform:UMSocialPlatformType_QQ completion:nil];
            [[UMSocialManager defaultManager] cancelAuthWithPlatform:UMSocialPlatformType_WechatSession completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.tabBarController.selectedIndex = 0;
                [self.navigationController popToRootViewControllerAnimated:NO];
            });
            
        }
    }];

}




@end
