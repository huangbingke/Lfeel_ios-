//
//  LFShopcartView.h
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/1.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import "LFShopCartModels.h"

@interface LFShopcartHeaderView : UIView
@property (nonatomic, strong) LFShopCart * cart;
@end


@interface LFShopcartCell : MGSwipeTableCell

@property (nonatomic, strong) LFGoods * goods;
@property (nonatomic, assign) NSInteger orderStatus;
@property (nonatomic,   copy) NSString * order_id;

///  点击状态按钮
@property (nonatomic,   copy) void (^didClickStautsBtnBlock)(LFShopcartCell *cell);
///  点击评价
@property (nonatomic,   copy) void (^didClickCommentBtnBlock)(LFShopcartCell *cell);

///  订单模式下使用
- (void)setOrderModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;



@end

@interface LFShopcartBottomView : UIView {
 @public
__weak IBOutlet UIImageView *_statusImageView;
__weak IBOutlet UILabel *_totalPrice;
__weak IBOutlet UIButton *_settleBtn;
    
}

///  点击结算
@property (nonatomic,   copy) VoidBlcok didClickSettleBtnBlock;
/// 全选
@property (nonatomic,   copy) VoidBlcok didSelectedAllBtnBlock;

@end


@interface LFShopcartAlertView : UIView

+ (void)alertWithTitle:(NSString *)title clickSureAction:(VoidBlcok)action;

@end
