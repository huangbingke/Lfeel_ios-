//
//  LFRentalrecordViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFRentalrecordViewController.h"
#import "LFRentalView.h"
#import "LFRentalCell.h"
#import "SLEmptyView.h"

@interface LFRentalrecordViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) LFRentalView * rentalHeadView;
@property (nonatomic, strong) NSMutableArray * datas;
@property (nonatomic, strong) UITableView * tabbleView;
@property (strong, nonatomic) LFRecordListModel *model1;
@property (nonatomic, strong) SLEmptyView * emptyView;

@end

@implementation LFRentalrecordViewController
{
    UIView * HeaderView;
    NSInteger startPage ;
    NSString *  totlapage;
    BOOL _isRefresh;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    self.datas = [NSMutableArray array];
    startPage = 0;
    [self CreateView];
    
}

/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    @weakify(self);
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"出租记录"   backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


- (void)mainAccountEndRefreshing {
    [self.tabbleView.mj_header endRefreshing];
    [self.tabbleView.mj_footer endRefreshing];
}

-(void)HTTPRequestRecordList:(BOOL)refrsh{
    NSString * url =@"personal/idleRentRecordList.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.loginKey = user_loginKey;
    paeme.startPage = stringWithInt(startPage);
    @weakify(self);
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:refrsh completeBlock:^(NSDictionary *request) {
        @strongify(self);
        [self mainAccountEndRefreshing];
        
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        SLLog(request);
         [self setHeraderData:request[@"rentGoodsRecord"]];
        NSArray * array  = [NSArray yy_modelArrayWithClass:[LFRentEarningsRecordListModel class] json:request[@"rentGoodsRecord"][@"rentEarningsRecordList"]];
        
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

-(void)CreateView{
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    tabbleView.dataSource = self;
    tabbleView.delegate = self;
    tabbleView.tableFooterView = [UIView new];
    [self.view addSubview:tabbleView];
    self.tabbleView = tabbleView;
    
    @weakify(self);
    tabbleView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self ->_isRefresh = YES;
        [self refreshLoad];
    }];
    
    [tabbleView.mj_header beginRefreshing];
      tabbleView.mj_footer =   [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addRefrshData)];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    
    return self.datas.count;
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LFRentalCell  * cell = [LFRentalCell cellWithTableView:tableView];
    cell.model = self.datas[indexPath.row];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (HeaderView != nil) {
        return HeaderView;
    }
    
    HeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Fit375(169))];
    HeaderView.backgroundColor = HexColorInt32_t(f1f1f1);
    LFRentalView * rentalHeadView = [LFRentalView creatViewFromNib];
    rentalHeadView.frame = Rect(0, 0 , HeaderView.width,HeaderView.height );
    [HeaderView addSubview:rentalHeadView];
    self.rentalHeadView = rentalHeadView;
    return HeaderView;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Fit375(169);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Fit375(88);
}



-(void)setHeraderData:(NSDictionary *)dict{
    
    [self.rentalHeadView setDictData:dict];

}

-(void)refreshLoad{
    _isRefresh = YES;
    startPage = 0;
    [self HTTPRequestRecordList:YES];
}

-(void)addRefrshData{
    [self HTTPRequestRecordList:YES];
    
}
- (SLEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[SLEmptyView alloc] initWithFrame:Rect(0, Fit(169), kScreenWidth, self.tabbleView.height - Fit(169))];
    }
    return _emptyView;
}
@end
