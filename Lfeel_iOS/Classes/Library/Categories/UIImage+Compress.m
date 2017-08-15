//
//  UIImage+Compress.m
//  ImageCompress
//
//  Created by apple on 2016/11/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "UIImage+Compress.h"

@implementation UIImage (Compress)

- (UIImage *)compressImageToScaleSize:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)compressImageToScaleWidth:(CGFloat)newwidth {
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat newHeight = newwidth * height / width;
    return [self compressImageToScaleSize:CGSizeMake(newwidth, newHeight)];
}

- (NSData *)compressToData {
    if (self.size.width < 640) {
        return UIImageJPEGRepresentation(self, 0.9);
    }
    // 将图片尺寸缩到640 * xxx, `xxx`由图片自身高度决定
    UIImage * image = [self compressImageToScaleWidth:640];
    return UIImageJPEGRepresentation(image, 0.9);
}
@end
