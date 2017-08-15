//
//  LFIntergerDetailCell.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFIntergerDetailCell.h"
#import "NSAttributedString+YYText.h"
@interface LFIntergerDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeNamLabel;

@end

@implementation LFIntergerDetailCell
 

-(void)setModel:(LFIntegralModel *)model{
    _model = model;
    if ([model.type isEqualToString:@"2"]) {
    self.titleLabel1.text  = [NSString stringWithFormat:@"乐荟币%@",@"积分提现"];
    }else{
    self.titleLabel1.text  = [NSString stringWithFormat:@"乐荟币%@",model.typeName];
    }
    self.dateLabel.text = [NSDate dateWithTimeIntervalSince1970:model.operDate/1000 dateFormat:2];
    
    
      NSString * str1 = [NSString stringWithFormat:@"%@",model.typeName];
   
    NSRange range1111 = [str1 rangeOfString:@"提取"];
        NSString * str;
    if (range1111.length > 0) {
        str = [NSString stringWithFormat:@"-%@乐荟币,提现￥%@",model.integral.formatNumber,model.integralAmount.formatNumber];
        
    }else{
        str = [NSString stringWithFormat:@"%@乐荟币,提现￥%@",model.integral.formatNumber,model.integralAmount.formatNumber];
    }
    self.typeNamLabel.textColor = HexColorInt32_t(333333);
    
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
    NSString * string ;
    if (range1111.length > 0) {
        string = [NSString stringWithFormat:@"-%@乐荟币",model.integral.formatNumber];
    }else{
        string = [NSString stringWithFormat:@"%@乐荟币",model.integral.formatNumber];
    }
    
    
    NSString * string1 = [NSString stringWithFormat:@"￥%@",model.integralAmount.formatNumber];
    NSRange  range  =[str rangeOfString:string];
    NSRange  range1  =[str rangeOfString:string1];
    [attr yy_setColor:HexColorInt32_t(FA5048) range:range];
    [attr yy_setColor:HexColorInt32_t(FA5048) range:range1];
    self.typeNamLabel.attributedText =attr ;
 
}


@end
