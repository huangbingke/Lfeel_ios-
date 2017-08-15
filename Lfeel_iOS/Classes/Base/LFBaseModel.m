//
//  LFBaseModel.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/3.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFBaseModel.h"

@implementation LFBaseModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    NSMutableDictionary * dict = @{}.mutableCopy;
    dict[@"imgList"] = [LFHomeModel class];
 
    return dict;
}
@end
@implementation LFHomeModel
//+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
//    return @{@"ID" : @"id"};
//}

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"ID"}];
}
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end

@implementation LFHotBaseModel


+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end
@implementation LFHothirevModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end

@implementation LFGoodsDetailModel

 

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end

@implementation LFGoodsDetailGoodsParameList
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"ID"}];
}
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end

@implementation LFGoodsDetailColourList

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"ID"}];
}
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end

@implementation LFGoodsDetailGoodsUrlList

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"ID"}];
}
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end

@implementation LfGoodsDetailEvlutionMode

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    NSMutableDictionary * dict = @{}.mutableCopy;
    dict[@"commentsList"] = [LfGoodsDetailEvlutionCommentsListModel class];
    return dict;
}


@end

@implementation LfGoodsDetailEvlutionCommentsListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    NSMutableDictionary * dict = @{}.mutableCopy;
    dict[@"commentsImg"] = [LfGoodsDetailEvlutionCommentsImgModel class];
    return dict;
}

@end


@implementation LfGoodsDetailEvlutionCommentsImgModel


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}
@end

@implementation LFAddressModel

@end

@implementation LFIntegralModel

@end
@implementation LFRetailViewModel

@end
@implementation LFCollectioListModel
@end

@implementation LFRecordListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    NSMutableDictionary * dict = @{}.mutableCopy;
    dict[@"rentEarningsRecordList"] = [LFRentEarningsRecordListModel class];
    return dict;
}


@end
@implementation LFRentEarningsRecordListModel
@end

@implementation LFidleRentListModel

@end

@implementation LFBanklistModel

@end

@implementation LFapplyFaceliftListModel

@end
@implementation LFchangeColoseModel
@end
@implementation LFVIpModel
@end
@implementation LFerenceViewModel
@end

