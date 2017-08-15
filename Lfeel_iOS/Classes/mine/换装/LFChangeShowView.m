
//
//  LFChangeShowView.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/29.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFChangeShowView.h"

@implementation LFChangeShowView

- (IBAction)TapBtn:(id)sender {
    if (self.didselectBtn) {
        self.didselectBtn();
    }
}

@end
