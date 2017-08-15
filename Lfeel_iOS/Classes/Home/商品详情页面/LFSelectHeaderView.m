//
//  LFSelectHeaderView.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/1.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFSelectHeaderView.h"
@interface LFSelectHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *addShopCarBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;

//售价
@property (weak, nonatomic) IBOutlet UILabel *stailPrice;
@property (weak, nonatomic) IBOutlet UILabel *installmentPrice;
@property (weak, nonatomic) IBOutlet UILabel *commentTotalLabel;

@end

@implementation LFSelectHeaderView


-(void)awakeFromNib{
    [super awakeFromNib];
    [self.contentView rm_fitAllConstraint];
}
- (IBAction)TapSelectShopCarAction:(id)sender {
    if (self.didSelectShopCarBtn) {
        self.didSelectShopCarBtn();
    }
}

- (IBAction)TapBuyNowAction:(id)sender {
    if (self.didSelectBayNowBtn) {
        self.didSelectBayNowBtn();
    }
}
- (IBAction)TapSelectXLBtn:(id)sender {
    if (self.didSelectXLBtn) {
        self.didSelectXLBtn();
    }
    
}
- (IBAction)TapGoodsEvaluationBtn:(id)sender {
    if (self.didSelectGoodEvationBtn) {
        self.didSelectGoodEvationBtn();
    }
}
- (IBAction)TapGoodsDetailBtn:(UIButton *)sender {
    if (self.didSelectGoodsDetailBtn) {
        self.didSelectGoodsDetailBtn();
    }
}


-(void)setSelectModelData:(LFGoodsDetailModel *)model{
    self.goodsName.text = [NSString stringWithFormat:@"%@",model.goodsName];
    self.stailPrice.text = [NSString stringWithFormat:@"乐荟价: ￥%@",model.store_price];
    self.commentTotalLabel.text = [NSString stringWithFormat:@"商品评价(%@)",model.commentTotal];
    self.installmentPrice.text = [NSString stringWithFormat:@"分期￥%@/月",model.paymentPrice];
}



@end
