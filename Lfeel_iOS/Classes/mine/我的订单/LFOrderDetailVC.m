//
//  LFOrderDetailVC.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/4/4.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFOrderDetailVC.h"
#import "LFOrderDetailView.h"

@interface LFOrderDetailVC ()
//<UITableViewDelegate, UITableViewDataSource>
//@property (nonatomic,   weak) UITableView * tableView;

@end

@implementation LFOrderDetailVC

#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    
    [self setupNavigationBar];
    
    [self _requestOrderDetail];
}

///  初始化子控件
- (void)setupSubViews {
    
}

///  设置自定义导航条
- (void)setupNavigationBar {
    @weakify(self);
    NSString * title = @"订单详情";
    self.ts_navgationBar = [TSNavigationBar navWithTitle:title backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Actions
///  请求订单详情
- (void)_requestOrderDetail {
    NSString * url = @"shoppingCart/orderDetailed.htm?";
    LFParameter * parameter = [LFParameter new];
    [parameter appendBaseParam];
    parameter.orderId = self.order_id;
    
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        
        LFOrderDetail * model = [LFOrderDetail yy_modelWithDictionary:request];
        
        LFOrderDetailView * view = [LFOrderDetailView creatViewFromNib];
        view.detail = model;
        view.frame = Rect(0, 0, kScreenWidth, Fit(view.height));
        
        UIScrollView * scrollView = [UIScrollView defaultScrollView];
        [self.view addSubview:scrollView];
        [scrollView addSubview:view];
        scrollView.contentSize = Size(0, view.height + 30);
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
    
}

#pragma mark - Networking


#pragma mark - Delegate

#pragma mark - Private


#pragma mark - Public


#pragma mark - Getter\Setter

@end
