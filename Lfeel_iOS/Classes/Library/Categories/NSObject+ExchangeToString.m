//
//  NSObject+ExchangeToString.m
//  ForFans
//
//  Created by Seven Lv on 15/10/17.
//  Copyright (c) 2015年 Seven Lv. All rights reserved.
//

#import "NSObject+ExchangeToString.h"

@implementation NSObject (ExchangeToString)
- (NSString *)toString
{
    return [NSString stringWithFormat:@"%@", self];
}
@end

/*
 NSData * data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
 params.goods_json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];*/

@implementation NSArray (JSON)

- (NSString *)JSONString {
    NSData * data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    return  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end

@implementation NSDictionary (JSON)

- (NSString *)JSONString {
    NSData * data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    return  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end