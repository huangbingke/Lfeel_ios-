//
//  LFElutionViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/6.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFElutionViewController.h"
#import "BarEvaluationCell.h"
#import "LFEmptyView.h"
#import "SLEmptyView.h"

@interface LFElutionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) LfGoodsDetailEvlutionMode  *model;
@property (nonatomic, strong) SLEmptyView * emptyView;
@property (strong, nonatomic) UITableView  *tabbleView;
@property (strong, nonatomic) NSMutableArray  *datas;

@end

@implementation LFElutionViewController
{
    NSString * startPage1;
    
    
    NSArray* dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self CreateView];
    self.datas = [NSMutableArray array];
    SLEmptyView * EmptyView = [[SLEmptyView alloc]initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-64)];
    [self.view addSubview:EmptyView];
    self.emptyView = EmptyView;
    EmptyView.hidden = YES;
    startPage1 = @"0";
    [self HTTPRequestcommentsList];
    
    

}

/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    
    @weakify(self);
    
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"评论" backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated: YES];
    }];
    
}

-(void)CreateView{
    
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:Rect(0,64 , kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
    [self.view addSubview:tabbleView];
    tabbleView.separatorStyle = UITableViewCellAccessoryNone;
    
    self.tabbleView = tabbleView;
    
    @weakify(self);
    self.tabbleView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self HTTPRequestcommentsList];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BarEvaluationCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BarEvaluationCell"];
    if (cell == nil) {
        cell = [[BarEvaluationCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"BarEvaluationCell"];
    }
    if (self.datas.count >0) {
        [cell setEvaluation:self.datas[indexPath.row]];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.datas.count > 0) {

        for (LfGoodsDetailEvlutionCommentsListModel * model  in self.datas) {
            if (model.commentsImg.count > 0) {
                return Fit375(161);
            }else{
                return Fit375(85);
            }
        }
 
    }
    
    return 0;
}


#pragma mark - 评论列表

-(void)HTTPRequestcommentsList
{
    NSString * url = @"manage/commentsList.htm?";
    LFParameter * param = [LFParameter new];
    param.startPage = startPage1;
    param.goodsId = self.goodsId;
    [TSNetworking POSTWithURL:url paramsModel:param completeBlock:^(NSDictionary *request) {
        SLLog(request);
    
        if ([request[@"result"] integerValue]!= 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        NSArray * arr = [NSArray yy_modelArrayWithClass:[LfGoodsDetailEvlutionCommentsListModel class] json:request[@"commentsList"]];
        
        if (!arr.count && !self.datas.count) {
            self.emptyView.hidden = NO;
            return;
        }
        
        [self.datas addObjectsFromArray:arr];
        [self.tabbleView reloadData];
        
        startPage1 = request[@"startPage"];
        if (startPage1.integerValue == [request[@"totalPage"] integerValue]) {
            [self.tabbleView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
    } failBlock:^(NSError *error) {
        SLLog(error);
    }];
    
}




@end
