//
//  LFOrdersModel.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/26.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFOrdersModel.h"

@implementation LFOrder

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"orderDetailedList" : @"LFGoods"};
}

- (NSString *)statusString {
    if (!_statusString) {
//        0=订单取消状态 1=全部订单 2=待付款 3=待发货 4=待收货，7完成订单,8已经评价，9退货成功, 10已申请退货
        NSArray * arr = @[@"已取消", @"", @"待付款", @"待发货", @"待收货", @"", @"", @"待评价", @"已评价", @"退货成功", @"已申请退货", @""];
        return arr[self.orderStatus];
    }
    return _statusString;
}

@end

@implementation LFOrderDetail

@end
