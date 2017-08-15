//
//  LHScrollView.h
//  LFeelAPP
//
//  Created by 黄冰珂 on 2017/6/16.
//  Copyright © 2017年 黄冰珂. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHScrollView : UIScrollView



/*
 多张图片, 一张一张翻页
 */
- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray;





/*
 一张图片, 不是整张翻页
 */
- (instancetype)initWithFrame:(CGRect)frame imageRadio:(CGFloat)imageRadio imageName:(NSString *)imageName;



















@end
