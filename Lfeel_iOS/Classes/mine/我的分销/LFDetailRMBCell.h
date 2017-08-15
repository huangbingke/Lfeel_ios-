//
//  LFDetailRMBCell.h
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/7/6.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFUserGetRmbModel.h"
@interface LFDetailRMBCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tiemLabel;

@property (weak, nonatomic) IBOutlet UILabel *rmbLabel;

@property (weak, nonatomic) IBOutlet UILabel *getRMBLabel;

@property (nonatomic, strong) LFDetailRmbModel *detailModel;

















@end
