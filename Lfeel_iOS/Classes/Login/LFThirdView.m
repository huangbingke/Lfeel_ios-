//
//  LFThirdView.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/4/16.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFThirdView.h"

@implementation LFThirdView
- (IBAction)_weChat:(id)sender {
    BLOCK_SAFE_RUN(self.didClickThirdBtnBlock, 0);
}
- (IBAction)_QQ:(id)sender {
    BLOCK_SAFE_RUN(self.didClickThirdBtnBlock, 1);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self rm_fitAllConstraint];
}

@end
