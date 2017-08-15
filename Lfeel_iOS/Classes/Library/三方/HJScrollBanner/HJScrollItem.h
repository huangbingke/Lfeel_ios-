//
//  HJScrollItem.h
//  HJScrollImage
//
//  Created by hoojack on 15/8/8.
//  Copyright (c) 2015年 hoojack. All rights reserved.
//
#import <UIKit/UIKit.h>

@class HJScrollItemData;
@interface HJScrollItem : UIView

@property (nonatomic, strong) HJScrollItemData* data;
@property (nonatomic, weak) UIImageView* imageView;
@end
