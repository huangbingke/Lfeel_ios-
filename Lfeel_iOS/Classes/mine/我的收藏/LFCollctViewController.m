//
//  LFCollctViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFCollctViewController.h"
#import "LFPreferencesView.h"
#import "LFCollctCell.h"
#import "LFPreferenceViewController.h"
#import "LFGoodsDetailViewController.h"
#import "SLEmptyView.h"

@interface LFCollctViewController ()<UITableViewDelegate,UITableViewDataSource, MGSwipeTableCellDelegate>
@property (nonatomic, strong) LFPreferencesView * heraderView;
@property (nonatomic, strong) NSMutableArray<LFCollectioListModel *>  * datas;
@property (nonatomic, strong) UITableView * tabbleView;
@property (nonatomic, strong) SLEmptyView * emptyView;
@end

@implementation LFCollctViewController
{
    UIView * HeaderView;
    NSInteger startPage;
    NSString * totalPage;
    BOOL _isRefreshing;
    BOOL _isFirst;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self refreshLoad];
    startPage = 0;
    [self.datas removeAllObjects];
    [self HttpRequestCollectionData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexColorInt32_t(f6f6f6);
    self.datas = [NSMutableArray array];
    startPage = 0;
    [self setupNavigationBar];
    [self CreateView];
    _isFirst = YES;
    
}
/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    @weakify(self);
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"我的收藏" backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


-(void)HttpRequestCollectionData {
    NSString * url =@"personal/myCollectio.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.loginKey = user_loginKey;
    paeme.startPage = stringWithInt(startPage);
    [self.tabbleView.mj_footer resetNoMoreData];
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:_isFirst completeBlock:^(NSDictionary *request) {
        _isFirst = NO;
        SLEndRefreshing(self.tabbleView);
        SLLog(request);
        if ([request[@"result"] integerValue] !=200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        NSArray * array = [NSArray yy_modelArrayWithClass:[LFCollectioListModel class] json:request[@"collectioList"]];
        if (!array.count) {
            [self.tabbleView addSubview:self.emptyView];
            return;
        }
        if (_isRefreshing) {
            [self.datas removeAllObjects];
            _isRefreshing = NO;
        }
        [self.emptyView removeFromSuperview];
        [self.datas addObjectsFromArray:array];
        [self.tabbleView reloadData];
        
        startPage  = [request[@"startPage"] integerValue];
        totalPage  = request[@"totalPage"];
        if (startPage == [totalPage integerValue]) {
            [self.tabbleView.mj_footer endRefreshingWithNoMoreData];
        } 
        
    } failBlock:^(NSError *error) {
        SLLog(error);
        SLEndRefreshing(self.tabbleView);
    }];
   
    
}
-(void)HTTPRequestDeleteCollection:(NSIndexPath *)path {
    NSString * url =@"personal/delCollectio.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.goodsId = self.datas[path.row].goodsId;
    
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        [self.datas removeObjectAtIndex:path.row];
        [self.tabbleView reloadData];
        if (!self.datas.count) {
            [self.tabbleView addSubview:self.emptyView];
            return;
        }
        
    } failBlock:^(NSError *error) {
        
    }];
}


-(void)CreateView{
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:Rect(0, 64, kScreenWidth , kScreenHeight - 64)style:UITableViewStylePlain];
    tabbleView.dataSource = self;
    tabbleView.delegate = self;
    tabbleView.backgroundColor = [UIColor clearColor];
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tabbleView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:tabbleView];
    tabbleView.tableFooterView = [UIView new];
    self.tabbleView = tabbleView;
    
    @weakify(self);
    tabbleView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self->startPage = 0;
        self->_isRefreshing = YES;
        [self HttpRequestCollectionData];
    }];
    
    tabbleView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self HttpRequestCollectionData];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LFCollctCell * cell = [LFCollctCell cellWithTableView:tableView];
    [cell setModel:self.datas[indexPath.row]];
    cell.delegate = self;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Fit375(101);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.datas.count > 0) {
        
        LFCollectioListModel * model = self.datas[indexPath.row];
        LFGoodsDetailViewController *  goodsvc = [[LFGoodsDetailViewController alloc]init];
        
        
        goodsvc.goodsId = model.goodsId;
        [self.navigationController pushViewController:goodsvc animated:YES];
    }
    

}
#pragma mark MGSwipeTableCellDelegate
- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion {
    
    NSIndexPath * path = [self.tabbleView indexPathForCell:cell];
    [self HTTPRequestDeleteCollection:path];
    return NO;
}

- (SLEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[SLEmptyView alloc] initWithFrame:self.tabbleView.bounds];
    }
    return _emptyView;
}

@end
