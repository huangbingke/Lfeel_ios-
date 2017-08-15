//
//  LFSecurityViewController.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/23.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "BaseViewController.h"

@interface LFSecurityViewController : BaseViewController
@property (nonatomic, assign, getter=isBind) BOOL bind;
@property (nonatomic,   copy) NSString * loginKey;
@end
