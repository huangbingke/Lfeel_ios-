//
//  TSAudioTool.m
//  UploadAudio
//
//  Created by Seven on 15/8/29.
//  Copyright (c) 2015年 toocms. All rights reserved.
//  处理系统相册业务

#import "TSAudioTool.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudioKit/CoreAudioKit.h>

int recordEncoding;
enum
{
    ENC_AAC = 1,
    ENC_ALAC = 2,
    ENC_IMA4 = 3,
    ENC_ILBC = 4,
    ENC_ULAW = 5,
    ENC_PCM = 6,
} encodingTypes;
static ImageCompleteBlock completeBlock;

@interface TSAudioTool () <AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioRecorder * recorder;
@property (nonatomic, strong) AVAudioPlayer * player;
@end

@implementation TSAudioTool

/// 录音
- (void)beginRecord {
    // Init audio with record capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
    if(recordEncoding == ENC_PCM)
    {
        [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    }
    else
    {
        NSNumber *formatObject;
//        std::string strPath = cocos2d::CCFileUtils::getInstance()->getWritablePath();
        switch (recordEncoding) {
            case (ENC_AAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
                break;
            case (ENC_ALAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleLossless];
                break;
            case (ENC_IMA4):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
                break;
            case (ENC_ILBC):
                formatObject = [NSNumber numberWithInt: kAudioFormatiLBC];
                break;
            case (ENC_ULAW):
                formatObject = [NSNumber numberWithInt: kAudioFormatULaw];
                break;
            default:
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
        }
    
        [recordSettings setObject:formatObject forKey: AVFormatIDKey];//ID
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];//采样率
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];//通道的数目,1单声道,2立体声
        [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];//解码率
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];//采样位
        [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityLow] forKey: AVEncoderAudioQualityKey];
    }
    
//    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.AAC", [[NSBundle mainBundle] resourcePath]]];

    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recordTest.AAC"];
    NSURL * url2 = [NSURL fileURLWithPath:path];
    
    NSError *error = nil;
    self.recorder = [[ AVAudioRecorder alloc] initWithURL:url2 settings:recordSettings error:&error];
    if (error) {
        SLLog(error.localizedDescription);
    }
    if ([self.recorder prepareToRecord] == YES){
    }
    
    [self.recorder record];
}

- (void)stopRecord
{
    [self.recorder stop];
}

/// 播放录音
- (void)playRecording {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recordTest.AAC"];
    NSURL * url2 = [NSURL fileURLWithPath:path];
    NSError *error;
    NSData * data = [NSData dataWithContentsOfURL:url2];
    self.player = [[AVAudioPlayer alloc] initWithData:data error:&error];
    SLLog(error);
    self.player.numberOfLoops = 0;
    [self.player play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    SLLog(@"播放完毕");
}

+ (void)saveVideoToPhotoAlbum:(NSString *)videoName complete:(void (^)(NSURL *assetURL, NSError *error))success
{
    
    ALAssetsLibrary * lib = [[ALAssetsLibrary alloc] init];
    [lib writeVideoAtPathToSavedPhotosAlbum:[[NSBundle mainBundle] URLForResource:videoName withExtension:nil] completionBlock:^(NSURL *assetURL, NSError *error)
    {
        if (success) {
            success(assetURL, error);
        }
    }];
    
}

+ (void)savePhotoToPhotoAlbum:(UIImage *)image complete:(ImageCompleteBlock)imageBlock
{
    completeBlock = [imageBlock copy];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (completeBlock) {
        completeBlock(image, error);
        completeBlock = nil;
    }
}
@end