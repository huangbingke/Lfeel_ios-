//
//  LFSelectBankfooterView.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFSelectBankfooterView.h"
@interface LFSelectBankfooterView()
@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

@implementation LFSelectBankfooterView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.bgView rm_fitAllConstraint];
}

- (IBAction)TapAddBankCode:(id)sender {
    if (self.DidAddBankCode) {
        self.DidAddBankCode();
    }
    
    SLLog2(@"添加银行卡");
}


@end
