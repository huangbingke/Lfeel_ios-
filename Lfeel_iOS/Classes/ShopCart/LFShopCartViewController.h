//
//  LFShopCartViewController.h
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/1.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "BaseViewController.h"

@interface LFShopCartViewController : BaseViewController
///  是否为子页面(从别的页面跳到购物车的时候，设置为yes)
@property (nonatomic, assign, getter=isSubPage) BOOL subPage;
@end
