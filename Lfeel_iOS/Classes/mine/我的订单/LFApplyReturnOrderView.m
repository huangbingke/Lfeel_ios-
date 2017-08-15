//
//  LFApplyReturnOrderView.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 2017/6/16.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFApplyReturnOrderView.h"
#import "TZImagePickerController.h"
#import "LFAddCommentVC.h"

@implementation LFApplyReturnOrderView {
    
    __weak IBOutlet UIImageView *_type;
    __weak IBOutlet UIImageView *_deliveryStatueNo;
    __weak IBOutlet UIImageView *_deliveryStatueYes;
    __weak IBOutlet UILabel *_reason;
    
    __weak IBOutlet UITextField *_remark;
    __weak IBOutlet UITextField *_amount;
    
    __weak IBOutlet UIButton *_addBtn;
    __weak IBOutlet NSLayoutConstraint *_addBtnLeftCons;
    __weak IBOutlet UIButton *_btn1;
    __weak IBOutlet UIButton *_btn2;
    __weak IBOutlet UIButton *_btn3;
 
    NSInteger _selectType;
    NSMutableArray<UIImage *> * _pics;
    BOOL _isSelectedReaseon;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self rm_fitAllConstraint];
    _pics = @[].mutableCopy;
    _selectType = -1;
    _deliveryStatueYes.highlighted = YES;
    _type.highlighted = YES;
    
    NSArray<UIButton *> * btns = @[_btn1, _btn2, _btn3];
    @weakify(self);
    for (UIButton * btn in btns) {
        [[btn rac_touchupInsideSignal] subscribeNext:^(UIButton * x) {
            @strongify(self);
            NSInteger b = [btns indexOfObject:x];
            [self->_pics removeObjectAtIndex:b];
            [x setImage:nil forState:UIControlStateNormal];
            [self _layoutImageViews];
        }];
    }
    
    [_amount.rac_textSignal subscribeNext:^(NSString * x) {
        @strongify(self);
        if (x.doubleValue > 200) {
                self->_amount.text = @"200";
        }
    }];
}
- (IBAction)_didClickType:(id)sender {
    _type.highlighted = YES;
}
- (IBAction)_didClickDeliveryStatueNo:(id)sender {
    if (!_deliveryStatueNo.isHighlighted) {
        _deliveryStatueNo.highlighted = YES;
        _deliveryStatueYes.highlighted = NO;
    }
}
- (IBAction)_didClickDeliveryStatueYes:(id)sender {
    if (!_deliveryStatueYes.isHighlighted) {
        _deliveryStatueYes.highlighted = YES;
        _deliveryStatueNo.highlighted = NO;
    }
}
- (IBAction)_didClickReason:(id)sender {
    @weakify(self);
    [LFApplyReturnOrderReasonView showWithCompleteHandle:^(NSInteger b) {
        @strongify(self);
        NSArray * arr = @[@"不想要/拍错等个人原因", @"面料款式不符合描述", @"卖家要求加价/库存不够", @"未按约定时间发货", @"无客服接待", @"其它"];
        self->_selectType = b;
        self->_reason.text = arr[b];
        self->_isSelectedReaseon = YES;
    } selectedType:_selectType];
}
- (IBAction)_didClickAddPhoto:(id)sender {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 - _pics.count delegate:nil];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        [self _uploadImages:photos];
    }];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePickerVc animated:YES completion:nil];
    
}

/// 上传图片
- (void)_uploadImages:(NSArray *)images {
    dispatch_group_t group = dispatch_group_create();
    
    for (int i = 0; i < images.count; i++) {
        UIImage * image = images[i];
        NSString * url = @"image/upload";
        dispatch_group_enter(group);
        [TSNetworking POSTImageWithURL:url paramsModel:nil image:image imageParam:@"111" completeBlock:^(NSDictionary *request) {
            SLLog(request);
            if ([request[@"result"] integerValue] != 200) {
                SVShowError(request[@"msg"]);
                return ;
            }
            image.urlString = request[@"imgUrl"];
            dispatch_group_leave(group);
        } failBlock:^(NSError *error) {
            SLShowNetworkFail;
            SLLog(error);
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        BOOL y = YES;
        for (UIImage * image in images) {
            if (!image.urlString) {
                y = NO;
                break;
            }
        }
        if (!y) return ;
        [_pics addObjectsFromArray:images];
        [self _layoutImageViews];
    });
}

///  布局图片
- (void)_layoutImageViews {
    
    NSArray<UIButton *> * btns = @[_btn1, _btn2, _btn3];
    for (UIButton * btn in btns) {
        [btn setImage:nil forState:UIControlStateNormal];
    }
    
    for (int i = 0; i < _pics.count; i++) {
        UIImage * image = _pics[i];
        UIButton * btn = btns[i];
        btn.image = image;
    }
    NSInteger index = _pics.count - 1;
    if (index == 2) {
        _addBtn.hidden = YES;
    } else {
        _addBtn.hidden = NO;
        _addBtnLeftCons.constant = btns[index + 1].x;
    }
}

#pragma mark - Public
- (NSString *)reasonText {
    return _isSelectedReaseon ? _reason.text : nil;
}

- (NSInteger)status {
    return _deliveryStatueYes.isHighlighted;
}

- (NSString *)amountText {
    return _amount.text;
}

- (NSString *)remarkText {
    return _remark.text;
}

- (NSArray<NSString *> *)imageUrls {
    if (!_pics.count) {
        return nil;
    }
    
    NSMutableArray * arr = @[].mutableCopy;
    for (UIImage * image in _pics) {
        [arr addObject:image.urlString];
    }
    return [arr copy];
}
- (void)setPrice:(NSString *)p {
    _amount.text = p;
}
@end

@implementation LFApplyReturnOrderReasonView {
    
    __weak IBOutlet UIView *_bgView;
    
    NSArray<UIImageView *> * _imageViews;
    void (^_block)(NSInteger index);
    NSInteger _selectedIndex;
}
- (IBAction)_didClickClose:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.y = kScreenHeight;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}

+ (void)showWithCompleteHandle:(void (^)(NSInteger))block selectedType:(NSInteger)type {
    [self showWithCompleteHandle:block selectedType:type needFenQing:YES];
}

+ (void)showWithCompleteHandle:(void (^)(NSInteger))block selectedType:(NSInteger)type needFenQing:(BOOL)isNee {
    UIView * view = [UIView viewWithBgColor:[HexColorInt32_t(000000) colorWithAlphaComponent:0.5] frame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    LFApplyReturnOrderReasonView * payView = [LFApplyReturnOrderReasonView creatView];
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
    for (int i = 0; i < 6; i++) {
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
    return [self creatViewFromNibName:@"LFApplyReturnOrderView" atIndex:1];
}


@end
