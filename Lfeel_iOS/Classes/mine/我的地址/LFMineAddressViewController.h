//
//  LFMineAddressViewController.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "BaseViewController.h"

@interface LFMineAddressViewController : BaseViewController
@property (nonatomic,   copy) void (^didSelectedAddressBlock)(LFAddressModel *model);
@end
