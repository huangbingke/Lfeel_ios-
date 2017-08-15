//
//  TSNavigationBar.m
//
//  Created by Seven on 15/10/13.
//  Copyright © 2015年 Seven Lv. All rights reserved.
//

/// 返回按钮图片
static NSString * BackButtonImageName = @"返回-黑";
///  标题文字大小
static CGFloat    TitleFont           = 16;
///  按钮文字大小
static CGFloat    ButtonFont          = 15;

#import "TSNavigationBar.h"
#import <objc/runtime.h>
typedef void (^ButtonClick)(void);


typedef void (^LeftButtonClick)(void);

@interface TSNavigationBar ()

@property (nonatomic, copy)ButtonClick backBlock;
@property (nonatomic, copy)ButtonClick actionBlock;
@property (nonatomic, copy)LeftButtonClick leftBtnBlock;

@property (nonatomic, strong) CALayer * deviderLayer;
@end

@implementation TSNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.size = Size(kScreenWidth, 64);
        
        self.backgroundColor = HexColorInt32_t(F8F8F8);
        // 分隔线
        CALayer * layer = [CALayer layer];
        layer.frame = Rect(0, 63.5, kScreenWidth, 0.5);
        layer.backgroundColor = HexColorInt32_t(DDDDDD).CGColor;
        [self.layer addSublayer:layer];
        _deviderLayer = layer;
    }
    return self;
}
- (instancetype)initWithTitle_sl:(NSString *)title
                           right:(NSString *)right
                     rightAction:(void (^)(void))action
                           left:(NSString *)left
                     leftAction:(LeftButtonClick)leftAction
                      backAction:(void (^)(void))backAction {
    
    if (self = [super init]) {
        // 标题
        UILabel * label = [UILabel labelWithText:title font:TitleFont textColor:HexColorInt32_t(333333) frame:Rect(0, 21, kScreenWidth, 42)];
        [self addSubview:label];
        self.titleLabel = label;
        label.textAlignment = NSTextAlignmentCenter;
        
        // 如果实现了右边的事件，会创建右边的按钮
        if (action) {
            UIImage * image = [UIImage imageNamed:right];
            UIButton * btn = nil;
            if (image) {
                btn = [UIButton buttonWithTitle:nil titleColor:nil backgroundColor:nil font:0 image:right frame:Rect(kScreenWidth - 40, 0, 44, 44)];
                CGFloat edg = 9;
                btn.contentEdgeInsets = UIEdgeInsetsMake(edg, edg, edg, edg);
                btn.maxX = kScreenWidth - 7;
                [self addSubview:btn];
            } else {
                // 按钮
                CGSize size = [NSString getStringRect:right fontSize:ButtonFont width:300];
                btn = [UIButton buttonWithTitle:right titleColor:HexColorInt32_t(333333) backgroundColor:nil font:ButtonFont image:nil frame:Rect(kScreenWidth - 15 - size.width, 0, size.width, 30)];
                [self addSubview:btn];
                btn.adjustsImageWhenHighlighted = NO;
            }
            
            btn.centerY = label.centerY;
            [btn addTarget:self action:@selector(btnClick)];
            self.actionBlock = action;
            self.rightButton = btn;
        }
        
        // 如果实现了返回的事件，才创建返回按钮
        if (backAction) {
            UIButton * back = [UIButton buttonWithTitle:nil titleColor:nil backgroundColor:nil font:0 image:BackButtonImageName frame:Rect(0, 32, 44, 44)];
            [back addTarget:self action:@selector(backClick)];
            back.contentEdgeInsets = UIEdgeInsetsMake(14, 8, 14, 20);
            back.centerY = label.centerY;
            back.adjustsImageWhenHighlighted = NO;
            [self addSubview:back];
            self.backBlock = backAction;
            self.leftButton = back;
        }
        
        if (leftAction) {
            UIImage * image = [UIImage imageNamed:left];
            UIButton * btn = nil;
            if (image) {
                btn = [UIButton buttonWithTitle:nil titleColor:nil backgroundColor:nil font:0 image:left frame:Rect(0, 32, 44, 44)];
                [self addSubview:btn];
            } else {
                // 按钮
                btn = [UIButton buttonWithTitle:left titleColor:HexColorInt32_t(333333) backgroundColor:nil font:ButtonFont image:nil frame:Rect(0, 32, 44, 44)];
                btn.contentEdgeInsets = UIEdgeInsetsMake(14, 8, 14, 20);
                [self addSubview:btn];
                btn.adjustsImageWhenHighlighted = NO;
            }
            
            btn.centerY = label.centerY;
            [btn addTarget:self action:@selector(leftBtnClick)];
            self.leftBtnBlock = leftAction;
            self.leftBtn = btn;        }
    }
    return self;
}

#pragma mark - ButtonAction
- (void)btnClick {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

- (void)backClick {
    if (self.backBlock) {
        self.backBlock();
    }
}

- (void)leftBtnClick {
    if (self.leftBtnBlock) {
        self.leftBtnBlock();
    }
}

//- (void)setupToWhiteTheme {
//    self.backgroundColor = [UIColor whiteColor];
//    self.leftButton.image = [UIImage imageNamed:@"返回-黑"];
//    self.titleLabel.textColor = [UIColor blackColor];
//    self.rightButton.titleColor = [UIColor blackColor];
//    [self.layer addSublayer:_deviderLayer];
//}

#pragma mark - 类方法
+ (instancetype)navWithTitle:(NSString *)title rightItem:(NSString *)rightItem rightAction:(void (^)(void))action {
    return [[self alloc] initWithTitle_sl:title right:rightItem rightAction:action left:nil leftAction:nil backAction:nil];
}

+ (instancetype)navWithTitle:(NSString *)title {
    return [[self alloc] initWithTitle_sl:title right:nil rightAction:nil left:nil leftAction:nil backAction:nil];
}

+ (instancetype)navWithTitle:(NSString *)title backAction:(void (^)(void))backAction {
    return [[self alloc] initWithTitle_sl:title right:nil rightAction:nil left:nil leftAction:nil backAction:backAction];
}

+ (instancetype)navWithTitle:(NSString *)title rightItem:(NSString *)rightItem rightAction:(void (^)(void))action backAction:(void (^)(void))backAction {
    return [[self alloc] initWithTitle_sl:title right:rightItem rightAction:action left:nil leftAction:nil backAction:backAction];
}

+ (instancetype)navWithTitle:(NSString *)title
                   rightItem:(NSString *)rightItem
                 rightAction:(void (^)(void))action
                    leftItem:(NSString *)leftItem
                  leftAction:(void (^)(void))leftaction {

    return [[self alloc] initWithTitle_sl:title right:rightItem rightAction:action left:leftItem leftAction:leftaction backAction:nil];
}
@end

#import "TSNavigationBar.h"
static const char NavgationBarkey = '\0';
@implementation UIViewController (NavigatiionBar)

- (void)setTs_navgationBar:(TSNavigationBar *)ts_navgationBar {
    if (self.ts_navgationBar != ts_navgationBar) {
        [self.ts_navgationBar removeFromSuperview];
        [self.view addSubview:ts_navgationBar];
        objc_setAssociatedObject(self, &NavgationBarkey, ts_navgationBar, OBJC_ASSOCIATION_ASSIGN);
    }
}

- (TSNavigationBar *)ts_navgationBar {
    return objc_getAssociatedObject(self, &NavgationBarkey);
}

@end
