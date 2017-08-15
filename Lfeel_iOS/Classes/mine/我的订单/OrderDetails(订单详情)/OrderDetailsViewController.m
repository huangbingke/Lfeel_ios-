//
//  OrderDetailsViewController.m
//  PocketJC
//
//  Created by kvi on 16/9/28.
//  Copyright © 2016年 CHY. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "DetailsCell.h"
#import "DetailsHeadView.h"
#import "DetailsFooterView.h"
#import "Masonry.h"
#import "SLPayVC.h"
#import "SLAddEvaluationVC.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "BaseNavigationController.h"
#import "SLAppDelegate.h"
#import "SLHud.h"


@interface OrderDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) _SLOrderDetail * orderDetail;
@property (nonatomic,   weak) UITableView * tableView;
@property (nonatomic,   weak) UIView * bottomView;
@end

@implementation OrderDetailsViewController {
    BOOL _isFirst;
    SLHud * _hud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _hud = [[SLHud alloc] initWithTitle:nil frame:defaultRect()];
    [self.view addSubview:_hud];
    [self _setupSubViews];
}

///  <#Description#>
- (void)_setupSubViews {
    self.view.backgroundColor = HexColorInt32_t(f6f6f6);
    
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:Rect(0, 69, kScreenWidth, kScreenHeight - 69 - 50) style:UITableViewStyleGrouped];
    tabbleView.dataSource = self;
    tabbleView.delegate = self;
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tabbleView];
    [tabbleView registerNib:[UINib nibWithNibName:@"DetailsCell" bundle:nil] forCellReuseIdentifier:@"DetailsCell"];
    tabbleView.backgroundColor = HexColorInt32_t(F6F6F6);
    tabbleView.rowHeight = 67;
    self.tableView = tabbleView;
    

    UIView * view = [UIView viewWithBgColor:[UIColor redColor] frame:Rect(0, tabbleView.maxY, kScreenWidth, 50)];
    UIView * v = [UIView creatViewFromNibName:@"OrderDetail1" atIndex:0];;
    v.frame = Rect(0, 0, kScreenWidth, v.height);
    self.bottomView = v;
    [view addSubview:v];
    [self.view addSubview:view];
    for (int i = 0; i < 3; i++) {
        UIButton * btn = [view viewWithTag:i + 1];
        [btn addTarget:self action:@selector(_handleBtnAction:)];
    }
    
    
    [self setupNavigationBar];
    self->_isFirst = YES;
    [self _requestOrderDetailData];
    
    if (!self.isOrderList) {
        UITabBarController * tab =  (UITabBarController *)[SLAppDelegate sharedDelegate].window.rootViewController;
        BaseNavigationController * base = (BaseNavigationController *)tab.selectedViewController;
        base.gestureRecognizerEnabled = NO;
    }
}

- (void)dealloc {
    UITabBarController * tab =  (UITabBarController *)[SLAppDelegate sharedDelegate].window.rootViewController;
    BaseNavigationController * base = (BaseNavigationController *)tab.selectedViewController;
    base.gestureRecognizerEnabled = YES;
}

/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    
    @weakify(self);
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"订单详情" backAction:^{
        @strongify(self);
        if (self.isOrderList) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    
}


///  请求订单详情
- (void)_requestOrderDetailData {
    
    NSString * url = @"UOrder/orderInfo";
    SLParameter * params = [SLParameter new];
    params.order_id = self.order_id;
    
    [TSNetworking POSTWithURL:url paramsModel:params needProgressHUD:!_isFirst completeBlock:^(SLBaseModel *request) {
  
        SLLog(request);
        [_hud removeFromSuperview];
        if ([request.flag isEqualToString:@"error"]) {
            SVShowError(request.message); return ;
        }
        self.orderDetail = [_SLOrderDetail yy_modelWithDictionary:request.data];
        if (self.orderDetail.status < 1) {
            self.orderDetail.status =1;
        } else if (self.orderDetail.status > 3) {
            self.orderDetail.status = 3;
        }
        [self.tableView reloadData];
        _isFirst = NO;
        
        [self _setupBtns];
        
    } failBlock:^(NSError *error) {
        [_hud removeFromSuperview];
        SLShowNetworkFail;
        SLLog(error);
    }];
    
}

