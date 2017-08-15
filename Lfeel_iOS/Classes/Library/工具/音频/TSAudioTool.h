//
//  TSAudioTool.h
//  UploadAudio
//
//  Created by Seven on 15/8/29.
//  Copyright (c) 2015年 toocms. All rights reserved.
//  处理系统相册业务

#import <UIKit/UIKit.h>

typedef void (^ImageCompleteBlock) (UIImage *image, NSError *error);
@interface TSAudioTool : NSObject

/**
 *  将bundle中的视频文件保存到系统相册
 *
 *  @param videoName 文件名(需要加拓展名)
 *  @param success   回调
 */
+ (void)saveVideoToPhotoAlbum:(NSString *)videoName
                     complete:(void (^)(NSURL *assetURL, NSError *error))success;
/**
 *  将图片保存至系统相册
 *
 *  @param image      图片
 *  @param imageBlock 回调
 */
+ (void)savePhotoToPhotoAlbum:(UIImage *)image
                     complete:(ImageCompleteBlock)imageBlock;

/// 录音
- (void)beginRecord;

/// 结束录音
- (void)stopRecord;

/// 播放录音
- (void)playRecording;
@end
