//
//  LFShareView.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/2.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFShareView : UIView

@property (nonatomic,   copy) void (^didClickBtnBlock)(BOOL cancel, NSInteger index);

@end
