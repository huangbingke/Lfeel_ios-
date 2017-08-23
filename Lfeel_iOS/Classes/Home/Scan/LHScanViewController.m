//
//  LHScanViewController.m
//  LFeelAPP
//
//  Created by 黄冰珂 on 2017/7/18.
//  Copyright © 2017年 黄冰珂. All rights reserved.
//

#import "LHScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LHScaningView.h"
#import "LHScanSuccessJumpViewController.h"
#import "LFCardBagViewController.h"
@interface LHScanViewController () <AVCaptureMetadataOutputObjectsDelegate>
/** 会话对象 */
@property (nonatomic, strong) AVCaptureSession *session;
/** 图层类 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) LHScaningView *scanningView;

@property (nonatomic, strong) UIButton *right_Button;

@end

@implementation LHScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建扫描边框
    self.scanningView = [[LHScaningView alloc] initWithFrame:self.view.frame outsideViewLayer:self.view.layer];
    [self.view addSubview:self.scanningView];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBar];
}

///  设置自定义导航条
- (void)setupNavigationBar {
//    @weakify(self);
    NSString * title = @"扫一扫";
    self.ts_navgationBar = [TSNavigationBar navWithTitle:title backAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 二维码扫描
    [self setupScanningQRCode];
    
}
#pragma mark - - - 二维码扫描
- (void)setupScanningQRCode {
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2、 创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // 3、 创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    // 4、设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 设置扫描范围(每一个取值0～1，以屏幕右上角为坐标原点)
    output.rectOfInterest = CGRectMake(0.15, 0.24, 0.7, 0.52);
    
    // 5、 初始化链接对象（会话对象）
    self.session = [[AVCaptureSession alloc] init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    // 5.1 添加会话输入
    [_session addInput:input];
    
    // 5.2 添加会话输出
    [_session addOutput:output];
    
    // 6、设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // 7、实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.view.layer.bounds;
    
    // 8、将图层插入当前视图
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    
    // 9、启动会话
    [_session startRunning];
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    // 会频繁的扫描，调用代理方法
    // 1. 如果扫描完成，停止会话
    [self.session stopRunning];
    // 2. 删除预览图层
    [self.previewLayer removeFromSuperlayer];
    // 3. 设置界面显示扫描结果
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        if ([_idString isEqualToString:@"LFPackViewController"]) {
            if (self.codeBlock) {
                self.codeBlock(obj.stringValue);
            }
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        //        NSLog(@"metadataObjects = %@", metadataObjects);
        if ([obj.stringValue hasPrefix:@"inviteCode"]) {
            NSLog(@"***************%@", obj.stringValue);
            NSString *code = [obj.stringValue substringFromIndex:11];
            if ([_idString isEqualToString:@"LFRegisterViewController"]) {
                if (self.codeBlock) {
                    self.codeBlock(code);
                }
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self HttpRequestChangeCenterMessage:code];
            }
        } else if ([obj.stringValue hasPrefix:@"http"]) {
            // 提示：如果需要对url或者名片等信息进行扫描，可以在此进行扩展！
            LHScanSuccessJumpViewController *jumpVC = [[LHScanSuccessJumpViewController alloc] init];
            jumpVC.jump_URL = obj.stringValue;
            [self.navigationController pushViewController:jumpVC animated:YES];
            
        } else { // 扫描结果为条形码
            LHScanSuccessJumpViewController *jumpVC = [[LHScanSuccessJumpViewController alloc] init];
            jumpVC.jump_bar_code = obj.stringValue;
            [self.navigationController pushViewController:jumpVC animated:YES];
        }
    }
}

//邀请码
-(void)HttpRequestChangeCenterMessage:(NSString *)txt {
    NSString * url =@"personal/addinviteCode.htm?";
    LFParameter *parameter = [LFParameter new];
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    parameter.user_id = dic[@"user_id"];
    parameter.inviteCode = txt;
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        if ([request[@"result"] integerValue]!=200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        BLOCK_SAFE_RUN(self.vBlock);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LFCardBagViewController *cardVC = [[LFCardBagViewController alloc] init];
            [self.navigationController pushViewController:cardVC animated:YES];
        });
    } failBlock:^(NSError *error) {
        SLLog(error);
    }];
}
- (void)invoteCodeBlock:(InvoteCodeBlock)block {
    self.codeBlock = block;
}
// 移除定时器
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.scanningView removeTimer];
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
