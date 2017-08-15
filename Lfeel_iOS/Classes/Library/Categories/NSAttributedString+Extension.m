//
//  NSAttributedString+Extension.m
//  
//
//  Created by Seven Lv on 15/11/6.
//  Copyright (c) 2015年 Seven Lv. All rights reserved.
//

#import "NSAttributedString+Extension.h"

@implementation NSAttributedString (Extension)
+ (NSMutableAttributedString *)attributedstringWithText:(NSString *)text
                                          range1:(NSRange)range1
                                           font1:(CGFloat)font1
                                          color1:(UIColor *)color1
                                          range2:(NSRange)range2
                                           font2:(CGFloat)font2
                                          color2:(UIColor *)color2
{
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:text];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font1] range:range1];
    [attr addAttribute:NSForegroundColorAttributeName value:color1 range:range1];
    
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font2] range:range2];
    [attr addAttribute:NSForegroundColorAttributeName value:color2 range:range2];
    return attr;
}
@end
