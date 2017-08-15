//
//  LFSelectHeaderView.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/1.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFSelectHeaderView : UIView


///加入购物车
@property (nonatomic,   copy) void (^didSelectShopCarBtn)();
/// 立即购买
@property (nonatomic,   copy) void (^didSelectBayNowBtn)();
///选择尺码
@property (nonatomic,   copy) void (^didSelectXLBtn)();
///商品评价
@property (nonatomic,   copy) void (^didSelectGoodEvationBtn)();
//商品细节
@property (nonatomic,   copy) void (^didSelectGoodsDetailBtn)();

-(void)setSelectModelData:(LFGoodsDetailModel *)model;


@end
