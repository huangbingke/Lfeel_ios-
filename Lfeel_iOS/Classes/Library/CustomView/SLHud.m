//
//  SLHud.m
//  TKLUser
//
//  Created by Seven Lv on 16/11/17.
//  Copyright © 2016年 Seven Lv. All rights reserved.
//

#import "SLHud.h"

@implementation SLHud {
    UIActivityIndicatorView * _activity;
    UILabel * _titleLabel;
}

- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activity startAnimating];
        [self addSubview:activity];
        _activity = activity;
        
        UILabel * label = [UILabel labelWithText:title font:Fit414(14) textColor:HexColorInt32_t(666666) frame:CGRectZero];
        [self addSubview:label];
        _titleLabel = label;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat centerY = self.halfHeight;
    if (_titleLabel.text) {
        centerY -= 30;
    }
    _activity.center = Point(self.halfWidth, centerY);
    [_titleLabel sizeToFit];
    _titleLabel.center = Point(_activity.centerX, _activity.maxY + 20);
}

CGRect defaultRect() {
    return CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
}

@end
