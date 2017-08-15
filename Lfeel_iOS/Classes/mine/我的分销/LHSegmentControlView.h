//
//  LHSegmentControlView.h
//  LFeelAPP
//
//  Created by 黄冰珂 on 2017/6/14.
//  Copyright © 2017年 黄冰珂. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ClickTitleButtonBlock)(NSInteger index);


@interface LHSegmentControlView : UIView



@property (nonatomic, strong) UIView *sliderView;

@property (nonatomic, assign) BOOL isClick;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray titleFont:(UIFont *)titleFont titleDefineColor:(UIColor *)titleColor titleSelectedColor:(UIColor *)selectedColor;



@property (nonatomic, copy) ClickTitleButtonBlock clickBlock;


- (void)clickTitleButtonBlock:(ClickTitleButtonBlock)block;



























@end
