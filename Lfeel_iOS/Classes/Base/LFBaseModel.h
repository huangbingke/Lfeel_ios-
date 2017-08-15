//
//  LFBaseModel.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/3.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>






@interface LFBaseModel : NSObject
///  首页数据模型
@property (nonatomic, assign) NSArray * imgList;

@end
@interface LFHomeModel : JSONModel
///  type
@property (nonatomic,   copy) NSString * type;
///  imgUrl
@property (nonatomic,   copy) NSString * imgUrl;
///  id
@property (nonatomic,   copy) NSString * ID;
///  minorTitleName
@property (nonatomic,   copy) NSString * minorTitleName;
///  mainTitleName
@property (nonatomic,   copy) NSString * mainTitleName;
@end


@class LFHothirevModel;
@interface LFHotBaseModel : JSONModel

///  startPage
@property (nonatomic,   copy) NSString * startPage;
///  totalPage
@property (nonatomic,   copy) NSString * totalPage  ;

///  goodsList
@property (nonatomic, assign) NSArray <LFHothirevModel*>* goodsList;
@end


@interface LFHothirevModel : JSONModel
///  goodsId
@property (nonatomic,   copy) NSString * goodsId;
///  goodsName
@property (nonatomic,   copy) NSString * goodsName;

///  goodsUrl
@property (nonatomic,   copy) NSString * goodsUrl;

@end



@interface LFGoodsDetailGoodsParameList : JSONModel
///  id
@property (nonatomic,   copy) NSString * ID;
///  imgUrl
@property (nonatomic,   copy) NSString * imgUrl;
@property (nonatomic,   copy) NSString * height;
@property (nonatomic,   copy) NSString *  width;
 


@end
@protocol LFGoodsDetailGoodsParameList
@end

@interface LFGoodsDetailColourList : JSONModel
///  id
@property (nonatomic,   copy) NSString * ID;
///  imgUrl
@property (nonatomic,   copy) NSString * name;
@end

@protocol LFGoodsDetailColourList
@end

@interface LFGoodsDetailGoodsUrlList : JSONModel
///  id
@property (nonatomic,   copy) NSString * ID;
///  imgUrl
@property (nonatomic,   copy) NSString * imgUrl;
@end

@protocol LFGoodsDetailGoodsUrlList

@end

@interface LFGoodsDetailModel :JSONModel
///  msg
@property (nonatomic,   copy) NSString * msg;
///  result
@property (nonatomic,   copy) NSString * result;
///  collectionStatus  收藏状态
@property (nonatomic, assign) BOOL collectionStatus;
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
///

@property (nonatomic,   copy) NSString * store_price;


@property (nonatomic,   assign) CGFloat imageSize;
///  colourList
@property (nonatomic, strong) NSArray <LFGoodsDetailColourList>*  colourList;
///  goodsParameList 参数图片集
@property (nonatomic, strong) NSArray  <LFGoodsDetailGoodsParameList>* goodsParameList;
///  goodsUrlList
@property (nonatomic,   strong) NSArray <LFGoodsDetailGoodsUrlList>* goodsUrlList;
///  goodsUrlList
@property (nonatomic,   strong) NSArray <LFGoodsDetailColourList>* sizList;
@end



@interface LfGoodsDetailEvlutionMode : NSObject<YYModel>
///commentsList
@property (strong, nonatomic)  NSArray *commentsList;
///result
@property (copy, nonatomic)  NSString   * result;
///endPage
@property (copy, nonatomic)  NSString   * endPage;

///msg
@property (copy, nonatomic)  NSString   * msg;
///startPage
@property (copy, nonatomic)  NSString   * startPage;

@end

@interface LfGoodsDetailEvlutionCommentsListModel : NSObject
///commentsName
@property (copy, nonatomic)  NSString   * commentsName;
///content
@property (copy, nonatomic)  NSString   * content;
///commentsImg
@property (strong, nonatomic)  NSArray * commentsImg;
@property (nonatomic,   copy) NSString * commentIoc;
@end

@interface LfGoodsDetailEvlutionCommentsImgModel : NSObject

///id
@property (copy, nonatomic)  NSString   * ID;
///no
@property (copy, nonatomic)  NSString   * no;
///imgUrl
@property (copy, nonatomic)  NSString   * imgUrl;
@end



