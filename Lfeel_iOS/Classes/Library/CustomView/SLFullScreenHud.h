//
//  SLFullScreenHud.h
//  TKLMerchant
//
//  Created by Seven Lv on 16/11/15.
//  Copyright © 2016年 Seven Lv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLFullScreenHud : UIView

+ (instancetype)showWithTitles:(NSArray<NSString *> *)titles didClickAtIndex:(void(^)(NSInteger index))block;

@end
