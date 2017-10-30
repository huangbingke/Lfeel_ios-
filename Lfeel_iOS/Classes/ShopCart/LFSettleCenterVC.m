//
//  LFSettleCenterVC.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/4.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFSettleCenterVC.h"
#import "LFSettleCenterView.h"
#import "LFPayResultVC.h"
#import "LFShopCartModels.h"
#import "LFMineAddressViewController.h"
#import "LFDelegateViewController.h"
#import "LFLeiBaiPayVC.h"
#import "LFLeiBaiPayView.h"
#import "LFBuyModels.h"
#import "LFCardBagViewController.h"
@interface LFSettleCenterVC ()
<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,   weak) UITableView * tableView;
@property (nonatomic,   copy) NSArray<LFGoods *> *internalGoodses;
///  支付方式
@property (nonatomic, assign) PayType payType;
@property (nonatomic, strong) LFAddressModel * addressModel;
///  请求的订单信息
@property (nonatomic,   copy) NSDictionary * orderInfo;
@property (nonatomic,   weak) LFSettleCenterHeaderView * header;


@property (nonatomic, copy) NSString *privilegeIDString;

@property (nonatomic, assign) CGFloat allPrice;


@end

@implementation LFSettleCenterVC

#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.payType = 1;
    [self setupSubViews];
    
    [self setupNavigationBar];
    
    if (self.goodses) {
        self.internalGoodses = [self.goodses copy];
        [self _setupTableHeaderFooterView];
        [self.tableView reloadData];
        self.goodsCartIds = self.goodses[0].goodsCartId;
    } else {
        [self _ruquestGoodsOrderData];
    }
    
    
    NSLog(@"------------------------------%@", self.goodses);
    for (LFGoods *model in self.goodses) {
        NSLog(@"%@", model.sellingPrice);
    }
    
    
}

