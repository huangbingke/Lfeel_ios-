//
//  LFDateView.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFDateView : UIView

///<#title#>
@property (copy, nonatomic)  void(^didStarTimer)(NSString *starTimer,NSString*startimer);
@property (copy, nonatomic)  void(^didendTimer)(NSString *endTimer,NSString *endtimer);
///  didType
@property (nonatomic,   copy) void(^didType)(NSInteger  index);

///  <#Description#>
@property (nonatomic, assign) BOOL  hidden1;

@end
