//
//  SLWaterLayout.h
//  WaterLayout
//
//  Created by Seven Lv on 16/4/6.
//  Copyright © 2016年 Toocms. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

///  总列数
static const NSUInteger coloumsCount = 2;
///  行距
static const CGFloat rowMargin = 8;
///  列距
static const CGFloat coloumsMargin = 8;

@interface SLWaterLayout : UICollectionViewLayout

///  高度block，通过这个block返回cell的高度
@property (nonatomic,   copy) CGFloat (^heightBlock)(NSInteger item, CGFloat width);

@end
