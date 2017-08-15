//
//  TSGlobalTool.h
//  UploadAudio
//
//  Created by Seven on 15/8/29.
//  Copyright (c) 2015年 toocms. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^IndexBlock)(NSInteger buttonIndex);

@interface TSGlobalTool : NSObject

/**
 *  用block方式封装UIAlertView
 *
 *  @param title             标题
 *  @param messge            信息
 *  @param cancleButtonTitle 取消按钮
 *  @param otherButtons      其它按钮
 *  @param clickAtIndex      回调block，返回点击了第几个按钮
 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
+(UIAlertView *)alertWithTitle:(NSString*)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
             OtherButtonsArray:(NSArray*)otherButtons
                  clickAtIndex:(IndexBlock)indexBlock;

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

#pragma clang diagnostic pop
@end
