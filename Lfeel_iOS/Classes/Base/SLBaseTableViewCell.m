//
//  SLBaseTableViewCell.m
//  DaChengWaiMaiMerchant
//
//  Created by Seven Lv on 16/4/29.
//  Copyright © 2016年 Seven Lv. All rights reserved.
//

#import "SLBaseTableViewCell.h"

@interface SLBaseTableViewCell ()

@end

@implementation SLBaseTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [super awakeFromNib];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    NSString * ID = NSStringFromClass(self.class);
    SLBaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

+ (instancetype)defalutCellWithTableView:(UITableView *)tableView {
    
    return [self cellWithTableView:tableView];
}

@end
