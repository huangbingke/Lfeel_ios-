//
//  ViewController.m
//  KCWC
//
//  Created by Seven on 2017/6/21.
//  Copyright © 2017年 TGF. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()
//<UITableViewDelegate, UITableViewDataSource>
//@property (nonatomic,   weak) UITableView * tableView;

@end

@implementation ViewController

#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubViews];
    
    [self setupNavigationBar];
}

///  初始化子控件
- (void)setupSubViews {
    WKWebView * webView = [[WKWebView alloc] initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight - 64)];
    NSURL * url = [[NSBundle mainBundle] URLForResource:@"lebai" withExtension:@"doc"];
    [webView loadFileURL:url allowingReadAccessToURL:url];
    [self.view addSubview:webView];
}

///  设置自定义导航条
- (void)setupNavigationBar {
    @weakify(self);
    NSString * title = @"个人消费分期支付合同";
    self.ts_navgationBar = [TSNavigationBar navWithTitle:title backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Actions


#pragma mark - Networking

@end
