//
//  LFClothesHeaderView.h
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/8/2.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFClothesHeaderView : UIView


@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *addShopCarBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;




///加入我的盒子
@property (nonatomic,   copy) void (^didSelectShopCarBtn)();


-(void)setSelectModelData:(LFGoodsDetailModel *)model;



@end
