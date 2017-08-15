//
//  LFShopCartModels.h
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/11.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFBuyModels.h"

@interface LFShopCart : NSObject <YYModel>
@property (nonatomic,   copy) NSString * goodsPlatform;
@property (nonatomic,   copy) NSArray<LFGoods *> * shoppingCartList;
@property (nonatomic, assign, getter=isSelected) BOOL selected;
@end
