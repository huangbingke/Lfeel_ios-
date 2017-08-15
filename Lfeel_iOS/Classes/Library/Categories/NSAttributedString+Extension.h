//
//  NSAttributedString+Extension.h
//  
//
//  Created by Seven Lv on 15/11/6.
//  Copyright (c) 2015年 Seven Lv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Extension)

+ (NSMutableAttributedString *)attributedstringWithText:(NSString *)text
                                          range1:(NSRange)range1
                                           font1:(CGFloat)font1
                                          color1:(UIColor *)color1
                                          range2:(NSRange)range2
                                           font2:(CGFloat)font2
                                          color2:(UIColor *)color2

;

@end
