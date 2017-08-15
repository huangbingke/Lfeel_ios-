//
//  HJScrollBanner.h
//  滚动视图
//
//  Created by Toocms on 15/9/11.
//  Copyright (c) 2015年 daiqian. All rights reserved.
//

typedef NS_ENUM(NSInteger, HJImageType) {
    HJImageURLType = 0, // 传url
    HJImageImageType // 传图片
};

#import <UIKit/UIKit.h>
#import "HJScrollImage.h"

@interface HJScrollBanner : UIView

/**
 *  传入一个 图片image的数组 传入一个HJScrollImage的对象  实现轮播图
 *
 *  @param ImageArray   数组  储存图片
 *  @param HJscrollView 对象  HJScrollImage对象
 *  @param imageType    图片类型  url图片HJImageUrl    本地图片HJImageImage
 *  @return nil
 */
+ (void)bannerWithArray:(NSArray <NSString *> *)array
            scrollImage:(HJScrollImage *)scrollImage
              imageType:(HJImageType)type;
@end
