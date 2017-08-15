//
//  LFUsedCell.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFUsedCell.h"
#import "NSAttributedString+YYText.h"
@interface LFUsedCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgUrl;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *couLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *stausLabel;

@end


@implementation LFUsedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView rm_fitAllConstraint];
}

-(void)setModel:(LFidleRentListModel *)model{
    _model = model;
    NSArray * array = @[@"下架",@"上架" ,@"待审核",@"审核通过"];
    self.stausLabel.text = array[[model.goodsRentStatus integerValue]];
        self.nameLabel.text = [NSString stringWithFormat:@"%@",model.goodsName];
    [self.imgUrl sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",   model.goodsMainUrl]] placeholderImage:SLPlaceHolder];
    NSString * string=[NSString stringWithFormat:@"累计租出:%@次",model.rentNum ];
    NSMutableAttributedString *day = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange range = [string rangeOfString:model.rentNum];
    [day yy_setColor:HexColorInt32_t(FA5048) range:range];
    self.couLabel.attributedText = day;
   
    NSString * rentEarnings = [NSString stringWithFormat:@"%@",model.rentEarnings.formatNumber];
    
    NSString * string1=[NSString stringWithFormat:@"累计收益:%@乐荟币",rentEarnings];
    NSMutableAttributedString *day1 = [[NSMutableAttributedString alloc]initWithString:string1];
    
        NSRange range1 = [string1 rangeOfString: rentEarnings];
    [day1 yy_setColor:HexColorInt32_t(FA5048) range:range1];
   
    self.moneyLabel.attributedText = day1;
    
    

    
}
@end
