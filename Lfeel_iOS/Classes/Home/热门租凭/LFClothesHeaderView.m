//
//  LFClothesHeaderView.m
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/8/2.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFClothesHeaderView.h"

@implementation LFClothesHeaderView


//加入我的盒子
- (IBAction)addBoxBtn:(UIButton *)sender {
    if (self.didSelectShopCarBtn) {
        self.didSelectShopCarBtn();
    }  
}



- (void)setSelectModelData:(LFGoodsDetailModel *)model {
    self.goodsName.text = [NSString stringWithFormat:@"%@",model.goodsName];
}



















/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
