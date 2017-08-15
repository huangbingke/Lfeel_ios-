//
//  SLShopCell.m
//  WaterLayout
//
//  Created by Seven Lv on 16/4/6.
//  Copyright © 2016年 Toocms. All rights reserved.
//

#import "SLShopCell.h"
//#import "Shop.h"
#import "UIImageView+WebCache.h"

@interface SLShopCell ()
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SLShopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self rm_fitAllConstraint];
}



-(void)setShop:(LFerenceViewModel *)shop{
    _shop = shop;
    

    self.nameLabel.text = [NSString stringWithFormat:@"%@",shop.goodsName];
//    self.price.text = [NSString stringWithFormat:@"￥%@",    shop.stagesPrice.formatNumber];
    
    [self.picture sd_setImageWithURL:[NSURL URLWithString:shop.goodsUrl] placeholderImage:SLPlaceHolder];
}

@end
