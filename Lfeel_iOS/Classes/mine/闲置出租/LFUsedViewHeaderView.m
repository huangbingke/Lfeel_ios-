//
//  LFUsedViewHeaderView.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFUsedViewHeaderView.h"
#import "NSAttributedString+YYText.h"

@interface LFUsedViewHeaderView  ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation LFUsedViewHeaderView


-(void)awakeFromNib{
    [super awakeFromNib];
    [self rm_fitAllConstraint ];
}

-(void)setDict:(NSDictionary *)dict{

    
    NSString *  integralTotal  =  [NSString stringWithFormat:@"%@", dict[@"integralTotal"]];
    NSString * goodnumber = [NSString stringWithFormat:@"%@",dict[@"goodsNum"]];
    
    NSString * string = [NSString stringWithFormat:@"共%@件商品,累计收益%@乐荟币",goodnumber,integralTotal.formatNumber];
    
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = [string rangeOfString:goodnumber];
    NSRange range1 = [string rangeOfString:integralTotal.formatNumber options:NSBackwardsSearch];
    [attr yy_setColor:HexColorInt32_t(FA5048) range:range];
    [attr yy_setColor:HexColorInt32_t(FA5048) range:range1];
    self.titleLabel.attributedText = attr;
    
    SLLog(dict);
}

@end
