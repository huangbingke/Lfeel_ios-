//
//  LFShopCartViewController.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/1.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFShopCartViewController.h"
#import "LFShopcartView.h"
#import "LFSettleCenterVC.h"
#import "LFShopCartModels.h"
#import "LFPayHelper.h"
#import "LHSegmentControlView.h"
#import "LHMyBoxCell.h"
#import "LHPackingBoxView.h"
#import "SLEmptyView.h"
#import "LFPackSuccessViewController.h"
#import "LFPackViewController.h"
#import "LFVipViewController.h"

///order/application.htm?user_id=&type=&remark=&bank_no=&price=



@interface LFShopCartViewController ()
<UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate>
@property (nonatomic,   weak) UITableView * tableView;
@property (nonatomic, strong) UIView * emptyView;
@property (nonatomic, strong) UIView * emptyBoxView;

@property (nonatomic,   copy) NSArray<LFShopCart *> * shopCartsData;
@property (nonatomic,   weak) LFShopcartBottomView * bottomView;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) UIScrollView *boxScrollView;
@property (nonatomic, strong) UITableView *myBoxTableView;

@property (nonatomic, strong) NSMutableArray<LFGoods *> * datas;
@property (nonatomic, assign, getter=isRefreshing) BOOL refreshing;

@property (nonatomic, assign) CGFloat boxHeigh;
@end

@implementation LFShopCartViewController{
    NSInteger startPage;
}

#pragma mark - Life circle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestBoxStatus];
    [self _requestShopCartData];
    startPage = 0;
    [self.datas removeAllObjects];
    [self HTTPRequset];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    startPage = 0;

    self.datas = [NSMutableArray array];
    
    [self setupSubViews];

    [self setupNavigationBar];
    
    self.isFirst = YES;
    
}


///  初始化子控件
- (void)setupSubViews {
    CGFloat f = 49;
    if (self.isSubPage) {
        f = 0;
        self.boxScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-f-64)];
        self.boxScrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight-f);
        self.boxScrollView.pagingEnabled = YES;
        self.boxScrollView.scrollEnabled = NO;
        [self.view addSubview:self.boxScrollView];
        self.boxScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    } else {
        self.boxScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-f-64)];
        self.boxScrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight-f);
        self.boxScrollView.pagingEnabled = YES;
        self.boxScrollView.scrollEnabled = NO;
        [self.view addSubview:self.boxScrollView];
    
    }
    LFShopcartBottomView * bottomView = [LFShopcartBottomView creatView];
    CGFloat h = Fit(bottomView.height);
    self.boxHeigh = h;
    bottomView.frame = Rect(kScreenWidth, kScreenHeight -64- f - h, kScreenWidth, h);
    [self.boxScrollView addSubview:bottomView];
    
        @weakify(self);
        bottomView.didClickSettleBtnBlock = ^{
            @strongify(self);
            NSMutableString * str = [NSMutableString new];
            for (LFShopCart * cart in self.shopCartsData) {
                for (LFGoods *goods in cart.shoppingCartList) {
                    if (goods.isSelected == NO) continue;
                    [str appendFormat:@"%@;", goods.goodsCartId];
                }
            }
            SLAssert(str.length, @"您未选择任何商品");
            [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
            LFSettleCenterVC * controller = [[LFSettleCenterVC alloc] init];
            controller.goodsCartIds = str;
            [self.navigationController pushViewController:controller animated:YES];
        };
        bottomView.didSelectedAllBtnBlock = ^{
            @strongify(self);
            BOOL select = self.bottomView->_statusImageView.isHighlighted;
            for (LFShopCart * cart in self.shopCartsData) {
                cart.selected = select;
                for (LFGoods *goods in cart.shoppingCartList) {
                    goods.selected = select;
                }
            }
            [self.tableView reloadData];
            [self _checkStatus];
        };
        self.bottomView = bottomView;
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:Rect(kScreenWidth, 0, kScreenWidth, kScreenHeight - 64 - f - h) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = Fit(114);
    [self.boxScrollView addSubview:tableView];
    self.tableView = tableView;
    
    
    self.myBoxTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - f - h) style:(UITableViewStylePlain)];
    self.myBoxTableView.delegate = self;
    self.myBoxTableView.dataSource = self;
    self.myBoxTableView.backgroundColor = RGBColor(246, 246, 246);
    self.myBoxTableView.tableFooterView = [[UIView alloc] init];
    [self.boxScrollView addSubview:self.myBoxTableView];
    [self.myBoxTableView.mj_header beginRefreshing];
    self.myBoxTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        startPage = 0;
        self.refreshing = YES;
        [self HTTPRequset];
    }];
    self.myBoxTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self HTTPRequset];
    }];

}


