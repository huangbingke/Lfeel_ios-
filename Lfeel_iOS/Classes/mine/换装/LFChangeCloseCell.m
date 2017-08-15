//
//  LFChangeCloseCell.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFChangeCloseCell.h"
@interface LFChangeCloseCell ()

@property (weak, nonatomic) IBOutlet UIView *contentBgView;
@property (weak, nonatomic) IBOutlet UILabel *attyColor;

@property (weak, nonatomic) IBOutlet UIImageView *imgUrl;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnCnstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btHi;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btw;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *right;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageContr;
@end

@implementation LFChangeCloseCell
{
    NSInteger index ;
}




-(void)awakeFromNib{
    [super awakeFromNib];
    [self.contentBgView rm_fitAllConstraint];
    index =1;
    
}
-(void)setModel:(LFapplyFaceliftListModel *)model{
    _model = model;
    self.selectBtn.selected = model.select;
    [self.imgUrl sd_setImageWithURL:[NSURL URLWithString:model.goodsUrl] placeholderImage:SLPlaceHolder];
    self.attyColor.text = [NSString stringWithFormat:@"%@",model.attribute ? : @""];
     self.namelabel.text = [NSString stringWithFormat:@"%@",model.goodsName];
}

-(void)setModel1:(LFapplyFaceliftListModel *)model1{
    _model1 = model1;
    if (index == 1) {
        self.selectBtn.hidden = YES;
        [self.btnCnstraint setConstant:0];
        
        [self.imageContr setConstant:Fit(15)];
        [self.btw setConstant:0];
        [self.btHi setConstant:0];
                [self.left setConstant:0];
                [self.right setConstant:0];
                [self.top setConstant:0];
        
        
    }
    [self.imgUrl sd_setImageWithURL:[NSURL URLWithString:model1.goodsUrl] placeholderImage:SLPlaceHolder];
    self.attyColor.text = [NSString stringWithFormat:@"%@",model1.attribute ? : @""];
    self.namelabel.text = [NSString stringWithFormat:@"%@",model1.goodsName];
    
    
}


@end
