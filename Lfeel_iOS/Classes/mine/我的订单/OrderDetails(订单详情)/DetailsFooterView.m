//
//  DetailsFooterView.m
//  PocketJC
//
//  Created by kvi on 16/9/28.
//  Copyright © 2016年 CHY. All rights reserved.
//

#import "DetailsFooterView.h"

@interface DetailsFooterView ()
@property (weak, nonatomic) IBOutlet UILabel *totalFee;
///  实付
@property (weak, nonatomic) IBOutlet UILabel *actualFee;
///  信息view高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewHeighCons;
///  信息view
@property (weak, nonatomic) IBOutlet UIView *infoView;
///  背景约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeightCons;
@end
@implementation DetailsFooterView


- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setDetail:(_SLOrderDetail *)detail {
    _detail = detail;
    _totalFee.text = [NSString stringWithFormat:@"总计￥%@", detail.total_price];
    _actualFee.text = [NSString stringWithFormat:@"实付￥%.2f", detail.total_price.doubleValue ];
    
    NSDateFormatter * fmt = [NSDateFormatter new];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * creat_date = [fmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:detail.create_time.doubleValue]];
    
    NSArray * arr = @[
                      [NSString stringWithFormat:@"订单编号：%@", detail.order_sn],
                      [NSString stringWithFormat:@"下单时间：%@", creat_date],
                      [NSString stringWithFormat:@"支付方式：在线支付"],
                      ];
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel * label = self.infoView.subviews[idx];
        label.text = obj;
    }];
}
@end
