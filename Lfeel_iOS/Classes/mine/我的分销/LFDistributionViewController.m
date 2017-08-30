//
//  LFDistributionViewController.m
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/7/5.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFDistributionViewController.h"
#import "LFDistributionHeaderView.h"
#import "LFDistributionCell.h"
#import "LFDetailRMBCell.h"
#import "LFWithdrawalViewController.h"
#import "LFUserGetRmbModel.h"
@interface LFDistributionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *agentTableView;//代理商

@property (nonatomic, strong) UITableView *userTableView;//用户

@property (nonatomic, strong) UITableView *detailTableView;//明细

@property (nonatomic, strong) UIScrollView *getScrollView;

@property (nonatomic, strong) LFDistributionHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray *agentDataArray;

@property (nonatomic, strong) NSMutableArray *userDataArray;

@property (nonatomic, strong) NSMutableArray *detailArray;

@property (nonatomic, strong) UIView * emptyView;
@property (nonatomic, strong) UIView * emptyUserView;
@property (nonatomic, strong) UIView * emptyDetailView;


@end

@implementation LFDistributionViewController
{
    UIView * HeaderView;
    NSInteger starPage ;
    NSString *totelpage;
    BOOL _isRefreshing;
}

- (NSMutableArray *)agentDataArray {
    if (!_agentDataArray) {
        self.agentDataArray = [NSMutableArray new];
    }
    return _agentDataArray;
}

- (NSMutableArray *)userDataArray {
    if (!_userDataArray) {
        self.userDataArray = [NSMutableArray new];
    }
    return _userDataArray;
}

- (NSMutableArray *)detailArray {
    if (!_detailArray) {
        self.detailArray = [NSMutableArray new];
    }
    return _detailArray;
}


