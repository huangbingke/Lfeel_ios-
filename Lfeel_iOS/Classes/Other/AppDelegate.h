//
//  AppDelegate.h
//  Lfeel_iOS
//
//  Created by apple on 2017/2/22.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "TSScreenShotView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

///  main
@property (nonatomic, strong) MainViewController * mainViewController;

+ (AppDelegate *)sharedDelegate;
/// 截屏view
@property (nonatomic, strong) TSScreenShotView * screenShotView;

/// 添加监听
- (void)ts_addObserver;
/// 移除监听
- (void)ts_removeObserver;

///  截屏view
- (void)setupScreenView;


///  <#Description#>
@property (nonatomic, assign) NSInteger flagIndex;






@end


