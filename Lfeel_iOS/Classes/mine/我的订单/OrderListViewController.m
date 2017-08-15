//
//  OrderListViewController.m
//  PocketJC
//
//  Created by kvi on 16/9/27.
//  Copyright © 2016年 CHY. All rights reserved.
//

#import "OrderListViewController.h"
#import "SLEmptyView.h"
#import "LFShopCartModels.h"
#import "LFOrdersModel.h"
#import "LFShopcartView.h"
#import "LFAddCommentVC.h"
#import "LFOrderDetailVC.h"
#import "LFSettleCenterView.h"
#import "LFPayResultVC.h"
#import "LFEmptyView.h"
#import "LFLeiBaiPayVC.h"
#import "LFApplyReturnOrderVC.h"

@interface OrderListViewController ()<UITableViewDataSource,UITableViewDelegate, MGSwipeTableCellDelegate>
@property (nonatomic,   copy) NSString * startPage;
@property (nonatomic, strong) NSMutableArray<LFOrder *> * orders;
@property (nonatomic, assign, getter=isRefreshing) BOOL refreshing;
@property (nonatomic, strong) SLEmptyView * emptyView;
@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView * tableView = self.tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.rowHeight = Fit(114);
    [tableView registerNib:[UINib nibWithNibName:@"OrderCell" bundle:nil] forCellReuseIdentifier:@"OrderCell"];
    tableView.backgroundColor = HexColorInt32_t(f6f6f6);
    
    
    self.startPage = @"0";
    [self _requestOrderListData];
    
    @weakify(self);
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.startPage = @"0";
        self.refreshing = YES;
        [self _requestOrderListData];
    }];
    
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self _requestOrderListData];
    }];
}

///  请求订单数据
- (void)_requestOrderListData {
    
    NSString * url = @"shoppingCart/myOrderList.htm?";
    LFParameter * parameter = [LFParameter new];
    [parameter appendBaseParam];
    parameter.startPage = self.startPage;
    parameter.orderStatus = self.type;
    [self.tableView.mj_footer resetNoMoreData];
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        SLEndRefreshing(self.tableView);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        if (self.isRefreshing) {
            [self.orders removeAllObjects];
            self.refreshing = NO;;
        }
        [self.orders addObjectsFromArray:[NSArray yy_modelArrayWithClass:[LFOrder class] json:request[@"orderInfoList"]]];
        [self.tableView reloadData];
        self.startPage = [request[@"startPage"] stringValue];
        if (self.startPage.integerValue == [request[@"totalPage"] integerValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (!self.orders.count) {
            [self.tableView addSubview:self.emptyView];
        } else {
            [self.emptyView removeFromSuperview];
        }
        
    } failBlock:^(NSError *error) {
        SLEndRefreshing(self.tableView);
        SLShowNetworkFail;
        SLLog(error);
    }];

}

/// 取消订单
- (void)_cancelOrder:(NSInteger)index {
    
    NSString * url = @"shoppingCart/cancelOrder.htm?";
    LFParameter * parameter = [LFParameter new];
    [parameter appendBaseParam];
    parameter.orderId = self.orders[index].orderId;
    
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        SVShowSuccess(request[@"msg"]);
        [self reloadData];
        BLOCK_SAFE_RUN(self.vblock);
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
}

/// 确认收货
- (void)_confireOrder:(NSInteger)index {
    
    NSString * url = @"shoppingCart/orderCofirm.htm?";
    LFParameter * parameter = [LFParameter new];
    [parameter appendBaseParam];
    parameter.orderId = self.orders[index].orderId;
    
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        SVShowSuccess(request[@"msg"]);
        [self reloadData];
        BLOCK_SAFE_RUN(self.vblock);
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
}

