//
//  LFSelectBankViewController.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "BaseViewController.h"

@interface LFSelectBankViewController : BaseViewController
///<#name#>
@property (copy, nonatomic) void (^didSelectBank)(LFBanklistModel *model);

@end
