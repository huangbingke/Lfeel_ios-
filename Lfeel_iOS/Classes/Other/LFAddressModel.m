//
//  LFAddressModel.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/12.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFAddressModel.h"

@implementation LFProvince
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"cityList" : [LFCity class]};
}
@end


@implementation LFCity

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"regionList" : [LFRegion class]};
}

@end

@implementation LFRegion

@end

NSArray<LFProvince *> * getAddressList() {
    
    static NSArray<LFProvince *> * result;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray * arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"address.plist" ofType:nil]];
        result = [NSArray yy_modelArrayWithClass:[LFProvince class] json:arr];
    });
    return result;
}
