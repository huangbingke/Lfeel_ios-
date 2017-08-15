//
//  TSAddressPickerView.h
//  RunningMan
//
//  Created by Seven Lv on 16/1/16.
//  Copyright © 2016年 Toocms. All rights reserved.
//  地址选择

#import <UIKit/UIKit.h>
#import "TSAddress.h"

@interface TSAddressPickerView : UIView
/**
 *  创建地址选择
 *  用法：TSAddressPickerView * pickerView = [TSAddressPickerView addressPickerView];
 *  不需要设置frame,直接添加
 */
+ (instancetype)addressPickerView;

/** 
 *  结果block,value是 TSAddress
        @{@"province" : pro1,
        @"city"     : city1,
        @"district" : dis1}
 */
@property (nonatomic,   copy) DictionaryBlcok resultBlock;

- (void)show;
- (void)hidden;

+ (NSString *)addressForCityId:(NSString *)ID;





@end
