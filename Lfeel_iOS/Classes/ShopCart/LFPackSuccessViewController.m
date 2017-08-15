//
//  LFPackSuccessViewController.m
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/7/7.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFPackSuccessViewController.h"

@interface LFPackSuccessViewController ()

@end

@implementation LFPackSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)continue:(UIButton *)sender {
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popViewControllerAnimated:YES];
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
