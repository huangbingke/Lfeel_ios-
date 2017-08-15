//
//  OrderListViewController.h
//  PocketJC
//
//  Created by kvi on 16/9/27.
//  Copyright © 2016年 CHY. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderListViewController : UITableViewController
///刷新数据
- (void) reloadData;
///是否需要刷新数据
@property (nonatomic , assign ,getter=isNeedRefresh)BOOL needRefresh;

@property (nonatomic,   copy) VoidBlcok vblock;

@property (nonatomic, copy)NSString * type;





@end
