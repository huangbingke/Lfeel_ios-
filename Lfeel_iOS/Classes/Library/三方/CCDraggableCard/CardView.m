//
//  CardView.m
//  YSLDraggingCardContainerDemo
//
//  Created by yamaguchi on 2015/11/09.
//  Copyright © 2015年 h.yamaguchi. All rights reserved.
//

#import "CardView.h"
@interface CardView()


@end

@implementation CardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _imageView = [[UIImageView alloc]init];
    _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 30);
    [self addSubview:_imageView];
    
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:_imageView.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(7.0, 7.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _imageView.bounds;
    maskLayer.path = maskPath.CGPath;
    _imageView.layer.mask = maskLayer;
    
    _selectedView = [[UIView alloc]init];
    _selectedView.frame = _imageView.frame;
    _selectedView.backgroundColor = [UIColor clearColor];
    _selectedView.alpha = 0.0;
    [_imageView addSubview:_selectedView];
    
    _label = [[UILabel alloc]init];
    _label.backgroundColor = [UIColor clearColor];
    _label.frame = CGRectMake(10, self.frame.size.height-35, self.frame.size.width - 20, 20);
    _label.font = [UIFont fontWithName:@"Futura-Medium" size:14];
    _label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_label];
    
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageView.layer setMasksToBounds:YES];
    
//    self.addVip  =  [UIButton buttonWithType:UIButtonTypeCustom];
//    self.addVip.frame = Rect(self.frame.size.width/2- Fit375(50),self.frame.size.height - 80  ,Fit375(100) , Fit375(34));
//    [self.addVip  setTitleColor:HexColorInt32_t(C00D23)];
//    self.addVip.borderWidth = 1;
//    self.addVip.borderColor = HexColorInt32_t(C00D23);
//
//    [self.addVip setTitle:@"加入会员"];
//    self.addVip.titleLabel.font = [UIFont systemFontOfSize:Fit375(Fit375(13))];
//    [self.addVip addTarget:self action:@selector(TapAddVipBtn)];
//    [self addSubview:self.addVip];
}


-(void)TapAddVipBtn {
    SLLog2(@"加入会员");
    if (self.TapSelectAddVipBtn) {
        self.TapSelectAddVipBtn();
    }
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
