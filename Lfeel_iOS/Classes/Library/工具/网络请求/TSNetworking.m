//
//  TSNetworking.m
//  TSNetworking
//
//  Created by Seven Lv on 15/12/22.
//  Copyright © 2015年 Seven. All rights reserved.
//

#import "TSNetworking.h"
#import "UIImage+Compress.h"
#import "LFLoginViewController.h"
//NSString * const kAPIBaseURL = @"http://120.76.215.11:8081/leHuiShop/";//服务器 .  测试环境
//NSString * const kAPIBaseURL = @"http://120.76.215.11:8020/leHuiShop/";//服务器,   上线环境

//NSString * const kAPIBaseURL = @"http://lfeeltest.ngrok.cc/shopping/";//本地

NSString * const kAPIBaseURL = @"http://120.76.215.11:83/leHuiShop/";//服务器,   上线环境. 自动分发



@implementation SLBaseModel

@end
static TSHTTPSessionManager *_manager = nil;
@implementation TSHTTPSessionManager

+ (instancetype)sharedManager {
    if (_manager == nil) {
        _manager = [[self alloc] init];
    }
    return _manager;
}


- (instancetype)init {
    return [super initWithBaseURL:[NSURL URLWithString:kAPIBaseURL]
             sessionConfiguration:nil];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [super allocWithZone:zone];
    });
    return _manager;
}

@end

@implementation TSNetworking
#pragma mark - Public

/**
 *  获取文件的mineType（文件需要在mainBundle中）
 *
 *  @param fileName 文件名（含拓展名）
 */
+ (NSString *)getFileMineType:(NSString *)fileName {
    
    NSURL * url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    __block NSURLResponse * res = nil;
    [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        res = response;
    }];
    
    return res.MIMEType;
}

+ (void)GETWithURL:(NSString *)urlString
       paramsModel:(id)params
     completeBlock:(void(^)(NSDictionary * request))success
         failBlock:(void (^)(NSError *))failure {
    
    [self GETWithURL:urlString paramsModel:params needProgressHUD:YES completeBlock:success failBlock:failure];
}

+ (void)POSTWithURL:(NSString *)urlString
        paramsModel:(id)params
      completeBlock:(void(^)(NSDictionary * request))success
          failBlock:(void (^)(NSError *))failure {
    
    [self POSTWithURL:urlString paramsModel:params needProgressHUD:YES completeBlock:success failBlock:failure];
}


+ (void)GETWithURL:(NSString *)urlString paramsModel:(id)params needProgressHUD:(BOOL)isNeed completeBlock:(void (^)(NSDictionary *))success failBlock:(void (^)(NSError *))failure {
    
    TSHTTPSessionManager * manager = [TSHTTPSessionManager sharedManager];

    MBProgressHUD * hud = nil;
    if (isNeed) {
        hud = [MBProgressHUD showMessage:nil];
    }
    
    NSDictionary * p = nil;
    if ([params isKindOfClass:[NSDictionary class]]) {
        p = params;
    } else {
        p = [params yy_modelToJSONObject];
    }
    if (![urlString hasSuffix:@"?"]) {
        urlString = [urlString stringByAppendingString:@"?"];
    }
#if DEBUG
    _printParameter(p, urlString);
#endif
    [manager GET:urlString parameters:p progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (hud != nil) [hud removeFromSuperview];
        if (_checkLoginstatus(responseObject)) return ;
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (hud != nil) [hud removeFromSuperview];
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)POSTWithURL:(NSString *)urlString paramsModel:(id)params needProgressHUD:(BOOL)isNeed completeBlock:(void (^)(NSDictionary *))success failBlock:(void (^)(NSError *))failure {
    TSHTTPSessionManager * manager = [TSHTTPSessionManager sharedManager];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
        MBProgressHUD * hud = nil;
        if (isNeed) {
            hud = [MBProgressHUD showMessage:nil];
        }

    
    NSDictionary * p = nil;
    if ([params isKindOfClass:[NSDictionary class]]) {
        p = params;
    } else {
        p = [params yy_modelToJSONObject];
    }
    if (![urlString hasSuffix:@"?"]) {
        urlString = [urlString stringByAppendingString:@"?"];
    }
    
    
#if DEBUG
    _printParameter(p, urlString);
#endif
    [manager POST:urlString parameters:p progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (hud != nil) [hud removeFromSuperview];
        if (_checkLoginstatus(responseObject)) return ;
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (hud != nil) [hud removeFromSuperview];
        if (failure) {
            failure(error);
        }
    }];
    
}


