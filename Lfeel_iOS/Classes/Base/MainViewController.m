//
//  AppDelegate.m
//  NBG
//
//  Created by Seven on 16/1/12.
//  Copyright © 2016年 Seven Lv. All rights reserved.
//



#import "MainViewController.h"
#import "BaseNavigationController.h"
#import "LFHomeViewController.h"
#import "LFBuyViewController.h"
#import "LFShopCartViewController.h"
#import "LFMineViewController.h"
#import "LFLoginViewController.h"

@interface MainViewController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) UIImageView * imageV;
@property (nonatomic,   weak) UIView * bgView;
@property (nonatomic,   weak) UILabel * label;
@end

@implementation MainViewController

+ (void)initialize {
    
    [[UITabBar appearance] setTintColor:HexColorInt32_t(C00D23)];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    NSString * isFirst = [[NSUserDefaults standardUserDefaults] objectForKey:@"First"];
//    if (!isFirst) {
//        isFirst = @"NO";
//    }
//    
//    if ([isFirst isEqualToString:@"YES"]) {
//        [self requestOpenImage];
//    }
    [self setupChildControllers];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.delegate = self;
}

- (void)dealloc {
    SLLog(self);
}

- (void)setupChildControllers {
    NSArray *selectImages = @[@"选中首页",@"选中分类",@"选中购物车", @"选中我的"];
    NSArray *normalImages = @[@"首页",@"分类", @"购物车", @"我的"];;
    NSArray *title = @[@"乐荟盒子",@"新品购买",@"购物车",@"我的乐荟"];
    
    LFHomeViewController * controller1 = [[LFHomeViewController alloc] init];
    LFBuyViewController * controller2 = [[LFBuyViewController alloc] init];
    LFShopCartViewController * controller3 = [[LFShopCartViewController alloc] init];
    LFMineViewController* controller4 = [[LFMineViewController alloc] init];
 
    NSArray * array = @[controller1, controller2,controller3,controller4];
    for (int i = 0; i < title.count; i++) {
        [self setupChildVc:array[i] title:title[i] image:normalImages[i] selectedImage:selectImages[i]];
    }
    
}
/**
 * 初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    //    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    vc.tabBarController.tabBar.translucent = NO;
    // 包装一个导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    //登录联通数据了以后才用到
    if (user_is_login) return YES;
    BaseNavigationController * nav = (BaseNavigationController *)viewController;
    UIViewController * vc = nav.topViewController;
    
    if ([vc isKindOfClass:[LFMineViewController class]] || [vc isKindOfClass:[LFShopCartViewController class]]) {
        BaseNavigationController * b = [[BaseNavigationController alloc] initWithRootViewController:[LFLoginViewController new]];
        [self presentViewController:b animated:YES completion:nil];
        return NO;
    }
    
    return YES;
}


@end
