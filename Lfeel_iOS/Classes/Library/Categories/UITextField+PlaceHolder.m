//
//  UITextField+PlaceHolder.m
//  PocketJC
//
//  Created by Seven Lv on 16/10/1.
//  Copyright © 2016年 CHY. All rights reserved.
//

#import "UITextField+PlaceHolder.h"

@implementation UITextField (PlaceHolder)

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (UIColor *)placeholderColor {
    return nil;
}
@end
