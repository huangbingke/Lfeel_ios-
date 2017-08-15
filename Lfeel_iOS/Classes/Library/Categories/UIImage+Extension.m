//
//  UIImage+Extension.h
//
//
//  Created by apple on 14-4-2.
//  Copyright (c) 2014年 Seven Lv All rights reserved.
//  UIImage分类

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
/**
 *  返回一张可以随意拉伸不变形的图片
 *
 *  @param name 图片名字
 */
+ (UIImage *)resizableImage:(NSString *)name
{
    UIImage *normal = [UIImage imageNamed:name];
//    CGFloat w = normal.size.width * 0.5;
//    CGFloat h = normal.size.height * 0.5;
    CGFloat w = normal.size.width * 0.5;
    CGFloat h = normal.size.height * 0.75;
    CGFloat h2 = normal.size.height * 0.25;
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h2, w)];
}

+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 1.加载原图
    UIImage *oldImage = [UIImage imageNamed:name];
    
    // 2.开启上下文
    CGFloat imageW = oldImage.size.width + 2 * borderWidth;
    CGFloat imageH = oldImage.size.height + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (instancetype)captureWithView:(UIView *)view
{
    // 1.开启上下文
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    
    // 2.将控制器view的layer渲染到上下文
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 3.取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)image:(UIImage *)image rotatedByDegrees:(CGFloat)degrees
{
    return [image imageRotatedByDegrees:degrees];
}
- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)clipImageToHexagon:(CGSize)size {
    
    UIImage *image = self;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat width = size.width;
    double fff = sqrt(3) * width * 0.25;
    CGRect rect = CGRectMake(0, 0, width, width);
    
    CGContextMoveToPoint(context, width * 0.5, 0);
    CGContextAddLineToPoint(context, width * 0.5 - fff, width * 0.25);
    CGContextAddLineToPoint(context, width * 0.5 - fff, width * 0.75);
    CGContextAddLineToPoint(context, width * 0.5, width);
    CGContextAddLineToPoint(context, width * 0.5 + fff, width * 0.75);
    CGContextAddLineToPoint(context, width * 0.5 + fff, width * 0.25);
    CGContextClosePath(context);
    CGContextClip(context);
    [image drawInRect:rect];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)clipImageToHexagon:(UIImage *)image imageSize:(CGSize)size
{
    return [image clipImageToHexagon:size];
}

- (CGFloat)fitHeight:(CGFloat)h {
    CGSize size = self.size;
    return size.width * h / size.height;
}

- (CGFloat)fitWidth:(CGFloat)w {
    CGSize size = self.size;
    return size.height * w / size.width;
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
