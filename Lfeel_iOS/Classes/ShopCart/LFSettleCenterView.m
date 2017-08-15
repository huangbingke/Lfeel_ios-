//
//  LFSettleCenterView.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/4.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFSettleCenterView.h"
#import "LFShopCartModels.h"
#import "TSAddressPickerView.h"

@implementation LFSettleCenterHeaderView {
    
    __weak IBOutlet UIView *_addressView;
    __weak IBOutlet UILabel *_name;
    __weak IBOutlet UILabel *_phone;
    __weak IBOutlet UILabel *_address;
    __weak IBOutlet UILabel *_subAddress;
    __weak IBOutlet NSLayoutConstraint *_addressViewHeightCons;
    
    __weak IBOutlet UIView *_bottomView;
    __weak IBOutlet UIView *_emptyView;
    
}
//[TSAddressPickerView addressForCityId:address.cityId]
- (void)setAddressModel:(LFAddressModel *)addressModel {
    _addressModel = addressModel;
    _name.text = addressModel.contactName;
    _phone.text = addressModel.contact;
    _address.text = [NSString stringWithFormat:@"%@", addressModel.address];
//    NSArray * arr = [addressModel.address componentsSeparatedByString:@" "];
//    if (arr.count > 2) {
//        _address.text = [NSString stringWithFormat:@"%@ %@", arr[0], arr[1]];
//        NSMutableString * str = [addressModel.address mutableCopy];
//        [str deleteCharactersInRange:[str rangeOfString:arr[0]]];
//        [str deleteCharactersInRange:[str rangeOfString:arr[1]]];
//        if ([str hasPrefix:@" "]) {
//            [str deleteCharactersInRange:NSMakeRange(0, 1)];
//        }
//        _subAddress.text = [str copy];
//    } else {
//        _address.text = [NSString stringWithFormat:@"%@", arr[0]];
//        NSMutableString * str = [addressModel.address mutableCopy];
//        [str deleteCharactersInRange:[str rangeOfString:arr[0]]];
//        if ([str hasPrefix:@" "]) {
//            [str deleteCharactersInRange:NSMakeRange(0, 1)];
//        }
//        _subAddress.text = [str copy];
//    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self rm_fitAllConstraint];
    
    _addressViewHeightCons.constant = Fit(44);
    
    {
        UITapGestureRecognizer * tap = [UITapGestureRecognizer new];
        @weakify(self);
        [tap.rac_gestureSignal subscribeNext:^(id x) {
            @strongify(self);
            BLOCK_SAFE_RUN(self.didClickSelectedAddressBlock);
        }];
        [_emptyView addGestureRecognizer:tap];
    }
    
    {
        UITapGestureRecognizer * tap = [UITapGestureRecognizer new];
        @weakify(self);
        [tap.rac_gestureSignal subscribeNext:^(id x) {
            @strongify(self);
            BLOCK_SAFE_RUN(self.didClickSelectedAddressBlock);
        }];
        [_addressView addGestureRecognizer:tap];
    }
}

- (CGFloat)completeSelected {
    _addressViewHeightCons.constant = Fit(108);
    _emptyView.hidden = YES;
    return self.height;
}

- (CGFloat)height {
    [self layoutIfNeeded];
    return _bottomView.maxY;
}
+ (instancetype)creatView {
    return [self creatViewFromNibName:@"LFSettleCenterView" atIndex:0];
}
@end


@implementation LFSettleCenterGoodsCell {
    
    __weak IBOutlet UIImageView *_pic;
    __weak IBOutlet UILabel *_name;
    __weak IBOutlet UILabel *_price;
    /// 分期
    __weak IBOutlet UILabel *_installment;
    __weak IBOutlet SLDevider *_devider;
    __weak IBOutlet UILabel *_count;
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView rm_fitAllConstraint];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString * ID = @"LFSettleCenterGoodsCell";
    LFSettleCenterGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LFSettleCenterView" owner:nil options:nil] objectAtIndex:2];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)setGoods:(LFGoods *)goods {
    _goods = goods;
    
    _name.text = goods.goodsName;
    [_pic sd_setImageWithURL:[NSURL URLWithString:goods.goodsUrl] placeholderImage:SLPlaceHolder];
    _price.text = [NSString stringWithFormat:@"售价：￥%@", goods.sellingPrice.formatNumber];
//#warning 分期字段error
    _installment.text = [NSString stringWithFormat:@"分期：￥%@", goods.sl_fenqing.formatNumber];
    _count.text = [NSString stringWithFormat:@"x%@", goods.goodsNum];
}

