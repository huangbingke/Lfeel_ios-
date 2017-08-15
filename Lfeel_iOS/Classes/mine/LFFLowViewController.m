//
//  LFFLowViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/21.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFFLowViewController.h"

@interface LFFLowViewController ()

@end

@implementation LFFLowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self CreateView];
    
}
/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    
    @weakify(self);
    
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"租用流程" backAction:^{
        @strongify(self);
        [self.navigationController  popViewControllerAnimated:YES];
    }];
    
}

-(void)CreateView{
    UIScrollView  * scro = [[UIScrollView alloc]initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-64 )];
    [self.view addSubview:scro];
    
    
    
    UIImage * image1 = [UIImage imageNamed:@"IMG_2148 3.jpg"];
    
    
  

    UIImageView *img = [[UIImageView alloc]initWithFrame:Rect(0, 0, scro.width, scro.height)];
        img.image =  image1;
        [scro addSubview:img];
 
    scro.contentSize = CGSizeMake(kScreenWidth, image1.size.height);
    
    
    
}




@end
