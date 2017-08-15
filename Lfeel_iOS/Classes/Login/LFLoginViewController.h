//
//  LFLoginViewController.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/23.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "BaseViewController.h"

@interface LFLoginViewController : BaseViewController
///回掉去到Vip页面
@property (copy, nonatomic)  void(^PushAddVipVC)();
///  未登录的否时候需要popToRoot
@property (nonatomic, assign) BOOL needPopToRootVC;
@end
