//
//  LFSeleSizeView.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/6.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFSeleSizeView : UIView
///  重新设置高度
@property (nonatomic,   copy) void (^didSetHeightView)(NSInteger sizeIndex, NSInteger colorIndex  );

///  <#Description#>
@property (nonatomic,   copy) void (^didTapCloseBtn)();
/// 点击确定
@property (nonatomic,   copy) void (^didTapSureBtn)(NSDictionary *dict);
/// 点击选择color  
@property (nonatomic,   copy) void (^didTapSelectColorBtn)();
/// 点击选择尺寸
@property (nonatomic,   copy) void (^didTapSizeBtn)();



-(void)setModelData:(LFGoodsDetailModel *)model;

@end