///  退货
- (void)_returnOrder:(NSInteger)index {
    
    NSString * url = @"shoppingCart/orderCofirm.htm?";
    LFParameter * parameter = [LFParameter new];
    [parameter appendBaseParam];
    parameter.orderId = self.orders[index].orderId;
    
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        SVShowSuccess(request[@"msg"]);
        [self reloadData];
        BLOCK_SAFE_RUN(self.vblock);
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];

}
#pragma mark - UItableViewDataSorue
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orders.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orders[section].orderDetailedList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LFShopcartCell * cell = [LFShopcartCell cellWithTableView:tableView];
    [cell setOrderModel];
    cell.orderStatus = self.orders[indexPath.section].orderStatus;
    cell.order_id = self.orders[indexPath.section].orderId;
    cell.goods = self.orders[indexPath.section].orderDetailedList[indexPath.row];
    cell.delegate = self;
    if (!cell.didClickCommentBtnBlock) {
        @weakify(self);
        cell.didClickCommentBtnBlock = ^(LFShopcartCell * x) {
            @strongify(self);
            LFAddCommentVC * controller = [[LFAddCommentVC alloc] init];
            controller.goods = x.goods;
            controller.order_id = x.order_id;
            controller.vBlock = ^{
                [self reloadData];
            };
            [self.navigationController pushViewController:controller animated:YES];
        };
    }
    return cell;
}

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell shouldHideSwipeOnTap:(CGPoint)point {
    return NO;
}
-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction fromPoint:(CGPoint) point {
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LFOrderDetailVC * controller = [[LFOrderDetailVC alloc] init];
    controller.order_id = self.orders[indexPath.section].orderId;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * header = [UIView viewWithBgColor:nil frame:Rect(0, 0, kScreenWidth, Fit(50))];
    
    UIView * contentView = [UIView viewWithBgColor:[UIColor whiteColor] frame:Rect(0, Fit(10), header.width, header.height - Fit(10))];
    [header addSubview:contentView];
    
    NSString * sn = [NSString stringWithFormat:@"订单编号：%@", self.orders[section].orderCode];
    UILabel * orderSN = [UILabel labelWithText:sn font:Fit(14) textColor:HexColorInt32_t(333333) frame:Rect(Fit(15), 0, kScreenWidth - 100, contentView.height)];
    [contentView addSubview:orderSN];
    
    UILabel * status = [UILabel labelWithText:self.orders[section].statusString font:orderSN.font.pointSize textColor:HexColorInt32_t(999a9b) frame:Rect(0, 0, 100, contentView.height)];
    status.textAlignment = NSTextAlignmentRight;
    status.maxX = contentView.width - Fit(15);
    [contentView addSubview:status];
    
    SLDevider * devider = [[SLDevider alloc] initWithFrame:Rect(0, header.height - 1, kScreenWidth, 1)];
    [header addSubview:devider];
    
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footer = [UIView viewWithBgColor:[UIColor whiteColor] frame:Rect(0, 0, kScreenWidth, Fit(55))];
    
    LFOrder * order = self.orders[section];
    NSString * sn = [NSString stringWithFormat:@"总价：￥%@", order.totalPrice.formatNumber];
    UILabel * orderSN = [UILabel labelWithText:sn font:Fit(14) textColor:HexColorInt32_t(333333) frame:Rect(Fit(15), 0, kScreenWidth - 100, footer.height)];
    [footer addSubview:orderSN];
//    static int i = 0;
//    order.orderStatus = 2;
//    0=订单取消状态 1=全部订单 2=待付款 3=待发货 4=待收货 7=已完成
    UIColor * color = HexColorInt32_t(bd132a); // 红色
    
    UIButton * rightBtn = ({
        UIButton * statusBtn = [UIButton buttonWithTitle:@"支付" titleColor:HexColorInt32_t(FFFFFF) backgroundColor:color font:Fit(14) image:nil frame:Rect(0, 0, Fit(80), Fit(30))];
        statusBtn.maxX = footer.width - Fit(15);
        statusBtn.centerY = footer.halfHeight;
        statusBtn;
    });
    [footer addSubview:rightBtn];
    rightBtn.tag = section;
    
    UIButton * leftBtn = ({
        UIButton * statusBtn = [UIButton buttonWithTitle:@"取消订单" titleColor:color backgroundColor:nil font:Fit(14) image:nil frame:rightBtn.bounds];
        statusBtn.maxX = rightBtn.x - Fit(10);
        statusBtn.centerY = footer.halfHeight;
        [statusBtn setBorderWidth:1 borderColor:color];
        statusBtn;
    });
    [footer addSubview:leftBtn];
    leftBtn.tag = section;
    
    [leftBtn  addTarget:self action:@selector(_didClickStatusBtn:)];
    [rightBtn addTarget:self action:@selector(_didClickStatusBtn:)];
    
    if (order.orderStatus == 0) {
        leftBtn.hidden = YES;
        rightBtn.hidden = YES;
    } else if (order.orderStatus == 2) {
        // 不用变
    } else if (order.orderStatus == 3) {
        leftBtn.hidden = YES;
        rightBtn.title = @"申请退货";
    } else if (order.orderStatus == 4) {
        leftBtn.hidden = YES;
        rightBtn.title = @"确认收货";
    } else if (order.orderStatus == 7) {
        leftBtn.hidden = YES;
        rightBtn.title = @"申请退货";
    } else {
        leftBtn.hidden = YES;
        rightBtn.hidden = YES;
    }
    return footer;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Fit(50);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return Fit(55);
}