@end

@implementation LFSettleCenterFooterView {
    
    __weak IBOutlet UIView *_topView;
    __weak IBOutlet UILabel *_payType;
    __weak IBOutlet UIImageView *_icon;
    __weak IBOutlet UILabel *_totalPrice;
    __weak IBOutlet UILabel *_protocolLabel;
    __weak IBOutlet UIButton *_protocalBtn;
    
    __weak IBOutlet UILabel *cheaperCardLabel;
    VoidBlcok _payTypeBlock;
    VoidBlcok _submitBlock;
    VoidBlcok _protocalBlock;
    VoidBlcok _cheaperBlock;
}
- (BOOL)isSelected {
    return _protocalBtn.isSelected;
}
- (IBAction)_didClickSubmitBtn:(id)sender {
    BLOCK_SAFE_RUN(_submitBlock);
}
- (IBAction)_didClickProtocolBtn:(id)sender {
    _protocalBtn.selected = !_protocalBtn.isSelected;
}

- (void)setSelecePayTypeBlock:(VoidBlcok)payType submitBlock:(VoidBlcok)submit protocolBlock:(VoidBlcok)pro cheaperBlock:(VoidBlcok)cheap{
    _payTypeBlock = payType; _submitBlock = submit; _protocalBlock = pro;_cheaperBlock= cheap;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self rm_fitAllConstraint];
    _protocalBtn.selected = YES;
    {
        UITapGestureRecognizer * tap = [UITapGestureRecognizer new];
        @weakify(self);
        [tap.rac_gestureSignal subscribeNext:^(UITapGestureRecognizer * x) {
            @strongify(self);
            CGFloat f = [x locationInView:x.view].y;
            if (f > Fit(44)) return ;
            BLOCK_SAFE_RUN(self->_payTypeBlock);
        }];
        [_topView addGestureRecognizer:tap];
    }
    
    {
        UITapGestureRecognizer * tap = [UITapGestureRecognizer new];
        @weakify(self);
        [tap.rac_gestureSignal subscribeNext:^(UITapGestureRecognizer * x) {
            @strongify(self);
            BLOCK_SAFE_RUN(self->_protocalBlock);
        }];
        _protocolLabel.userInteractionEnabled = YES;
        [_protocolLabel addGestureRecognizer:tap];
    }
    {
        UITapGestureRecognizer * tap = [UITapGestureRecognizer new];
        @weakify(self);
        [tap.rac_gestureSignal subscribeNext:^(UITapGestureRecognizer * x) {
            @strongify(self);
            BLOCK_SAFE_RUN(self->_cheaperBlock);
        }];
        cheaperCardLabel.userInteractionEnabled = YES;
        [cheaperCardLabel addGestureRecognizer:tap];
        
    
    
    }
}
+ (instancetype)creatView {
    return [self creatViewFromNibName:@"LFSettleCenterView" atIndex:1];
}

- (void)setTotalPriceString:(NSString *)totalPriceString {
    _totalPriceString = [totalPriceString copy];
    NSString * txt = [NSString stringWithFormat:@"合计金额：￥%@", totalPriceString.formatNumber];
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:txt];
    NSRange range = NSMakeRange(0, 5);
    [attr addAttribute:NSForegroundColorAttributeName value:HexColorInt32_t(999999) range:range];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:Fit(14)] range:range];
    _totalPrice.attributedText = attr;
}

- (void)setPayTypeString:(NSString *)payTypeString {
    _payTypeString = [payTypeString copy];
    _payType.text = payTypeString;
}

- (void)setCheapPriceString:(NSString *)cheapPriceString {
    _cheapPriceString = [cheapPriceString copy];
    cheaperCardLabel.text = cheapPriceString;
    cheaperCardLabel.textColor = [UIColor redColor];
}


@end


@implementation LFSettleCenterSelectPayTypeView {
    
    __weak IBOutlet UIView *_bgView;
    
    __weak IBOutlet NSLayoutConstraint *_fenqingViewHeightCons;
    NSArray<UIImageView *> * _imageViews;
    void (^_block)(PayType payType);
    PayType _selectedPayType;
}
- (IBAction)_didClickClose:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.y = kScreenHeight;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}

+ (void)showWithCompleteHandle:(void (^)(PayType))block selectedType:(PayType)type {
    [self showWithCompleteHandle:block selectedType:type needFenQing:YES];
}

