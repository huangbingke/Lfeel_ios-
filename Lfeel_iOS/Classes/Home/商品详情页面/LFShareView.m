//
//  LFShareView.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/2.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFShareView.h"
@interface LFShareView()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end


@implementation LFShareView


-(void)awakeFromNib{
    [super awakeFromNib];
    [self.bgView rm_fitAllConstraint];
    
    for (int i = 1; i < 6; i++) {
        UIButton * btn = (UIButton *)[self.bgView viewWithTag:i];
        [btn.rac_touchupInsideSignal subscribeNext:^(UIButton * x) {
            BLOCK_SAFE_RUN(self.didClickBtnBlock, (x.tag == 1), x.tag - 2);
        }];
    }
    
}



@end
