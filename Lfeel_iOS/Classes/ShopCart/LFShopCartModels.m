//
//  LFShopCartModels.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/11.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFShopCartModels.h"

@implementation LFShopCart

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"shoppingCartList" : [LFGoods class]};
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _selected = YES;
    }
    return self;
}
@end
