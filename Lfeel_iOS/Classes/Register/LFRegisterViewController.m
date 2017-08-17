//
//  LFRegisterViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/23.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFRegisterViewController.h"
#import "LFRegisterMinuteView.h"
#import "NSAttributedString+YYText.h"
#import "LFDelegateViewController.h"
#import "TSAddressPickerView.h"
#import "LFAddressModel.h"
#import "LHScanViewController.h"

@interface LFRegisterViewController ()
///  <#Description#>
@property (weak, nonatomic) IBOutlet UILabel *ssMessageLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (nonatomic, strong) LFRegisterMinuteView * MinuteView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) UIView * bgView;

@property (weak, nonatomic) IBOutlet UITextField *iphoneText;
@property (weak, nonatomic) IBOutlet UITextField *vifyCodeText;

@property (weak, nonatomic) IBOutlet UITextField *passWordText;
@property (weak, nonatomic) IBOutlet UITextField *NewPassWordText;

@property (weak, nonatomic) IBOutlet UITextField *FriendCode;

@property (weak, nonatomic) IBOutlet UIButton *RegBtn;

@property (weak, nonatomic) IBOutlet UILabel *protocal;
@property (weak, nonatomic) IBOutlet UIButton *passWordLogin;

@property (weak, nonatomic) IBOutlet UIButton *addressBtn;

@property (nonatomic,   copy) NSDictionary * addressDict;

@property (nonatomic, copy) NSString *province;//省
@property (nonatomic, copy) NSString *city;//市
@property (nonatomic, copy) NSString *district;//区
 

@end

@implementation LFRegisterViewController
{
    NSInteger selectIndex;
    NSDictionary * _dictMessage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    selectIndex = 1;
    //设置导航栏
    [self setupNavigationBar];
    [self TapTextFeildDown];
    

    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    @weakify(self);
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        LFDelegateViewController * controller = [[LFDelegateViewController alloc] init];
        controller.selectType = @"1";
        [self.navigationController pushViewController:controller animated:YES];
    }];
    [self.protocal addGestureRecognizer:tap];
    self.protocal.userInteractionEnabled = YES;
    NSString * x = @"点击\"注册\",表示同意乐荟《服务协议》";
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:x];
    [attr yy_setColor:[UIColor blackColor] range:[x rangeOfString:@"乐荟《服务协议》"]];
    self.protocal.attributedText = attr;
}
- (IBAction)addressBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    TSAddressPickerView * pickerView = [TSAddressPickerView addressPickerView];
    pickerView.resultBlock = ^(NSDictionary * dict) {
        self.addressDict = [dict copy];
        LFProvince * p = dict[@"province"];
        LFCity * c = dict[@"city"];
        LFRegion * d = dict[@"district"];
        NSString * t = [NSString stringWithFormat:@"%@%@%@", p.provinceName, c.cityName, d.regionName];
        [sender setTitle:t forState:(UIControlStateNormal)];
        [sender setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        self.province = p.provinceName;
        self.city = c.cityName;
        self.district = d.regionName;
    };
    [self.view addSubview:pickerView];
    
}


//创建遮挡层
-(void)crateBgView{
    _bgView = [self bgView];
    [self.view addSubview:_bgView];
}

- (IBAction)_didClickPasswordLogin:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    @weakify(self);
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"注 册" backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}


#pragma mark - Action
///注 册
- (IBAction)TapRegisterBtn:(id)sender {
    SLLog2(@"注册");
    
        if (selectIndex==1 ) {
            _bgView.hidden = NO;
            [self crateBgView];
            selectIndex = 2;
            
        }else if (selectIndex == 2){
            SLLog2(@"注册");
            
            
            SLVerifyPhone(self.iphoneText.text, @"请输入手机号");
            
            SLVerifyText(self.vifyCodeText.text.length, @"验证码不正确")
            
            if (![self.NewPassWordText.text isEqualToString:self.passWordText.text]) {
                SVShowError(@"两次密码不一致");
                return;
            }
            [self HttpRequestRegister];
        }
        
   
}


