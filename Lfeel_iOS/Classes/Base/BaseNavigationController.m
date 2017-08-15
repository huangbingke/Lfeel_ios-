//
//  User.m
//  NBG
//
//  Created by Seven on 16/1/12.
//  Copyright © 2016年 Seven Lv. All rights reserved.
//


static CGFloat kDistance = 80.0f;

#import "BaseNavigationController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface BaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gestureRecognizerEnabled = YES;
    self.screenShotArray = [NSMutableArray array];
    self.navigationBar.hidden = YES;
    self.fd_fullscreenPopGestureRecognizer.enabled = YES;
    self.interactivePopGestureRecognizer.enabled = NO;
    self.fd_fullscreenPopGestureRecognizer.delegate = self;
    [self.fd_fullscreenPopGestureRecognizer addTarget:self action:@selector(panGesIng:)];
    [self.view addGestureRecognizer:self.fd_fullscreenPopGestureRecognizer];
}

- (void)setGestureRecognizerEnabled:(BOOL)gestureRecognizerEnabled {
    _gestureRecognizerEnabled = gestureRecognizerEnabled;
    self.fd_fullscreenPopGestureRecognizer.enabled = gestureRecognizerEnabled;
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super init]) {
        self.viewControllers = @[rootViewController];
    }
    return self;
}

- (void)panGesIng:(UIPanGestureRecognizer *)panGes {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIViewController *rootVC = appdelegate.window.rootViewController;
    UIViewController *presentedVC = rootVC.presentedViewController;
    if (self.viewControllers.count == 1) {
        return;
    }
    
    if (panGes.state == UIGestureRecognizerStateBegan) {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        appdelegate.screenShotView.hidden = NO;
        
    } else if (panGes.state == UIGestureRecognizerStateChanged) {
        CGPoint pt = [panGes translationInView:self.view];
        
        if (pt.x >= 10) {
            rootVC.view.transform = CGAffineTransformMakeTranslation(pt.x - 10, 0);
            presentedVC.view.transform = CGAffineTransformMakeTranslation(pt.x - 10, 0);
        }
    } else if (panGes.state == UIGestureRecognizerStateEnded) {
        CGPoint pt = [panGes translationInView:self.view];
        if (pt.x >= kDistance)
        {
            [UIView animateWithDuration:0.15 animations:^{
                rootVC.view.transform = CGAffineTransformMakeTranslation(kScreenWidth, 0);
                presentedVC.view.transform = CGAffineTransformMakeTranslation(kScreenWidth, 0);
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
                rootVC.view.transform = CGAffineTransformIdentity;
                presentedVC.view.transform = CGAffineTransformIdentity;
                appdelegate.screenShotView.hidden = YES;
            }];
        } else {
            [UIView animateWithDuration:0.15 animations:^{
                rootVC.view.transform = CGAffineTransformIdentity;
                presentedVC.view.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                appdelegate.screenShotView.hidden = YES;
            }];
        }
    }
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
        ///第二层viewcontroller 隐藏tabbar
        viewController.hidesBottomBarWhenPushed=YES;
    }
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(appdelegate.window.size.width, appdelegate.window.size.height), YES, 0);
    [appdelegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.screenShotArray addObject:viewImage];
    
    appdelegate.screenShotView.imageView.image = viewImage;

    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.screenShotArray removeLastObject];
    UIImage *image = [self.screenShotArray lastObject];
    
    if (image) {
        appdelegate.screenShotView.imageView.image = image;
    }

    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.screenShotArray.count > 2) {
        [self.screenShotArray removeObjectsInRange:NSMakeRange(1, self.screenShotArray.count - 1)];
    }
    UIImage *image = [self.screenShotArray lastObject];
    if (image) {
        appdelegate.screenShotView.imageView.image = image;
    }
    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *arr = [super popToViewController:viewController animated:animated];
    
    if (self.screenShotArray.count > arr.count) {
        for (int i = 0; i < arr.count; i++) {
            [self.screenShotArray removeLastObject];
        }
        UIImage *image = [self.screenShotArray lastObject];
        if (image) {
            AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appdelegate.screenShotView.imageView.image = image;
        }
    }
    return arr;
}
@end
