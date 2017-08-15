//
//  LFGoodsDetaiModel.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/7.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LFGoodsDetaiModel1 : NSObject
///  msg
@property (nonatomic,   copy) NSString * msg;
///  result
@property (nonatomic,   copy) NSString * result;
///  collectionStatus  收藏状态
@property (nonatomic,   copy) NSString * collectionStatus;
///  goodsAbridgeImgUrl 缩写图
@property (nonatomic,   copy) NSString * goodsAbridgeImgUrl;
///  goodsId
@property (nonatomic,   copy) NSString * goodsId;
///  goodsName
@property (nonatomic,   copy) NSString * goodsName;
///评价列表
@property (copy, nonatomic)  NSString   * commentTotal;

///  goodsStatus
@property (nonatomic,   copy) NSString * goodsStatus;
///  goodsType
@property (nonatomic,   copy) NSString * goodsType;
///  inventory
@property (nonatomic,   copy) NSString * inventory;
///  postage
@property (nonatomic,   copy) NSString * postage;
///  paymentPrice
@property (nonatomic,   copy) NSString * paymentPrice;
///  sellingPrice
@property (nonatomic,   copy) NSString * sellingPrice;

@property (nonatomic,   copy) NSString * store_price;

///  colourList
@property (nonatomic, strong) NSArray *  colourList;
///  goodsParameList 参数图片集
@property (nonatomic, strong) NSArray * goodsParameList;
///  goodsUrlList
@property (nonatomic,   strong) NSArray * goodsUrlList;
///  goodsUrlList
@property (nonatomic,   strong) NSArray * sizList;

@end


@interface LFGoodsDetailGoodsParameList1 :NSObject///  id
@property (nonatomic,   copy) NSString * ID;
///  imgUrl
@property (nonatomic,   copy) NSString * imgUrl;
@property (nonatomic,   copy) NSString * height;
@property (nonatomic,   copy) NSString *  width;



@end


@interface LFGoodsDetailColourList1 : NSObject
///  id
@property (nonatomic,   copy) NSString * ID;
///  imgUrl
@property (nonatomic,   copy) NSString * name;
@end



@interface LFGoodsDetailGoodsUrlList1 : NSObject
///  id
@property (nonatomic,   copy) NSString * ID;
///  imgUrl
@property (nonatomic,   copy) NSString * imgUrl;
@end






