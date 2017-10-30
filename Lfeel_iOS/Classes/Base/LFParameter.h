//
//  LFParameter.h
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/2/26.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFParameter : NSObject

@property (nonatomic,   copy) NSString * photo_url;
@property (nonatomic,   copy) NSString * user_account;
@property (nonatomic,   copy) NSString * third_id;
@property (nonatomic,   copy) NSString * cvn;
@property (nonatomic,   copy) NSString * idCard;
@property (nonatomic,   copy) NSString * txnAmt;
@property (nonatomic,   copy) NSString * name;
@property (nonatomic,   copy) NSString * validDate;
@property (nonatomic,   copy) NSString * txnTerms;
@property (nonatomic,   copy) NSString * accNo;
@property (nonatomic,   copy) NSString * phone;
@property (nonatomic,   copy) NSString * invoiceStatus;
@property (nonatomic,   copy) NSString * orderIds;
@property (nonatomic,   copy) NSString * totalPrice;
@property (nonatomic,   copy) NSString * telName;
@property (nonatomic,   copy) NSString * prom;
@property (nonatomic,   copy) NSString * invoiceType;
@property (nonatomic,   copy) NSString * invoiceName;
@property (nonatomic,   copy) NSString * areaId;
@property (nonatomic,   copy) NSString * passWord;
@property (nonatomic,   copy) NSString * password;

@property (nonatomic,   copy) NSString * id_url;
@property (nonatomic,   copy) NSString * trueName;
@property (nonatomic,   copy) NSString * id_No;



@property (nonatomic,   copy) NSString * type;
@property (nonatomic,   copy) NSString * mobilePhone;
@property (nonatomic,   copy) NSString * smsCode;
@property (nonatomic,   copy) NSString * oldPassWord;
@property (nonatomic,   copy) NSString * waist;
@property (nonatomic,   copy) NSString * weight;
@property (nonatomic,   copy) NSString * size;
@property (nonatomic,   copy) NSString * inviteCode;
@property (nonatomic,   copy) NSString * height;
@property (nonatomic,   copy) NSString * hipline;
@property (nonatomic,   copy) NSString * bust;
@property (nonatomic,   copy) NSString * commentImgUrls;
@property (nonatomic,   copy) NSString * goodsId;
@property (nonatomic,   copy) NSString * loginKey;
@property (nonatomic,   copy) NSString * content;
@property (nonatomic,   copy) NSString * sortType;
@property (nonatomic,   copy) NSString * searchType;
@property (nonatomic,   copy) NSString * searchParam;
@property (nonatomic,   copy) NSString * startPage;
@property (nonatomic,   copy) NSString * goodsType;
@property (nonatomic,   copy) NSString * id;
@property (nonatomic,   copy) NSString * phoneMark;
@property (nonatomic,   copy) NSString * goodsCartIds;
@property (nonatomic,   copy) NSString * gsp;
@property (nonatomic,   copy) NSString * leaseStartDate;
@property (nonatomic,   copy) NSString * price;
@property (nonatomic,   copy) NSString * orderform_id;

@property (nonatomic,   copy) NSString * count;
@property (nonatomic,   copy) NSString * storeId;
@property (nonatomic,   copy) NSString * goodsCartId;
@property (nonatomic,   copy) NSString * goodsParm;
@property (nonatomic,   copy) NSString * phoneMoble;
@property (nonatomic,   copy) NSString * telephone;
@property (nonatomic,   copy) NSString * cityId;
@property (nonatomic,   copy) NSString * areaInfo;
@property (nonatomic,   copy) NSString * addressId;
//@property (nonatomic,   copy) NSString * trueName;
@property (nonatomic,   copy) NSString * identification;
@property (nonatomic,   copy) NSString * sex;
@property (nonatomic,   copy) NSString * birthday;
@property (nonatomic,   copy) NSString * userName;
@property (nonatomic,   copy) NSString * userIocUrl;
@property (nonatomic,   copy) NSString * favoriteId;
@property (nonatomic,   copy) NSString * addressStatus;
@property (nonatomic,   copy) NSString * payType;
@property (nonatomic,   copy) NSString * amount;
@property (nonatomic,   copy) NSString * endDate;
@property (nonatomic,   copy) NSString * startDate;
@property (nonatomic,   copy) NSString * integralType;
@property (nonatomic,   copy) NSString * goodsDescribe;
@property (nonatomic,   copy) NSString * rentPrice;
@property (nonatomic,   copy) NSString * contactTel;
@property (nonatomic,   copy) NSString * goodsImg;
@property (nonatomic,   copy) NSString * orderId;
@property (nonatomic,   copy) NSString * gold;
@property (nonatomic,   copy) NSString * refund;
@property (nonatomic,   copy) NSString * refund_log;
@property (nonatomic,   copy) NSString * refund_img_urls;
@property (nonatomic,   copy) NSString * refund_status;
@property (nonatomic,   copy) NSString * refund_remark;
@property (nonatomic,   copy) NSString * orderStatus;
@property (copy, nonatomic)  NSString   * goodsIds;
@property (nonatomic,   copy) NSString * accountName;
@property (nonatomic,   copy) NSString * accountNo;
@property (nonatomic,   copy) NSString * bankFullName;
@property (nonatomic,   copy) NSString * bankId;
@property (nonatomic,   copy) NSString * integral;
@property (nonatomic,   copy) NSString * nPassWord;
@property (nonatomic,   copy) NSString * attribute;
@property (nonatomic,   copy) NSString * imgsVoucher;

@property (nonatomic,   copy) NSString * privilege_id;
@property (nonatomic,   copy) NSString * province;
@property (nonatomic,   copy) NSString * city;
@property (nonatomic,   copy) NSString * state;

//登录请求的参数
@property (nonatomic,   copy) NSString * user_id;
@property (nonatomic,   copy) NSString * isAgent;
@property (nonatomic,   copy) NSString * agent_level;


@property (nonatomic,   assign) NSInteger  start;
@property (nonatomic,   assign) NSInteger  end;

//@property (nonatomic,   copy) NSString  *start;
//@property (nonatomic,   copy) NSString  *end;


@property (nonatomic,   copy) NSString * keyword;
@property (nonatomic,   copy) NSString * remark;

@property (nonatomic,   copy) NSString * express_no;
@property (nonatomic,   copy) NSString * goods_Num;

@property (nonatomic,   copy) NSString * goodsparams;


@property (nonatomic,   copy) NSString * application_id;

@property (nonatomic,   copy) NSString * defaultStatus;



/// 拼接基础参数
- (void)appendBaseParam;

@end
