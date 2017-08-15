//
//  SLNavigationButton.h
//  TKLMerchant
//
//  Created by Seven Lv on 16/10/26.
//  Copyright © 2016年 Seven Lv. All rights reserved.

#import <UIKit/UIKit.h>

@interface SLNavigationButton : UIView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title action:(VoidBlcok)action;

///  文字
@property (nonatomic,   copy) NSString * title;
@property (nonatomic, strong) NSAttributedString * attibutedString;

@end
