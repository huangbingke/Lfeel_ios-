//
//  LFCheapCardModel.m
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/7/24.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFCheapCardModel.h"

@implementation LFCheapCardModel



- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.id_ = value;
    }
}







@end
