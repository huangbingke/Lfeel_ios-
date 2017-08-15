//
//  HJScrollImage.m
//  HJScrollImage
//
//  Created by hoojack on 15/8/8.
//  Copyright (c) 2015年 hoojack. All rights reserved.
//

#import "HJScrollImage.h"
#import "HJScrollItem.h"
#import "HJScrollItemData.h"
#import "YYTextWeakProxy.h"

@interface HJScrollImage() <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView* scrollView;


@property (nonatomic, weak) HJScrollItem* leftItem;
@property (nonatomic, weak) HJScrollItem* midItem;
@property (nonatomic, weak) HJScrollItem* rightItem;
@property (nonatomic, assign) CGRect leftFrame;
@property (nonatomic, assign) CGRect midFrame;
@property (nonatomic, assign) CGRect rightFrame;

@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic,   weak) UIImageView * placeholderImageView;
@end

@implementation HJScrollImage

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIPageControl* pageControl = [[UIPageControl alloc] init];
    pageControl.hidesForSinglePage = YES;
    pageControl.numberOfPages = 1;
    pageControl.currentPage = 0;
    pageControl.userInteractionEnabled = NO;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    HJScrollItem* leftItem = [[HJScrollItem alloc] init];
    [self.scrollView addSubview:leftItem];
    self.leftItem = leftItem;
    
    HJScrollItem* midItem = [[HJScrollItem alloc] init];
    [self.scrollView addSubview:midItem];
    self.midItem = midItem;
    
    HJScrollItem* rightItem = [[HJScrollItem alloc] init];
    [self.scrollView addSubview:rightItem];
    self.rightItem = rightItem;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat itemW = CGRectGetWidth(self.frame);
    CGFloat itemH = CGRectGetHeight(self.frame);
    self.scrollView.frame = CGRectMake(0, 0, itemW, itemH);
    
    self.leftFrame = CGRectMake(0, 0, itemW, itemH);
    self.midFrame = CGRectMake(itemW, 0, itemW, itemH);
    self.rightFrame = CGRectMake(itemW * 2, 0, itemW, itemH);
    
    self.leftItem.frame = self.leftFrame;
    self.midItem.frame = self.midFrame;
    self.rightItem.frame = self.rightFrame;
}
- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    if (self.datas.count) {
        return;
    }
    UIImageView * placeholderImageView = [UIImageView imageViewWithImage:placeholderImage frame:self.bounds];
    [self addSubview:placeholderImageView];
    self.placeholderImageView = placeholderImageView;
}
- (void)setDatas:(NSArray *)datas
{
    _datas = datas;
    [self.placeholderImageView removeFromSuperview];
    int index = 0;
    for (HJScrollItemData* data in self.datas)
    {
        data.index = index;
        index ++;
    }
    
    CGFloat itemW = CGRectGetWidth(self.frame);
    CGFloat itemH = CGRectGetHeight(self.frame);
    CGFloat pageControlW = 22.0;
    CGFloat pageControlH = 35.0;
    NSUInteger count = self.datas.count;
    self.pageControl.numberOfPages = count;
    self.pageControl.currentPage = 0;
    self.pageControl.frame = CGRectMake(itemW - pageControlW * count , itemH - pageControlH, pageControlW * count, pageControlH);
//#warning 设置pageControl的位置
    self.pageControl.centerX = kScreenWidth * 0.5;
//    self.pageControl.maxX = kScreenWidth - 20;
    if (count > 0)
    {
        self.leftItem.data = [self.datas lastObject];
        if (count > 1)
        {
            self.midItem.data = [self.datas firstObject];
            self.rightItem.data = [self.datas objectAtIndex:1];
            
            self.scrollView.contentSize = CGSizeMake(itemW * 3, 0);
            self.scrollView.contentOffset = CGPointMake(itemW, 0);
        }
        else
        {
            self.scrollView.contentSize = CGSizeMake(itemW, 0);
            self.midItem.frame = self.leftFrame;
        }
    }
    
    [self startTimer];
}

- (void)startTimer
{
    if (self.datas.count < 2)
    {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:[YYTextWeakProxy proxyWithTarget:self] selector:@selector(scrollPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)endTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollPage
{
    CGFloat itemW = CGRectGetWidth(self.frame);
    [self.scrollView setContentOffset:CGPointMake(itemW * 2, 0) animated:YES];
}

- (void)stop
{
    [self endTimer];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat itemW = CGRectGetWidth(self.frame);
    CGPoint offset = scrollView.contentOffset;
    
    if (offset.x == 0 || offset.x == itemW * 2)
    {
        self.scrollView.contentOffset = CGPointMake(itemW, 0);
        __weak HJScrollItem* midItem = self.midItem;
        __weak HJScrollItem* leftItem = self.leftItem;
        __weak HJScrollItem* rightItem = self.rightItem;
        
        if (offset.x == 0)
        {
            self.midItem = leftItem;
            self.leftItem = midItem;
            
            self.midItem.frame = self.midFrame;
            self.leftItem.frame = self.leftFrame;
        }
        else
        {
            self.midItem = rightItem;
            self.rightItem = midItem;
            
            self.midItem.frame = self.midFrame;
            self.rightItem.frame = self.rightFrame;
        }
        
        NSInteger count = self.datas.count;
        NSInteger curindex = self.midItem.data.index;
        NSInteger previndex = curindex - 1;
        NSInteger nextindex = curindex + 1;
       
        if (previndex < 0)
        {
            previndex = count - 1;
        }
        if (nextindex >= count)
        {
            nextindex = 0;
        }
        
        self.leftItem.data = [self.datas objectAtIndex:previndex];
        self.rightItem.data = [self.datas objectAtIndex:nextindex];
        self.pageControl.currentPage = curindex;

    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}
- (void)setImageContentMode:(UIViewContentMode)imageContentMode {
    _imageContentMode = imageContentMode;
    NSArray * arr = @[self.leftItem, self.midItem, self.rightItem];
    for (HJScrollItem * item in arr) {
        item.imageView.contentMode = imageContentMode;
        item.imageView.clipsToBounds = YES;
    }
}
@end
