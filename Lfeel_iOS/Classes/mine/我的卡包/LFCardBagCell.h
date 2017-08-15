//
//  LFCardBagCell.h
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/7/24.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFCheapCardModel.h"
@interface LFCardBagCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;




@property (nonatomic, strong) LFCheapCardModel *model;





@end
