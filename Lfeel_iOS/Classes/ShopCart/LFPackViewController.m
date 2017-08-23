//
//  LFPackViewController.m
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/7/12.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFPackViewController.h"
#import "LFPackCell.h"
#import "LHScanViewController.h"


@interface LFPackViewController ()
@property (weak, nonatomic) IBOutlet UITextField *expressTF;
@property (weak, nonatomic) IBOutlet UITextField *remarkTF;

@property (nonatomic, copy) NSString *number;

@end

@implementation LFPackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.number = nil;

}
- (void)requestSubmitData {
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    NSString * url =@"order/update.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.user_id = dic[@"user_id"];
    paeme.type = @"2";
    paeme.express_no = self.expressTF.text;
    paeme.application_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"application_id"];
    paeme.remark = [NSString stringWithFormat:@"寄回了%@件,备注:%@", self.number, self.remarkTF.text];
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

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)selectBtn:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    [alert addAction:[UIAlertAction actionWithTitle:@"寄回 1 件" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self.number = @"1";
        [sender setTitle:@"寄回 1 件" forState:(UIControlStateNormal)];
        sender.titleColor = [UIColor blackColor];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"寄回 2 件" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self.number = @"2";
        [sender setTitle:@"寄回 2 件" forState:(UIControlStateNormal)];
        sender.titleColor = [UIColor blackColor];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"寄回 3 件" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self.number = @"3";
        [sender setTitle:@"寄回 3 件" forState:(UIControlStateNormal)];
        sender.titleColor = [UIColor blackColor];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


//提交
- (IBAction)submitAction:(UIButton *)sender {
    NSLog(@"提交");
    if (self.number.length == 0 && self.expressTF.text.length == 0) {
        SVShowError(@"请填写正确信息");
    } else {
        [self requestSubmitData];
    }
}


- (IBAction)Scan:(UIButton *)sender {
    LHScanViewController *scanVC = [[LHScanViewController alloc] init];
    scanVC.idString = @"LFPackViewController";
    scanVC.codeBlock = ^(NSString *invoteCode) {
        self.expressTF.text = invoteCode;
    };
    [self.navigationController pushViewController:scanVC animated:YES];
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















