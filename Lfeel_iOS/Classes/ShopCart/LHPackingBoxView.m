//
//  LHPackingBoxView.m
//  LFeelAPP
//
//  Created by 黄冰珂 on 2017/6/14.
//  Copyright © 2017年 黄冰珂. All rights reserved.
//

#import "LHPackingBoxView.h"

@implementation LHPackingBoxView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame packingStatusString:(NSString *)packingLabelStr packingButtonTitle:(NSString *)packingButtonTitle {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *packLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth/3*2-10, frame.size.height-20)];
        packLabel.text = packingLabelStr;
        packLabel.font = kFont(17);
        packLabel.textColor = [UIColor lightGrayColor];
        packLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:packLabel];
        
        UIButton *packBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        packBtn.frame = CGRectMake(kScreenWidth/3*2, 0, kScreenWidth/3, frame.size.height);
        [packBtn setTitle:packingButtonTitle forState:(UIControlStateNormal)];
        packBtn.backgroundColor = [UIColor redColor];
        packBtn.titleLabel.font = kFont(17);
        [packBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [packBtn addTarget:self action:@selector(handldPacking:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:packBtn];
    }
    return self;
}

- (void)handldPacking:(UIButton *)sender {
    if (self.clickPackingBtnBlock) {
        self.clickPackingBtnBlock(sender.titleLabel.text);
    }
}


- (void)clickPackingButtonBlock:(ClickPackingButtonBlock)block {
    self.clickPackingBtnBlock = block;
}

//
//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        CustomButton *allBtn = [[CustomButton alloc] initWithFrame:CGRectMake(15, 0, kAllBarHeight*kRatio, kAllBarHeight*kRatio) imageFrame:CGRectMake(5, 0, kAllBarHeight*kRatio-10, kAllBarHeight*kRatio-10) imageName:@"MyBox_click_default" titleLabelFrame:CGRectMake(5, kAllBarHeight*kRatio-15, kAllBarHeight*kRatio-10, 14*kRatio) title:@"全部" titleColor:[UIColor lightGrayColor] titleFont:12*kRatio bageLabelSize:CGSizeMake(0, 0)];
////        UIButton *allBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
////        [allBtn setTitle:@"全部" forState:(UIControlStateNormal)];
////        [allBtn setImage:[UIImage imageNamed:@"MyBox_unChoose"] forState:(UIControlStateNormal)];
//        [allBtn addTarget:self action:@selector(allBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
//        [self addSubview:allBtn];
//        
//        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAllBarHeight*kRatio+20, 5, kScreenWidth/3*2-kAllBarHeight*kRatio-5, kAllBarHeight*kRatio-10)];
//        self.priceLabel.text = @"总价:";
//        self.priceLabel.font = kFont(14);
//        [self addSubview:self.priceLabel];
//        
//        UIButton *accountButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
//        [accountButton setTitle:@"去结算" forState:(UIControlStateNormal)];
//        [accountButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//        accountButton.titleLabel.font = kFont(16*kRatio);
//        accountButton.backgroundColor = [UIColor redColor];
//        accountButton.frame = CGRectMake(kScreenWidth/3*2, 0, kScreenWidth/3, kAllBarHeight*kRatio);
//        [accountButton addTarget:self action:@selector(accrountBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
//        [self addSubview:accountButton];
//        
//        
//        
//    }
//    return self;
//}


//- (void)allBtnAction:(CustomButton *)sender {
//    sender.selected = !sender.selected;
//    if (sender.selected == YES) {
//        sender.titleImageView.image = [UIImage imageNamed:@"MyBox_clicked"];
//    } else {
//        sender.titleImageView.image = [UIImage imageNamed:@"MyBox_click_default"];
//    }
//    if (self.allClickGoodsBlock) {
//        self.allClickGoodsBlock();
//    }
//    
//}

//- (void)allClickGoodsBlock:(AllClickGoodsBlock)block {
//    self.allClickGoodsBlock = block;
//}
//
//- (void)accrountBtnAction:(UIButton *)sender {
//    if (self.goAccrountBlock) {
//        self.goAccrountBlock();
//    }
//}
//
//- (void)goAccrountGoodsBlock:(GoAccrountBlock)block {
//    self.goAccrountBlock = block;
//}



@end