-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self requestMyDistributionData];
        
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self requestUserData];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self HttpRequestIntegralExtrac];

    });
    
}
- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getBtnAction {
    NSLog(@"提现");
    LFWithdrawalViewController *drawaVC = [[LFWithdrawalViewController alloc] init];
    drawaVC.integral = [NSString stringWithFormat:@"%@", self.headerView.allRestLabel.text];
    [self.navigationController pushViewController:drawaVC animated:YES];
}
- (void)setUI {
    self.headerView = [[LFDistributionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
    [self.headerView.backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.headerView.getBtn addTarget:self action:@selector(getBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.headerView];
    
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    if ([dic[@"agent_level"] integerValue] == 1 || [dic[@"agent_level"] integerValue] == 2) {
        LHSegmentControlView *segView = [[LHSegmentControlView alloc] initWithFrame:CGRectMake(0, 250, kScreenWidth, 40) titleArray:@[@"分销商", @"用户", @"明细"] titleFont:[UIFont systemFontOfSize:15] titleDefineColor:[UIColor blackColor] titleSelectedColor:[UIColor redColor]];
        segView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:segView];
        [segView clickTitleButtonBlock:^(NSInteger index) {
            if (index == 0) {
                self.getScrollView.contentOffset = CGPointMake(0, 0);
            } else if (index == 1){
                self.getScrollView.contentOffset = CGPointMake(kScreenWidth, 0);

            }else {
                self.getScrollView.contentOffset = CGPointMake(kScreenWidth*2, 0);
                
            }
        }];
        
        self.getScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 290, kScreenWidth, kScreenHeight-290)];
        self.getScrollView.contentSize = CGSizeMake(kScreenWidth*3, kScreenHeight-290);
        self.getScrollView.pagingEnabled = YES;
        self.getScrollView.scrollEnabled = NO;
        [self.view addSubview:self.getScrollView];        
        
        self.agentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-290) style:(UITableViewStylePlain)];
        self.agentTableView.delegate = self;
        self.agentTableView.dataSource = self;
        self.agentTableView.backgroundColor = RGBColor(245, 245, 245);
        [self.getScrollView addSubview:self.agentTableView];
        [self.agentTableView registerNib:[UINib nibWithNibName:@"LFDistributionCell" bundle:nil] forCellReuseIdentifier:@"LFDistributionCell"];
        self.agentTableView.tableFooterView = [[UIView alloc] init];
        
        
        self.userTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-290) style:(UITableViewStylePlain)];
        self.userTableView.delegate = self;
        self.userTableView.dataSource = self;
        self.userTableView.backgroundColor = RGBColor(245, 245, 245);
        [self.getScrollView addSubview:self.userTableView];
        [self.userTableView registerNib:[UINib nibWithNibName:@"LFDistributionCell" bundle:nil] forCellReuseIdentifier:@"LFDistributionCell"];
        self.userTableView.tableFooterView = [[UIView alloc] init];
        
        self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, kScreenHeight-290) style:(UITableViewStylePlain)];
        self.detailTableView.delegate = self;
        self.detailTableView.dataSource = self;
        self.detailTableView.backgroundColor = RGBColor(245, 245, 245);
        [self.getScrollView addSubview:self.detailTableView];
        [self.detailTableView registerNib:[UINib nibWithNibName:@"LFDetailRMBCell" bundle:nil] forCellReuseIdentifier:@"LFDetailRMBCell"];
        self.detailTableView.tableFooterView = [[UIView alloc] init];
    } else {
        LHSegmentControlView *segView = [[LHSegmentControlView alloc] initWithFrame:CGRectMake(0, 250, kScreenWidth, 40) titleArray:@[@"用户", @"明细"] titleFont:[UIFont systemFontOfSize:15] titleDefineColor:[UIColor blackColor] titleSelectedColor:[UIColor redColor]];
        segView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:segView];
        [segView clickTitleButtonBlock:^(NSInteger index) {
            if (index == 0) {
                self.getScrollView.contentOffset = CGPointMake(0, 0);
                [self requestUserData];
            } else if (index == 1){
                self.getScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
                
            }
        }];
        
        self.getScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 290, kScreenWidth, kScreenHeight-290)];
        self.getScrollView.contentSize = CGSizeMake(kScreenWidth*2, kScreenHeight-290);
        self.getScrollView.pagingEnabled = YES;
        self.getScrollView.scrollEnabled = NO;
        [self.view addSubview:self.getScrollView];
        
        self.userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-290) style:(UITableViewStylePlain)];
        self.userTableView.delegate = self;
        self.userTableView.dataSource = self;
        self.userTableView.backgroundColor = RGBColor(245, 245, 245);
        [self.getScrollView addSubview:self.userTableView];
        [self.userTableView registerNib:[UINib nibWithNibName:@"LFDistributionCell" bundle:nil] forCellReuseIdentifier:@"LFDistributionCell"];
        self.userTableView.tableFooterView = [[UIView alloc] init];
        
        self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-290) style:(UITableViewStylePlain)];
        self.detailTableView.delegate = self;
        self.detailTableView.dataSource = self;
        self.detailTableView.backgroundColor = RGBColor(245, 245, 245);
        [self.getScrollView addSubview:self.detailTableView];
        [self.detailTableView registerNib:[UINib nibWithNibName:@"LFDetailRMBCell" bundle:nil] forCellReuseIdentifier:@"LFDetailRMBCell"];
        self.detailTableView.tableFooterView = [[UIView alloc] init];
        
        
    }
}


#pragma mark  --------------- 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    if ([dic[@"agent_level"] integerValue] == 1 || [dic[@"agent_level"] integerValue] == 2) {
        if (tableView == self.agentTableView) {
            return self.agentDataArray.count;
            
        } else if (tableView == self.userTableView) {
            return self.userDataArray.count;
            
        } else {
            return self.detailArray.count;
        }
    } else {
        if (tableView == self.userTableView) {
            return self.userDataArray.count;
            
        } else {
            return self.detailArray.count;
        }
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    if ([dic[@"agent_level"] integerValue] == 1 || [dic[@"agent_level"] integerValue] == 2) {
        if (tableView == self.agentTableView) {
            LFDistributionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFDistributionCell" forIndexPath:indexPath];
            cell.getRmbLabel.textColor = [UIColor redColor];
            cell.timeLabel.textColor = [UIColor redColor];
            cell.agentModel = self.agentDataArray[indexPath.row];
            return cell;
        } else if (tableView == self.userTableView) {
            LFDistributionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFDistributionCell" forIndexPath:indexPath];
            cell.getRmbLabel.textColor = [UIColor redColor];
            cell.model = self.userDataArray[indexPath.row];
            return cell;
        } else {
            LFDetailRMBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFDetailRMBCell" forIndexPath:indexPath];
            cell.detailModel = self.detailArray[indexPath.row];
            
            
            return cell;
        }
        
    } else {
        if (tableView == self.userTableView) {
            LFDistributionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFDistributionCell" forIndexPath:indexPath];
            
            
            
            return cell;
        } else {
            LFDetailRMBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFDetailRMBCell" forIndexPath:indexPath];
            
            
            
            return cell;
        }

    }
}

