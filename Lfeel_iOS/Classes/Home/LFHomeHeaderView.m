//
//  LFHomeHeaderView.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/3.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFHomeHeaderView.h"
@interface LFHomeHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *mainTitleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorTitleNameLabel;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@end


@implementation LFHomeHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.contentView rm_fitAllConstraint];
}

-(void)setHeaderMainTitleName:(NSString *)mainTitleName andminorTitleName:(NSString *)minorTitleName{
    self.mainTitleNameLabel.text = mainTitleName;
    self.minorTitleNameLabel.text = minorTitleName;
}
@end
