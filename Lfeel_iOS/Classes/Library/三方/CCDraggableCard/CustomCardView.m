//
//  CustomCardView.m
//  CCDraggableCard-Master
//
//  Created by jzzx on 16/7/9.
//  Copyright © 2016年 Zechen Liu. All rights reserved.
//

#import "CustomCardView.h"

@interface CustomCardView ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel     *titleLabel;
///<#name#>
@property (strong, nonatomic)  UIButton * addVip;

@end

@implementation CustomCardView

- (instancetype)init {
    if (self = [super init]) {
        [self loadComponent];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadComponent];
    }
    return self;
}

- (void)loadComponent {
    self.imageView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.addVip  =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addVip  setTitleColor:HexColorInt32_t(C00D23)];
    self.addVip.borderWidth = 1;
    self.addVip.borderColor = HexColorInt32_t(C00D23);
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageView.layer setMasksToBounds:YES];
    [self.addVip setTitle:@"加入会员"];
    self.addVip.titleLabel.font = [UIFont systemFontOfSize:Fit375(Fit375(13))];
    [self.addVip addTarget:self action:@selector(TapAddVipBtn)];
    
    self.titleLabel.textColor = HexColorInt32_t(333333);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:Fit375(13)];
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.addVip];
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)cc_layoutSubviews  {    
    self.imageView.frame   = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 64);
    self.titleLabel.frame = CGRectMake(0, self.frame.size.height -86, self.frame.size.width, Fit375(44));
    self.addVip.frame = Rect(self.frame.size.width/2- Fit375(50),CGRectGetMaxY(self.titleLabel.frame)-10  ,Fit375(100) , Fit375(34));
}

- (void)installData:(LFHothirevModel *)element {
    
    
    
    self.model = element;
    
    
    
    SLLog(element);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:element.goodsUrl]];
    self.imageView.transform = CGAffineTransformIdentity;
    self.titleLabel.text = element.goodsName;
    self.titleLabel.transform = CGAffineTransformIdentity;
}

-(void)TapAddVipBtn {
    SLLog2(@"加入会员");
    if (self.TapSelectAddVipBtn) {
        self.TapSelectAddVipBtn();
    }
}


@end