//自定义区头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    hView.backgroundColor = [UIColor whiteColor];
    UILabel *label1 = [[UILabel alloc] init];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = kFont(14);
    [hView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hView).offset(20);
        make.width.mas_offset(80);
        make.top.equalTo(hView).offset(0);
        make.bottom.equalTo(hView).offset(0);
    }];
    UILabel *label3 = [[UILabel alloc] init];
    label3.textAlignment = NSTextAlignmentRight;
    label3.font = kFont(14);
    [hView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(hView).offset(-20);
        make.width.mas_offset(80);
        make.top.equalTo(hView).offset(0);
        make.bottom.equalTo(hView).offset(0);
    }];
    UILabel *label2 = [[UILabel alloc] init];
    label2.font = kFont(14);
    label2.textAlignment = NSTextAlignmentCenter;
    [hView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1).offset(0);
        make.right.equalTo(label3).offset(0);
        make.top.equalTo(hView).offset(0);
        make.bottom.equalTo(hView).offset(0);
    }];
    
    if ([dic[@"agent_level"] integerValue] == 1 || [dic[@"agent_level"] integerValue] == 2) {
        if (tableView == self.agentTableView) {
            label1.text = @"分销商";
            label2.text = @"当月收益/元";
            label3.text = @"累计收益";
        } else if (tableView == self.userTableView) {
            label1.text = @"用户";
            label2.text = @"时间";
            label3.text = @"明细";
        }
    } else {
        if (tableView == self.userTableView) {
            label1.text = @"用户";
            label2.text = @"时间";
            label3.text = @"明细";
        }
    }
    return hView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.agentTableView) {
        return 40;
        
    } else if (tableView == self.userTableView) {
        return 40;
        
    } else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    if ([dic[@"agent_level"] integerValue] == 1 || [dic[@"agent_level"] integerValue] == 2) {
        if (tableView == self.agentTableView) {
            return 45;
            
        } else if (tableView == self.userTableView) {
            return 45;
            
        } else {
            return 60;
        }
    } else {
        if (tableView == self.userTableView) {
            return 45;
            
        } else {
            return 60;
        }
    }
}


- (void)requestMyDistributionData {
    NSString * url =@"agent/show.htm?";
    LFParameter *paeme = [LFParameter new];
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    NSLog(@"%@", dic[@"user_id"]);
    paeme.user_id = dic[@"user_id"];
    paeme.start = 0;
    paeme.end = 20;
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:NO completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if (!([request[@"result"] integerValue] == 200)) {
            SVShowError(request[@"msg"]);
            return ;
        } else {
            if (request[@"Accumulated_earnings"]) {
                self.headerView.allGetLabel.text = [NSString stringWithFormat:@"%.2f", [request[@"Accumulated_earnings"] floatValue]];
            } else {
                self.headerView.allGetLabel.text = @"0.00";
            }
            if (request[@"balance"]) {
                self.headerView.allRestLabel.text = [NSString stringWithFormat:@"%.2f", [request[@"balance"] floatValue]];
            } else {
                self.headerView.mouthGetLabel.text = @"0.00";
            }
            if (request[@"thisMoneh_earnings"]) {
                self.headerView.mouthGetLabel.text = [NSString stringWithFormat:@"%.2f", [request[@"thisMoneh_earnings"] floatValue]];
            } else {
                self.headerView.mouthGetLabel.text = @"0.00";
            }
            
            for (NSDictionary *dic in request[@"agents"]) {
                LFAgentGetRmbModel *model = [[LFAgentGetRmbModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.agentDataArray addObject:model];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.agentTableView reloadData];
            
        });
        if (self.agentDataArray.count == 0) {
            [self.getScrollView addSubview:self.emptyView];
        }
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error)
        
    }];
}
//agent/customers.htm?
- (void)requestUserData {
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    NSString * url =@"agent/customers.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.user_id = dic[@"user_id"];
    paeme.start = 0;
    paeme.end = 20;
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:NO completeBlock:^(NSDictionary *request) {
//        SLLog(request);
        if (!([request[@"result"] integerValue] == 200)) {
            SVShowError(request[@"msg"]);
            return ;
        } else {
            for (NSDictionary *dic in request[@"data"]) {
                LFUserGetRmbModel *model = [[LFUserGetRmbModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.userDataArray addObject:model];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.userTableView reloadData];
            
        });
        if (self.userDataArray.count == 0) {
            [self.getScrollView addSubview:self.emptyUserView];
        }
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error)
        
    }];
}

