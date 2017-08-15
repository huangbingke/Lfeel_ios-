//
//  LFDetailRMBCell.m
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/7/6.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFDetailRMBCell.h"

@implementation LFDetailRMBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDetailModel:(LFDetailRmbModel *)detailModel {
    if ([[NSString stringWithFormat:@"%@", detailModel.finishTime] isEqualToString:@"审核中"]) {
        self.tiemLabel.text = [NSString stringWithFormat:@"%@", detailModel.finishTime];
    } else {
        self.tiemLabel.text = [NSString stringWithFormat:@"%@", [self timeWithTimeIntervalString:detailModel.finishTime]];
    }
    
    self.rmbLabel.text = [NSString stringWithFormat:@"%@", detailModel.price];
    self.getRMBLabel.text = detailModel.info;
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
