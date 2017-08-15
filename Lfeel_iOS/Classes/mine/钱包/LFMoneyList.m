//
//  LFMoneyList.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFMoneyList.h"

@interface LFMoneyList ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation LFMoneyList
-(void)settitleLebelText:(NSString *)text{
    self.titleLabel.text = text;
}

- (IBAction)tapSelectBtn:(id)sender {
    if (self.didClickSelectedText) {
        self.didClickSelectedText();
    }
    
}


-(void)awakeFromNib{
    [super awakeFromNib];
    [self.bgView rm_fitAllConstraint];
}


@end
