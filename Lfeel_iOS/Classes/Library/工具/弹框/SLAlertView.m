//
//  SLAlertView.m
//  AlertView
//
//  Created by Seven on 15/10/10.
//  Copyright (c) 2015年 Seven Lv. All rights reserved.
//

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#import "SLAlertView.h"
#import "Category.h"

typedef void (^AlertClickBlock)(int index);
static SLAlertView * alertView = nil;
static AlertClickBlock alertClickBlock = nil;

@implementation SLAlertView

+ (void)alertViewWithTitle:(NSString *)title cancelBtn:(NSString *)cancelbtn destructiveButton:(NSString *)des otherButtons:(NSArray *)array clickAtIndex:(void (^)(NSInteger))click
{
    if (click) alertClickBlock = [click copy];
    int count = 0;
    if (array) count += array.count;
    if (des) count++;
    if (cancelbtn) count++;
    
    SLAlertView * view = [[SLAlertView alloc] initWithFrame:Rect(0, 0, kWidth, kHeight)];
    alertView = view;
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelView)]];
    
    UIView * content = [[UIView alloc] initWithFrame:Rect(0, kHeight, kWidth, 100)];
    content.backgroundColor = [UIColor whiteColor];
    content.tag = 100;
    
    UILabel * titleLabel = nil;
    if (title) {
        // 标题
        titleLabel = [UILabel labelWithText:title font:13 textColor:[UIColor darkGrayColor] frame:Rect(0, 0, content.width, 50)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        UIView * devidr0 = [self makeDiveder];
        devidr0.y = titleLabel.maxY - 1;
        [content addSubview:titleLabel];
        [content addSubview:devidr0];
    }
    
    // 创建其它btn
    UIButton * temp = nil;
    for (int i = 0; i < array.count; i++) {
        CGRect frame = Rect(0, i * 45 + titleLabel.maxY, content.width, 44);
        UIButton * btn = [UIButton buttonWithTitle:array[i] titleColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] font:15 image:nil frame:frame];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:)];
        [content addSubview:btn];
        
        UIView * devider = [self makeDiveder];
        devider.y = btn.maxY;
        [content addSubview:devider];
        temp = btn;
    }
    
    CGFloat desY = 0;
    if (titleLabel && !temp) {
        desY = titleLabel.maxY;
    } else {
        desY = temp.maxY;
    }
    
    // destructiveButton
    UIButton * destructiveButton = nil;
    if (des) {
        destructiveButton = [UIButton buttonWithTitle:des titleColor:[UIColor redColor] backgroundColor:[UIColor clearColor] font:15 image:nil frame:Rect(0, desY, content.width, 44)];
        [content addSubview:destructiveButton];
        destructiveButton.tag = array.count;
        [destructiveButton addTarget:self action:@selector(btnClick:)];
    }
    
    CGFloat y = des ? destructiveButton.maxY : temp.maxY;
    UIView * devier2 = [UIView viewWithBgColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1] frame:Rect(0, y, kWidth, 5)];
    [content addSubview:devier2];
    
    UIButton * cancel = [UIButton buttonWithTitle:cancelbtn titleColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] font:15 image:nil frame:Rect(0, devier2.maxY, content.width, 40)];
    [content addSubview:cancel];
    [cancel addTarget:self action:@selector(cancelView)];
    
    content.height = cancel.maxY;
    view.hidden = YES;
    [view addSubview:content];
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    
    alertView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        content.y = alertView.height - content.height;
    }];
    
}

