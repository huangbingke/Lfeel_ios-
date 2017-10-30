//
//  LFCertificationViewController.m
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/8/31.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFCertificationViewController.h"
#import "SLImagePickerController.h"
#import "LFCenterViewController.h"

@interface LFCertificationViewController ()


@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *IDCaridText;

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@property (nonatomic, copy) NSString *imageUrl;

@end

@implementation LFCertificationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   NSInteger isreal =  [[User getUseDefaultsOjbectForKey:@"isReal"] integerValue];
    if (isreal == -1) {
        SVShowError(@"审核中");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"实名认证" rightItem:@"提交" rightAction:^{
        [self HttpRequestChangeCenterMessage];
        
    } backAction:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}


#pragma Http
-(void)HttpRequestChangeCenterMessage{
    SLAssert(self.nameText.hasText, @"请输入姓名")
    if (self.IDCaridText.hasText) {
        SLAssert([self.IDCaridText.text validateIdentityCard], @"身份证号码格式不正确");
    }
    
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    NSString * url =@"order/application.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.user_id = dic[@"user_id"];
    paeme.type = @"4";
    paeme.id_No = self.IDCaridText.text;
    paeme.id_url = self.imageUrl;
    paeme.trueName = self.nameText.text;
    paeme.remark = @"实名认证";
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccess:@"已提交申请,24小时之内处理"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"为了获得更好的体验, 建议完善个人信息!" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
                    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                        LFCenterViewController *centerVC = [[LFCenterViewController alloc] init];
                        [self.navigationController pushViewController:centerVC animated:YES];
                        
                    }]];
                    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    [self presentViewController:alertVC animated:YES completion:nil];
                });
            });
        } else {
            SVShowError(request[@"msg"]);
        }
    } failBlock:^(NSError *error) {
        SLLog(error);
    }];
}


- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [SLImagePickerController showInViewController:self libraryType:(SLImagePickerCameraType) allowEdit:YES complete:^(UIImage *image) {
            
            [self HttpUpDataPhoto:image];
        }];
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [SLImagePickerController showInViewController:self libraryType:(SLImagePickerPhotoLibraryType) allowEdit:YES complete:^(UIImage *image) {
            [self HttpUpDataPhoto:image];
        }];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

/// 上传头像
-(void)HttpUpDataPhoto:(UIImage *)image {
    NSString * url =@"image/upload";
    LFParameter *parameter = [LFParameter new];
    [TSNetworking POSTImageWithURL:url paramsModel:parameter image:image imageParam:@"My_real" completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue]==200) {
            self.imageUrl = request[@"imgUrl"];
            self.picImageView.image = image;
        } else {
            SVShowError(request[@"msg"]);
            return ;
        }
    } failBlock:^(NSError *error) {
        
    }];
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
