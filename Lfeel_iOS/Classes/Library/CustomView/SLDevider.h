//
//  SLDevider.h
//  TCYG
//
//  Created by Seven Lv on 16/6/13.
//  Copyright © 2016年 Seven Lv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLDevider : UIView

///  分隔线颜色 默认（222, 223, 224）
@property (nonatomic, strong) UIColor *deviderColor;
///  分隔线颜色 默认0.5 最大为1
@property (nonatomic, assign) CGFloat deviderHeigth;

@end
