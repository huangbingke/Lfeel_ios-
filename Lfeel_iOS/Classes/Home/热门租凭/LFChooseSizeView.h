//
//  LFChooseSizeView.h
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/8/3.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFChooseSizeView : UIView



@property (weak, nonatomic) IBOutlet UIView *sizeBgView;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sizeViewConstraint;
@property (weak, nonatomic) IBOutlet UIView *ColorBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorViewConstraint;

@property (weak, nonatomic) IBOutlet UIView *addNumberBgView;

@property (weak, nonatomic) IBOutlet UIImageView *AbridgeImgUrl;


@property (weak, nonatomic) IBOutlet UILabel *colorLabel;

@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ColorConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SizeConstaint;
@property (weak, nonatomic) IBOutlet UITextField *numberTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIButton *addButton;






///  重新设置高度
@property (nonatomic,   copy) void (^didSetHeightView)(NSInteger sizeIndex, NSInteger colorIndex  );

@property (nonatomic,   copy) void (^didTapCloseBtn)();
/// 点击确定
@property (nonatomic,   copy) void (^didTapSureBtn)(NSDictionary *dict);
/// 点击选择color
@property (nonatomic,   copy) void (^didTapSelectColorBtn)();
/// 点击选择尺寸
@property (nonatomic,   copy) void (^didTapSizeBtn)();



-(void)setModelData:(LFGoodsDetailModel *)model;







@end
