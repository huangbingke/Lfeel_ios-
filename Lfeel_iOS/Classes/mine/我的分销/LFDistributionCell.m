//
//  LFDistributionCell.m
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/7/5.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFDistributionCell.h"

@implementation LFDistributionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setModel:(LFUserGetRmbModel *)model {
    self.userLabel.text = model.customersName;
    self.getRmbLabel.text = [NSString stringWithFormat:@"+ %.2f", [model.price doubleValue]];
    if (![model.finishTime isKindOfClass:[NSNull class]]) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@", [self timeWithTimeIntervalString:model.finishTime]];
    }
}

- (void)setAgentModel:(LFAgentGetRmbModel *)agentModel {
    self.userLabel.text = agentModel.agentName;
    self.timeLabel.text = [NSString stringWithFormat:@"+ %.2f", [agentModel.agents_this_month doubleValue]];
    self.getRmbLabel.text = [NSString stringWithFormat:@"+ %.2f", [agentModel.agents_total_month doubleValue]];
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
