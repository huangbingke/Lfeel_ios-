//
//  GoodSBannarView.m
//  PocketJC
//
//  Created by kvi on 16/10/8.
//  Copyright © 2016年 CHY. All rights reserved.
//

#import "GoodSBannarView.h"
#import "HJScrollBanner.h"
#import "SLPageControl.h"

@interface GoodSBannarView()
///banner位置
@property (strong, nonatomic)  HJScrollImage * scrollBanner;
@property (nonatomic,   weak) SLPageControl * pageControl;

@end
@implementation GoodSBannarView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        HJScrollImage * scrollBanner = [[HJScrollImage alloc]initWithFrame:frame];
        self.scrollBanner = scrollBanner;
        
        self.scrollBanner.pageControl.currentPageIndicatorTintColor = HexColorInt32_t(FFD96C);
        self.scrollBanner.pageControl.pageIndicatorTintColor = HexColorInt32_t(d4d4d4);
        self.scrollBanner.imageContentMode = UIViewContentModeScaleAspectFit;
//        self.imageView.contentMode = UIViewContentModeScaleAspectFit
        self.scrollBanner.placeholderImage = SLPlaceHolder;
        [self addSubview:scrollBanner];
//        self.scrollBanner.isGoodsFrame = YES;
        
    }
    return self;
}


- (void)setBannarPic:(LFGoodsDetailModel *)model{

    NSMutableArray * urls = [NSMutableArray array];
    for (LFGoodsDetailGoodsUrlList *brapic in model.goodsUrlList) {
        if (brapic.imgUrl) {
            [urls addObject:brapic.imgUrl];
        } else {
            [urls addObject:SLPlaceHolder];
        }
    }
    [HJScrollBanner bannerWithArray:urls scrollImage:self.scrollBanner imageType:HJImageURLType];
    
}


@end
