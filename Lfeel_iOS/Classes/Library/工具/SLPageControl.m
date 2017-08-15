//
//  SLPageControl.m
//  RunningMan
//
//  Created by Seven Lv on 16/1/15.
//  Copyright © 2016年 Toocms. All rights reserved.
//

#import "SLPageControl.h"

@interface SLPageControl ()
@property (nonatomic, strong) NSMutableArray * pages;
@property (nonatomic, assign) CGFloat pageSize;

@property(nullable, nonatomic,strong) UIImage *pageIndicatorImage; // 默认图片
@property(nullable, nonatomic,strong) UIImage *currentPageIndicatorImage; // 当前图片
@end

@implementation SLPageControl

+ (instancetype)pageControlWithNumber:(NSInteger)count imageName:(NSString *)name currentImageName:(NSString *)current frame:(CGRect)frame {

    return [[self alloc] initWithNumber:count imageName:name currentImageName:current frame:frame];
}

- (instancetype)initWithNumber:(NSInteger)count imageName:(NSString *)name currentImageName:(NSString *)current frame:(CGRect)frame {
    if (self = [super init]) {
        self.frame = frame;
        _currentPage = 0;
        for (int i = 0; i < count; i++) {
            UIImage * image = nil;
            if (i == _currentPage) {
                image = [UIImage imageNamed:current];
                self.currentPageIndicatorImage = image;
            } else {
                image = [UIImage imageNamed:name];
                self.pageIndicatorImage = image;
            }
            CGFloat panding = (self.width - self.height * count - 6) / (count - 1);
            CGRect f = CGRectMake(3 + i * (self.height + panding), 0, self.height, self.height);
            UIImageView * imageV = [UIImageView imageViewWithImage:image frame:f];
            [self addSubview:imageV];
        }
    }
    return self;
}

- (void)setCurrentPage:(NSInteger)currentPage {
    
    NSAssert(currentPage < self.subviews.count, @"当前页数不能大于总数");
    
    
    UIImageView * last = self.subviews[_currentPage];
    UIImageView * arrive = self.subviews[currentPage];
    
    last.image = self.pageIndicatorImage;
    arrive.image = self.currentPageIndicatorImage;
    
    _currentPage = currentPage;
    
    [self setNeedsDisplay];
}

@end
