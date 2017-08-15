//
//  LFRentalView.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFRentalView.h"
#import "NSAttributedString+YYText.h"
@interface LFRentalView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageUrl;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentDayLabel;

@property (weak, nonatomic) IBOutlet UILabel *rentEarningsLabel;

@end



@implementation LFRentalView


-(void)awakeFromNib{
    [super awakeFromNib];
    [self rm_fitAllConstraint];
}


 

-(void)setDictData:(NSDictionary *)dict{
    
    
    [self.imageUrl sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", dict[@"goodsUrl"]]] placeholderImage:SLPlaceHolder];
    
    
    NSString * renaString = [NSString stringWithFormat:@"%@",dict[@"rentNum"]];
    NSString * rentEarnings = [NSString stringWithFormat:@"%@",dict[@"rentEarnings"]];
    
    NSString * string=[NSString stringWithFormat:@"累计租出:%@次",renaString];
    NSMutableAttributedString *day = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange range = [string rangeOfString:renaString];
    [day yy_setColor:HexColorInt32_t(FA5048) range:range];
    self.rentDayLabel.attributedText = day;
    
    
    NSString * string1=[NSString stringWithFormat:@"累计收益:%@乐荟币",rentEarnings];
    NSMutableAttributedString *day1 = [[NSMutableAttributedString alloc]initWithString:string1];
    NSRange range1 = [string rangeOfString:rentEarnings];
    [day1 yy_setColor:HexColorInt32_t(FA5048) range:range1];
    self.rentEarningsLabel.attributedText = day;
    

} 

@end
