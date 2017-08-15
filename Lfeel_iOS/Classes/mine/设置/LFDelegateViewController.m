//
//  LFDelegateViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/21.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFDelegateViewController.h"

@interface LFDelegateViewController ()<UIWebViewDelegate>

@end

@implementation LFDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self CreateView];
    
}

/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    
    @weakify(self);
    NSString * name ;
    if ([self.selectType isEqualToString:@"1"]) {
        name = @"服务协议";
    } else if ([self.selectType isEqualToString:@"2"]){
        name = @"注意事项";
    }
    else{
        name = @"常见问题";
    }
    self.ts_navgationBar = [TSNavigationBar navWithTitle:name backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}


-(void)CreateView{
    NSString* path;
    
    if([self.selectType isEqualToString:@"1"]){
        path= [[NSBundle mainBundle] pathForResource:@"userAgr" ofType:@"html"];
    }else if ([self.selectType isEqualToString:@"2"]){
        path= [[NSBundle mainBundle] pathForResource:@"precautions" ofType:@"html"];
    }else{
        path= [[NSBundle mainBundle] pathForResource:@"changjianwenti" ofType:@"html"];
    }
        
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;

    UIWebView *webView =[[UIWebView alloc]init];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    [webView loadRequest:request];

    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.mas_equalTo(kScreenWidth);
        make.top.offset(64);
        make.height.mas_equalTo(kScreenHeight-64);
    
    }];
}




@end
