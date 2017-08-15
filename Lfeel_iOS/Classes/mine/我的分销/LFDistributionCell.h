//
//  LFDistributionCell.h
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/7/5.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFUserGetRmbModel.h"
@interface LFDistributionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *getRmbLabel;



@property (nonatomic, strong) LFUserGetRmbModel *model;

@property (nonatomic, strong) LFAgentGetRmbModel *agentModel;

















@end
