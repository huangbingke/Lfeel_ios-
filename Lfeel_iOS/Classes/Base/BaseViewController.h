//
//  User.m
//  NBG
//
//  Created by Seven on 16/1/12.
//  Copyright © 2016年 Seven Lv. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RACDisposable;
@interface BaseViewController : UIViewController
@property (nonatomic,   copy) void(^vBlock)();

///  用来存放RAC销毁对象（需要在deallco里面统一销毁）
@property (nonatomic, strong) NSMutableArray <RACDisposable *> * disposables;

- (void)TapTextFeildDown;


//时间戳转化为时间NSDate
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString;


- (void)removeUserInfo;


- (void)openZCServiceWithProduct:(id)productInfo;


//提示框
- (void)showAlertViewWithTitle:(NSString *)title;


- (void)showAlertViewWithTitle:(NSString *)title yesHandler:(void (^ __nullable)(UIAlertAction *action))yesHandler noHandler:(void (^ __nullable)(UIAlertAction * _Nullable action))noHandler;

@end
