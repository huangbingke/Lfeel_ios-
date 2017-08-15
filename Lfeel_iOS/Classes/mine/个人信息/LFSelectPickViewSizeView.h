//
//  LFSelectPickViewSizeView.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/15.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFSelectPickViewSizeView : UIView

///  <#Description#>
@property (nonatomic,   copy) void (^didSelectCloseBtn)();
@property (nonatomic,   copy) void (^didSelectSaveBtn)(NSString * string ,NSString  *string2,NSString * string3);


@end
