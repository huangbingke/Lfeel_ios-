//
//  LFCollctCell.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "SLBaseTableViewCell.h"
#import "MGSwipeTableCell.h"

@interface LFCollctCell : MGSwipeTableCell
@property (nonatomic, strong) LFCollectioListModel * model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
