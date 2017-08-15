//
//  LFChangeCloseViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFChangeCloseViewController.h"
#import "LFChangeCloseCell.h"
#import "LFChangeColoseViewController.h"
#import "SLEmptyView.h"
#import "LFPreferencesView.h"
#import "LFPreferenceViewController.h"

@interface LFChangeCloseViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray * datas;
@property (nonatomic, strong) UITableView * tabbleView;
@property (nonatomic, strong) UIButton * changeBtn;
@property (nonatomic, strong) SLEmptyView * emptyView;
@end

@implementation LFChangeCloseViewController
{
    NSString * _startPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = [NSMutableArray array];
    self.view.backgroundColor =  HexColorInt32_t(F1F1F1);
    _startPage = @"0";
    // 设置导航栏
    [self setupNavigationBar];
    
    [self CreateView];
    [self _requestApplyList];
    
}
/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    
    @weakify(self);
    
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"我要换装" backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

///创建界面
-(void)CreateView{
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
    tabbleView .backgroundColor =  HexColorInt32_t(F1F1F1);
    [self.view addSubview:tabbleView];
    self.tabbleView = tabbleView;
    tabbleView.tableHeaderView = [self _tableHeaderView];
    tabbleView.tableFooterView = [UIView new];
    
    
    
    
    UIButton *button  = [UIButton buttonWithTitle:@"申请换衣" titleColor:HexColorInt32_t(C00D23) backgroundColor:nil font:Fit(14) image:nil frame:Rect(Fit(15), kScreenHeight - Fit(44), kScreenWidth -Fit(30), Fit(36))];
    button.borderColor = HexColorInt32_t(C00D23);
    button.borderWidth = 1;
    [button addTarget:self action:@selector(TapBtn)];
    [self.view addSubview:button];
    self.changeBtn = button;
    
    [self.view addSubview:self.emptyView];
    
    @weakify(self);
    tabbleView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self _requestApplyList];
    }];
}

- (UIView *)_tableHeaderView {
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Fit375(74))];
    headerView.backgroundColor = HexColorInt32_t(f6f6f6);
    LFPreferencesView * preferencesView = [LFPreferencesView creatViewFromNib];
    preferencesView.frame = Rect(0, headerView.height-Fit375(10)-Fit375(51) , headerView.width, Fit375(51));
    @weakify(self);
    preferencesView.didSelectPreferenceBtn =^{
        @strongify(self);
        LFPreferenceViewController * prefrerView = [[LFPreferenceViewController alloc]init];
        [self.navigationController pushViewController:prefrerView animated:YES];
    };
    [headerView addSubview:preferencesView];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LFChangeCloseCell * cell = [LFChangeCloseCell cellWithTableView:tableView];
    if (self.datas.count > 0) {
        LFapplyFaceliftListModel * model = self.datas[indexPath.row];
        [cell setModel:model];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Fit375(116);
}

-(void)_requestApplyList{
    NSString * url =@"personal/applyFaceliftList.htm?";
    
    LFParameter *paeme = [LFParameter new];
    paeme.loginKey = user_loginKey;
    paeme.startPage = _startPage;
    
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        SLEndRefreshing(self.tabbleView);
        if ([request[@"result"]integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        NSArray *array =[NSArray yy_modelArrayWithClass:[LFapplyFaceliftListModel class] json:request[@"goodsList"]];
        
        [self.datas addObjectsFromArray:array];
        [self.tabbleView reloadData];
        
        if (self.datas.count) {
            [self.emptyView removeFromSuperview];
        }
        _startPage = request[@"startPage"];
        if (_startPage.integerValue == [request[@"totalPage"] integerValue]) {
            [self.tabbleView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failBlock:^(NSError *error) {
        SLLog(error);
        SLEndRefreshing(self.tabbleView);
    }];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LFapplyFaceliftListModel * model = self.datas[indexPath.row];
    model.select = !model.select;
    [self.tabbleView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
 
}

-(void)TapBtn{
    
    NSMutableArray * arr = @[].mutableCopy;
    
    for (LFapplyFaceliftListModel * model in self.datas) {
        if (model.select) {
            [arr addObject:model];
        }
    }
    
    if (!arr.count) {
        SVShowError(@"请选择需要换的服装");
        return;
    }
 
    
    LFChangeColoseViewController * close = [[LFChangeColoseViewController alloc] init];
    close.datasArray = [arr copy];
    close.vBlock = ^{
        [self.datas removeObjectsInArray:arr];
        [self.tabbleView reloadData];
        if (!self.datas.count) {
            [self.view addSubview:self.emptyView];
        }
    };
    [self.navigationController pushViewController: close animated:YES];
     
}



- (SLEmptyView *)emptyView {
    if (!_emptyView) {
        CGFloat y = 64 + Fit(74);
        _emptyView = [[SLEmptyView alloc] initWithFrame:Rect(0, y, kScreenWidth, kScreenHeight - y)];
    }
    return _emptyView;
}

@end
