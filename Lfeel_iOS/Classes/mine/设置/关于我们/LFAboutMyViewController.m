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
    textView.text = [NSString stringWithFormat:@"%@",@"广州乐荟电子商务有限公司（Guangzhou lfeel electronic commerce co., LTD）隶属于广东苹果集团，总部位于广州天河，是一家具有资深行业背景，同时充满创造力和执行力的奢侈品一体化公司。乐荟致力于让奢侈变得简单！让每一个热爱时尚，专注品质的人都可以用最低的价格，享受到最高的生活体验。乐荟由一帮90后有志青年牵头组成一个极具创意的团队。\
                     乐荟主要业务范围涉及奢侈品租赁、奢品销售、线下实体体验中心、奢侈品养护、乐荟提倡“绿色消费”，希望将环保融入时尚，致力于回收二手奢侈品进行再利用，提供包袋、服饰、腕表等商品的租赁业务。乐荟还拥有163家国际一线奢侈品牌资源，销售产品覆盖面包含服装、配饰、美妆护肤、家居用品等。" ];
    
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
