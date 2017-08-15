//
//  User.m
//  NBG
//
//  Created by Seven on 16/1/12.
//  Copyright © 2016年 Seven Lv. All rights reserved.
//


#import "BaseViewController.h"

@interface BaseViewController ()
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SetBackgroundGrayColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)TapTextFeildDown{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    [self.view  addGestureRecognizer:tap];
    
}



- (void)tapView {
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)dealloc{
    SLLog2(@"%@-------------------释放了", self);
}

- (NSString *)description {
    return NSStringFromClass([self class]);
}



- (NSString *)timeWithTimeIntervalString:(NSString *)timeString {
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}




- (void)removeUserInfo {
    [User removeUserInfomation];
    [User removeUseDefaultsForKey:KLogin_Info];
    [User removeCenterUserInfomation];
    [User removeUseDefaultsForKey:kVipStatus];
}



- (void)openZCServiceWithProduct:(id)productInfo {
    // 配置参数类
    ZCLibInitInfo *initInfo = [ZCLibInitInfo new];
    initInfo.appKey = @"8266c1ca81574caab451099dda19fcc1";
    // 将配置参数传
    [ZCLibClient getZCLibClient].libInitInfo = initInfo;
    NSString * url =@"personal/userInfo.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.loginKey = user_loginKey;
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        } else {
            NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
            initInfo.userId = dic[@"user_id"];
            initInfo.phone = request[@"phoneMoble"];
            initInfo.nickName = request[@"userName"];
            initInfo.userSex = [request[@"sex"] integerValue] == 1 ? @"男" : @"女";
            // 定义UI参数类
            ZCKitInfo *uiInfo = [ZCKitInfo new];
            if ([productInfo isKindOfClass:[ZCProductInfo class]]) {
                uiInfo.productInfo = productInfo;
            }
            uiInfo.customBannerColor = [UIColor redColor];
            uiInfo.rightChatColor = [UIColor redColor];
            uiInfo.goodSendBtnColor = [UIColor redColor];
            uiInfo.socketStatusButtonBgColor = [UIColor redColor];
            uiInfo.chatRightLinkColor = [UIColor blackColor];
            [IQKeyboardManager sharedManager].enable = NO;
            // 是否自动提醒
            [[ZCLibClient getZCLibClient] setAutoNotification:YES];
            
            [ZCSobot startZCChatView:uiInfo with:self target:nil pageBlock:^(ZCUIChatController *object, ZCPageBlockType type) {
                if (type == ZCPageBlockGoBack) {
                    [IQKeyboardManager sharedManager].enable = YES;
                }
            } messageLinkClick:^(NSString *link) {
                NSLog(@"-----------------%@---------------------", link);
                
                
            }];
        }
    } failBlock:^(NSError *error) {
        SLLog(error);
    }];
}

-(void)HttpRequestCenter:(ZCLibInitInfo *)initInfo {
    NSString * url =@"personal/userInfo.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.loginKey = user_loginKey;
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        } else {
            NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
            initInfo.userId = dic[@"user_id"];
            initInfo.phone = request[@"phoneMoble"];
            initInfo.nickName = request[@"userName"];
            initInfo.userSex = [request[@"sex"] integerValue] == 1 ? @"0" : @"1";
            initInfo.customInfo = @{@"体重": request[@"weight"], @"尺寸": request[@"size"]};
        }
    } failBlock:^(NSError *error) {
        SLLog(error);
    }];
}



#pragma mark --提示框
- (void)showAlertViewWithTitle:(NSString *)title {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:sureAction];
    [self presentViewController:alertC animated:YES completion:nil];
    
}



@end
