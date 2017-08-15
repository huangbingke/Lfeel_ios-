//
//  SLFullScreenHud.m
//  TKLMerchant
//
//  Created by Seven Lv on 16/11/15.
//  Copyright © 2016年 Seven Lv. All rights reserved.
//

#import "SLFullScreenHud.h"

@implementation SLFullScreenHud

+ (instancetype)showWithTitles:(NSArray<NSString *> *)titles didClickAtIndex:(void (^)(NSInteger))block {
    SLFullScreenHud * hud = [[SLFullScreenHud alloc] initWithFrame:[UIScreen mainScreen].bounds];
    hud.backgroundColor = RGBColor2(0, 0, 0, 0.3);
    CGFloat h = 44;
    UIView * container = [UIView viewWithBgColor:[UIColor whiteColor] frame:Rect(Fit414(57), 0, kScreenWidth - Fit414(114), h * titles.count)];
    
    for (int i = 0; i < titles.count; i++) {
        UIButton * btn = [UIButton buttonWithTitle:titles[i] titleColor:HexColorInt32_t(000000) backgroundColor:nil font:Fit414(14) image:nil frame:Rect(0, i * h, container.width, h)];
        [container addSubview:btn];
        if (i != titles.count - 1) {
            SLDevider * d = [[SLDevider alloc] initWithFrame:Rect(0, btn.maxY - 1, btn.width, 1)];
            [container addSubview:d];
        }
        btn.tag = i;
        @weakify(hud);
        [[btn rac_signalForControlEvents:64] subscribeNext:^(UIButton * x) {
            @strongify(hud);
            BLOCK_SAFE_RUN(block, x.tag);
            [hud removeFromSuperview];
        }];
    }
    container.centerY = kHalfScreenHeight - 30;
    [hud addSubview:container];
    container.cornerRadius = 3;
    
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    UITapGestureRecognizer * tap = [UITapGestureRecognizer new];
    @weakify(hud);
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(hud);
        [hud removeFromSuperview];
    }];
    [hud addGestureRecognizer:tap];
    return hud;
}

- (void)dealloc {
    SLLog(self);
}

@end
