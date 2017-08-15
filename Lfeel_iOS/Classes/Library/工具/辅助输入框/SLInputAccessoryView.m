//
//  SLInputAccessoryView.m
//  晟轩生鲜
//
//  Created by Seven on 15/10/23.
//  Copyright (c) 2015年 Seven Lv. All rights reserved.
//

#import "SLInputAccessoryView.h"

@interface SLInputAccessoryView ()
@property (nonatomic,   weak) UIButton * btn;
@end

@implementation SLInputAccessoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
        self.backgroundColor = [UIColor whiteColor];
        UIButton * btn = [UIButton buttonWithTitle:@"完成" titleColor:[UIColor darkGrayColor] backgroundColor:nil font:15 image:nil frame:Rect([UIScreen mainScreen].bounds.size.width - 60, 0, 40, self.frame.size.height)];
        [btn addTarget:self action:@selector(endEdit)];
        [self addSubview:btn];
        self.btn = btn;

        UIView * devider = [UIView viewWithBgColor:[UIColor lightGrayColor] frame:Rect(0, 0, kScreenWidth, 1)];
        devider.alpha = 0.2;
        [self addSubview:devider];
    }
    return self;
}

+ (instancetype)inputAccessoryView
{
    return [[self alloc] init];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.btn.frame = Rect([UIScreen mainScreen].bounds.size.width - 45, 0, 40, self.frame.size.height);
}
- (void)endEdit {
     [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
@end
