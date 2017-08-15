//
//  LHMyBoxCell.h
//  LFeelAPP
//
//  Created by 黄冰珂 on 2017/6/14.
//  Copyright © 2017年 黄冰珂. All rights reserved.
//

#import "LFBuyModels.h"
#import "MGSwipeTableCell.h"

@class LFGoods;

@interface LHMyBoxCell : MGSwipeTableCell
@property (strong, nonatomic) UIImageView *goodsImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *brandLabel;
@property (strong, nonatomic) UILabel *sizeLabel;
@property (nonatomic, strong) LFGoods * goods;

@end
