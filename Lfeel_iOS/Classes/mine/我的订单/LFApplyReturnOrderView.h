//
//  LFApplyReturnOrderView.h
//  Lfeel_iOS
//
//  Created by Seven Lv on 2017/6/16.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFApplyReturnOrderView : UIView
///  收货状态 0未收货，1已收货
@property (nonatomic, assign, readonly) NSInteger status;
@property (nonatomic,   copy, readonly) NSString * reasonText;
@property (nonatomic,   copy, readonly) NSString * amountText;
@property (nonatomic,   copy, readonly) NSString * remarkText;
@property (nonatomic,   copy, readonly) NSArray<NSString *> * imageUrls;

- (void)setPrice:(NSString *)p;
@end


@interface LFApplyReturnOrderReasonView : UIView
+ (void)showWithCompleteHandle:(void (^)(NSInteger))block selectedType:(NSInteger)type;
@end
