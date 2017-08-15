//
//  LFPackViewController.m
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/7/12.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFPackViewController.h"
#import "LFPackCell.h"
@interface LFPackViewController ()
@property (weak, nonatomic) IBOutlet UITextField *expressTF;
@property (weak, nonatomic) IBOutlet UITextField *goodsNumTF;
@property (weak, nonatomic) IBOutlet UITextField *remarkTF;

@end

@implementation LFPackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}
- (void)requestSubmitData {
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    NSString * url =@"order/update.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.user_id = dic[@"user_id"];
    paeme.type = @"2";
    paeme.express_no = self.expressTF.text;
    paeme.application_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"application_id"];
    paeme.remark = [NSString stringWithFormat:@"打包了%@件,备注:%@", self.goodsNumTF.text, self.remarkTF.text];
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] == 200) {
            SVShowSuccess(@"已成功提交申请");
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            SVShowError(request[@"msg"]);
        }
        
    } failBlock:^(NSError *error) {
        SLLog(error);
    }];
    
    
    
}

- (IBAction)backAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


//提交
- (IBAction)submitAction:(UIButton *)sender {
    NSLog(@"提交");
    if (self.goodsNumTF.text.length == 0 && self.expressTF.text.length == 0) {
        SVShowError(@"请填写正确信息");
    } else {
        [self requestSubmitData];
    }
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















