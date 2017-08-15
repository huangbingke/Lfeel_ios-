//
//  SLImagePickerController.h
//  DaChengWaiMai
//
//  Created by Seven Lv on 16/4/23.
//  Copyright © 2016年 Seven Lv. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, SLImagePickerMediaType) {
    SLImagePickerCameraType = 1 << 0,
    SLImagePickerPhotoLibraryType = 1 << 1
};

@interface SLImagePickerController : NSObject

///  弹出相机或相册
///
///  @param vc          由哪个控制器modal出来
///  @param libraryType 相机或相册类型，传单个或多个，传‘0’两个都选
///  @param edit        是否需要裁剪
///  @param complete    回调
+ (void)showInViewController:(UIViewController *)vc
                 libraryType:(SLImagePickerMediaType)libraryType
                   allowEdit:(BOOL)edit
                    complete:(void(^)(UIImage *image))complete;
@end