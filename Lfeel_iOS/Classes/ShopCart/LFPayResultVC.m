//
//  LFPayResultVC.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/5.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFPayResultVC.h"
#import "AppDelegate.h"

@interface LFPayResultVC ()
//<UITableViewDelegate, UITableViewDataSource>
//@property (nonatomic,   weak) UITableView * tableView;

///  支付失败view
@property (nonatomic, strong) UIView * failView;
///  支付成功view
@property (nonatomic, strong) UIView * successView;

@end

@implementation LFPayResultVC

#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    
    [self setupNavigationBar];
    
    MainViewController * main = (MainViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    BaseNavigationController * base = (BaseNavigationController *)main.selectedViewController;
    base.gestureRecognizerEnabled = NO;
    
    

    
}

- (void)dealloc {
    
    MainViewController * main = (MainViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    BaseNavigationController * base = (BaseNavigationController *)main.selectedViewController;
    base.gestureRecognizerEnabled = YES;
}

///  初始化子控件
- (void)setupSubViews {
    if (self.success) {
        [self requestIsVipData];
        [self.view addSubview:self.successView];
    } else {
        [self.view addSubview:self.failView];
    }
}

///  设置自定义导航条
- (void)setupNavigationBar {
    @weakify(self);
    NSString * title = @"支付结果";
    self.ts_navgationBar = [TSNavigationBar navWithTitle:title backAction:^{
        @strongify(self);
        [self _popVC];
    }];
}

- (void)_popVC {
    
    @try {
        UIViewController * vc = self.navigationController.viewControllers.firstObject;
        if ([vc isKindOfClass:NSClassFromString(@"SLOrdersVC")]) {
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } @catch (NSException *exception) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } @finally {
    }
}

#pragma mark - Actions


#pragma mark - Networking


#pragma mark - Delegate

#pragma mark - Private


#pragma mark - Public

///personal/isVip.htm？user_id=

//充值成功   记录一下是否是会员的状态, 好在其他页面判断
- (void)requestIsVipData {
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    LFParameter *param = [[LFParameter alloc] init];
    param.user_id = dic[@"user_id"];
    [TSNetworking POSTWithURL:@"personal/isVip.htm?" paramsModel:param completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] == 200) {
            [User removeUseDefaultsForKey:kVipStatus];
            [User saveUseDefaultsOjbect:request[@"isVip"] forKey:kVipStatus];
            
        } else {
            SVShowError(request[@"msg"]);
        }
    } failBlock:^(NSError *error) {
        SLLog(error);
    }];
}



#pragma mark - Getter\Setter
- (UIView *)failView {
    if (_failView) return _failView;
    UIView * failView = [UIView viewWithBgColor:[UIColor whiteColor] frame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    
    UIImageView * imageV = [UIImageView imageViewWithImage:[UIImage imageNamed:@"支付失败_失败_icon"] frame:Rect(0, Fit(160), Fit(48), Fit(48))];
    imageV.centerX = kHalfScreenWidth;
    [failView addSubview:imageV];
    
    UILabel * label = [UILabel labelWithText:@"支付失败！请重新支付~" font:Fit(14) textColor:HexColorInt32_t(333333) frame:Rect(0, imageV.maxY + Fit(20), 1, 1)];
    [label sizeToFit];
    label.centerX = imageV.centerX;
    [failView addSubview:label];
    
    UIButton * btn = [UIButton buttonWithTitle:@"确定" titleColor:HexColorInt32_t(C00D23) backgroundColor:nil font:Fit(14) image:nil frame:Rect(0, 0, Fit(150), Fit(36))];
    btn.maxY = failView.height - Fit(42);
    btn.centerX = label.centerX;
    [btn setBorderWidth:1 borderColor:btn.currentTitleColor];
    [failView addSubview:btn];
    @weakify(self);
    [[btn rac_touchupInsideSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    _failView = failView;
    return _failView;
}

- (UIView *)successView {
    if (_successView) return _successView;
    UIScrollView * successView = [UIScrollView scrollViewWithBgColor:[UIColor whiteColor] frame:Rect(0, 64, kScreenWidth, kScreenHeight - 64)];
    _successView = successView;
    
    UIImageView * imageV = [UIImageView imageViewWithImage:[UIImage imageNamed:@"支付成功"] frame:Rect(0, Fit(75), Fit(48), Fit(48))];
    imageV.centerX = kHalfScreenWidth;
    [successView addSubview:imageV];
    
    NSString * txt = @"支付成功！我们将第一时间安排发货！";
    if (self.showShortTitle) {
        txt = @"支付成功！";
    }
    UILabel * label = [UILabel labelWithText:txt font:Fit(14) textColor:HexColorInt32_t(333333) frame:Rect(0, imageV.maxY + Fit(20), 1, 1)];
    [label sizeToFit];
    label.centerX = imageV.centerX;
    [successView addSubview:label];
    
    SLDevider * devider = [[SLDevider alloc] initWithFrame:Rect(0, label.maxY + Fit(75), kScreenWidth, 1)];
    [successView addSubview:devider];
    
    NSArray * keys = @[@"订单号", @"支付流水号", @"订单总金额", @"订单日期"];
    NSArray * values = @[self.orderInfo[@"orderCode"], self.orderInfo[@"orderCode"], [NSString stringWithFormat:@"￥%.2f", [self.orderInfo[@"totalPrice"] doubleValue]], self.orderInfo[@"orderTime"]];
    CGFloat y = devider.maxY;
    for (int i = 0; i < keys.count; i++) {
        UIView * infoView = [self _makeInfoView:keys[i] value:values[i]];
        infoView.y = y;
        [successView addSubview:infoView];
        y = infoView.maxY;
    }
    
    UIButton * btn = [UIButton buttonWithTitle:@"继续购物" titleColor:HexColorInt32_t(C00D23) backgroundColor:nil font:Fit(14) image:nil frame:Rect(0, y + Fit(110), Fit(150), Fit(36))];
    btn.centerX = label.centerX;
    [btn setBorderWidth:1 borderColor:btn.currentTitleColor];
    [successView addSubview:btn];
    @weakify(self);
    [[btn rac_touchupInsideSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self _popVC];
    }];
    successView.contentSize = Size(0, btn.maxY + 30);
    return _successView;
}

- (UIView *)_makeInfoView:(NSString *)key value:(NSString *)value {
    
    UIView * infoView = [UIView viewWithBgColor:[UIColor whiteColor] frame:Rect(0, 0, kScreenWidth, Fit(44))];
    UILabel * keyLabel = [UILabel labelWithText:key font:Fit(14) textColor:HexColorInt32_t(999999) frame:Rect(Fit(15), 0, 1, 1)];
    [keyLabel sizeToFit];
    keyLabel.centerY = infoView.halfHeight;
    [infoView addSubview:keyLabel];
    
    UILabel * valueLabel = [UILabel labelWithText:value font:Fit(14) textColor:HexColorInt32_t(333333) frame:Rect(0, 0, 1, 1)];
    [valueLabel sizeToFit];
    valueLabel.maxX = infoView.width - Fit(15);
    valueLabel.centerY = keyLabel.centerY;
    [infoView addSubview:valueLabel];
    
    SLDevider * devider = [[SLDevider alloc] initWithFrame:Rect(0, infoView.height - 1, infoView.width, 1)];
    [infoView addSubview:devider];
    
    return infoView;
}

@end