///  post传图片，带hud
+ (void)POSTImageWithURL:(NSString *)urlString
             paramsModel:(id)params
                   image:(UIImage *)image
              imageParam:(NSString *)imageParam
           completeBlock:(void(^)(NSDictionary * request))success
               failBlock:(void (^)(NSError *))failure {
    NSParameterAssert(image);
    NSParameterAssert(imageParam);
    [self POSTImagesWithURL:urlString paramsModel:params images:@[image] imageParams:@[imageParam] completeBlock:success failBlock:failure];
    
}

#pragma clang diagnostic pop
+ (void)POSTImagesWithURL:(NSString *)urlString
              paramsModel:(id)params
                   images:(NSArray<UIImage *> *)images
              imageParams:(NSArray<NSString *> *)imageParams
            completeBlock:(void(^)(NSDictionary * request))success
                failBlock:(void(^)(NSError * error))failure {
    
    TSHTTPSessionManager * manager = [TSHTTPSessionManager sharedManager];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];

    NSDictionary * p = nil;
    if ([params isKindOfClass:[NSDictionary class]]) {
        p = params;
    } else {
        p = [params yy_modelToJSONObject];
    }
    if (![urlString hasSuffix:@"?"]) {
        urlString = [urlString stringByAppendingString:@"?"];
    }
#if DEBUG
    _printParameter(p, urlString);
#endif
    
    MBProgressHUD * hud = [MBProgressHUD showMessage:nil];
    [manager POST:urlString parameters:p constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSInteger i = 0;
        for (UIImage * image in images) {
            // 文件二进制数据
            NSData * data = [image compressToData];
            SLLog2(@"%zdKB", data.length / 1024);
            // 文件名
            NSString * fileName = [self getfileNameWithIndex:i];
            
            [formData appendPartWithFileData:data name:imageParams[i] fileName:fileName mimeType:@"image/jpeg"];
            i++;
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud removeFromSuperview];
        if (_checkLoginstatus(responseObject)) return ;
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud removeFromSuperview];
        if (failure) {
            failure(error);
        }
    }];
    
}

#pragma clang diagnostic pop

#pragma mark - Private
static BOOL _isShowing = NO;
static BOOL _checkLoginstatus (NSDictionary *dict) {
    if ([dict[@"result"] integerValue] == 204) {
        [User removeUserInfomation];
        [User removeUseDefaultsForKey:KLogin_Info];
        [User removeCenterUserInfomation];
        [User removeUseDefaultsForKey:kVipStatus];
        if (_isShowing) return YES;
        _isShowing = YES;
        [UIAlertView alertWithTitle:@"提示" message:@"登录过期，请重新登录" cancelButtonTitle:nil OtherButtonsArray:@[@"确定"] clickAtIndex:^(NSInteger buttonIndex) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                LFLoginViewController * vc = [LFLoginViewController new];
                vc.needPopToRootVC = YES;
                BaseNavigationController * b = [[BaseNavigationController alloc] initWithRootViewController:vc];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:b animated:YES completion:^{
                    
                    UITabBarController * tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                    UINavigationController * nav = (UINavigationController *)tabbar.selectedViewController;
                    [nav popToRootViewControllerAnimated:NO];
                    tabbar.selectedIndex = 0;
                }];
                _isShowing = NO;
                
            });
        }];
        return YES;
    }
    return NO;
}

/**
 *  产生图片名字
 */
+ (NSString *)getfileNameWithIndex:(int)index
{
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyyMMddHHmmss";
    NSString * date = [format stringFromDate:[NSDate date]];
    return [date stringByAppendingFormat:@"%@%d.jpg",date, index];
}

NSString *getfileNameWithIndex(int index) {
    return [TSNetworking getfileNameWithIndex:index];
}

static void _printParameter(NSDictionary * p, NSString * urlString) {
    NSString * string = [NSString stringWithFormat:@"请求参数：\n%@\nURL: ", p];
    NSString * u = [NSString stringWithFormat:@"%@%@", kAPIBaseURL, urlString];
    NSMutableString * str = [NSMutableString string];
    [str appendString:string];
    [str appendString:u];
    [p enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [str appendFormat:@"%@=%@&", key, obj];
    }];
    
    if ([str hasSuffix:@"&"]) {
        [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
    }
    u = [NSString stringWithFormat:@"🎈%s 第 %d 行📍\n%@\n\n", __func__, __LINE__, str];
    printf("%s", u.UTF8String);
}
@end
