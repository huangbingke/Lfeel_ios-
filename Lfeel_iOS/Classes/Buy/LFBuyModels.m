//
//  LFBuyModels.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/5.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFBuyModels.h"

@implementation LFBuyCategory

@end

@implementation LFBuyBrand

@end

@implementation LFGoods

- (instancetype)init {
    self = [super init];
    if (self) {
        _selected = YES;
    }
    return self;
}

- (NSString *)goodsCartId {
    if (_goodsCartId == nil) {
        _goodsCartId = _goodsCarId;
    }
    return _goodsCartId;
}

- (NSString *)sl_fenqing {
    if (!_sl_fenqing) {
        _sl_fenqing = _stagesPrice ? : _rentalPrice;
    }
    return _sl_fenqing;
}

@end


@implementation LFCardInfo
@end

@implementation LFPayModel

@end
