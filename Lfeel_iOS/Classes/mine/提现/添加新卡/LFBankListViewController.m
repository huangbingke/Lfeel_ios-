//
//  LFBankListViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/22.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFBankListViewController.h"

@interface LFBankListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LFBankListViewController
{
    NSArray *array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    array = @[@"中国工商银行",@"招商银行",@"中国农业银行",@"中国建设银行",@"中国银行",@"中国民生银行",@"中国光大银行",@"中信银行",@"交通银行",@"兴业银行",@"上海浦东发展银行",@"中国人民银行",@"华夏银行",@"深圳发展银行",@"广东发展银行",@"中国邮政储蓄银行",@"北京银行",@"上海银行",@"南京银行",@"宁波银行",@"深圳平安银行",@"深圳农村商业银行",@"重庆银行",@"汇丰中国银行",@"花旗中国银行",@"渣打中国银行"];
    
    [self setupNavigationBar];
    [self CreateView];
    

}
/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    
    @weakify(self);
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"选择银行列表" backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

-(void)CreateView{
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    tabbleView.dataSource = self;
    tabbleView.delegate = self;
    [self.view addSubview:tabbleView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString * ID = @"Reg";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text =array[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelectBankName) {
        self.didSelectBankName(array[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

@end
