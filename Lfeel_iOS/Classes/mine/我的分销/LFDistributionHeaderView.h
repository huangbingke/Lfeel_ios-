//
//  LFDistributionHeaderView.h
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/7/5.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHSegmentControlView.h"

//typedef void(^ClickSegmentBlock)(NSInteger index);

@interface LFDistributionHeaderView : UIView



//总收益
@property (nonatomic, strong) UILabel *allGetLabel;

//总余额
@property (nonatomic, strong) UILabel *allRestLabel;

//当月收益
@property (nonatomic, strong) UILabel *mouthGetLabel;


@property (nonatomic, strong) LHSegmentControlView *segmentCV;


//提现
@property (nonatomic, strong) UIButton *getBtn;

//返回
@property (nonatomic, strong) UIButton *backBtn;




//@property (nonatomic, copy) ClickSegmentBlock clickBlock;
//
//
//- (void)clickSegmentBlock:(ClickSegmentBlock)block;
//










@end
