//
//  LFOrderDetailView.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/4/4.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFOrderDetailView.h"

@implementation LFOrderDetailView {
    
    __weak IBOutlet UILabel *_orderNO;
    __weak IBOutlet UILabel *_orderTime;
    __weak IBOutlet UILabel *_orderStatus;
    
    __weak IBOutlet UILabel *_payType;
    
    __weak IBOutlet UILabel *_contact;
    __weak IBOutlet UILabel *_address;
    __weak IBOutlet UILabel *_deliveryType;
}

- (void)setDetail:(LFOrderDetail *)detail {
    _detail = detail;
    NSArray * arr = @[@"已取消", @"", @"待付款", @"待发货", @"待收货", @"", @"", @"待评价", @"已评价",@"退货成功", @"已申请退货", @""];
    _orderNO.text = [NSString stringWithFormat:@"订单编号：%@", detail.orderCode];
    _orderTime.text = [NSString stringWithFormat:@"下单时间：%@", detail.orderDatetime];
    _orderStatus.text = [NSString stringWithFormat:@"订单状态：%@", arr[detail.orderStatus.integerValue]];
    _payType.text = [NSString stringWithFormat:@"支付方式：%@", detail.payType];
    _contact.text = [NSString stringWithFormat:@"收货信息：%@", detail.userInfo];
    _address.text = [NSString stringWithFormat:@"收货地址：%@", detail.addressInfo];
    _deliveryType.text = [NSString stringWithFormat:@"配送方式：%@ %@", detail.transportMode, detail.transportCompany];
}

@end
