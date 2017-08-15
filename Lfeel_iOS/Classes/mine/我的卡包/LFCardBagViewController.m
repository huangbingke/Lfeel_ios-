//
//  LFCardBagViewController.m
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/7/24.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFCardBagViewController.h"
#import "LFCardBagCell.h"
@interface LFCardBagViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *cardBagTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation LFCardBagViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cardBagTableView.tableFooterView = [[UIView alloc] init];
    [self requestData];
    [self.cardBagTableView registerNib:[UINib nibWithNibName:@"LFCardBagCell" bundle:nil] forCellReuseIdentifier:@"LFCardBagCell"];
    
    [self setupNavigationBar];
}

/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    @weakify(self);
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"我的卡包" rightItem:nil rightAction:^{
        
    } backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}


- (void)passCardModelBlock:(CardModelBlock)block {
        self.cardBlock = block;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LFCardBagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFCardBagCell" forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.jumpId isEqualToString:@"LFSettleCenterVC"]) {
        if (self.cardBlock) {
            self.cardBlock(self.dataArray[indexPath.row]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}




- (void)requestData {
    LFParameter *param = [LFParameter new];
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    param.user_id = dic[@"user_id"];
    [TSNetworking POSTWithURL:@"personal/privileges.htm?" paramsModel:param completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] == 200) {
            for (NSDictionary *dic in request[@"data"]) {
                LFCheapCardModel *model = [[LFCheapCardModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        } else {
            SVShowError(request[@"msg"]);
        }
        [self.cardBagTableView reloadData];
    } failBlock:^(NSError *error) {
        
    }];
    
    
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
