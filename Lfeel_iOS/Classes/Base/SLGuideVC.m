//
//  SLGuideVC.m
//  PocketJC
//
//  Created by Seven Lv on 16/10/6.
//  Copyright © 2016年 CHY. All rights reserved.
//

#import "SLGuideVC.h"
#import "MainViewController.h"
#import "APPAplicktion.h"

@interface SLGuideVC ()

@end

@implementation SLGuideVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupSubViews];
}

#pragma mark - 初始化UI

/// 初始化view
- (void)setupSubViews {
    
    UIScrollView * scrollView = [UIScrollView scrollViewWithBgColor:[UIColor whiteColor] frame:self.view.bounds];
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    NSInteger count = 3;
    for (int i = 0; i < count; i++) {
        NSString * name = [NSString stringWithFormat:@"guide-%d", i + 1];
        UIImageView * imageView = [UIImageView imageViewWithImage:[UIImage imageNamed:name] frame:Rect(i * kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        [scrollView addSubview:imageView];
        if (i == count -1) {
            UIButton * btn = [UIButton buttonWithTitle:nil titleColor:nil backgroundColor:[UIColor clearColor] font:0 image:nil frame:Rect(0, kScreenHeight - 104 * (kScreenHeight / 2208) - Fit1242(100), Fit1242(300), Fit1242(100))];
            btn.centerX = kHalfScreenWidth;
            [imageView addSubview:btn];
            imageView.userInteractionEnabled = YES;
            @weakify(self);
            [[btn rac_signalForControlEvents:64] subscribeNext:^(id x) {
                @strongify(self);
                
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:@(NO) forKey:@"_isFirstLaunchApp"];
                [defaults synchronize];
                
                MainViewController * main = [[MainViewController alloc] init];
                self.view.window.rootViewController = main;
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate setupScreenView];
            }];
        }
    }
    scrollView.contentSize = Size(kScreenWidth * 3, 0);
    
    
}


@end