/// 地址
@interface LFAddressModel : NSObject
@property (nonatomic,   copy) NSString * contact;
@property (nonatomic,   copy) NSString * addressId;
@property (nonatomic,   copy) NSString * cityId;
@property (nonatomic,   copy) NSString * contactName;
@property (nonatomic, assign) BOOL defaultStatus;
@property (nonatomic,   copy) NSString * address;
@end


@interface LFIntegralModel : NSObject
@property (nonatomic,   copy) NSString * integral;
@property (nonatomic,   copy) NSString * integralAmount;
@property (nonatomic,   assign) NSTimeInterval  operDate;
@property (nonatomic,   copy) NSString * typeName;
@property (nonatomic,   copy) NSString * type;


@end

@interface LFRetailViewModel : NSObject

@property (copy, nonatomic)  NSString   * invitationPerson;
@property (copy, nonatomic)  NSString   * lehuiCurrency;
@end


@interface LFCollectioListModel : NSObject
///  favoriteId
@property (nonatomic,   copy) NSString * favoriteId;
@property (nonatomic,   copy) NSString * goodsId;
@property (nonatomic,   copy) NSString * goodsName;
@property (nonatomic,   copy) NSString * goodsUrl;
///  分期价格
@property (nonatomic,   copy) NSString * paymentPrice;
///  卖价
@property (nonatomic,   copy) NSString * sellingPrice;
@end


@interface LFRecordListModel : NSObject
///goodsUrl
@property (copy, nonatomic)  NSString   * goodsUrl;
@property (nonatomic,   copy) NSString * goodsId;
@property (nonatomic,   copy) NSString * goodsName;
@property (nonatomic,   copy) NSString * rentNum;
@property (nonatomic,   copy) NSString * rentEarnings;
@property (nonatomic,   strong)NSArray  * rentEarningsRecordList;


@end


@interface LFRentEarningsRecordListModel : NSObject
@property (nonatomic,   copy) NSString * accountName;
@property (nonatomic,   copy) NSString * earnings;
@property (nonatomic,   copy) NSString * endDate;
@property (nonatomic,   copy) NSString * leaseDay;
@property (nonatomic,   copy) NSString * startDate;
@end

@interface LFidleRentListModel : NSObject

@property (copy, nonatomic)  NSString   * goodsId;
@property (copy, nonatomic)  NSString   * goodsMainUrl;
@property (copy, nonatomic)  NSString   * goodsName;
@property (copy, nonatomic)  NSString   * goodsRentStatus;
@property (copy, nonatomic)  NSString   * rentEarnings;
@property (copy, nonatomic)  NSString   * rentNum;


@end

@interface LFBanklistModel : NSObject
//@property (copy, nonatomic)  NSString   * bank_no;
@property (copy, nonatomic)  NSString   * bankName;
@property (copy, nonatomic)  NSString   * bankId;

@end

@interface LFapplyFaceliftListModel : NSObject
///  goodsName
@property (nonatomic,   copy) NSString * goodsName;
@property (nonatomic,   copy) NSString * attribute;
@property (nonatomic,   copy) NSString * goodsUrl;
@property (nonatomic,   copy) NSString * goodsId;
@property (nonatomic,  assign) BOOL select;
@end


@interface LFchangeColoseModel : NSObject
@property (nonatomic,   copy) NSString * goodsUrl;
@property (nonatomic,   copy) NSString * attribute;
@property (nonatomic,   copy) NSString * goodsId;
@property (nonatomic,   copy) NSString * goodsName;

@end


@interface LFVIpModel : NSObject

@property (copy, nonatomic)  NSString   * monthPrice;
@property (copy, nonatomic)  NSString   * goodsId;
@property (copy, nonatomic)  NSString   * membershipName;
@property (copy, nonatomic)  NSString   * totalPrice;

@end



@interface LFerenceViewModel : NSObject
@property (nonatomic,   copy) NSString * height;
@property (nonatomic,   copy) NSString * goodsUrl;
@property (nonatomic,   copy) NSString * goodsName;
@property (nonatomic,   copy) NSString * goodsId;
@property (nonatomic,   copy) NSString * favoriteId;
@property (nonatomic,   copy) NSString * sellingPrice;
@property (nonatomic,   copy) NSString * stagesPrice;
@property (nonatomic,   copy) NSString * width;

@end





