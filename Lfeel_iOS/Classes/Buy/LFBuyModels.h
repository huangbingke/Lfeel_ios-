//
//  LFBuyModels.h
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/5.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFBuyCategory : NSObject
@property (nonatomic,   copy) NSString * id;
@property (nonatomic,   copy) NSString * categoryImgUrl;
@property (nonatomic,   copy) NSString * categoryName;
@end

@interface LFBuyBrand : NSObject
@property (nonatomic,   copy) NSString * brandId;
@property (nonatomic,   copy) NSString * brandUrl;
@property (nonatomic,   copy) NSString * brandName;
@end

@interface LFGoods : NSObject
@property (nonatomic,   copy) NSString * goodsUrl;
@property (nonatomic,   copy) NSString * goodsId;
@property (nonatomic,   copy) NSString * sellingPrice;
@property (nonatomic,   copy) NSString * attribute;

@property (nonatomic,   copy) NSString * goodsName;
@property (nonatomic,   copy) NSString * goodsCartId;
@property (nonatomic,   copy) NSString * goodsCarId;
@property (nonatomic,   copy) NSString * goodsNum;
@property (nonatomic,   copy) NSString * stagesPrice;
@property (nonatomic,   copy) NSString * storeId;
@property (nonatomic,   copy) NSString * goodsType;
@property (nonatomic,   copy) NSString * goodsStats;
@property (nonatomic,   copy) NSString * goodsImgUrl;
@property (nonatomic,   copy) NSString * cashPledge;
@property (nonatomic,   copy) NSString * rentalPrice;
@property (nonatomic,   copy) NSString * store_price;

@property (nonatomic, assign) BOOL evaluate;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic,   copy) NSString * sl_fenqing;

@end



@interface LFCardInfo : NSObject
@property (nonatomic,   copy) NSString * accNo;
@property (nonatomic,   copy) NSString * idCard;
@property (nonatomic,   copy) NSString * name;
@property (nonatomic,   copy) NSString * bankName;
@end


@interface LFPayModel : NSObject
@property (nonatomic,   copy) NSString * order_id;
@property (nonatomic,   copy) NSString * order_sn;
@property (nonatomic, assign) NSInteger stageCount;
///  单位分
@property (nonatomic,   copy) NSString * price;
///  银行卡列表
@property (nonatomic,   copy) NSArray<LFCardInfo *> * bankCardList;
@end
