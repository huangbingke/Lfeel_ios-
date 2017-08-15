//
//  LFSelectBankHeader.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFSelectBankHeader.h"

@interface LFSelectBankHeader ()
@property (weak, nonatomic) IBOutlet UIView *bgView;


@end
@implementation LFSelectBankHeader


-(void)awakeFromNib{
    [super awakeFromNib];
    [self.bgView rm_fitAllConstraint];
}

@end
