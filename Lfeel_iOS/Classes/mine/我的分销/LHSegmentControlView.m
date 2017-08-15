//
//  LHSegmentControlView.m
//  LFeelAPP
//
//  Created by 黄冰珂 on 2017/6/14.
//  Copyright © 2017年 黄冰珂. All rights reserved.
//

#import "LHSegmentControlView.h"

@interface LHSegmentControlView ()

@property (nonatomic, assign) CGFloat btnWidth;


@end
@implementation LHSegmentControlView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray titleFont:(UIFont *)titleFont titleDefineColor:(UIColor *)titleColor titleSelectedColor:(UIColor *)selectedColor {
    if (self = [super initWithFrame:frame]) {
        self.isClick = YES;
        self.btnWidth = frame.size.width/titleArray.count;
        for (int i = 0; i < titleArray.count; i++) {
            UIButton *titleBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
            titleBtn.tag = 3000+i;
            [titleBtn setTitle:titleArray[i] forState:(UIControlStateNormal)];
            if (i == 0) {
                [titleBtn setTitleColor:selectedColor forState:(UIControlStateNormal)];
            } else {
                [titleBtn setTitleColor:titleColor forState:(UIControlStateNormal)];
            }
            titleBtn.titleLabel.font = titleFont;
            titleBtn.frame = CGRectMake(i*(self.frame.size.width/(titleArray.count)), 0, self.frame.size.width/(titleArray.count), frame.size.height-2);
            
            [titleBtn addTarget:self action:@selector(handleTitleBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:titleBtn];
        }
        _sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-2, self.frame.size.width/(titleArray.count), 2)];
        _sliderView.backgroundColor = selectedColor;
        [self addSubview:_sliderView];
    }
    return self;
}


- (void)handleTitleBtn:(UIButton *)sender {
    //点击哪个, 哪个变成红色, 其他的变成黑色
   NSArray *btnArr = [self subviews];
    for (UIView *btn in btnArr) {
        if (btn.tag != sender.tag && [btn isKindOfClass:[UIButton class]]) {
            [(UIButton *)btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];

        }
    }
    [sender setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    
    if (sender.center.x == _sliderView.center.x) {
        
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint point = self.sliderView.center;
        point.x += sender.frame.size.width *((sender.center.x-_sliderView.center.x)/self.btnWidth);
        
        _sliderView.center = point;
    }];
    

    if (self.clickBlock) {
        self.clickBlock(sender.tag-3000);
    }
}


- (void)clickTitleButtonBlock:(ClickTitleButtonBlock)block {
    self.clickBlock = block;
}











@end
