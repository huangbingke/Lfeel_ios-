//
//  LFSettleCenterView.h
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/4.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLBaseTableViewCell.h"
#import "LFPayHelper.h"

@interface LFSettleCenterHeaderView : UIView
///  选择地址
@property (nonatomic,   copy) void (^didClickSelectedAddressBlock)();
@property (nonatomic, strong) LFAddressModel * addressModel;

/**
 完成选择地址

 @return 自身的高度
 */
- (CGFloat)completeSelected;

@end

@class LFGoods;
@interface LFSettleCenterGoodsCell : SLBaseTableViewCell
@property (nonatomic, strong) LFGoods * goods;
@end


/// 结算中心footer
@interface LFSettleCenterFooterView : UIView
///  总价
@property (nonatomic,   copy) NSString * totalPriceString;
///  支付方式
@property (nonatomic,   copy) NSString * payTypeString;

//优惠金额
@property (nonatomic,   copy) NSString * cheapPriceString;


///  是否同意协议
@property (nonatomic, assign, getter=isSelected, readonly) BOOL selected;

- (void)setSelecePayTypeBlock:(VoidBlcok)payType
                  submitBlock:(VoidBlcok)submit
                protocolBlock:(VoidBlcok)pro
                 cheaperBlock:(VoidBlcok)cheap;
@end

/// 选择支付方式
@interface LFSettleCenterSelectPayTypeView : UIView

+ (void)showWithCompleteHandle:(void(^)(PayType payType))block selectedType:(PayType)type;
+ (void)showWithCompleteHandle:(void(^)(PayType payType))block selectedType:(PayType)type needFenQing:(BOOL)isNeed;

@end


/// 选择发票类型
@interface LFSelectedInvoiceTypeView : UIView
+ (void)showWithCompleteHandle:(void(^)(NSInteger payType))block selectedType:(NSInteger)type;
@end
