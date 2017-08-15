//
//  User.m
//  NBG
//
//  Created by Seven on 16/1/12.
//  Copyright © 2016年 Seven Lv. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController

@property (nonatomic, strong) NSMutableArray * screenShotArray;

///  手势的可用性// default is YES
@property (nonatomic, assign, getter=isGestureRecognizerEnabled) BOOL gestureRecognizerEnabled;
@end
