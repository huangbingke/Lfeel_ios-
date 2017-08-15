//
//  UIImage+Compress.h
//  ImageCompress
//
//  Created by apple on 2016/11/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compress)

- (UIImage *)compressImageToScaleWidth:(CGFloat)width;
- (UIImage *)compressImageToScaleSize:(CGSize)size;

/// 将图片压缩成以640为宽，高度以图片自己的高度比例缩放
/// 比如图片size == 1280 * 2000, 压缩之后---> 640 * 1000; size == 1280 * 1000, 压缩之后---> 640 * 500
- (NSData *)compressToData;

@end
