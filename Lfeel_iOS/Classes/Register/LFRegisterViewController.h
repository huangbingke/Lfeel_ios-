//
//  LFRegisterViewController.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/23.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "BaseViewController.h"


typedef void(^UsernamePassBlock)(NSString *username, NSString *password);

@interface LFRegisterViewController : BaseViewController


@property (nonatomic, copy) UsernamePassBlock userPassBlock;





































@end