-(void)HttpRequestIntegralExtrac{
    ///order/application.htm?user_id=&type=&remark=&bank_no=&price=
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    NSString * url =@"agent/customdetail.htm";
    LFParameter *paeme = [LFParameter new];
    paeme.user_id = dic[@"user_id"];
    paeme.loginKey = user_loginKey;
    paeme.start = 0;
    paeme.end = 20;
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:NO completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
        } else {
            for (NSDictionary *dic in request[@"data"]) {
                NSLog(@"~~~~~~%@", dic);
                LFDetailRmbModel *model = [[LFDetailRmbModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.detailArray addObject:model];
            }
        }
        NSLog(@"%ld", self.detailArray.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.detailTableView reloadData];
            
        });
        if (self.detailArray.count == 0) {
            [self.getScrollView addSubview:self.emptyDetailView];
        }
        
        
    } failBlock:^(NSError *error) {
        SLLog(error);
    }];
}









- (UIView *)emptyView {
    if (_emptyView) return _emptyView;
    self.emptyView = [UIView viewWithBgColor:HexColorInt32_t(f0f1f2) frame:Rect(0, 0, kScreenWidth, kScreenHeight - 290)];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"空盒子"]];
    imageView.center = Point(kHalfScreenWidth, _emptyView.height * 0.345);
    [_emptyView addSubview:imageView];
    
    UILabel * label = [UILabel labelWithText:@"暂时没有代理商收益" font:Fit(12) textColor:HexColorInt32_t(999999) frame:Rect(0, imageView.maxY + Fit(15), 1, 1)];
    [label sizeToFit];
    label.centerX = kHalfScreenWidth;
    [_emptyView addSubview:label];
    return _emptyView;
}

- (UIView *)emptyUserView {
    if (_emptyUserView) return _emptyUserView;
    self.emptyUserView = [UIView viewWithBgColor:HexColorInt32_t(f0f1f2) frame:Rect(kScreenWidth, 0, kScreenWidth, kScreenHeight - 290)];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"空盒子"]];
    imageView.center = Point(kHalfScreenWidth, _emptyUserView.height * 0.345);
    [_emptyUserView addSubview:imageView];
    
    UILabel * label = [UILabel labelWithText:@"暂时没有用户收益" font:Fit(12) textColor:HexColorInt32_t(999999) frame:Rect(0, imageView.maxY + Fit(15), 1, 1)];
    [label sizeToFit];
    label.centerX = kHalfScreenWidth;
    [_emptyUserView addSubview:label];
    return _emptyUserView;
}

- (UIView *)emptyDetailView {
    if (_emptyDetailView) return _emptyDetailView;
    self.emptyDetailView = [UIView viewWithBgColor:HexColorInt32_t(f0f1f2) frame:Rect(2*kScreenWidth, 0, kScreenWidth, kScreenHeight - 290)];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"空盒子"]];
    imageView.center = Point(kHalfScreenWidth, _emptyDetailView.height * 0.345);
    [_emptyDetailView addSubview:imageView];
    
    UILabel * label = [UILabel labelWithText:@"暂时没有提现明细" font:Fit(12) textColor:HexColorInt32_t(999999) frame:Rect(0, imageView.maxY + Fit(15), 1, 1)];
    [label sizeToFit];
    label.centerX = kHalfScreenWidth;
    [_emptyDetailView addSubview:label];
    return _emptyDetailView;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
