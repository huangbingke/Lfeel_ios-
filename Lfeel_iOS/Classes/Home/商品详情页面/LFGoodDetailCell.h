//
//  LFGoodDetailCell.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/6.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "SLBaseTableViewCell.h"

@interface LFGoodDetailCell : SLBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *detailTextView;

- (void)adjustCellWithString:(NSString *)string;
+ (CGFloat)cellHeightWithString:(NSString *)string;
@end
