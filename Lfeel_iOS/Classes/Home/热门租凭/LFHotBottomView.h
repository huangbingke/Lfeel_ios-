//
//  LFHotBottomView.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/1.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFHotBottomView : UIView
///
@property (nonatomic,   copy) void(^didSelectDelegeteBtn)();
@property (nonatomic,   copy) void(^didSelectColloctBtn)();
@property (nonatomic,   copy) void(^didSelectSetpUpBtn)();


@end