///刷新
- (void)reloadData{
    self.needRefresh = NO;
    [self.tableView.mj_header beginRefreshing];
}

- (void)_didClickStatusBtn:(UIButton *)btn {
    NSString * btnTitle = btn.currentTitle;
    if ([btnTitle isEqualToString:@"取消订单"]) {
        [SLAlertView alertViewWithTitle:@"确定要取消订单吗" cancelBtn:@"取消" destructiveButton:@"确定" otherButtons:nil clickAtIndex:^(NSInteger buttonIndex) {
            [self _cancelOrder:btn.tag];
        }];
    } else if ([btnTitle isEqualToString:@"支付"]) {
        @weakify(self);
        [LFSettleCenterSelectPayTypeView showWithCompleteHandle:^(PayType payType) {
            @strongify(self);
            
            // 修改支付方式
            NSString * url = @"personal/updateOrderPayType.htm?";
            LFParameter * parameter = [LFParameter new];
            [parameter appendBaseParam];
            parameter.orderId = self.orders[btn.tag].orderId;
            NSArray * arr = @[@"4", @"1", @"2", @"3"];
            parameter.payType = arr[payType];
            
            [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
                SLLog(request);
                if ([request[@"result"] integerValue] != 200) {
                    SVShowError(request[@"msg"]);
                    return ;
                }
                
                LFOrder * order = self.orders[btn.tag];
                NSString * price = order.totalPrice;
                if (payType == 0) {
                    
                    NSString * price = stringWithDoubleAndDecimalCount([order.totalPrice doubleValue] * 100, 0);
                    if ([price doubleValue] < 600) {
                        SVShowError(@"分期最小金额为600"); return;
                    }
                    
                    LFLeiBaiPayVC * controller = [[LFLeiBaiPayVC alloc] init];
                    LFPayModel * model = [LFPayModel new];
                    model.order_id = order.orderId;
                    model.price = price;
                    model.order_sn = order.orderCode;
                    model.bankCardList = [NSArray yy_modelArrayWithClass:[LFCardInfo class] json:request[@"bankCardList"]].copy;
                    controller.payModel = model;
                    [self.navigationController pushViewController:controller animated:YES];
                    
                    return;
                }
                @weakify(self);
                NSString * priceFen = stringWithInteger(price.doubleValue * 100);
                [LFPayHelper payWithType:payType price:priceFen orderNum:order.orderCode showInViewController:self completionHandle:^(BOOL success, NSString *msg) {
                    @strongify(self);
                    LFPayResultVC * controller = [[LFPayResultVC alloc] init];
                    controller.success = success;
                    controller.orderInfo = [order yy_modelToJSONObject];
                    [self.navigationController pushViewController:controller animated:YES];
                    
                    [self reloadData];
                }];
                
            } failBlock:^(NSError *error) {
                SLShowNetworkFail;
                SLLog(error);
            }];
            
        } selectedType:-1];
    } else if ([btnTitle isEqualToString:@"确认收货"]) {
        [self _confireOrder:btn.tag];
    } else if ([btnTitle isEqualToString:@"申请退货"]) {
        LFOrder * order = self.orders[btn.tag];
        LFApplyReturnOrderVC * controller = [[LFApplyReturnOrderVC alloc] init];
        controller.order_id = order.orderId;
        controller.price = order.totalPrice;
        @weakify(self);
        controller.vBlock = ^{
            @strongify(self);
            [self reloadData];
            BLOCK_SAFE_RUN(self.vblock);
        };
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}


- (NSMutableArray<LFOrder *> *)orders { SLLazyMutableArray(_orders) }

- (SLEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[SLEmptyView alloc] initWithFrame:self.tableView.bounds];
    }
    return _emptyView;
}
@end
