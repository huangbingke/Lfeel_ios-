//
//  SLImagePickerController.m
//  DaChengWaiMai
//
//  Created by Seven Lv on 16/4/23.
//  Copyright © 2016年 Seven Lv. All rights reserved.
//

#import "SLImagePickerController.h"
#import "SLAlertView.h"


@interface SLImagePickerController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

static void (^_imageBlock)(UIImage *) = nil;
static BOOL _allowEdit = NO;

@implementation SLImagePickerController

+ (void)showInViewController:(UIViewController *)vc libraryType:(SLImagePickerMediaType)media allowEdit:(BOOL)edit complete:(void (^)(UIImage *))complete {
    
    _imageBlock = [complete copy];
    _allowEdit = edit;
    
    if (media & SLImagePickerCameraType) {
#if TARGET_IPHONE_SIMULATOR // 模拟器
        NSLog(@"模拟器不支持");
#elif TARGET_OS_IPHONE      // 真机
        [self _excute:UIImagePickerControllerSourceTypeCamera vc:vc];
#endif
    } else if (media & SLImagePickerPhotoLibraryType) {
        [self _excute:UIImagePickerControllerSourceTypePhotoLibrary vc:vc];
    } else  {
        [SLAlertView alertViewWithTitle:nil cancelBtn:@"取消" destructiveButton:nil otherButtons:@[@"拍照", @"从本地相册选择"] clickAtIndex:^(NSInteger buttonIndex) {
            
            UIImagePickerControllerSourceType sourceType;
            if (buttonIndex == 0) {
#if TARGET_IPHONE_SIMULATOR // 模拟器
                NSLog(@"模拟器不支持");return ;
#elif TARGET_OS_IPHONE      // 真机
                sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
            } else if (buttonIndex == 1) {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            
            [self _excute:sourceType vc:vc];
        }];
        
    }
}

+ (void)_excute:(UIImagePickerControllerSourceType)type vc:(UIViewController *)vc{
    UIImagePickerController *pickerCtrl = [[UIImagePickerController alloc] init];
    pickerCtrl.allowsEditing = _allowEdit;
    pickerCtrl.sourceType = type;
    pickerCtrl.delegate = [self self];
    [vc presentViewController:pickerCtrl animated:YES completion:nil];
}

#pragma mark - 代理

+ (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = nil;
    if (!_allowEdit) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    } else {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    !_imageBlock ? : _imageBlock(image);
    _allowEdit = NO;
    _imageBlock = nil;
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


+ (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    _allowEdit = NO;
    _imageBlock = nil;
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    SLLog(self);
}
@end
