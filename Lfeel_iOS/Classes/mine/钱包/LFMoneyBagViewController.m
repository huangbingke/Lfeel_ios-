//
//  LFMoneyBagViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFMoneyBagViewController.h"
#import "LFBagHeader.h"
#import "LFMoneyList.h"
#import "LFIntegralPayViewController.h"
#import "LFWithdrawalViewController.h"
#import "LFIntergerDetailViewController.h"
#import "LFInvoiceVC.h"

@interface LFMoneyBagViewController ()
///<#name#>
@property (strong, nonatomic) LFBagHeader * bghearder;
///  <#Description#>
@property (nonatomic, strong) UIScrollView  * scro;
@end

@implementation LFMoneyBagViewController{
    NSString * moneyStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self CreateView];
    [self HTTPRequestMyWallet];
}

/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    
    @weakify(self);
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"我的钱包" backAction:^{
        @strongify(self);
          [self.navigationController popViewControllerAnimated:YES];
    }];
    
}


-(void)HTTPRequestMyWallet
{
    NSString * url = @"personal/myWallet.htm?";
    LFParameter * param = [LFParameter new];
    param.loginKey = user_loginKey;
    @weakify(self);
    [TSNetworking POSTWithURL:url paramsModel:param completeBlock:^(NSDictionary  *request) {
        @strongify(self);
        SLLog(request);
      self ->  moneyStr = [NSString stringWithFormat:@"%@",request[@"integral"]];
        NSString  * string = [NSString stringWithFormat:@"%@",request[@"integral"]];
        [self.bghearder Setintegral:string];

    } failBlock:^(NSError *error) {
        SLLog(error);
        
    }];
}

-(void)CreateView{
    
    UIScrollView *scro  = [[UIScrollView alloc]initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight -64)];
    [self.view addSubview:scro];
    
     self.bghearder = [LFBagHeader creatViewFromNib];
    self.bghearder.frame = Rect(0, 0, kScreenWidth, Fit375(121));
    [scro addSubview:self.bghearder];
    LFMoneyList * pay  = [LFMoneyList creatViewFromNib];
    [pay settitleLebelText:@"充值"];
    @weakify(self);
//    
    pay.didClickSelectedText = ^{
        @strongify(self);
        LFIntegralPayViewController  * intergral  = [[LFIntegralPayViewController alloc]init];
        [self.navigationController pushViewController:intergral animated:YES];
        
    };
    [scro addSubview:pay];
    [pay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.mas_equalTo(kScreenWidth);
        make.top.equalTo(self.bghearder.mas_bottom).offset(20);
        make.height.mas_equalTo(Fit375(45));
    }];
    LFMoneyList * withdrawal  = [LFMoneyList creatViewFromNib];
    [withdrawal settitleLebelText:@"提现"];
    [scro addSubview:withdrawal];
    
    
   
//
    [withdrawal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.mas_equalTo(kScreenWidth);
        make.top.equalTo(pay.mas_bottom).offset(0);
        make.height.mas_equalTo(Fit375(45));
    }];
    
    withdrawal.didClickSelectedText = ^{
        @strongify(self);
        LFWithdrawalViewController  * intergral  = [[LFWithdrawalViewController alloc]init];
        intergral.integral = self -> moneyStr;
        [self.navigationController pushViewController:intergral animated:YES];
        
    };
    LFMoneyList * detail  = [LFMoneyList creatViewFromNib];
    [detail settitleLebelText:@"明细"];
    
   
    
    [scro addSubview:detail];
    [detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.mas_equalTo(kScreenWidth);
        make.top.equalTo(withdrawal.mas_bottom).offset(0);
        make.height.mas_equalTo(Fit375(45));
    }];
    
    detail.didClickSelectedText =^{
        @strongify(self);
        
        LFIntergerDetailViewController  * detail  = [[LFIntergerDetailViewController alloc]init];
        detail.integralType = @"0";
        detail.iSBooll = YES;
        [self.navigationController pushViewController:detail animated:YES];
        
    };
    
    
    LFMoneyList * invoice  = [LFMoneyList creatViewFromNib];
    [invoice settitleLebelText:@"发票"];
    [scro addSubview:invoice];
    [invoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.mas_equalTo(kScreenWidth);
        make.top.equalTo(detail.mas_bottom).offset(0);
        make.height.mas_equalTo(Fit375(45));
    }];
    
    invoice.didClickSelectedText = ^{
        @strongify(self);
        LFInvoiceVC * controller = [[LFInvoiceVC alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    };
    
}

-(NSString *)update{
    NSDate *senddate = [NSDate date];
    
    NSLog(@"date1时间戳 = %ld",time(NULL));
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    NSLog(@"date2时间戳 = %@",date2);
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *date1 = [dateformatter stringFromDate:senddate];
    NSLog(@"获取当前时间   = %@",date1);
    
    // 时间戳转时间
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[senddate timeIntervalSince1970]];
    NSString *confromTimespStr = [dateformatter stringFromDate:confromTimesp];
    NSLog(@"时间戳转时间   = %@",confromTimespStr);
    return confromTimespStr;
}








@end