///  初始化子控件
- (void)setupSubViews {
    UITableView * tableView = [[UITableView alloc] initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = Fit(101);
    [self.view addSubview:tableView];
    self.tableView = tableView;
}


///  设置自定义导航条
- (void)setupNavigationBar {
    @weakify(self);
    NSString * title = @"结算中心";
    self.ts_navgationBar = [TSNavigationBar navWithTitle:title backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Actions


#pragma mark - Networking
///  请求下单前信息
- (void)_ruquestGoodsOrderData {
    
    NSString * url = @"shoppingCart/goodsOrder.htm?";
    LFParameter * parameter = [LFParameter new];
    parameter.goodsCartIds = self.goodsCartIds;
    
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        self.internalGoodses = [NSArray yy_modelArrayWithClass:[LFGoods class] json:request[@"orderGoodsList"]];
        [self _setupTableHeaderFooterView];
        [self.tableView reloadData];
        
        NSDictionary * dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
        if (dict) {
            LFAddressModel * model = [LFAddressModel yy_modelWithDictionary:dict];
            [self _setupAddress:model];
        }
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
}

///  请求新增订单数据
- (void)_requestAddOrderData {
    /*addressId	商品发货地址ID	string
     goodsCartIds	购物车ID	string
     loginKey		string	@mock=00fa95958febf957bf48ce2aebde71db
     payType	1支付宝 2=微信 3银联，4分期	string	*/
    NSString * url = @"shoppingCart/submitOrder.htm?";
    LFParameter * parameter = [LFParameter new];
    parameter.addressId = self.addressModel.addressId;
    parameter.goodsCartIds = self.goodsCartIds;
    parameter.privilege_id = self.privilegeIDString;
    [parameter appendBaseParam];
    NSArray * arr = @[@"4", @"1", @"2", @"3"];
    parameter.payType = arr[self.payType];
    
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        self.orderInfo = request.copy;
        [self _sendPay];
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UITextField *txt = [alertView textFieldAtIndex:0];
    NSLog(@"========%@========", txt.text);
    [self requestSubmitOrderDataWithPassword:txt.text];
}

- (void)requestSubmitOrderDataWithPassword:(NSString *)password {
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    
    NSString * url = @"pay/zeropay.htm?";
    LFParameter * parameter = [LFParameter new];
    parameter.price = [NSString stringWithFormat:@"%lf", self.allPrice];
    parameter.user_id = dic[@"user_id"];
    parameter.password = password;
    parameter.orderform_id = self.orderInfo[@"orderId"];
    [parameter appendBaseParam];
    NSArray * arr = @[@"4", @"1", @"2", @"3"];
    parameter.payType = arr[self.payType];
    
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        LFPayResultVC * controller = [[LFPayResultVC alloc] init];
        controller.success = YES;
        controller.orderInfo = self.orderInfo.copy;
        [self.navigationController pushViewController:controller animated:YES];
        
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

        
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
}



///  发起支付
- (void)_sendPay {
    NSDictionary * request = self.orderInfo;
    if ([request[@"totalPrice"] isEqualToString:@"0.0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入登录密码" message:@"输入密码,确认身份,减掉优惠券响应价格." delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
        [alert show];
        return;
    }
    
    if (![request[@"totalPrice"] doubleValue]) {
        SVShowError(@"金额有误");
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    if (self.payType == 0) {
        
        if ([request[@"totalPrice"] doubleValue] < 600) {
            SVShowError(@"分期最小金额为600"); return;
        }
        
        NSString * orderNO = [NSString stringWithFormat:@"%@", request[@"orderId"]];
        NSString * price = stringWithDoubleAndDecimalCount([request[@"totalPrice"] doubleValue] * 100, 0);
        LFLeiBaiPayVC * controller = [[LFLeiBaiPayVC alloc] init];
        LFPayModel * model = [LFPayModel new];
        model.order_id = orderNO;
        model.price = price;
        model.order_sn = request[@"orderCode"];
        model.bankCardList = [NSArray yy_modelArrayWithClass:[LFCardInfo class] json:request[@"bankCardList"]].copy;
        controller.payModel = model;
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    @weakify(self);
    NSString * price = [NSString stringWithFormat:@"%.0f",  [request[@"totalPrice"] doubleValue] * 100];
    
    [LFPayHelper payWithType:self.payType price:price orderNum:request[@"orderCode"] showInViewController:self completionHandle:^(BOOL success, NSString *msg) {
        
        @strongify(self);
        LFPayResultVC * controller = [[LFPayResultVC alloc] init];
        controller.success = success;
        controller.orderInfo = self.orderInfo.copy;
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

#pragma mark - Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.internalGoodses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LFSettleCenterGoodsCell * cell = [LFSettleCenterGoodsCell cellWithTableView:tableView];
    cell.goods = self.internalGoodses[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - Private

- (void)_setupTableHeaderFooterView {
    UITableView * tableView = self.tableView;
    // 地址view
    LFSettleCenterHeaderView * header = [LFSettleCenterHeaderView creatView];
    header.frame = Rect(0, 0, kScreenWidth, Fit(91));
    tableView.tableHeaderView = header;
    self.header = header;
    @weakify(self);
    header.didClickSelectedAddressBlock = ^{
        @strongify(self);
        
        LFMineAddressViewController * controller = [[LFMineAddressViewController alloc] init];
        controller.didSelectedAddressBlock = ^(LFAddressModel *model) {
            [self _setupAddress:model];
        };
        [self.navigationController pushViewController:controller animated:YES];
    };
    
    // footer
    CGFloat f = 0;
    for (LFGoods *goods in self.internalGoodses) {
        f += (goods.sellingPrice.doubleValue) * goods.goodsNum.integerValue;
    }
    self.allPrice = f;
    NSLog(@"====================================================== >>>  %lf", f);
    UIView * footerBg = [UIView viewWithBgColor:nil frame:Rect(0, 0, kScreenWidth, 1)];
    LFSettleCenterFooterView * footer = [LFSettleCenterFooterView creatView];
    footer.totalPriceString = stringWithDouble(f);
    footer.frame = Rect(0, 10, kScreenWidth, Fit(footer.height));
    [footerBg addSubview:footer];
    @weakify(footer);
    [footer setSelecePayTypeBlock:^{ // 选择支付类型
        @strongify(self, footer);
        [LFSettleCenterSelectPayTypeView showWithCompleteHandle:^(PayType payType) {
            self.payType = payType;
            NSArray * arr = @[@"信用卡分期", @"支付宝", @"微信支付", @"银联支付"];
            footer.payTypeString = arr[payType];
        } selectedType:self.payType];
        
    } submitBlock:^{ // 提交订单
        @strongify(self);
        SLAssert(self.addressModel != nil, @"请选择收货地址");
        if (self.orderInfo) {
            [self _sendPay];
        } else {
            [self _requestAddOrderData];
        }
        
    } protocolBlock:^{ // 协议
        @strongify(self);
        LFDelegateViewController * controller = [[LFDelegateViewController alloc] init];
        controller.selectType = @"1";
        [self.navigationController pushViewController:controller animated:YES];
        
    } cheaperBlock:^{
        @strongify(self, footer);
        NSLog(@"选择优惠券");
        LFCardBagViewController *bagVc = [[LFCardBagViewController alloc] init];
        bagVc.jumpId = @"LFSettleCenterVC";
        bagVc.cardBlock = ^(LFCheapCardModel *model) {
            self.privilegeIDString = model.privilege_id;
            
            
            CGFloat price = f - [model.price floatValue];
            if (price < 0) {
                footer.cheapPriceString = [NSString stringWithFormat:@"-%.2lf", f];
                footer.totalPriceString = @"0.00";
            } else {
                footer.cheapPriceString = [NSString stringWithFormat:@"-%@", model.price];
                footer.totalPriceString = stringWithDouble(price);
            }
            NSLog(@"----------- %@", model.price);
        };
        [self.navigationController pushViewController:bagVc animated:YES];
        
    }];
    footerBg.height = footer.height + 10;
    
    tableView.tableFooterView = footerBg;
}
             
- (void)_setupAddress:(LFAddressModel *)model {
 
     self.addressModel = model;
     self.header.addressModel = model;
     CGFloat f = [self.header completeSelected];
     self.header.height = f;
     self.tableView.tableHeaderView = self.header;
     
     [[NSUserDefaults standardUserDefaults] setObject:[model yy_modelToJSONObject] forKey:@"address"];
     [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - Public


#pragma mark - Getter\Setter

@end