+ (void)showWithCompleteHandle:(void (^)(PayType))block selectedType:(PayType)type needFenQing:(BOOL)isNeed {
    UIView * view = [UIView viewWithBgColor:[HexColorInt32_t(000000) colorWithAlphaComponent:0.5] frame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    LFSettleCenterSelectPayTypeView * payView = [LFSettleCenterSelectPayTypeView creatView];
    CGFloat height = Fit(payView.height);
    payView.frame = Rect(0, kScreenHeight, kScreenWidth, height);
    payView->_block = block;
    [payView _setSelectedType:type];
    if (!isNeed) {
        payView->_fenqingViewHeightCons.constant = 0;
    }
    [view addSubview:payView];
    
    [UIView animateWithDuration:0.25 animations:^{
        payView.y = kScreenHeight - height;
    }];
}
- (void)_setSelectedType:(PayType)type {
    
    for (UIImageView * imageV in self->_imageViews) {
        imageV.highlighted = NO;
    }
    if (type >= 0) self->_imageViews[type].highlighted = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self rm_fitAllConstraint];
    
    NSMutableArray * arr = @[].mutableCopy;
    for (int i = 0; i < 4; i++) {
        UIImageView * view = [_bgView viewWithTag:i + 10];
        [arr addObject:view];
    }
    _imageViews = [arr copy];
    
    UITapGestureRecognizer * tap = [UITapGestureRecognizer new];
    @weakify(self);
    [tap.rac_gestureSignal subscribeNext:^(UITapGestureRecognizer * x) {
        @strongify(self);
        CGFloat f = [x locationInView:x.view].y;
        NSInteger index = ((NSInteger)(f - Fit(40))) / (NSInteger)(Fit(60));
        for (UIImageView * imageV in self->_imageViews) {
            imageV.highlighted = NO;
        }
        self->_imageViews[index].highlighted = YES;
        
        [self _didClickClose:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BLOCK_SAFE_RUN(self->_block, index);
        });
    }];
    [_bgView addGestureRecognizer:tap];
}

+ (instancetype)creatView {
    return [self creatViewFromNibName:@"LFSettleCenterView" atIndex:3];
}
@end


@implementation LFSelectedInvoiceTypeView {
    
    __weak IBOutlet UIView *_bgView;
    
    NSArray<UIImageView *> * _imageViews;
    void (^_block)(NSInteger payType);
    NSInteger _selectedPayType;
}
- (IBAction)_didClickClose:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.y = kScreenHeight;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}

+ (void)showWithCompleteHandle:(void (^)(NSInteger))block selectedType:(NSInteger)type {
    
    UIView * view = [UIView viewWithBgColor:[HexColorInt32_t(000000) colorWithAlphaComponent:0.5] frame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    LFSelectedInvoiceTypeView * payView = [LFSelectedInvoiceTypeView creatView];
    CGFloat height = Fit(payView.height);
    payView.frame = Rect(0, kScreenHeight, kScreenWidth, height);
    payView->_block = block;
    [payView _setSelectedType:type];
    [view addSubview:payView];
    
    [UIView animateWithDuration:0.25 animations:^{
        payView.y = kScreenHeight - height;
    }];
}



- (void)_setSelectedType:(NSInteger)type {
    
    for (UIImageView * imageV in self->_imageViews) {
        imageV.highlighted = NO;
    }
    if (type >= 0) self->_imageViews[type].highlighted = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self rm_fitAllConstraint];
    
    NSMutableArray * arr = @[].mutableCopy;
    for (int i = 0; i < 2; i++) {
        UIImageView * view = [_bgView viewWithTag:i + 10];
        [arr addObject:view];
    }
    _imageViews = [arr copy];
    
    UITapGestureRecognizer * tap = [UITapGestureRecognizer new];
    @weakify(self);
    [tap.rac_gestureSignal subscribeNext:^(UITapGestureRecognizer * x) {
        @strongify(self);
        CGFloat f = [x locationInView:x.view].y;
        NSInteger index = ((NSInteger)(f - Fit(40))) / (NSInteger)(Fit(60));
        for (UIImageView * imageV in self->_imageViews) {
            imageV.highlighted = NO;
        }
        self->_imageViews[index].highlighted = YES;
        
        [self _didClickClose:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BLOCK_SAFE_RUN(self->_block, index);
        });
    }];
    [_bgView addGestureRecognizer:tap];
}

+ (instancetype)creatView {
    return [self creatViewFromNibName:@"LFSettleCenterView" atIndex:4];
}




@end
