//
//  LFSettleCenterVC.h
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/4.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "BaseViewController.h"
#import "LFBuyModels.h"

@interface LFSettleCenterVC : BaseViewController
///  商品们
@property (nonatomic,   copy) NSArray<LFGoods *> * goodses;
///  购物车商品ID，以；隔开
@property (nonatomic,   copy) NSString * goodsCartIds;
@end