///  删除订单
- (void)_requestDeleteOrder   {
    
    NSString * url = @"UOrder/deleteOrder";
    SLParameter * params = [SLParameter new];
    params.order_id = self.orderDetail.order_id;
    
    [TSNetworking POSTWithURL:url paramsModel:params needProgressHUD:YES completeBlock:^(SLBaseModel *request) {
        SLLog(request);
        if ([request.flag isEqualToString:@"error"]) {
            SVShowError(request.message);
            return ;
        }
        SVShowSuccess(request.message);
        [User sharedUser].needRefreshOrder = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
    
}

///  投诉
- (void)_requestComplainOrder{
    
    NSString * url = @"UOrder/complaintsOrder";
    SLParameter * params = [SLParameter new];
    params.order_id = self.orderDetail.order_id;
    
    [TSNetworking POSTWithURL:url paramsModel:params needProgressHUD:YES completeBlock:^(SLBaseModel *request) {
        SLLog(request);
        if ([request.flag isEqualToString:@"error"]) {
            SVShowError(request.message); return ;
        }
        BLOCK_SAFE_RUN(self.vBlock);
        SVShowSuccess(request.message);
        [self _requestOrderDetailData];
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
    
}

///  确认收货
- (void)_requestConfirUOrder {
    NSString * url = @"UOrder/confirUOrder";
    SLParameter * params = [SLParameter new];
    params.order_id = self.order_id;
    
    [TSNetworking POSTWithURL:url paramsModel:params needProgressHUD:YES completeBlock:^(SLBaseModel *request) {
        SLLog(request);
        if ([request.flag isEqualToString:@"error"]) {
            SVShowError(request.message); return ;
        }
        BLOCK_SAFE_RUN(self.vBlock);
        SVShowSuccess(request.message);
        [self _requestOrderDetailData];
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
}

#pragma mark - UITabbleViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderDetail ? 1 : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DetailsCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detail = self.orderDetail;
    return cell;
}

#pragma mark - UITabbleViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    DetailsHeadView * headerView = [DetailsHeadView creatViewFromNib];
    headerView.frame = CGRectMake(0, 69, kScreenWidth, headerView.height);
    headerView = headerView;
    headerView.detail = self.orderDetail;
    return headerView;
}

///创建tabbleViewFooter
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (!self.orderDetail) return nil;
    DetailsFooterView * footerView =  [[NSBundle mainBundle]loadNibNamed:@"DetailsFooterView" owner:nil options:nil].firstObject;
    footerView.frame = CGRectMake(0, 0, kScreenWidth, footerView.height);
    footerView.detail = self.orderDetail;
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 217;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 290;
}

///  处理按钮的事件
///
///  @param btnTitle 按钮的文字
///  @param order    对应的模型
- (void)_handleBtnAction:(UIButton *)btn {
    /*
     status=2并且r_m_verify=0 并且is_complaints=0订单状态：待收货，      显示按钮：查看物流
     status=2 并且r_m_verify=1 并且is_complaints=0，订单状态：待收货，   显示按钮：查看物流，投诉，确认收货
     status=2 并且r_m_verify=1 并且is_complaints=1 订单状态：已投诉，    显示按钮：无
     status=3 订单状态：待评价，                                       显示按钮：立即评价
     status=4 订单状态：已完成，                                       显示按钮：删除订单*/
    NSString * btnTitle = btn.currentTitle;
    if ([btnTitle isEqualToString:@"投诉"]) {
        [SLAlertView alertViewWithTitle:@"确定要投诉吗" cancelBtn:@"取消" destructiveButton:@"确定" otherButtons:nil clickAtIndex:^(NSInteger buttonIndex) {
            [self _requestComplainOrder];
        }];
    } else if ([btnTitle isEqualToString:@"确认收货"]) {
        [SLAlertView alertViewWithTitle:@"确定要收货吗" cancelBtn:@"取消" destructiveButton:@"确定" otherButtons:nil clickAtIndex:^(NSInteger buttonIndex) {
            [self _requestConfirUOrder];
        }];
    } else if ([btnTitle isEqualToString:@"删除订单"]) {
        [SLAlertView alertViewWithTitle:@"确定要删除订单吗" cancelBtn:@"取消" destructiveButton:@"确定" otherButtons:nil clickAtIndex:^(NSInteger buttonIndex) {
            [self _requestDeleteOrder];
        }];
    } else if ([btnTitle isEqualToString:@"查看物流"]) {
        SVShowError(@"该功能暂未开放");
        return;
    } else if ([btnTitle isEqualToString:@"立即评价"]) {
        SLAddEvaluationVC * controller = [[SLAddEvaluationVC alloc] init];
        controller.order_id = self.orderDetail.order_id;
        controller.vBlock = ^{
            BLOCK_SAFE_RUN(self.vBlock);
            [self _requestOrderDetailData];
        };
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
}
///  设置底部3个按钮
- (void)_setupBtns {
    
    if ([self _rightBtnIsHidden]) {
        [self.bottomView.superview removeFromSuperview];
        self.tableView.height += 50;
        return;
    }
    
    UIButton * left  = [self.bottomView viewWithTag:1];
    UIButton * middle  = [self.bottomView viewWithTag:2];
    UIButton * right  = [self.bottomView viewWithTag:3];
    
    left.title = [self _leftBtnTitle];
    left.hidden = [self _leftBtnIsHidden];
    
    right.title = [self _rigthBtnTitle];
    right.hidden = [self _rightBtnIsHidden];
    
    middle.title = [self _middleBtnTitle];
    middle.hidden = left.isHidden;
}
- (BOOL)_leftBtnIsHidden {
    if ((self.orderDetail.status == 2 && self.orderDetail.r_m_verify && self.orderDetail.is_complaints)) {
        return NO;
    }
    return YES;
    /*用户端订单说明文档
     status=1:订单状态：待发货，                                       显示按钮：无
     status=2并且r_m_verify=0 并且is_complaints=0订单状态：待收货，      显示按钮：查看物流
     status=2 并且r_m_verify=1 并且is_complaints=0，订单状态：待收货，   显示按钮：查看物流，投诉，确认收货
     status=2 并且r_m_verify=1 并且is_complaints=1 订单状态：已投诉，    显示按钮：无
     status=3 订单状态：待评价，                                       显示按钮：立即评价
     status=4 订单状态：已完成，                                       显示按钮：删除订单
     */
}

- (BOOL)_rightBtnIsHidden {
    NSInteger status = self.orderDetail.status;
    if (status == 1 || (status == 2 && self.orderDetail.r_m_verify && self.orderDetail.is_complaints)) {
        return YES;
    }
    return NO;
}

- (NSString *)_leftBtnTitle {
    return @"查看物流";
}
- (NSString *)_middleBtnTitle {
    return @"投诉";
}
- (NSString *)_rigthBtnTitle {
    
    static NSArray * _statusArray;
    
    if (_statusArray == nil) {
        _statusArray = @[@"", @"", @"立即评价", @"删除订单"];
    }
    
    if (self.orderDetail.status == 2) {
        if (self.orderDetail.r_m_verify == 0 && self.orderDetail.is_complaints == 0) {
            return @"查看物流";
        } else if (self.orderDetail.r_m_verify == 1 && self.orderDetail.is_complaints == 0) {
            return @"确认收货";
        }
        return @"";
    }
    
    return _statusArray[self.orderDetail.status - 1];
}
@end
