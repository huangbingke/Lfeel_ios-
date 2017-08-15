//
//  DetailsCell.m
//  PocketJC
//
//  Created by kvi on 16/9/28.
//  Copyright © 2016年 CHY. All rights reserved.
//

#import "DetailsCell.h"

@implementation DetailsCell {
    
    __weak IBOutlet UIImageView *_icon;
    __weak IBOutlet UILabel *_name;
    __weak IBOutlet UILabel *_price;
    __weak IBOutlet UILabel *_count;
}

- (void)setDetail:(_SLOrderDetail *)detail {
    _detail = detail;
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:detail.goods_pic] placeholderImage:SLPlaceHolder];
    _name.text = detail.goods_name;
    _price.text = [NSString stringWithFormat:@"￥%@", detail.every_item_price];
    NSInteger c = detail.goods_number.doubleValue / detail.every_item_jin.doubleValue;
    _count.text = [NSString stringWithFormat:@"x%zd", c];
}

@end
