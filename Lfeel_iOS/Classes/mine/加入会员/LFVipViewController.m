//
//  LFVipViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/4.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFVipViewController.h"
#import "LFPayHelper.h"
#import "LFSettleCenterVC.h"
#import "LFSettleCenterView.h"
#import "LFPayResultVC.h"
#import "LFLeiBaiPayVC.h"

@interface LFVipViewController()

@property (weak, nonatomic) IBOutlet UIImageView *Yearimge;


@property (weak, nonatomic) IBOutlet UIImageView *monthImage;


@property (weak, nonatomic) IBOutlet UILabel *yearPrice;


@property (weak, nonatomic) IBOutlet UILabel *mouthPrice;

@property (weak, nonatomic) IBOutlet UILabel *allYearPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *allMouthPriceLabel;




@property (nonatomic, strong) NSArray * dataArr;
@property (nonatomic,   copy) NSDictionary  * orderInfo;
@property (nonatomic, assign) NSInteger payType;
@property (nonatomic, assign) NSInteger index;
@end


@implementation LFVipViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.index = 0;
    self.payType = -1; // 默认支付方式为空
    [self HttpRequestVip];
    
}

- (IBAction)TapYearBtn:(id)sender {
    SLLog2(@"年");
    self.index = 0;
    [self TapSelectImg];
    
}

- (IBAction)TapMonth:(id)sender {
    SLLog2(@"月份");
    self.index = 1;
    [self TapSelectImg];
}


-(void)TapSelectImg{
    if (self.index ==0) {
        
        [self.Yearimge setImage:[UIImage imageNamed:@"选择-拷贝-2"]];
        [self.monthImage setImage:[UIImage imageNamed:@"椭圆-3-拷贝"]];
    }else{
        [self.monthImage setImage:[UIImage imageNamed:@"选择-拷贝-2"]];
        [self.Yearimge setImage:[UIImage imageNamed:@"椭圆-3-拷贝"]];
    }
}
- (IBAction)TapPOPViewVC:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}




-(void)HttpRequestVip{
    NSString *url = @"personal/membershipList.htm";
    LFParameter * parme = [LFParameter new];
    
    [TSNetworking POSTWithURL:url paramsModel:parme completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowSuccess(request[@"msg"]);
            return ;
        }
        
        self.dataArr =[NSArray yy_modelArrayWithClass:[LFVIpModel class] json:request[@"membershipBeanList"]].copy;
        for (NSDictionary *dic in request[@"membershipBeanList"]) {
            if ([dic[@"membershipName"] isEqualToString:@"年费"]) {
                self.yearPrice.text = [NSString stringWithFormat:@"¥%@/月", dic[@"monthPrice"]];
                self.allYearPriceLabel.text = [NSString stringWithFormat:@"¥%ld = ¥%@/月 * 12个月", [dic[@"totalPrice"] integerValue], dic[@"monthPrice"]];
            } else {
                self.mouthPrice.text = [NSString stringWithFormat:@"¥%@/月", dic[@"monthPrice"]];
                self.allMouthPriceLabel.text = [NSString stringWithFormat:@"¥%ld = ¥%@/月 * 6个月", [dic[@"totalPrice"] integerValue], dic[@"monthPrice"]];
            }
        }
        
        
    } failBlock:^(NSError *error) {
        
    }];

}

- (IBAction)TapSubmitBtn:(id)sender {
    SLLog2(@"立即购买");
    
    @weakify(self);
    
    [LFSettleCenterSelectPayTypeView showWithCompleteHandle:^(PayType payType) {
        @strongify(self);
        self.payType = payType;
        [self requestOrderInfo];
        
  } selectedType:self.payType];
    
}

/// 下单
-(void)requestOrderInfo {
    
    if (self.orderInfo) {
        [self _startPay];
        return;
    }
    
    if (self.dataArr.count > 0) {
        
      LFVIpModel * model = self.dataArr[self.index];
        
        NSString * url =@"personal/immediately.htm?";
        
        LFParameter *paeme = [LFParameter new];
        paeme.goodsId = model.goodsId;
        paeme.loginKey = user_loginKey;
        NSArray * arr = @[@"4", @"1", @"2", @"3"];
        paeme.payType = arr[self.payType];
     
        [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
            SLLog(request);
            if ([request[@"result"] integerValue]!= 200) {
                SVShowError(request[@"msg"]);
                return ;
            }
            self.orderInfo = [request copy];
            [self _startPay];
            
        } failBlock:^(NSError *error) {
            SLLog(error);
            SLShowNetworkFail;
        }];
    }
}

/// 开始支付
-(void)_startPay {
    NSDictionary * dict = self.orderInfo;
    
    if (self.payType == 0) {
        
        NSString * price = stringWithDoubleAndDecimalCount([dict[@"totalPrice"] doubleValue] * 100, 0);
        if ([price doubleValue] < 600) {
            SVShowError(@"分期最小金额为600"); return;
        }
        
        LFLeiBaiPayVC * controller = [[LFLeiBaiPayVC alloc] init];
        LFPayModel * model = [LFPayModel new];
        model.order_id = dict[@"orderId"];
        model.price = price;
        model.order_sn = dict[@"orderCode"];
        model.bankCardList = [NSArray yy_modelArrayWithClass:[LFCardInfo class] json:dict[@"bankCardList"]].copy;
        controller.payModel = model;
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    @weakify(self);
    NSString * priceFen = stringWithInteger([dict[@"totalPrice"] doubleValue] * 100);
    [LFPayHelper payWithType:self.payType price:priceFen orderNum:dict[@"orderCode"] showInViewController:self completionHandle:^(BOOL success, NSString *msg) {
        @strongify(self);
 
        LFPayResultVC * controller = [[LFPayResultVC alloc] init];
        controller.success = success;
        controller.orderInfo = dict;
        controller.showShortTitle = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
        if (!success) return ;
        
        NSMutableArray * vcs = self.navigationController.viewControllers.mutableCopy;
        for (int i = 0; i < vcs.count; i++) {
            UIViewController * vc = vcs[i];
            if ([vc isKindOfClass:[LFSettleCenterVC class]]) {
                [vcs removeObject:vc];
                break;
            }
        }
        self.navigationController.viewControllers = [vcs copy];
        BaseNavigationController * nav = (BaseNavigationController *)self.navigationController;
        [nav.screenShotArray removeLastObject];
        AppDelegate *app = [AppDelegate sharedDelegate];
        app.screenShotView.imageView.image = nav.screenShotArray.lastObject;
    }];
 
}

@end
