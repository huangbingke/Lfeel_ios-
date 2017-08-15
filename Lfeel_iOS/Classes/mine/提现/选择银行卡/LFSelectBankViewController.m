//
//  LFSelectBankViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFSelectBankViewController.h"
#import "LFSelectBankfooterView.h"
#import "LFSelectBankHeader.h"
#import "LFSelectBankCell.h"
#import "LFAddNewBankCodeViewController.h"
@interface LFSelectBankViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tabbleView;
@property (strong, nonatomic) NSMutableArray *datas;
@end

@implementation LFSelectBankViewController
{
    UIView * headerView, *footerView;
    NSInteger startPage ;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas  = [NSMutableArray array];
    [self setupNavigationBar];
    [self CreateView];
    [self HTTPRequestaddUserBank];
}

/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    
    @weakify(self);
    
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"选择银行卡" backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

-(void)CreateView{
    UITableView *tabbleView = [[UITableView alloc]initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    tabbleView.dataSource = self;
    tabbleView.delegate = self;
    [self.view addSubview:tabbleView];
    self.tabbleView = tabbleView;
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    LFSelectBankCell * cell = [LFSelectBankCell  cellWithTableView:tableView];
    
    if (self.datas.count > 0) {
        LFBanklistModel * model = self.datas[indexPath.row];
        
        [cell setModel:model];
        
    }
    
    return cell;
}





-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (headerView != nil) {
        return headerView;
    }
    
    headerView = [[UIView alloc]initWithFrame:Rect(0, 0, kScreenWidth, Fit375(50))];
    headerView.backgroundColor = HexColorInt32_t(f1f1f1);
    LFSelectBankHeader * v = [LFSelectBankHeader creatViewFromNib];
    v.frame =Rect(0, 0, headerView.width, headerView.height);
    [headerView  addSubview:v];
    return headerView;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if ( footerView!= nil) {
        return footerView;
    }
    
    footerView = [[UIView alloc]initWithFrame:Rect(0, 0, kScreenWidth, Fit375(45))];
    LFSelectBankfooterView * v = [LFSelectBankfooterView creatViewFromNib];
    v.frame =Rect(0, 0, footerView.width, footerView.height);
    @weakify(self);
    v.DidAddBankCode =^{
        @strongify(self);
        LFAddNewBankCodeViewController * addbank = [[LFAddNewBankCodeViewController alloc]init];
        addbank.didRefreshbank =^{
            [self refrshDataBank];
        };
        [self.navigationController pushViewController:addbank animated:YES];
        
        
    };
    [footerView addSubview:v];
    
    return footerView;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Fit375(44);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return Fit375(45);

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  Fit375(50);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.datas.count > 0) {
        LFBanklistModel * model = self.datas[indexPath.row];
        NSLog(@"%@", model.bankId);
        
        if (self.didSelectBank != nil) {
            self.didSelectBank(model);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}


#pragma mark - 
-(void)HTTPRequestaddUserBank{
    NSString * url = @"personal/userBankList.htm";
    LFParameter * parm = [LFParameter new];
    parm.loginKey = user_loginKey;
    parm.startPage = stringWithInt(startPage);
    
    [TSNetworking POSTWithURL:url paramsModel:parm completeBlock:^(NSDictionary *request) {
        SLLog(request);
        
        if ([request[@"result"] integerValue]!= 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        NSArray * array  = [NSArray yy_modelArrayWithClass:[LFBanklistModel class] json:request[@"bankList"]];
        [self.datas addObjectsFromArray:array];
        [self.tabbleView reloadData];
        
        
    } failBlock:^(NSError *error) {
        
    }];

}

-(void)refrshDataBank{
    if (self.datas.count > 0) {
        [self.datas removeAllObjects];
    }
    startPage = 0;
    [self HTTPRequestaddUserBank];
}






@end
