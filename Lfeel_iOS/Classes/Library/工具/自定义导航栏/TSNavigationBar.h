//
//  TSNavigationBar.h
//
//  Created by Seven on 15/10/13.
//  Copyright © 2015年 Seven Lv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSNavigationBar : UIView
///  标题Label
@property (nonatomic,   weak) UILabel * titleLabel;
///  右侧按钮
@property (nonatomic,   weak) UIButton * rightButton;

@property (nonatomic,   weak) UIButton * leftButton;
@property (nonatomic,   weak) UIButton * leftBtn;

///  背景图片
//@property (nonatomic,   weak) UIImageView * backgroundImage;


///  设置成白色主题
//- (void)setupToWhiteTheme;

///  只有标题
///
///  @param title 标题
///
///  @return 导航栏
+ (instancetype)navWithTitle:(NSString *)title;

///  只有标题和返回键
///
///  @param title      标题
///  @param backAction 返回事件
///
///  @return 导航栏
+ (instancetype)navWithTitle:(NSString *)title
                  backAction:(void(^)(void))backAction;


/// 标题 + 右边item(图片或文字都行)（没有返回按钮）
///
/// @param title      标题
/// @param backAction 右侧点击事件
///
/// @return 导航栏
+ (instancetype)navWithTitle:(NSString *)title
                   rightItem:(NSString *)rightItem
                 rightAction:(void(^)(void))action;


///  标题 + 右边item(图片或文字都行) + 返回按钮
///
///  @param title      标题
///  @param rightItem  右侧图片/文字
///  @param action     右侧点击事件
///  @param backAction 返回事件
///
///  @return 导航栏
+ (instancetype)navWithTitle:(NSString *)title
                   rightItem:(NSString *)rightItem
                 rightAction:(void(^)(void))action
                  backAction:(void(^)(void))backAction;

+ (instancetype)navWithTitle:(NSString *)title
                   rightItem:(NSString *)rightItem
                 rightAction:(void (^)(void))action
                    leftItem:(NSString *)leftItem
                  leftAction:(void (^)(void))leftaction;

///导航栏背景图片
//@property (nonatomic , strong) UIImageView * bgImgNav;

@end


@class TSNavigationBar;

@interface UIViewController (NavigatiionBar)

@property (nonatomic, strong) TSNavigationBar * ts_navgationBar;

@end









