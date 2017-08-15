//
//  LFInvoiceVC.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/4/16.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFInvoiceVC.h"
#import "LFOrdersModel.h"
#import "MGSwipeTableCell.h"
#import "SLEmptyView.h"
#import "LFShopcartView.h"
#import "LFInvoiceView.h"
#import "LFApplyInvoiceVC.h"
#import "MJRefresh.h"

@interface LFInvoiceVC ()<UITableViewDataSource,UITableViewDelegate, MGSwipeTableCellDelegate>
@property (nonatomic,   weak) UITableView * tableView;
@property (nonatomic,   copy) NSString * startPage;
@property (nonatomic, strong) NSMutableArray<LFOrder *> * orders;
@property (nonatomic, assign, getter=isRefreshing) BOOL refreshing;
@property (nonatomic, strong) SLEmptyView * emptyView;
@property (nonatomic,   weak) LFInvoiceView * bottomView;
@end

@implementation LFInvoiceVC

#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.startPage = @"0";
    [self setupSubViews];
    self.orders = [NSMutableArray array];
    
    [self setupNavigationBar];
    
    [self _requestOrderListData];
}

///  初始化子控件
- (void)setupSubViews {
    CGFloat y = kScreenHeight;
    if (!self.isRecord) { // 不是记录
        LFInvoiceView * view = [LFInvoiceView creatViewFromNib];
        view.frame = Rect(0, 0, kScreenWidth, Fit(view.height));
        view.maxY = kScreenHeight;
        self.bottomView = view;
        [self.view addSubview:view];
        @weakify(self);
        [view setSelectedAll:^{ // 全选
            @strongify(self);
            self.bottomView.selected = !self.bottomView.isSelected;
            double totalPrice = 0;
            for (LFOrder * order in self.orders) {
                if (self.bottomView.isSelected) {
                    for (LFGoods * goods in order.orderDetailedList) {
                        totalPrice += goods.sellingPrice.doubleValue * goods.goodsNum.integerValue;
                        goods.selected = self.bottomView.isSelected;
                    }
                    
                }
                order.selected = self.bottomView.isSelected;
            }
            
            self.bottomView.totalLabel.text = [NSString stringWithFormat:@"共￥%@", stringWithDouble(totalPrice).formatNumber];
            [self.tableView reloadData];
        } submit:^{ // 提交
            @strongify(self);
            
            NSMutableString * orders = [NSMutableString new];
            double price = 0;
            for (LFOrder * order in self.orders) {
                if (!order.isSelected) continue;
                [orders appendFormat:@"%@;", order.orderId];
                price += order.totalPrice.doubleValue;
            }
            SLAssert(price != 0, @"请至少选择一个订单");
            [orders deleteCharactersInRange:NSMakeRange(orders.length - 1, 1)];
            
            LFApplyInvoiceVC * controller = [[LFApplyInvoiceVC alloc] init];
            controller.IDs = orders;
            controller.totalPrice = stringWithDouble(price);
            controller.vBlock = ^{
                @strongify(self);
                self.startPage = @"0";
                self.refreshing = YES;
                [self _requestOrderListData];
                [self _checkStatus];
            };
            [self.navigationController pushViewController:controller animated:YES];
        }];
        y = view.y;
    }
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:Rect(0, 64, kScreenWidth, y - 64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = Fit(114);
    [tableView registerNib:[UINib nibWithNibName:@"OrderCell" bundle:nil] forCellReuseIdentifier:@"OrderCell"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = HexColorInt32_t(f6f6f6);
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    @weakify(self);
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self _requestOrderListData];
    }];
}