- (IBAction)TapGetVerificationCode:(UIButton*)sender {
    SLLog2(@"获取验证码");
    SLVerifyPhone(self.iphoneText.text, @"请输入手机号");
    [self _requestSendVerify:sender];
    
    
    
}

- (UIView *)bgView {
    if (_bgView == nil) {
        
        _bgView = [UIView viewWithBgColor:RGBColor2(0, 0, 0, 0.3) frame:Rect(0, 0, kScreenWidth, kScreenHeight)];
        LFRegisterMinuteView *MinuteView = [LFRegisterMinuteView creatViewFromNib];
        [_bgView addSubview:MinuteView];
        
        self.MinuteView =MinuteView;
        [MinuteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Fit375(50));
            make.right.mas_equalTo(Fit375(-50));
            make.centerY.offset(0);
            make.height.mas_equalTo(Fit375(440));
        }];
        @weakify(self);
        MinuteView.didClickCannceBtnBlock = ^{
            @strongify(self);
            self->_bgView.hidden = YES;
        };
        
        MinuteView.didClickSaveBtnBlock =^(NSDictionary * dictMessage){
            @strongify(self);
            self->_bgView.hidden = YES;
            self->_dictMessage = dictMessage;
        };
    }
    return _bgView;
}


#pragma mark - 网络请求
///  请求验证码
- (void)_requestSendVerify:(UIButton *)sender {
    NSString * url = @"login/gainCode.htm";
    LFParameter * params = [LFParameter new];
    params.mobilePhone = self.iphoneText.text;
        [TSNetworking POSTWithURL:url paramsModel:params completeBlock:^(NSDictionary *request) {
//        SLLog2(@"~验证码发送成功~~~~~~~~~~~~~~~~~~~~~~~~`request :%@",request);
            [sender countDownWithTime:60 title:@"重新获取" countDownTitle:@"重新获取" backgroundColor:[UIColor whiteColor] disabledColor:HexColorInt32_t(C20D20)];

    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
                SLLog(error);
    }];
    
}


-(void)HttpRequestRegister {
    NSString * url =@"login/register.htm";
    LFParameter *paeme = [LFParameter new];
    paeme.mobilePhone = self.iphoneText.text;
    paeme.smsCode = self.vifyCodeText.text;
    paeme.passWord = self.NewPassWordText.text;
    paeme.height = _dictMessage[@"height"];
    paeme.weight = _dictMessage[@"weight"];
    paeme.waist = _dictMessage[@"waistline"];
    paeme.bust = _dictMessage[@"thechest"];
    paeme.hipline = _dictMessage[@"hipline"];
    paeme.size = _dictMessage[@"footage"];
    paeme.inviteCode = self.FriendCode.text;
    paeme.province = self.province;
    paeme.city = self.city;
    paeme.state = self.district;
    SLLog2(@"partr   == ==%@ , ---- %@" , paeme,_dictMessage);
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        NSLog(@"~~~~~~~~~%@", self.vifyCodeText.text);
        SLLog2(@"request :%@",request);
        if ([request[@"result"]integerValue] == 200 ) {
            SVShowSuccess(@"注册成功");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            SVShowError(request[@"msg"]);
        }
        
    } failBlock:^(NSError *error) {
        SVShowError(@"网络错误");
    }];
}

//扫一扫
- (IBAction)scan:(UIButton *)sender {
    NSLog(@"扫一扫");
    LHScanViewController *scanVC = [[LHScanViewController alloc] init];
    [scanVC invoteCodeBlock:^(NSString *invoteCode) {
        NSLog(@"%@", invoteCode);
        self.FriendCode.text = invoteCode;
    }];
    scanVC.idString = @"LFRegisterViewController";
    [self.navigationController pushViewController:scanVC animated:YES];
}



@end
