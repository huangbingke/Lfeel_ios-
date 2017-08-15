//
//  LFHotHireViewController.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/1.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "BaseViewController.h"

@interface LFHotHireViewController : BaseViewController
///  <#Description#>
@property (nonatomic,   copy) NSString * ID;
///  1=租赁 0=购
@property (nonatomic,   copy) NSString * type;

@property (nonatomic, copy) NSString *title;

@end
