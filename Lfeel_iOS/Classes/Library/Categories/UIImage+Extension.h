//
//  UIImage+Extension.h
//
//
//  Created by apple on 14-4-2.
//  Copyright (c) 2014年 Seven Lv All rights reserved.
//  UIImage分类

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  拉伸图片:(传入一张图片,返回一张可随意拉伸的图片)
 *
 *  @param name 图片名
 */
+ (UIImage *)resizableImage:(NSString *)name;
/**
 *  为图片加相框
 */
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
/**
 *  截图
 *
 *  @param view 需要截图的View
 */
+ (instancetype)captureWithView:(UIView *)view;

/**
 *  旋转图片
 *
 *  @param degrees 角度(正数为顺时针，负数为逆时针)
 *
 *  @return 旋转之后的图片
 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
+ (UIImage *)image:(UIImage *)image rotatedByDegrees:(CGFloat)degrees;

/**
 *  将一张图片裁剪成正6边形
 *
 *  @return 正6边形图片
 */
+ (UIImage *)clipImageToHexagon:(UIImage *)image imageSize:(CGSize)size;
- (UIImage *)clipImageToHexagon:(CGSize)size;


///  给定宽度或高度，根据自己的高度比算高度
- (CGFloat)fitWidth:(CGFloat)w;
- (CGFloat)fitHeight:(CGFloat)h;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end