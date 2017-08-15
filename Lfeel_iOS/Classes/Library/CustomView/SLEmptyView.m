//
//  SLEmptyView.m
//  TKLUser
//
//  Created by Seven Lv on 16/11/25.
//  Copyright © 2016年 Seven Lv. All rights reserved.
//

#import "SLEmptyView.h"

@implementation SLEmptyView {
    UIImageView * _imageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"空盒子"]];
        self.backgroundColor = HexColorInt32_t(f6f6f6);
        [self addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.center = Point(self.halfWidth, self.halfHeight - Fit414(0));
}
@end
