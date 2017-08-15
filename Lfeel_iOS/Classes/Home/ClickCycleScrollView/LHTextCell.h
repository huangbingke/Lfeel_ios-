//
//  LHTextCell.h
//  LFeelAPP
//
//  Created by 黄冰珂 on 2017/6/16.
//  Copyright © 2017年 黄冰珂. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CellHeightBlock)(CGFloat cellHeight);
@interface LHTextCell : UITableViewCell
@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *contentLabel;

- (void)adjustCellWithString:(NSString *)string;
+ (CGFloat)cellHeightWithString:(NSString *)string;

@property (nonatomic, assign) CGFloat rowHeight;




@end
