//
//  LFSelectBankfooterView.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFSelectBankfooterView : UIView
///    选择银行卡
@property (nonatomic,   copy) void (^DidAddBankCode)() ;
@end
