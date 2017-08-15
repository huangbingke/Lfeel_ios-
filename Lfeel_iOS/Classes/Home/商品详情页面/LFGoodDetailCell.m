//
//  LFGoodDetailCell.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/6.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFGoodDetailCell.h"
@interface LFGoodDetailCell ()


@property (weak, nonatomic) IBOutlet UIView *bgView;

@end


@implementation LFGoodDetailCell



-(void)awakeFromNib{
    [super awakeFromNib];
    [self.bgView rm_fitAllConstraint];
}



@end