+ (UIView *)makeDiveder
{
    UIView * devider = [UIView viewWithBgColor:[UIColor lightGrayColor] frame:Rect(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
    devider.alpha = 0.2;
    return devider;
}

- (void)show
{
    alertView.hidden = NO;
    UIView * content = [alertView viewWithTag:100];
    [UIView animateWithDuration:0.25 animations:^{
        content.y = alertView.height - content.height;
    }];
}

+ (void)btnClick:(UIButton *)btn {
    if (alertClickBlock) {
        alertClickBlock((int)btn.tag);
    }
    [self cancelView];
}

+ (void)cancelView {
    
    UIView * content = [alertView viewWithTag:100];
    [UIView animateWithDuration:0.25 animations:^{
        content.y = alertView.height;
        alertView.alpha = 0;
    } completion:^(BOOL finished) {
        [alertView removeFromSuperview];
        alertView = nil;
        alertClickBlock = nil;
    }];
}

@end


#pragma mark - _UIAlertViewDelegate
static const void * _UIAlertViewYey = "_UIAlertViewYey";
@interface _UIAlertViewDelegate : NSObject <UIAlertViewDelegate>
@property (nonatomic,   copy) IndexBlock indexBlock;
@end

@implementation _UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.indexBlock) {
        self.indexBlock(buttonIndex);
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.indexBlock = nil;
    NSMutableSet * set = objc_getAssociatedObject([UIAlertView class], _UIAlertViewYey);
    if ([set containsObject:self]) {
        [set removeObject:self];
    }
}
@end

#pragma mark - UIAlertView (add)
@implementation UIAlertView (add)

+ (UIAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle OtherButtonsArray:(NSArray *)otherButtons clickAtIndex:(IndexBlock)indexBlock {
    
    _UIAlertViewDelegate * delegate = [_UIAlertViewDelegate new];
    delegate.indexBlock = indexBlock;
    [[self allDelegate] addObject:delegate];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:delegate
                                           cancelButtonTitle:cancelButtonTitle
                                           otherButtonTitles:nil, nil];
    
    for (int i = 0; i < otherButtons.count; i++) {
        [alert addButtonWithTitle:otherButtons[i]];
    }
    [alert show];
    return alert;
}

+ (NSMutableSet *)allDelegate {
    
    NSMutableSet * set = objc_getAssociatedObject(self, _UIAlertViewYey);
    if (set == nil) {
        set = [NSMutableSet set];
        objc_setAssociatedObject(self, _UIAlertViewYey, set, OBJC_ASSOCIATION_RETAIN);
    }
    return set;
}

@end

#pragma mark - _UIActionSheetDelegate

static const void * _UIActionSheetKey = "_UIActionSheetKey";
@interface _UIActionSheetDelegate : NSObject <UIActionSheetDelegate>
@property (nonatomic,   copy) IndexBlock indexBlock;
@end

@implementation _UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.indexBlock) {
        self.indexBlock(buttonIndex);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.indexBlock = nil;
    NSMutableSet * set = objc_getAssociatedObject([UIActionSheet class], _UIActionSheetKey);
    if ([set containsObject:self]) {
        [set removeObject:self];
    }
}

@end


#pragma mark - UIActionSheet (add)
@implementation UIActionSheet (add)

+ (UIActionSheet *)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle destructiveButtonTitle:(NSString *)desTitle otherButtonTitles:(NSArray *)others showInView:(UIView *)view clickAtIndex:(IndexBlock)indexBlock {
    
    _UIActionSheetDelegate * delegate = [_UIActionSheetDelegate new];
    delegate.indexBlock = indexBlock;
    [[self allDelegate] addObject:delegate];
    
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:title
                                                        delegate:delegate
                                               cancelButtonTitle:cancelTitle
                                          destructiveButtonTitle:desTitle
                                               otherButtonTitles:nil, nil];
    
    for (int i = 0; i < others.count; i++) {
        [sheet addButtonWithTitle:others[i]];
    }
    
    [sheet showInView:view];
    return sheet;
}
+ (NSMutableSet *)allDelegate {
    
    NSMutableSet * set = objc_getAssociatedObject(self, _UIActionSheetKey);
    if (set == nil) {
        set = [NSMutableSet set];
        objc_setAssociatedObject(self, _UIActionSheetKey, set, OBJC_ASSOCIATION_RETAIN);
    }
    return set;
}
@end