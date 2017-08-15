//
//  LFUsedViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFUsedViewController.h"
#import "LFUsedViewHeaderView.h"
#import "LFUsedCell.h"
#import "LFRentalrecordViewController.h"
#import "LFNewRentViewController.h"
#import "SLEmptyView.h"

@interface LFUsedViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) LFUsedViewHeaderView * usedHeaderView;
@property (strong, nonatomic)  NSMutableArray  *datas;
@property (strong, nonatomic) UITableView  *tabbleView;
@property (nonatomic, strong) SLEmptyView * emptyView;
@end

@implementation LFUsedViewController
{
    UIView *HeaderView;
    NSInteger startPage;
    BOOL _isRefresh;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = [NSMutableArray array];
    
    startPage = 0;
    [self setupNavigationBar];
    [self CreateView];
 
}

/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    @weakify(self);
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"闲置出租" rightItem:@"出租记录" rightAction:^{
        SLLog2(@"出租记录");
        @strongify(self);
        LFRentalrecordViewController * rental = [[LFRentalrecordViewController alloc]init];
        [self.navigationController pushViewController:rental animated:YES];
    } backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}



-(void)CreateView{
    self.view.backgroundColor = HexColorInt32_t(f1f1f1);
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:Rect(0, 64, kScreenWidth , kScreenHeight - 64)style:UITableViewStyleGrouped];
    tabbleView.backgroundColor = HexColorInt32_t(f1f1f1);
    tabbleView.dataSource = self;
    tabbleView.delegate = self;
    [self.view addSubview:tabbleView];
    tabbleView.tableFooterView = [UIView new];
    self.tabbleView = tabbleView;
    
    tabbleView.height -= Fit(72);
    UIButton * new  = [UIButton buttonWithTitle:@"新增出租" titleColor:HexColorInt32_t(C00D23) backgroundColor:HexColorInt32_t(f1f1f1) font:13 image:@"" frame:Rect(Fit375(13), kScreenHeight-Fit375(62) , kScreenWidth - Fit375(26), Fit375(40)) ];
    new.borderColor = HexColorInt32_t(C00D23);
    [new addTarget:self action:@selector(TapPushNewReantVC)];
    new.borderWidth = 1;
    [self.view addSubview:new];
    @weakify(self);
    tabbleView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshdata];
    }];
    
    [tabbleView.mj_header beginRefreshing];
    
    tabbleView.mj_footer =   [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addfrshDataP)];

}


- (void)mainAccountEndRefreshing {
    [self.tabbleView.mj_header endRefreshing];
    [self.tabbleView.mj_footer endRefreshing];
}

-(void)HTTPRequestidleRentList
{
    NSString * url = @"personal/idleRentList.htm?";
    LFParameter * param = [LFParameter new];
    param.loginKey = user_loginKey;
    param.startPage = stringWithInt(startPage);
    
    @weakify(self);
    
    [TSNetworking POSTWithURL:url paramsModel:param completeBlock:^(NSDictionary *request) {
        @strongify(self);
        [self mainAccountEndRefreshing];
      
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        
        
        
        NSArray * array = [NSArray yy_modelArrayWithClass:[LFidleRentListModel class] json:request[@"rentGoodsList"]];
        [self.usedHeaderView setDict:request];
        
        if (!array.count) {
            [self.tabbleView addSubview:self.emptyView];
            return;
        }
        if (_isRefresh) {
            [self.datas removeAllObjects];
            _isRefresh = NO;
        }
        [self.emptyView removeFromSuperview];
        [self.datas addObjectsFromArray:array];
        [self.tabbleView reloadData];
        
        startPage  = [request[@"startPage"] integerValue];
        NSString * totalPage  = request[@"totalPage"];
        if (startPage == [totalPage integerValue]) {
            [self.tabbleView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failBlock:^(NSError *error) {
        [self mainAccountEndRefreshing];
    }];
}
-(void)TapPushNewReantVC{
    LFNewRentViewController *newRen = [[LFNewRentViewController alloc]init];
    [self.navigationController pushViewController:newRen animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    LFUsedCell * cell = [LFUsedCell cellWithTableView:tableView];
    if (self.datas.count > 0) {
        LFidleRentListModel *model = self.datas[indexPath.row];
        [cell setModel:model];
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (HeaderView!= nil) {
        return HeaderView;
    }
    
    HeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Fit375(41))];
    HeaderView.backgroundColor = HexColorInt32_t(f1f1f1);
    self.usedHeaderView = [LFUsedViewHeaderView creatViewFromNib];
    self.usedHeaderView.frame = Rect(0, 0 , HeaderView.width,HeaderView.height );
    [HeaderView addSubview:self.usedHeaderView];
    return HeaderView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Fit375(41);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Fit375(101);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.datas.count > 0) {
        LFidleRentListModel * model = self.datas[indexPath.row];
        LFRentalrecordViewController * rental = [[LFRentalrecordViewController alloc]init];
        rental.goodsId = model.goodsId;
        [self.navigationController pushViewController:rental animated:YES];
    }
    
}

-(void)refreshdata{
    
    _isRefresh = YES;
    startPage = 0;
    [self HTTPRequestidleRentList];
}

-(void)addfrshDataP{
    [self HTTPRequestidleRentList];
}




- (SLEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[SLEmptyView alloc] initWithFrame:Rect(0, Fit(41), kScreenWidth, self.tabbleView.height - Fit(41))];
    }
    return _emptyView;
}


@end
