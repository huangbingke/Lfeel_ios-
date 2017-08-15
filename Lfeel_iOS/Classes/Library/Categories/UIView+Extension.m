//
//  UIVew+SL.m
//  SPAHOME
//
//  Created by 吕超 on 15/4/7.
//  Copyright (c) 2015年 TooCMS. All rights reserved.
//
#import "UIView+Extension.h"
#import <objc/runtime.h>

#pragma mark - UIView (Extension)


@implementation UIView (Extension)
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)origin {
    return self.frame.origin;
}

- (CGFloat)halfWidth {
    return self.width * 0.5;
}

- (CGFloat)halfHeight {
    return self.height * 0.5;
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}


- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)bWidth borderColor:(UIColor *)bColor {
    self.borderWidth = bWidth;
    self.borderColor = bColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)bWidth borderColor:(UIColor *)bColor {
    self.cornerRadius = cornerRadius;
    [self setBorderWidth:bWidth borderColor:bColor];
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}
- (void)setMaxX:(CGFloat)maxX
{
    self.x = maxX - self.width;
}

- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}
- (void)setMaxY:(CGFloat)maxY
{
    self.y = maxY - self.height;
}

+ (instancetype)viewWithBgColor:(UIColor *)bgColor frame:(CGRect)frame {
    UIView * view = [[UIView alloc] initWithFrame:frame];
    if (!bgColor) {
        view.backgroundColor = [UIColor clearColor];
    } else {
        view.backgroundColor = bgColor;
    }
    return view;
}
+ (instancetype)creatView { return nil; }
///  从xib中加载和类名一样的xib
+ (instancetype)creatViewFromNib {
    return [self creatViewFromNibName:NSStringFromClass([self class]) atIndex:0];
}

+ (instancetype)creatViewFromNibName:(NSString *)aName atIndex:(NSInteger)index {
    return [[[NSBundle mainBundle] loadNibNamed:aName owner:nil options:nil] objectAtIndex:index];
}

- (UITableViewCell *)getTableViewCellIfExsited {
    
    UIView * view = self;
    while (view && ![view isKindOfClass:[UITableViewCell class]]) {
        view = self.superview;
    }
    
    if ([view isKindOfClass:[UITableViewCell class]]) {
        return (UITableViewCell *)view;
    }
    return nil;

}

#pragma mark 制作分隔线

UIView * sl_makeDevider(CGFloat width) {
    return sl_makeDeviderWithColor(width, [UIColor groupTableViewBackgroundColor]);
}
UIView * sl_makeDeviderWithRGB  (CGFloat width, CGFloat rgb) {
    return sl_makeDeviderWithColor(width, RGBColor(rgb, rgb, rgb));
}
extern UIView * sl_makeDeviderWithRGB2 (CGFloat width, CGFloat red, CGFloat green, CGFloat blue) {
    return sl_makeDeviderWithColor(width, RGBColor(red, green, blue));
}
extern UIView * sl_makeDeviderWithColor(CGFloat width, UIColor *color) {
    UIView * view = [UIView viewWithBgColor:nil frame:Rect(0, 0, width, 1)];
    CALayer * layer = [CALayer layer];
    layer.frame = Rect(0, 0.5, kScreenWidth, 0.5);
    layer.backgroundColor = color.CGColor;
    [view.layer addSublayer:layer];
    return view;
}
@end


#pragma mark - UILabel (Extension)
@implementation UILabel (Extension)

+ (instancetype)label_
{
    return [[UILabel alloc] init];
}

+ (instancetype)labelWithText:(NSString *)text font:(CGFloat)fontSize textColor:(UIColor *)color frame:(CGRect)frame
{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:fontSize];
    if (text) label.text = text;
    if (color) label.textColor = color;
    return label;
}
@end


#pragma mark - UIImageView
@implementation UIImageView (Extension)

+ (instancetype)imageViewWithImage:(UIImage *)image frame:(CGRect)frame {
    NSAssert(image != nil, @"图片不能为空");
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setImage:image];
    return imageView;
}

+ (instancetype)imageViewWithUrl:(NSURL *)url frame:(CGRect)frame {
    
    return [self imageViewWithUrl:url placeHolder:nil frame:frame];
}

+ (instancetype)imageViewWithUrl:(NSURL *)url placeHolder:(UIImage *)placeHolder frame:(CGRect)frame {
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView sd_setImageWithURL:url placeholderImage:placeHolder];
    return imageView;
}

@end

#pragma mark - UIScrollView
@implementation UIScrollView (Extension)

+ (instancetype)defaultScrollView {
    return [self scrollViewWithBgColor:nil frame:Rect(0, 64, kScreenWidth, kScreenHeight - 64)];
}

+ (instancetype)scrollViewWithBgColor:(UIColor *)bgColor frame:(CGRect)frame
{
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    if (bgColor) {
        scrollView.backgroundColor = bgColor;
    } else {
        scrollView.backgroundColor = [UIColor clearColor];
    }
    return scrollView;
}


@end



