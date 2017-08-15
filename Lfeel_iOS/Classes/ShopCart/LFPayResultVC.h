//
//  LFPayResultVC.h
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/5.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "BaseViewController.h"

@interface LFPayResultVC : BaseViewController
@property (nonatomic, assign) BOOL success;
@property (nonatomic,   copy) NSDictionary *orderInfo;
///  提示语是否显示简短文字
@property (nonatomic, assign) BOOL showShortTitle;

@end
