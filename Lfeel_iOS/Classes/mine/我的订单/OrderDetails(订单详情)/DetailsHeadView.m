//
//  DetailsHeadView.m
//  PocketJC
//
//  Created by kvi on 16/9/28.
//  Copyright © 2016年 CHY. All rights reserved.
//


#import "DetailsHeadView.h"

@interface DetailsHeadView ()
@property (weak, nonatomic) IBOutlet UILabel *titleStatus;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
///  取货地点
@property (weak, nonatomic) IBOutlet UILabel *address;
///  订单详情里面的地址
@property (weak, nonatomic) IBOutlet UILabel *getGoodsAddress;

@end

@implementation DetailsHeadView

- (void)setDetail:(_SLOrderDetail *)detail {
    _detail = detail;
    self.titleStatus.text =  self.statusStr;
    self.name.text = [NSString stringWithFormat:@"买家名称：%@", detail.name] ;
    self.phone.text = [NSString stringWithFormat:@"联系电话：%@", detail.tell_phone];
    self.address.text = [NSString stringWithFormat:@"取货地点：%@", detail.relay_name];
    self.getGoodsAddress.text = detail.relay_name;
}

- (NSString *)statusStr {
    if (!self.detail) return nil;
    static NSArray * _statusArray;
    
    if (_statusArray == nil) {
        _statusArray = @[@"待发货", @"", @"待评价", @"已完成"];
    }
    
    if (self.detail.status == 2) {
        if (self.detail.r_m_verify == 0 && self.detail.is_complaints == 0) {
            return  @"待收货";
        } else if (self.detail.r_m_verify == 1 && self.detail.is_complaints == 0) {
            return  @"确认收货";
        }
        return  @"已投诉";
    }
    return _statusArray[self.detail.status - 1];
}

@end
