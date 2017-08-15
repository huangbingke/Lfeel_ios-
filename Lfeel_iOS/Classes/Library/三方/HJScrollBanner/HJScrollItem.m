//
//  HJScrollItem.m
//  HJScrollImage
//
//  Created by hoojack on 15/8/8.
//  Copyright (c) 2015年 hoojack. All rights reserved.
//

#import "HJScrollItem.h"
#import "HJScrollItemData.h"
#import "HJScrollBanner.h"



@interface HJScrollItem()

//@property (nonatomic, weak) UIImageView* imageView;
@property (nonatomic, weak) UIView* titleBkg;
@property (nonatomic, weak) UILabel* lblTitle;
@property (nonatomic, weak) UILabel* lblDesc;
@property (nonatomic , weak) UIView * bgView;
//@property (nonatomic , strong) UIImageView * saveImageView;

@property (nonatomic, strong) HJScrollBanner * banner;

@end


@implementation HJScrollItem

- (instancetype)init
{
    if (self = [super init])
    {
        [self initSubViews];
    }
    return self;
}


- (void)initSubViews
{
    
//    UIView * bg = [[UIView alloc] init];
//    bg.backgroundColor = [UIColor blackColor];
//    bg.alpha = 0.5;
//    [self addSubview:bg];
//    self.bgView = bg;
    UIImageView* imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    self.imageView = imageView;
    
    UIView* titleBkg = [[UIView alloc] init];
    titleBkg.backgroundColor = [UIColor blackColor];
    titleBkg.alpha = 0.5;
    [self addSubview:titleBkg];
    self.titleBkg = titleBkg;
    
    UILabel* lblTitle = [[UILabel alloc] init];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.numberOfLines = 0;
    lblTitle.font = [UIFont systemFontOfSize:12];
    [self addSubview:lblTitle];
    self.lblTitle = lblTitle;
}

- (void)layoutSubviews
{
    CGFloat itemW = CGRectGetWidth(self.frame);
    CGFloat itemH = CGRectGetHeight(self.frame);
    self.imageView.frame = CGRectMake(0, 0, itemW, itemH);
    
    CGFloat titleH = 35.0;
    CGRect rcTitle = CGRectMake(15, itemH - titleH, itemW - 15 - 60, titleH);
    
    self.lblTitle.frame = rcTitle;
    self.titleBkg.frame = CGRectMake(0, itemH - titleH, itemW, 0);
//    self.bgView.frame = CGRectMake(0, itemH - titleH, itemW, titleH);
}

- (void)setData:(HJScrollItemData *)data
{
    _data = data;
    if (data.isUrl) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.data.imageName] placeholderImage:SLPlaceHolder];
    } else {
        if (data.image) {
            self.imageView.image = data.image;
        } else {
            
            self.imageView.image = [UIImage imageNamed:self.data.imageName];
        }
    }
    
//    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:data.imageName]]];
    
    //显示label的title
//    self.lblTitle.text = [NSString stringWithFormat:@"  %@", self.data.title];
    [self.lblTitle sizeToFit];
}

@end
