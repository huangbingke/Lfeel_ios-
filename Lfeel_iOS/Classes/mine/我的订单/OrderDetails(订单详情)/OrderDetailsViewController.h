//
//  OrderDetailsViewController.h
//  PocketJC
//
//  Created by kvi on 16/9/28.
//  Copyright © 2016年 CHY. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderDetailsViewController : BaseViewController
@property (nonatomic,   copy) NSString * order_id;
@property (nonatomic, assign) BOOL isOrderList;
@end
