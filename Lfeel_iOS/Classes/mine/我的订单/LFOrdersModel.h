//
//  LFOrdersModel.h
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/26.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LFGoods;
@interface LFOrder : NSObject <YYModel>
@property (nonatomic,   copy) NSString * orderCode;
@property (nonatomic, strong) NSArray<LFGoods *> * orderDetailedList;
@property (nonatomic,   copy) NSString * orderId;
@property (nonatomic,   copy) NSString * cashPledge;
@property (nonatomic,   copy) NSString * totalPrice;
@property (nonatomic, assign) NSInteger orderStatus;
@property (nonatomic,   copy) NSString * statusString;
@property (nonatomic, assign) NSInteger invoiceStatus;
@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic,   copy) NSString * orderTime;
@end


@interface LFOrderDetail : NSObject
@property (nonatomic,   copy) NSString * addressInfo;
@property (nonatomic,   copy) NSString * orderDatetime;
@property (nonatomic,   copy) NSString * orderCode;
@property (nonatomic,   copy) NSString * payType;
@property (nonatomic,   copy) NSString * transportCompany;
@property (nonatomic,   copy) NSString * orderId;
@property (nonatomic,   copy) NSString * orderStatus;
@property (nonatomic,   copy) NSString * transportCode;
@property (nonatomic,   copy) NSString * result;
@property (nonatomic,   copy) NSString * transportMode;
@property (nonatomic,   copy) NSString * msg;
@property (nonatomic,   copy) NSString * userInfo;

@end
