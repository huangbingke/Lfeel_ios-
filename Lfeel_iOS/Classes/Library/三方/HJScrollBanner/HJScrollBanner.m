//
//  HJScrollBanner.m
//  滚动视图
//
//  Created by Toocms on 15/9/11.
//  Copyright (c) 2015年 daiqian. All rights reserved.
//

#import "HJScrollBanner.h"
#import "HJScrollItem.h"
#import "HJScrollItemData.h"


@interface HJScrollBanner ()

@end

@implementation HJScrollBanner

+ (void)bannerWithArray:(NSArray *)array scrollImage:(HJScrollImage *)scrollImage imageType:(HJImageType)type
{
    NSMutableArray * tempArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i ++) {
        HJScrollItemData* data = [[HJScrollItemData alloc] init];
        id obj = array[i];
//        NSLog(@"________%@", [obj class]);
        if ([obj isKindOfClass:[UIImage class]]) {
            data.image = array[i];
        } else {
            data.imageName = array[i];
        }
        //            if (type == HJImageURLType) {
        //                data.url = YES;
        //            } else {
        //                data.url = NO;
        //            }
        // 这句相等于上面的判断
        data.url = type == HJImageURLType;
        
        
        [tempArray addObject:data];
    }
    scrollImage.datas = tempArray;

}

@end
