//
//  LHPackingBoxView.h
//  LFeelAPP
//
//  Created by 黄冰珂 on 2017/6/14.
//  Copyright © 2017年 黄冰珂. All rights reserved.



//自定义 打包盒子 和 结算条


#import <UIKit/UIKit.h>

/*打包盒子*/
typedef void(^ClickPackingButtonBlock)(NSString *packBtnTitle);

//全选
typedef void(^AllClickGoodsBlock)();

//去结算
typedef void(^GoAccrountBlock)();


@interface LHPackingBoxView : UIView



@property (nonatomic, copy) ClickPackingButtonBlock clickPackingBtnBlock;



/*打包盒子*/
- (instancetype)initWithFrame:(CGRect)frame packingStatusString:(NSString *)packingLabelStr packingButtonTitle:(NSString *)packingButtonTitle;


/*点击打包盒子的回调*/
- (void)clickPackingButtonBlock:(ClickPackingButtonBlock)block;


///*结算按钮*/
//- (instancetype)initWithFrame:(CGRect)frame;
//
///*显示总价格*/
//@property (nonatomic, strong) UILabel *priceLabel;
//
///*全选*/
//@property (nonatomic, copy) AllClickGoodsBlock allClickGoodsBlock;
//
///*点击全部的回调*/
//- (void)allClickGoodsBlock:(AllClickGoodsBlock)block;
//
//
////去结算
//@property (nonatomic, copy) GoAccrountBlock goAccrountBlock;
//
///*去结算回调*/
//- (void)goAccrountGoodsBlock:(GoAccrountBlock)block;








@end
