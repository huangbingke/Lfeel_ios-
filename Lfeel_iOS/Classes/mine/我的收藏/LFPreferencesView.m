//
//  LFPreferencesView.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFPreferencesView.h"
@interface LFPreferencesView ()
@property (weak, nonatomic) IBOutlet UIView *contentView;


@end


@implementation LFPreferencesView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.contentView rm_fitAllConstraint];
}
- (IBAction)TapPreferenceBtn:(id)sender {
    
    if (self.didSelectPreferenceBtn) {
        self.didSelectPreferenceBtn();
    }
    
}

@end
