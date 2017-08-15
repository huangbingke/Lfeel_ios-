//
//  LFCardBagCell.m
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/7/24.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFCardBagCell.h"

@implementation LFCardBagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super initWithCoder:aDecoder]) {
//        
//    }
//    return self;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self =[super initWithFrame: frame]) {
//
//    
//    }
//    return self;
//}

- (void)setModel:(LFCheapCardModel *)model {
    self.classLabel.text = @"乐荟券";
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.price];
    self.nameLabel.text = model.privilege_name;
    self.timeLabel.text = [NSString stringWithFormat:@"有效期:%@-%@",[self timeWithTimeIntervalString: model.privilege_start_time],[self timeWithTimeIntervalString: model.privilege_end_time]];
    
    
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString {
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}





@end
