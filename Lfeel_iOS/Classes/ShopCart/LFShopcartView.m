//
//  LFShopcartView.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/1.
//  Copyright © 2017年 Seven. All rights reserved.
//
#import "SLDevider.h"
#import "LFShopcartView.h"

@implementation LFShopcartHeaderView {
    
    __weak IBOutlet UILabel *_shopName;
    __weak IBOutlet UIImageView *_statusImageView;
}


+ (instancetype)creatView {
    return [self creatViewFromNibName:@"LFShopcartView" atIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self rm_fitAllConstraint];
}

- (void)setCart:(LFShopCart *)cart {
    _cart = cart;
    _shopName.text = cart.goodsPlatform;
    _statusImageView.highlighted = cart.isSelected;
}
@end


@implementation LFShopcartCell {
    
    __weak IBOutlet NSLayoutConstraint *_statueBtnWidthCons;
    __weak IBOutlet UILabel *_goodsName;
    __weak IBOutlet UIButton *_statusBtn;
    __weak IBOutlet UIImageView *_picture;
    __weak IBOutlet UILabel *_price;
    /// 分期
    __weak IBOutlet UILabel *_installment;
    __weak IBOutlet SLDevider *_devider;
    __weak IBOutlet UILabel *_count;
    __weak IBOutlet UIButton *_commentBtn;
    
}
- (IBAction)_didSelectedStatus:(UIButton *)sender {
    _statusBtn.selected = !_statusBtn.isSelected;
    self.goods.selected = _statusBtn.isSelected;
    BLOCK_SAFE_RUN(self.didClickStautsBtnBlock, self);
}

- (void)setOrderModel {
    _statueBtnWidthCons.constant = Fit(15);
    _statusBtn.hidden = YES;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString * ID = @"LFShopcartCell";
    LFShopcartCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LFShopcartView" owner:nil options:nil] objectAtIndex:1];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView rm_fitAllConstraint];
    
    MGSwipeButton * btn = [MGSwipeButton buttonWithTitle:nil icon:[UIImage imageNamed:@"垃圾桶-删除"] backgroundColor:[UIColor clearColor]];
    btn.size = Size(Fit(52), Fit(114));
    UIView * view = [UIView viewWithBgColor:HexColorInt32_t(dddddd) frame:Rect(0, 0, 0.7, Fit(65))];
    view.centerY = btn.halfHeight;
    [btn addSubview:view];
    self.rightButtons = @[btn];
    
    _commentBtn.hidden = YES;
    
    @weakify(self);
    [_commentBtn.rac_touchupInsideSignal subscribeNext:^(id x) {
        @strongify(self);
        BLOCK_SAFE_RUN(self.didClickCommentBtnBlock, self);
    }];
}
- (void)setGoods:(LFGoods *)goods {
    _goods = goods;
    
    _goodsName.text = goods.goodsName;
    [_picture sd_setImageWithURL:[NSURL URLWithString:goods.goodsImgUrl] placeholderImage:SLPlaceHolder];
    _price.text = [NSString stringWithFormat:@"售价：￥%@", goods.sellingPrice.formatNumber];
    _installment.text = [NSString stringWithFormat:@"分期：￥%@", goods.sl_fenqing.formatNumber];
    _statusBtn.selected = goods.isSelected;
    _count.text = [NSString stringWithFormat:@"x%@", goods.goodsNum];
    
    if (!goods.evaluate && self.orderStatus == 7) {
        _commentBtn.hidden = NO;
        _count.hidden = YES;
    } else {
        _commentBtn.hidden = YES;
        _count.hidden = NO;
    }
}
@end

@implementation LFShopcartBottomView 
- (IBAction)_didClickSettleBtn:(id)sender {
    BLOCK_SAFE_RUN(self.didClickSettleBtnBlock);
}

- (IBAction)_didClickSelectAllBtn:(UIButton *)sender {
    _statusImageView.highlighted = !_statusImageView.isHighlighted;
    BLOCK_SAFE_RUN(self.didSelectedAllBtnBlock);
}
+ (instancetype)creatView {
    return [self creatViewFromNibName:@"LFShopcartView" atIndex:2];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self rm_fitAllConstraint];
}

@end

@implementation LFShopcartAlertView {
    
    __weak IBOutlet UILabel *_title;
    VoidBlcok _action;
}

- (IBAction)_didClickSure:(id)sender {
    BLOCK_SAFE_RUN(_action);
    [self.superview removeFromSuperview];
}

- (IBAction)_didClickClose:(id)sender {
    [self.superview removeFromSuperview];
}

+ (instancetype)creatView {
    return [self creatViewFromNibName:@"LFShopcartView" atIndex:3];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self rm_fitAllConstraint];
}


+ (void)alertWithTitle:(NSString *)title clickSureAction:(VoidBlcok)action {
    LFShopcartAlertView * alert = [LFShopcartAlertView creatView];
    alert.size = Size(Fit(alert.width), Fit(alert.height));
    alert.center = Point(kHalfScreenWidth, kScreenHeight * 0.43);
    alert->_title.text = title;
    alert->_action = action;
    
    UIView * bg = [UIView viewWithBgColor:[HexColorInt32_t(000000) colorWithAlphaComponent:0.5] frame:[UIScreen mainScreen].bounds];
    [bg addSubview:alert];
    
    [[UIApplication sharedApplication].keyWindow addSubview:bg];
}

@end
