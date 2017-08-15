//
//  LFLeiBaiPayVC.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/5/1.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFLeiBaiPayVC.h"
#import "LFLeiBaiPayView.h"
#import "LFLeiBaiPayVC2.h"
#import "LFLeiBaiPayVC3.h"

@interface LFLeiBaiPayVC ()
//<UITableViewDelegate, UITableViewDataSource>
//@property (nonatomic,   weak) UITableView * tableView;

@end

@implementation LFLeiBaiPayVC

#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    
    [self setupNavigationBar];
}

///  初始化子控件
- (void)setupSubViews {
    
    UIScrollView * scrollView = [UIScrollView defaultScrollView];
    [self.view addSubview:scrollView];
    
    LFLeiBaiPayView * payView = [LFLeiBaiPayView creatViewFromNib];
    payView.price = self.payModel.price;
    payView.frame = Rect(0, 0, kScreenWidth, Fit(payView.height));
    [scrollView addSubview:payView];
    
    @weakify(self, payView);
    [payView setProtocalBlock:^{
        @strongify(self);
        UIViewController * controller = [[NSClassFromString(@"ViewController") alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } nextBlock:^{
        @strongify(self, payView);
        if (self.payModel.bankCardList.count) {
            LFLeiBaiPayVC3 * controller = [[LFLeiBaiPayVC3 alloc] init];
            controller.payModel = self.payModel;
            controller.payModel.stageCount = payView.selectedStage;
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            LFLeiBaiPayVC2 * controller = [[LFLeiBaiPayVC2 alloc] init];
            controller.payModel = self.payModel;
            controller.payModel.stageCount = payView.selectedStage;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
    scrollView.contentSize = Size(0, payView.maxY);
}

///  设置自定义导航条
- (void)setupNavigationBar {
    @weakify(self);
    NSString * title = @"分期付款";
    self.ts_navgationBar = [TSNavigationBar navWithTitle:title backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Actions


#pragma mark - Networking


#pragma mark - Delegate

#pragma mark - Private


#pragma mark - Public


#pragma mark - Getter\Setter

@end
