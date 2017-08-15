//
//  TSGlobalTool.m
//  UploadAudio
//
//  Created by Seven on 15/8/29.
//  Copyright (c) 2015年 toocms. All rights reserved.
//

#import "TSGlobalTool.h"

static IndexBlock _indexBlock;
@interface TSGlobalTool () <UIAlertViewDelegate, UIActionSheetDelegate>

@end

@implementation TSGlobalTool

+ (UIAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
              OtherButtonsArray:(NSArray *)otherButtons
                   clickAtIndex:(IndexBlock)indexBlock
{
    _indexBlock = [indexBlock copy];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:self
                                           cancelButtonTitle:cancelButtonTitle
                                           otherButtonTitles:nil, nil];
    
    for (int i = 0; i < otherButtons.count; i++) {
        [alert addButtonWithTitle:otherButtons[i]];
    }
    
    [alert show];
    return alert;
}

#pragma mark - UIAlertView delegate

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_indexBlock) {
        _indexBlock(buttonIndex);
    }
}

+ (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    _indexBlock = nil;
}

#pragma mark - UIActionSheet
+ (UIActionSheet *)actionSheetWithTitle:(NSString *)title
                      cancelButtonTitle:(NSString *)cancelTitle
                 destructiveButtonTitle:(NSString *)desTitle
                      otherButtonTitles:(NSArray *)others
                             showInView:(UIView *)view
                           clickAtIndex:(IndexBlock)indexBlock
{
    _indexBlock = [indexBlock copy];
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:title
                                                        delegate:[self self]
                                               cancelButtonTitle:cancelTitle
                                          destructiveButtonTitle:desTitle
                                               otherButtonTitles:nil, nil];
    
    for (int i = 0; i < others.count; i++) {
        [sheet addButtonWithTitle:others[i]];
    }
    
    [sheet showInView:view];
    return sheet;
}

+ (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_indexBlock) {
        _indexBlock(buttonIndex);
    }
}

+ (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    _indexBlock = nil;
}
@end