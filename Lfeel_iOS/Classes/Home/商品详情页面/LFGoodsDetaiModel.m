//
//  LFGoodsDetaiModel.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/7.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFGoodsDetaiModel.h"

@implementation LFGoodsDetaiModel1
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    NSMutableDictionary * dict = @{}.mutableCopy;
    dict[@"goodsParameList"] = [LFGoodsDetailGoodsParameList1 class];
    dict[@"sizList"] = [LFGoodsDetailGoodsParameList1 class];
    dict[@"goodsUrlList"]= [LFGoodsDetailGoodsUrlList1 class];
    dict[@"colourList"] = [LFGoodsDetailColourList1 class];
    return dict;
}

@end

@implementation LFGoodsDetailColourList1

@end
@implementation LFGoodsDetailGoodsUrlList1
@end
@implementation LFGoodsDetailGoodsParameList1

@end
