//
//  LFAddressModel.h
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/12.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LFCity, LFRegion;
@interface LFProvince : NSObject <YYModel>
@property (nonatomic,   copy) NSString * provinceId;
@property (nonatomic,   copy) NSString * provinceName;
@property (nonatomic,   copy) NSArray<LFCity *> * cityList;
@end

@interface LFCity : NSObject
@property (nonatomic,   copy) NSString * cityId;
@property (nonatomic,   copy) NSString * cityName;
@property (nonatomic,   copy) NSArray<LFRegion *> * regionList;
@end

@interface LFRegion : NSObject
@property (nonatomic,   copy) NSString * regionId;
@property (nonatomic,   copy) NSString * regionName;
@end

extern NSArray<LFProvince *> * getAddressList();

