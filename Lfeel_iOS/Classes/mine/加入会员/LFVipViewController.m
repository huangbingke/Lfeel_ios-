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

@property (weak, nonatomic) IBOutlet UIImageView *nvShenImage;


@property (weak, nonatomic) IBOutlet UIImageView *xiannvImage;

@property (weak, nonatomic) IBOutlet UIImageView *doukouImage;

@property (weak, nonatomic) IBOutlet UILabel *nvshenPrice;


@property (weak, nonatomic) IBOutlet UILabel *xiannvPrice;
@property (weak, nonatomic) IBOutlet UILabel *doukouPrice;

@property (weak, nonatomic) IBOutlet UILabel *nvshenTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *xiannvTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *doukouTimeLabel;



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
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self HttpRequestVip];
}

//原年费
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
        [self.nvShenImage setImage:[UIImage imageNamed:@"选择-拷贝-2"]];
        [self.xiannvImage setImage:[UIImage imageNamed:@"椭圆-3-拷贝"]];
        [self.doukouImage setImage:[UIImage imageNamed:@"椭圆-3-拷贝"]];

    }else if (self.index == 1){
        [self.xiannvImage setImage:[UIImage imageNamed:@"选择-拷贝-2"]];
        [self.doukouImage setImage:[UIImage imageNamed:@"椭圆-3-拷贝"]];
        [self.nvShenImage setImage:[UIImage imageNamed:@"椭圆-3-拷贝"]];
    } else {
        [self.xiannvImage setImage:[UIImage imageNamed:@"椭圆-3-拷贝"]];
        [self.doukouImage setImage:[UIImage imageNamed:@"选择-拷贝-2"]];
        [self.nvShenImage setImage:[UIImage imageNamed:@"椭圆-3-拷贝"]];
    }
}
- (IBAction)TapPOPViewVC:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//女神
- (IBAction)nvshenBox:(UIButton *)sender {
    self.index = 0;
    [self TapSelectImg];
    
}
//仙女
- (IBAction)xianNvBox:(UIButton *)sender {
    self.index = 1;
    [self TapSelectImg];
    
}
//豆蔻盒
- (IBAction)doukouBox:(UIButton *)sender {
    self.index = 2;
    [self TapSelectImg];
    
}





-(void)HttpRequestVip{
    NSString *url = @"personal/membershipList1.htm";
    LFParameter * parme = [LFParameter new];
    
    [TSNetworking POSTWithURL:url paramsModel:parme completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowSuccess(request[@"msg"]);
            return ;
        }
        
        self.dataArr =[NSArray yy_modelArrayWithClass:[LFVIpModel class] json:request[@"membershipBeanList"]].copy;
        for (NSDictionary *dic in request[@"membershipBeanList"]) {
            if ([dic[@"membershipName"] isEqualToString:@"女神盒"]) {
                self.nvshenPrice.text = [NSString stringWithFormat:@"¥%@", dic[@"totalPrice"]];
                self.nvshenTimeLabel.text = [NSString stringWithFormat:@"%.2lf万分钟 + 赠送%.2lf万分钟", [dic[@"membership"] floatValue]/10000 - [dic[@"monthPrice"] floatValue]/10000, [dic[@"monthPrice"] floatValue]/10000];
            } else if ([dic[@"membershipName"] isEqualToString:@"仙女盒"]) {
                self.xiannvPrice.text = [NSString stringWithFormat:@"¥%@", dic[@"totalPrice"]];
                self.xiannvTimeLabel.text = [NSString stringWithFormat:@"%.2lf万分钟 + 赠送%.2lf万分钟", [dic[@"membership"] floatValue]/10000 - [dic[@"monthPrice"] floatValue]/10000, [dic[@"monthPrice"] floatValue]/10000];
            } else if ([dic[@"membershipName"] isEqualToString:@"豆蔻盒"]) {
                self.doukouPrice.text = [NSString stringWithFormat:@"¥%@", dic[@"totalPrice"]];
                self.doukouTimeLabel.text = [NSString stringWithFormat:@"%.2lf万分钟 + 赠送%.2lf万分钟", [dic[@"membership"] floatValue]/10000 - [dic[@"monthPrice"] floatValue]/10000, [dic[@"monthPrice"] floatValue]/10000];
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

// 下单
-(void)requestOrderInfo {
//    if (self.orderInfo) {
//        [self _startPay];
//        return;
//    }
    NSLog(@"%ld", self.index);
    
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
