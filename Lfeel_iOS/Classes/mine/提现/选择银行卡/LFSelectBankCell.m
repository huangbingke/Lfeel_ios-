//
//  LFSelectBankCell.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFSelectBankCell.h"
@interface LFSelectBankCell ()
@property (weak, nonatomic) IBOutlet UILabel *namelabel;

@end


@implementation LFSelectBankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(LFBanklistModel *)model{
    _model = model;
    
    self.namelabel.text = [NSString stringWithFormat:@"%@",model.bankName];
    
}

@end