///  设置自定义导航条
- (void)setupNavigationBar {
    __weak typeof(self) weakself = self;
    LHSegmentControlView *segView = [[LHSegmentControlView alloc] initWithFrame:CGRectMake((kScreenWidth-150)/2, 20, 150, 42) titleArray:@[@"换衣盒", @"购物车"] titleFont:[UIFont systemFontOfSize:15] titleDefineColor:[UIColor blackColor] titleSelectedColor:[UIColor redColor]];
    [segView clickTitleButtonBlock:^(NSInteger index) {
        if (index == 0) {
            weakself.boxScrollView.contentOffset = CGPointMake(0, 0);
        } else {
            weakself.boxScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
        }
    }];
    UIView *nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    nav.backgroundColor = RGBColor(245, 245, 245);
    [nav addSubview:segView];
    self.ts_navgationBar = (TSNavigationBar *)nav;
    
    if (self.isSubPage) {
        UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [backBtn setImage:[UIImage imageNamed:@"返回-黑"] forState:(UIControlStateNormal)];
        backBtn.frame = CGRectMake(10, 27, 25, 25);
        [backBtn addTarget:self action:@selector(backBtnAction)];
        [nav addSubview:backBtn];
        
        //判断上个页面是点击哪个按钮进来的, 对应上相应的scrollView的偏移量
        for (UIView *btn in [segView subviews]) {
            if ([btn isKindOfClass:[UIButton class]]) {
                if (btn.tag == 1 + 3000) {
                    [(UIButton *)btn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
                    [UIView animateWithDuration:0.25 animations:^{
                        CGPoint point = segView.sliderView.center;
                        point.x = segView.sliderView.center.x + 75;
                        segView.sliderView.center = point;
                    }];
                } else {
                    [(UIButton *)btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
                }
                NSLog(@"%@", btn);
            }
        }
    }
}

#pragma mark - Actions
- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Networking
///  请求购物车数据
- (void)_requestShopCartData {
    NSString * url = @"shoppingCart/goodsCart.htm?";
    LFParameter * parameter = [LFParameter new];
    [parameter appendBaseParam];
    
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:self.isFirst completeBlock:^(NSDictionary *request) {
//        SLLog(request);
        self.isFirst = NO;
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        NSMutableArray * arr = [NSArray yy_modelArrayWithClass:[LFShopCart class] json:request[@"shoppingCartInfoList"]].mutableCopy;
        NSMutableIndexSet * set = [NSMutableIndexSet new];
        [arr enumerateObjectsUsingBlock:^(LFShopCart *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!obj.shoppingCartList.count) [set addIndex:idx];
        }];
        if (set.count) [arr removeObjectsAtIndexes:set];
        self.shopCartsData = [arr copy];
        [self.tableView reloadData];
        if (!self.shopCartsData.count) {
            [self.boxScrollView addSubview:self.emptyView];
        } else {
            [self.emptyView removeFromSuperview];
        }
        [self _checkStatus];
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
    
}

///  删除购物车
- (void)_requestDeleteShopCartData:(LFGoods *)goods indexPath:(NSIndexPath *)indexPath {
    NSString * url = @"shoppingCart/deleteShoppingCar.htm";
    LFParameter * parameter = [LFParameter new];
    parameter.goodsCartIds = goods.goodsCartId;
    
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
//        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        
        LFShopCart * cart = self.shopCartsData[indexPath.section];
        NSMutableArray * arr = [cart.shoppingCartList mutableCopy];
        [arr removeObject:goods];
        cart.shoppingCartList = [arr copy];


        NSInteger i = 0;
        NSMutableIndexSet * set = [NSMutableIndexSet new];
        for (LFShopCart * c in self.shopCartsData) {
            if (c.shoppingCartList.count == 0) {
                [set addIndex:i];
            }
            i++;
        }
        if (set.count) {
            NSMutableArray * arr = self.shopCartsData.mutableCopy;
            [arr removeObjectsAtIndexes:set];
            self.shopCartsData = [arr copy];
        }
        [self.tableView reloadData];
        
        if (!self.shopCartsData.count) {
            [self.boxScrollView addSubview:self.emptyView];
        }
        [self _checkStatus];
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
}

//我的喜爱
-(void)HTTPRequset{
    NSString * url =@"personal/perPreferenceList.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.loginKey = user_loginKey;
    paeme.startPage =stringWithInt(startPage);
    @weakify(self);
    [self.myBoxTableView.mj_footer resetNoMoreData];
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        @strongify(self);
//        SLLog(request);
        SLEndRefreshing(self.myBoxTableView);
        if ([request[@"result"] integerValue]!= 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        if (self.isRefreshing) {
            self.refreshing = NO;
            [self.datas removeAllObjects];
        }
        NSArray *arr = [NSArray  yy_modelArrayWithClass:[LFGoods class] json:request[@"collectioList"]];
        
        startPage = [request[@"startPage"] integerValue];
        NSString * totalPage  = request[@"totalPage"];
        if (startPage == [totalPage integerValue]) {
            [self.myBoxTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.datas addObjectsFromArray:arr];
        
        if (!self.datas.count) {
            [self.boxScrollView addSubview:self.emptyBoxView];
        } else {
            [self.emptyBoxView removeFromSuperview];
        }
        
        
        [self.myBoxTableView reloadData];
    } failBlock:^(NSError *error) {
        SLEndRefreshing(self.myBoxTableView);
        SLShowNetworkFail;
    }];
}



//取消收藏
- (void)HTTPRequestDeleteCollectionData:(LFGoods *)goods indexPath:(NSIndexPath *)indexPath {
    NSString * url =@"personal/delCollectio.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.goodsId = goods.goodsId;
    
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
//        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        
        if (self.datas.count) {
            NSMutableArray *arrs = self.datas.mutableCopy;
            [arrs removeObjectAtIndex:indexPath.row];
            self.datas = arrs.mutableCopy;
            [self.myBoxTableView reloadData];
            
        }
        if (self.datas.count == 0) {
                startPage = 0;
                [self HTTPRequset];
        }
        if (!self.datas.count) {
            [self.myBoxTableView reloadData];
            
            [self.boxScrollView addSubview:self.emptyBoxView];
        }
        [self.myBoxTableView reloadData];
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
    
}

/*盒子状态*/
- (void)requestBoxStatus {
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    LFParameter *paeme = [LFParameter new];
    paeme.user_id = dic[@"user_id"];
    NSString *url = @"order/check.htm?";
    paeme.user_id = dic[@"user_id"];
    paeme.type = @"2";
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
//        self.boxStatus = [request[@"result"] integerValue];
        CGFloat f = 49;
        if (self.isSubPage) f = 0;
        if ([request[@"result"] integerValue] == 401) {
            [[NSUserDefaults standardUserDefaults] setObject:request[@"application_id"] forKey:@"application_id"];
            LHPackingBoxView *packView = [[LHPackingBoxView alloc] initWithFrame:CGRectMake(0, kScreenHeight-64-f-self.boxHeigh, kScreenWidth, self.boxHeigh) packingStatusString:@"   将乐荟盒子中要换的商品寄回" packingButtonTitle:@"寄回盒子"];
            [packView clickPackingButtonBlock:^(NSString *packBtnTitle) {
                LFPackViewController *packVC = [[LFPackViewController alloc] init];
                packVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:packVC animated:YES];
            }];
            [self.boxScrollView addSubview:packView];
        } else if ([request[@"result"] integerValue] == 200){
            LHPackingBoxView *packView = [[LHPackingBoxView alloc] initWithFrame:CGRectMake(0, kScreenHeight-64-f-self.boxHeigh, kScreenWidth, self.boxHeigh) packingStatusString:@"   随机打包三件给你" packingButtonTitle:@"打包盒子"];
            [packView clickPackingButtonBlock:^(NSString *packBtnTitle) {
                if ([[User getUseDefaultsOjbectForKey:kVipStatus] integerValue] != 1) {
                    LFVipViewController *vipVC = [[LFVipViewController alloc] init];
                    vipVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vipVC animated:YES];
                    
                } else {
                    [self requestPackBoxData];
                }
                
            }];
            [self.boxScrollView addSubview:packView];
        }
    } failBlock:^(NSError *error) {
        SLLog(error);
    }];
}

