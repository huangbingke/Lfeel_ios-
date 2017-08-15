//
//  SLAlertView.h
//  AlertView
//
//  Created by Seven on 15/10/10.
//  Copyright (c) 2015年 Seven Lv. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^IndexBlock)(NSInteger buttonIndex);


@interface SLAlertView : UIView

/// 弹框
///
/// @param title     标题
/// @param cancelbtn 取消按钮
/// @param des       破坏性按钮
/// @param array     其它按钮
/// @param click     按钮点击事件(buttonIndex从上到下为0.1.2....,取消按钮没有索引)
+ (void)alertViewWithTitle:(NSString *)title cancelBtn:(NSString *)cancelbtn destructiveButton:(NSString *)des otherButtons:(NSArray *)array clickAtIndex:(void (^)(NSInteger buttonIndex))click;
@end


@interface UIAlertView (add)
/**
 *  用block方式封装UIAlertView
 *
 *  @param title             标题
 *  @param messge            信息
 *  @param cancleButtonTitle 取消按钮
 *  @param otherButtons      其它按钮
 *  @param clickAtIndex      回调block，返回点击了第几个按钮
 */
+ (UIAlertView *)alertWithTitle:(NSString*)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
              OtherButtonsArray:(NSArray * )otherButtons
                   clickAtIndex:(IndexBlock)indexBlock;
@end


@interface UIActionSheet (add)

/**
 *  用block方式封装UIActionSheet
 *
 *  @param title        标题
 *  @param cancelTitle  取消按钮
 *  @param desTitle     毁灭性按钮
 *  @param others       其它按钮
 *  @param clickAtIndex 回调block，返回点击了第几个按钮
 */
+ (UIActionSheet *)actionSheetWithTitle:(NSString *)title
                      cancelButtonTitle:(NSString *)cancelTitle
                 destructiveButtonTitle:(NSString *)desTitle
                      otherButtonTitles:(NSArray *)others
                             showInView:(UIView *)view
                           clickAtIndex:(IndexBlock)indexBlock;
@end