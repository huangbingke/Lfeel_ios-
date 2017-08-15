//
//  SLAddEvaluationCell.m
//  PocketJC
//
//  Created by apple on 16/10/9.
//  Copyright © 2016年 CHY. All rights reserved.
//

#import "SLAddEvaluationCell.h"
#import "CWStarRateView.h"
#import "SLImagePickerController.h"
#import "SLAppDelegate.h"

@implementation SLAddEvaluationCell {
  __weak IBOutlet UIImageView *_goodsImageView;
  __weak IBOutlet UITextView *_contentTextView;
  __weak IBOutlet UILabel *_placeholder;
  __weak IBOutlet UIView *_pictureBgView;
  __weak IBOutlet UIView *_bottomView;
  __weak IBOutlet NSLayoutConstraint *_pictureBgViewHeightCons;
  ///  选择图片按钮
  UIButton *_selectPictureBtn;
    ///  图片的间距
  CGFloat _pandding;
    ///  imageView集合
    NSMutableArray<UIImageView *> *_imageViews;
    ///  imageView集合
    NSMutableArray<UIButton *> *_deleteBtns;
    __weak IBOutlet UIView *_bottomDevider;
    
    CWStarRateView * _star;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    _bottomDevider.backgroundColor = HexColorInt32_t(f6f6f6);
    _pandding = 7;
    // 图片容器高度
    CGFloat wh = (kScreenWidth - 30 - 3 * _pandding) / 4;
    _pictureBgViewHeightCons.constant = wh + 7;
    
    _imageViews = @[].mutableCopy;
    _deleteBtns = @[].mutableCopy;
    for (int i = 0; i < 4; i++) {
        
        UIImageView * imageV = [UIImageView new];
        imageV.size = Size(wh, wh);
        imageV.userInteractionEnabled = YES;
        imageV.hidden = YES;
        [_pictureBgView addSubview:imageV];
        [_imageViews addObject:imageV];
        
        UIButton * btn = [UIButton buttonWithTitle:nil titleColor:nil backgroundColor:nil font:0 image:@"评价-删除" frame:Rect(0, 0, 14, 14)];
        btn.tag = i;
        btn.hidden = YES;
        [_pictureBgView addSubview:btn];
        [btn addTarget:self action:@selector(_deleteImageView:)];
        [_deleteBtns addObject:btn];
        
        if (i == 0) { // 创建添加图片按钮
            _selectPictureBtn = [UIButton buttonWithTitle:nil titleColor:nil backgroundColor:nil font:0 image:@"评价-图" frame:Rect(i * (wh + _pandding), 7, wh, wh)];

            [_selectPictureBtn addTarget:self action:@selector(_didClickselectPictureBtn)];
            [_pictureBgView addSubview:_selectPictureBtn];
        }
    }
    
    // 星星
    CWStarRateView * star = [[CWStarRateView alloc] initWithFrame:Rect(95, 0, 110, 16) numberOfStars:5];
    star.scorePercent = 1.0;
    star.centerY = 25;
    star.userInteractionEnabled = YES;
    [_bottomView addSubview:star];
    star.delegate = (id<CWStarRateViewDelegate>)self;
    _star = star;
    
    @weakify(self);
    [_contentTextView.rac_textSignal subscribeNext:^(NSString * x) {
        @strongify(self);
        self->_placeholder.hidden = x.length > 0;
        self->_detail.sl_evalutionText = x;
    }];
    
}

- (void)dealloc {
    SLLog(self);
}

- (void)setDetail:(_SLOrderDetail *)detail {
    _detail = detail;
    _contentTextView.text = detail.sl_evalutionText;
    _placeholder.hidden = _contentTextView.text.length > 0;
    _star.scorePercent = detail.sl_score;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:detail.goods_pic] placeholderImage:SLPlaceHolder];
    [self _layoutImageViews];
}

///  选择图片
- (void)_didClickselectPictureBtn {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (_detail.sl_images.count == 4) {
        SVShowError(@"最多可以选择4张");
        return;
    }
    [SLImagePickerController showInViewController:[SLAppDelegate sharedDelegate].window.rootViewController libraryType:0 allowEdit:NO complete:^(UIImage *image) {
        [self _requestUploadImage:@[image]];
    }];
}

///  给图片布局
- (void)_layoutImageViews {
    
    CGFloat wh = (kScreenWidth - 30 - 3 *  _pandding) / 4;
    for (UIImageView * image in _imageViews)
    {
        image.hidden = YES;
    }
    for (UIButton * btn in _deleteBtns) {
        btn.hidden = YES;
    }
    NSInteger i = 0;
    NSMutableArray * arr = _detail.sl_images;
    for (UIImage * image in arr) {
        UIImageView * imageView = _imageViews[i];
        imageView.image = image;
        imageView.hidden = NO;
        imageView.origin = Point(i * (wh + _pandding), 7);
        
        UIButton * deleteBtn = _deleteBtns[i];
        deleteBtn.center = Point(imageView.maxX, imageView.y);
        deleteBtn.hidden = NO;
        i++;
    }
    if (arr.count == 4) {
        _selectPictureBtn.hidden = YES;
    } else {
        if (arr.count == 0) {
            _selectPictureBtn.frame = Rect(0, 7, wh, wh);
        } else{
            _selectPictureBtn.frame = Rect((i) * (wh + _pandding), 7, wh, wh);
        }
        _selectPictureBtn.hidden = NO;
    }
    [self layoutIfNeeded];
}

///  删除图片
- (void)_deleteImageView:(UIButton *)btn {
    [_detail.sl_images removeObjectAtIndex:btn.tag];
    [_detail.sl_imagesIDs removeObjectAtIndex:btn.tag];
    [self _layoutImageViews];
}

///  星星view的代理
- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent {
    
    _detail.sl_score = newScorePercent;
}

///  请求上传图片
- (void)_requestUploadImage:(NSArray *)images {
    
    NSString * url = @"MOrder/uploadPic";
    
    NSMutableArray * params = @[].mutableCopy;
    for (int i = 0; i < images.count; i++) {
        [params addObject:[NSString stringWithFormat:@"comment_pic[%d]", i]];
    }
    
    [TSNetworking POSTImagesWithURL:url paramsModel:nil images:images imageParams:params completeBlock:^(SLBaseModel *request) {
        SLLog(request);
        if ([request.flag isEqualToString:@"error"]) {
            SVShowError(request.message); return ;
        }
        
        for (NSDictionary * dict in request.data) {
            [_detail.sl_imagesIDs addObject:dict[@"picture_id"]];
        }
        
        [_detail.sl_images addObjectsFromArray:images];
        [self _layoutImageViews];
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
    
}
@end
