//
//  LFAboutMyViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFAboutMyViewController.h"

@interface LFAboutMyViewController ()

@end

@implementation LFAboutMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];

    UIImageView * imageview =[[UIImageView alloc]init];
    imageview.image = [UIImage imageNamed:@"矢量智能对象"];
    [self.view addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(Fit(84));
        make.height.mas_equalTo(Fit(50));
        make.width.mas_equalTo(Fit(50));
    }];
    
    UITextView * textView = [[UITextView alloc]init];
    textView.backgroundColor = self.view.backgroundColor;
    textView.text = [NSString stringWithFormat:@"%@",@"乐荟致力于让奢侈变得简单！让每一个热爱时尚，专注品质的人都可以用最低的价格，享受到最高的生活体验。乐荟主要业务范围涉及奢侈品共享、新品代销平台以及线下实体体验中心，乐荟盒子，提出全新的消费理念、绿色的将包包、服饰、腕表、珠宝等实现超低价共享，为中国更多的年轻人带来更多、更好、更高的时尚享受，乐荟盒子不忘环保使命——'乐荟100'慈善基金将善举轻松融于消费中，融入每一位会员。乐荟盒子，正构建奢侈品的新文明时代！！！" ];
    
    textView.userInteractionEnabled = NO;
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(Fit(15));
        make.right.offset(-Fit(15));
        make.top.equalTo(imageview.mas_bottom).offset(Fit(15));
        make.bottom.offset(0);
        
    }];
    
}

/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    
    @weakify(self);
    
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"关于我们" backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}



@end
