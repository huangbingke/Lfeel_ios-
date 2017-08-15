//
//  LFRentalCell.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFRentalCell.h"
#import "NSAttributedString+YYText.h"

@implementation LFRentalCell {
    
    __weak IBOutlet UILabel *_name;
    __weak IBOutlet UILabel *_date;
    __weak IBOutlet UILabel *_days;
    __weak IBOutlet UILabel *_money;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView rm_fitAllConstraint];
}


-(void)setModel:(LFRentEarningsRecordListModel *)model{
    _model = model;
    _name.text = model.accountName;
    _date.text = [NSString stringWithFormat:@"%@至%@", model.startDate, model.endDate];
    NSString * dayTxt = [NSString stringWithFormat:@"租期：%@天", model.leaseDay];
    NSString * moneyTxt = [NSString stringWithFormat:@"收益：%@乐荟币", model.earnings];
    NSMutableAttributedString * dayAttr = [[NSMutableAttributedString alloc] initWithString:dayTxt];
    UIColor * color = HexColorInt32_t(C00D23);
    [dayAttr yy_setColor:color range:[dayTxt rangeOfString:model.leaseDay]];
    _days.attributedText = dayAttr;
    
    NSMutableAttributedString * moneyAttr = [[NSMutableAttributedString alloc] initWithString:moneyTxt];
    [moneyAttr yy_setColor:color range:[moneyTxt rangeOfString:model.earnings]];
    _money.attributedText = moneyAttr;
}


@end
