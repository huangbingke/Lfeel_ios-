//
//  LFSexView.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/14.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFSexView : UIView

@property (nonatomic,   copy) void(^didTapSelectBtn)(NSInteger index);

@property (nonatomic,   copy) void(^didTapCloseBtn)();

@property (nonatomic,   copy) NSString * selectedSex;
@end
