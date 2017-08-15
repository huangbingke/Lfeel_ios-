//
//  SLNavigationButton.m
//  TKLMerchant
//
//  Created by Seven Lv on 16/10/26.
//  Copyright © 2016年 Seven Lv. All rights reserved.
//

#import "SLNavigationButton.h"

@interface SLNavigationButton ()

@end

@implementation SLNavigationButton {
    UIButton * _btn;
    UIImageView * _imageView;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title action:(VoidBlcok)action {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    _btn = [UIButton buttonWithTitle:title titleColor:[UIColor whiteColor] backgroundColor:nil font:Fit414(14) image:nil frame:CGRectZero];
    [self addSubview:_btn];
    
    [[_btn rac_signalForControlEvents:64] subscribeNext:^(id x) {
        BLOCK_SAFE_RUN(action);
    }];
    
    _imageView = [UIImageView imageViewWithImage:[UIImage imageNamed:@"首页-白色三角"] frame:Rect(0, 0, 10, 10)];
    [self addSubview:_imageView];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_btn sizeToFit];
    if (_btn.width > self.width - 40) {
        _btn.width = self.width - 40;
    }
    _btn.center = Point(self.halfWidth, self.halfHeight);
    _imageView.origin = Point(_btn.maxX + 3, 0);
    _imageView.centerY = _btn.centerY;
}

- (void)setTitle:(NSString *)title {
    _btn.title = title;
    [self layoutIfNeeded];
}

- (NSString *)title {
    return _btn.currentTitle;
}

- (void)setAttibutedString:(NSAttributedString *)attibutedString {
    [_btn setAttributedTitle:attibutedString forState:UIControlStateNormal];
    [self layoutIfNeeded];
}

- (NSAttributedString *)attibutedString {
    return _btn.currentAttributedTitle;
}

@end