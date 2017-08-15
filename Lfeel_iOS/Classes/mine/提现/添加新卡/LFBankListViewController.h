//
//  LFBankListViewController.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/22.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "BaseViewController.h"

@interface LFBankListViewController : BaseViewController
///  <#Description#>
@property (nonatomic,   copy) void (^didSelectBankName)(NSString *bankname);
@end
