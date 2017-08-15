//
//  LFHotBottomView.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/1.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFHotBottomView.h"
@interface LFHotBottomView()
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
@implementation LFHotBottomView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.contentView rm_fitAllConstraint];
}
- (IBAction)TapSelectDelegeteBtn:(id)sender {
    SLLog2(@"删除");
    if (self.didSelectDelegeteBtn) {
        self.didSelectDelegeteBtn();
    }
}

- (IBAction)TapSelectColloctBtn:(id)sender {
    SLLog2(@"收藏");
    if (self.didSelectColloctBtn) {
        self.didSelectColloctBtn();
    }
}

- (IBAction)TapSelectSetpUpBtn:(id)sender {
    SLLog2(@"上一个");
    if (self.didSelectSetpUpBtn) {
        self.didSelectSetpUpBtn();
    }
}
@end