///  设置自定义导航条
- (void)setupNavigationBar {
    @weakify(self);
    NSString * title = nil;
    id block = nil;
    NSString * right = nil;
    
    if (self.isRecord) {
        title = @"开票记录";
    } else {
        title = @"发票";
        right = @"开票记录";
        block = ^{
            @strongify(self);
            LFInvoiceVC * controller = [[LFInvoiceVC alloc] init];
            controller.record = YES;
            [self.navigationController pushViewController:controller animated:YES];
        };
    }
    self.ts_navgationBar = [TSNavigationBar navWithTitle:title rightItem:right rightAction:block backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Actions


#pragma mark - Networking

///  请求订单数据
- (void)_requestOrderListData {
    
    NSString * url = @"personal/stayInvoiceList.htm?";
    LFParameter * parameter = [LFParameter new];
    [parameter appendBaseParam];
    parameter.startPage = self.startPage;
    parameter.invoiceStatus = self.isRecord ? @"1" : @"0";
    
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
        if ([request[@"totalPage"] integerValue] == 1 && self.orders.count == 0) {
            SLEmptyView * empty = [[SLEmptyView alloc] initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight - 64)];
            [self.view addSubview:empty];
        }
        
    } failBlock:^(NSError *error) {
        SLEndRefreshing(self.tableView);
        SLShowNetworkFail;
        SLLog(error);
    }];
    
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orders.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orders[section].orderDetailedList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LFShopcartCell * cell = [LFShopcartCell cellWithTableView:tableView];
    cell.goods = self.orders[indexPath.section].orderDetailedList[indexPath.row];
    cell.delegate = self;
    [cell setOrderModel];
    @weakify(self);
    if (!cell.didClickStautsBtnBlock) [cell setDidClickStautsBtnBlock:^(LFShopcartCell *x) {
        @strongify(self);
        [self _checkStatus];
    }];
    return cell;
}

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell shouldHideSwipeOnTap:(CGPoint)point {
    return NO;
}
-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction fromPoint:(CGPoint) point {
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)tapSelectOrder:(UIButton *)sender{
    LFOrder * order = self.orders[sender.tag];
    order.selected = !order.isSelected;
    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationNone];
    [self _checkStatus];
}



- (UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header = [UIView viewWithBgColor:nil frame:Rect(0, 0, kScreenWidth, Fit(50))];
    
    
    UIView * contentView = [UIView viewWithBgColor:[UIColor whiteColor] frame:Rect(0, Fit(10), header.width, header.height - Fit(10))];
    [header addSubview:contentView];
    
    UIButton * button = nil;
    if (!self.isRecord) {
        button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [button setImage:[UIImage imageNamed:@"椭圆-4-拷贝"] forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:@"选择-拷贝-3"] forState:(UIControlStateSelected)];
        
        
        button.frame  = Rect(0, 0, Fit(40), Fit(40));
        button.tag = section;
        [button addTarget:self action:@selector(tapSelectOrder:)];
        [contentView addSubview:button];
    }
    
    LFOrder * order = self.orders[section];
    
    NSString * sn = [NSString stringWithFormat:@"订单编号：%@", order.orderCode];
    UILabel * orderSN = [UILabel labelWithText:sn font:Fit(14) textColor:HexColorInt32_t(333333) frame:Rect(CGRectGetMaxX(button.frame)+Fit(15), 0, kScreenWidth - 100, contentView.height)];
    [contentView addSubview:orderSN];
    
    button.selected = order.isSelected;
    
    SLDevider * devider = [[SLDevider alloc] initWithFrame:Rect(0, header.height - 1, kScreenWidth, 1)];
    [header addSubview:devider];
    
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footer = [UIView viewWithBgColor:[UIColor whiteColor] frame:Rect(0, 0, kScreenWidth, Fit(55))];
    
    LFOrder * order = self.orders[section];
    NSString * sn = [NSString stringWithFormat:@"总价：￥%@",order.totalPrice.formatNumber];
    UIColor * color = self.isRecord ? HexColorInt32_t(C00D23) : HexColorInt32_t(333333);
    UILabel * orderSN = [UILabel labelWithText:sn font:Fit(14) textColor:color frame:Rect(Fit(15), 0, kScreenWidth - 100, footer.height)];
    [footer addSubview:orderSN];
    return footer;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Fit(50);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return Fit(55);
}

#pragma mark - Private
- (void)_checkStatus {
    
    double totalPrice = 0;
    BOOL all = YES;
    for (LFOrder * order in self.orders) {
        if (!order.isSelected) {
            all = NO;
            continue;
        }
        for (LFGoods * goods in order.orderDetailedList) {
            totalPrice += goods.sellingPrice.doubleValue * goods.goodsNum.integerValue;
        }
    }
    
    self.bottomView.selected = all;
    self.bottomView.totalLabel.text = [NSString stringWithFormat:@"共￥%@", stringWithDouble(totalPrice).formatNumber];
}

#pragma mark - Public


#pragma mark - Getter\Setter

@end