- (void)requestPackBoxData {
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    NSString * url =@"order/application.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.user_id = dic[@"user_id"];
    paeme.type = @"2";
    paeme.price = @"";
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] == 200) {
            LFPackSuccessViewController *packVC = [[LFPackSuccessViewController alloc] init];
            packVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:packVC animated:YES];
        } else {
            SVShowError(request[@"msg"]);
            
        }
        
    } failBlock:^(NSError *error) {
        SLLog(error);
    }];
    
    
}

#pragma mark - Delegate

#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return self.shopCartsData.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.shopCartsData[section].shoppingCartList.count;
    } else {
        return self.datas.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        LFShopcartCell * cell = [LFShopcartCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.goods = self.shopCartsData[indexPath.section].shoppingCartList[indexPath.row];
        if (!cell.didClickStautsBtnBlock) [cell setDidClickStautsBtnBlock:^(LFShopcartCell *x) {
            NSIndexPath * path = [self.tableView indexPathForCell:x];
            LFShopCart * cart = self.shopCartsData[path.section];
            BOOL all = YES;
            for (LFGoods * goods in cart.shoppingCartList) {
                if (!goods.isSelected) {
                    all = NO;
                    break;
                }
            }
            cart.selected = all;
            [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:path.section] withRowAnimation:UITableViewRowAnimationNone];
            [self _checkStatus];
        }];
        return cell;
    } else {
        LHMyBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LHMyBoxCell"];
        if (cell == nil) {
            cell = [[LHMyBoxCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"LHMyBoxCell"];
        }
        
        cell.goods = self.datas[indexPath.row];
        cell.delegate = self;
        return cell;
    
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        LFShopcartHeaderView * header = [LFShopcartHeaderView creatView];
        header.frame = Rect(0, 0, kScreenWidth, Fit(header.height));
        header.cart = self.shopCartsData[section];
        UITapGestureRecognizer * tap = [UITapGestureRecognizer new];
        @weakify(self);
        [tap.rac_gestureSignal subscribeNext:^(UITapGestureRecognizer * x) {
            @strongify(self);
            LFShopcartHeaderView * h = (LFShopcartHeaderView *)x.view;
            h.cart.selected = !h.cart.isSelected;
            BOOL select = h.cart.isSelected;
            for (LFGoods * goods in h.cart.shoppingCartList) {
                goods.selected = select;
            }
            [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:[self.shopCartsData indexOfObject:h.cart]] withRowAnimation:UITableViewRowAnimationNone];
            [self _checkStatus];
            
        }];
        [header addGestureRecognizer:tap];
        return header;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return Fit(40);
    } else {
        return 0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        UIView * footer = [UIView viewWithBgColor:nil frame:Rect(0, 0, kScreenWidth, Fit(15))];
        return footer;
    } else {
        return nil;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return Fit(15);
    } else {
        return 0;
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.myBoxTableView) {
        return 115;
    } else {
        return 115;
    }
}



- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion {
    if ([cell isKindOfClass:[LFShopcartCell class]]) {
        [LFShopcartAlertView alertWithTitle:@"确定要删除？" clickSureAction:^{
            LFShopcartCell * x = (LFShopcartCell *)cell;
            NSIndexPath * path = [self.tableView indexPathForCell:x];
            [self _requestDeleteShopCartData:x.goods indexPath:path];
        }];
    } else {
        [LFShopcartAlertView alertWithTitle:@"确定要删除？" clickSureAction:^{
            LHMyBoxCell *bCell = (LHMyBoxCell *)cell;
            NSIndexPath *path = [self.myBoxTableView indexPathForCell:bCell];
            [self HTTPRequestDeleteCollectionData:bCell.goods indexPath:path];
        }];
        NSLog(@"删除我的收藏");
        
    }
    return NO;
}





#pragma mark - Private
///  检查状态
- (void)_checkStatus {
    
    BOOL all = YES;
    double price = 0;
    for (LFShopCart * cart in self.shopCartsData) {
        
        if (cart.isSelected == NO) {
            all = NO;
        }
        
        for (LFGoods *goods in cart.shoppingCartList) {
            if (goods.isSelected == NO) continue;
            price += (goods.sellingPrice.doubleValue) * goods.goodsNum.integerValue;
        }
    }
    self.bottomView->_totalPrice.text = [NSString stringWithFormat:@"总价：￥%@", stringWithDouble(price).formatNumber];
    self.bottomView->_statusImageView.highlighted = all;
//
}

