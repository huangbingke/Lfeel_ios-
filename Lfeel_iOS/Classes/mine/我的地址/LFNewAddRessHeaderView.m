//
//  LFNewAddRessHeaderView.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFNewAddRessHeaderView.h"
@interface LFNewAddRessHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *contentView;


@end

@implementation LFNewAddRessHeaderView


-(void)awakeFromNib{
    [super awakeFromNib];
    [self.contentView rm_fitAllConstraint];
//    self.province.hidden = YES;
    
    UITapGestureRecognizer * tap = [UITapGestureRecognizer new];
    @weakify(self);
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        BLOCK_SAFE_RUN(self.didClickProvinceBlock);
    }];
    [self.province.superview addGestureRecognizer:tap];
}
- (void)setAddress:(NSString *)address {
    _address = [address copy];
    _province.text = address;
//    _province.hidden = NO;
}
@end
