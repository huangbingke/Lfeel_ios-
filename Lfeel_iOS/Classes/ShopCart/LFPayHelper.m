//
//  LFPayHelper.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/19.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFPayHelper.h"
#import "BCPayReq.h"
#import "BeeCloud.h"

static void(^_completion)(BOOL success, NSString *msg);

@implementation LFPayHelper

+ (void)payWithType:(PayType)type price:(NSString *)priceFen orderNum:(NSString *)no showInViewController:(UIViewController *)vc completionHandle:(void (^)(BOOL, NSString *))com {
    
    [BeeCloud setBeeCloudDelegate:[self self]];
    _completion = com;
    
    NSString *billno = no;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value",@"key", nil];
    /**
     按住键盘上的option键，点击参数名称，可以查看参数说明
     **/
    BCPayReq *payReq = [[BCPayReq alloc] init];
    /**
     *  支付渠道，PayChannelWxApp,PayChannelAliApp,PayChannelUnApp,PayChannelBaiduApp
     */
    NSInteger types[] = {0, PayChannelAliApp, PayChannelWxApp, PayChannelUnApp};
    payReq.channel = types[type]; //支付渠道
    if (payReq.channel == 0) {
//        SVShowError(@"暂时未开通");
        return;
    }
    payReq.title = @"乐荟订单";//订单标题
    payReq.totalFee = priceFen;//订单价格; channel为BC_APP的时候最小值为100，即1元
    
    payReq.billNo = billno;//商户自定义订单号
    payReq.scheme = @"lfeelios";//URL Scheme,在Info.plist中配置; 支付宝,银联必有参数
    payReq.billTimeOut = 300;//订单超时时间
    payReq.viewController = vc; //银联支付和Sandbox环境必填
    payReq.cardType = 0; //0 表示不区分卡类型；1 表示只支持借记卡；2 表示支持信用卡；默认为0
    payReq.optional = dict;//商户业务扩展参数，会在webhook回调时返回
    
//    NSLog(@"%ld-----%@-----%@------%@-------%@-------%ld", payReq.channel, payReq.optional, payReq.totalFee, payReq.billNo, payReq.viewController, type);
    
    [BeeCloud sendBCReq:payReq];

}

+ (void)onBeeCloudResp:(BCBaseResp *)resp {
    
    switch (resp.type) {
        case BCObjsTypePayResp:
        {
            // 支付请求响应
            BCPayResp *tempResp = (BCPayResp *)resp;
            if (tempResp.resultCode == 0) {
                //微信、支付宝、银联支付成功
//                [self showAlertView:resp.resultMsg];
                BLOCK_SAFE_RUN(_completion, YES, resp.resultMsg);
            } else {
                //支付取消或者支付失败
//                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];
                BLOCK_SAFE_RUN(_completion, NO, resp.resultMsg);
            }
        }
            break;
            
        default:
        {
            if (resp.resultCode == 0) {
                [self showAlertView:resp.resultMsg];
            } else {
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",resp.resultMsg, resp.errDetail]];
            }
        }
            break;
    }
}

+ (void)showAlertView:(NSString *)msg {
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
@end