#pragma mark - Public


#pragma mark - Getter\Setter
- (UIView *)emptyView {
    if (_emptyView) return _emptyView;
    
    CGFloat f = 49;
    if (self.isSubPage) f = 0;
    UIView * emptyView = [UIView viewWithBgColor:HexColorInt32_t(f0f1f2) frame:Rect(kScreenWidth, 0, kScreenWidth, kScreenHeight - 64 - f)];
    _emptyView = emptyView;
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"空盒子"]];
    imageView.center = Point(kHalfScreenWidth, emptyView.height * 0.345);
    [emptyView addSubview:imageView];
    
    UILabel * label = [UILabel labelWithText:@"购物车空空如也~" font:Fit(12) textColor:HexColorInt32_t(999999) frame:Rect(0, imageView.maxY + Fit(15), 1, 1)];
    [label sizeToFit];
    label.centerX = kHalfScreenWidth;
    [emptyView addSubview:label];
    
    UIColor * color = HexColorInt32_t(bb132a);
    UIButton * btn = [UIButton buttonWithTitle:@"去逛逛新品" titleColor:color backgroundColor:nil font:Fit(12) image:nil frame:Rect(0, label.maxY + Fit(35), Fit(185), Fit(35))];
    btn.centerX = label.centerX;
    [btn setCornerRadius:0 borderWidth:1 borderColor:color];
    [emptyView addSubview:btn];
    
    @weakify(self);
    [[btn rac_touchupInsideSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.tabBarController.selectedIndex = 1;
    }];
    return _emptyView;
}

- (UIView *)emptyBoxView {
    if (_emptyBoxView) return _emptyBoxView;
    
    CGFloat f = 49;
    if (self.isSubPage) f = 0;
    UIView * emptyView = [UIView viewWithBgColor:HexColorInt32_t(f0f1f2) frame:Rect(0, 0, kScreenWidth, kScreenHeight - 64 - f)];
    _emptyBoxView = emptyView;
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"空盒子"]];
    imageView.center = Point(kHalfScreenWidth, emptyView.height * 0.345);
    [emptyView addSubview:imageView];
    
    UILabel * label = [UILabel labelWithText:@"换衣盒空空如也~" font:Fit(12) textColor:HexColorInt32_t(999999) frame:Rect(0, imageView.maxY + Fit(15), 1, 1)];
    [label sizeToFit];
    label.centerX = kHalfScreenWidth;
    [emptyView addSubview:label];
    
    UIColor * color = HexColorInt32_t(bb132a);
    UIButton * btn = [UIButton buttonWithTitle:@"去逛逛乐荟盒子吧~" titleColor:color backgroundColor:nil font:Fit(12) image:nil frame:Rect(0, label.maxY + Fit(35), Fit(185), Fit(35))];
    btn.centerX = label.centerX;
    [btn setCornerRadius:0 borderWidth:1 borderColor:color];
    [emptyView addSubview:btn];
    
    @weakify(self);
    [[btn rac_touchupInsideSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.tabBarController.selectedIndex = 0;
    }];
    return _emptyBoxView;
}
































@end

