//
//  TSNetworking.h
//  TSNetworking
//
//  Created by Seven Lv on 15/12/22.
//  Copyright © 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPSessionManager.h"

/// 基础URL
UIKIT_EXTERN NSString * const kAPIBaseURL;

///  基础模型
@interface SLBaseModel : NSObject
@property (nonatomic,   copy) NSString * flag;
@property (nonatomic,   copy) NSString * message;
@property (nonatomic, strong) id data;
@end

/// 将AFHTTPSessionManager封装成单例
@interface TSHTTPSessionManager : AFHTTPSessionManager

/// 获取单例对象
+ (instancetype)sharedManager;
@end

@interface TSNetworking : NSObject


/**
 *  获取文件的mineType（文件需要在mainBundle中）
 *  @param fileName 文件名（含拓展名）
 */
+ (NSString *)getFileMineType:(NSString *)fileName;



/**
 *  用模型包装参数发送get请求
 */
+ (void)GETWithURL:(NSString *)urlString
       paramsModel:(id)params
     completeBlock:(void(^)(NSDictionary * request))success
         failBlock:(void(^)(NSError * error))failure;

/**
 *  用模型包装参数发送post请求
 */
+ (void)POSTWithURL:(NSString *)urlString
        paramsModel:(id)params
      completeBlock:(void(^)(NSDictionary * request))success
          failBlock:(void(^)(NSError * error))failure;

/**
 *  用模型包装参数上传图片
 */
+ (void)POSTImageWithURL:(NSString *)urlString
             paramsModel:(id)params
                   image:(UIImage *)image
              imageParam:(NSString *)imageParam
           completeBlock:(void(^)(NSDictionary * request))success
               failBlock:(void(^)(NSError * error))failure;

/// 用模型包装参数上传多张图片
+ (void)POSTImagesWithURL:(NSString *)urlString
              paramsModel:(id)params
                   images:(NSArray<UIImage *> *)images
              imageParams:(NSArray<NSString *> *)imageParams
            completeBlock:(void(^)(NSDictionary * request))success
                failBlock:(void(^)(NSError * error))failure;


/**
 *  用模型包装参数发送get请求
 */
+ (void)GETWithURL:(NSString *)urlString
       paramsModel:(id)params
   needProgressHUD:(BOOL)isNeed
     completeBlock:(void(^)(NSDictionary * request))success
         failBlock:(void(^)(NSError * error))failure;

/**
 *  用模型包装参数发送post请求
 */
+ (void)POSTWithURL:(NSString *)urlString
        paramsModel:(id)params
    needProgressHUD:(BOOL)isNeed
      completeBlock:(void(^)(NSDictionary * request))success
          failBlock:(void(^)(NSError * error))failure;

FOUNDATION_EXTERN NSString *getfileNameWithIndex(int index);
@end
