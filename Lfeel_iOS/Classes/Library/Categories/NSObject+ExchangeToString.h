//
//  NSObject+ExchangeToString.h
//  ForFans
//
//  Created by Seven Lv on 15/10/17.
//  Copyright (c) 2015年 Seven Lv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ExchangeToString)

- (NSString *)toString;

@end

@interface NSArray (JSON)
- (NSString *)JSONString;
@end

@interface NSDictionary (JSON)
- (NSString *)JSONString;
@end