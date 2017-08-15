//
//  LFHeaderView.h
//  Lfeel_iOS
//
//  Created by 陈泓羽 on 17/3/21.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFHeaderView : UIView
///  <#Description#>
@property (nonatomic,   copy) void (^didSelectAddressBtn)();
-(void)addressData:(LFAddressModel *)model;
@end
