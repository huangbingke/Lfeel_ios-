//
//  HJScrollImage.h
//  HJScrollImage
//
//  Created by hoojack on 15/8/8.
//  Copyright (c) 2015年 hoojack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJScrollImage : UIView

@property (nonatomic, strong) NSArray * datas;
@property (nonatomic,   weak) UIPageControl * pageControl;
@property (nonatomic, assign) UIViewContentMode imageContentMode;
@property (nonatomic, strong) UIImage * placeholderImage;
- (void)stop;
@end
