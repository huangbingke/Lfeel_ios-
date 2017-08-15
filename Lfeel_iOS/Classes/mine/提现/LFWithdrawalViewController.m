//
//  LFWithdrawalViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFWithdrawalViewController.h"

#import "LFSelectBankViewController.h"
#import "NSAttributedString+YYText.h"

@interface LFWithdrawalViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *contenView;
@property (weak, nonatomic) IBOutlet UILabel *bankName;


@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *integrallabel;

@property (weak, nonatomic) IBOutlet UITextField *drawTextF;


@end

@implementation LFWithdrawalViewController
{
    LFBanklistModel * model1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self.contenView rm_fitAllConstraint];
    NSString *st = [NSString stringWithFormat:@"%@",self.integral];
    NSString * rangeStr =[NSString stringWithFormat:@"乐荟币￥%@",st];
    
    NSString *string = [NSString stringWithFormat:@"乐荟币￥%@,全部提取",st];
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange range = [string rangeOfString:rangeStr];
    [attr yy_setColor:HexColorInt32_t(999999) range:range];
    self.integrallabel.attributedText = attr;

    [self.drawTextF addTarget:self action:@selector(changeTextFIntegral:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewTextf)];
    [self.view addGestureRecognizer:tap];
}

-(void)tapViewTextf{
    [self.view endEditing:YES];
}
-(void)changeTextFIntegral:(UITextField*)textFeild{

    if (textFeild.text.length > 0 ) {
        self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", [self.drawTextF.text floatValue]] ;
        NSString *st = [NSString stringWithFormat:@"%.2f",[self.drawTextF.text floatValue]];
        NSString * rangeStr =[NSString stringWithFormat:@"乐荟币￥%@",st];
        NSString *string = [NSString stringWithFormat:@"乐荟币￥%@,全部提取",st];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:string];
        NSRange range = [string rangeOfString:rangeStr];
        [attr yy_setColor:HexColorInt32_t(999999) range:range];
        self.integrallabel.attributedText = attr;
    }else{
        NSLog(@"666666666666666");
        
        self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", [self.drawTextF.text floatValue]] ;
        NSString *st = [NSString stringWithFormat:@"%.2f",[self.drawTextF.text floatValue]];
        NSString * rangeStr =[NSString stringWithFormat:@"乐荟币￥%@",st];
        NSString *string = [NSString stringWithFormat:@"乐荟币￥%@,全部提取",st];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:string];
        NSRange range = [string rangeOfString:rangeStr];
        [attr yy_setColor:HexColorInt32_t(999999) range:range];
        self.integrallabel.attributedText = attr;
        
    }
}


//余额200 全部提现
- (IBAction)TapSelectBtnAllMoney:(id)sender {
    SLLog2(@"全部提取");
    self.drawTextF.text = [NSString stringWithFormat:@"%@",self.integral];
    
    NSString *st = [NSString stringWithFormat:@"%@",self.integral];
    NSString * rangeStr =[NSString stringWithFormat:@"乐荟币￥%@",st];
    
    NSString *string = [NSString stringWithFormat:@"乐荟币￥%@,全部提取",st];
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange range = [string rangeOfString:rangeStr];
    [attr yy_setColor:HexColorInt32_t(999999) range:range];
    self.integrallabel.attributedText = attr;
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", [self.drawTextF.text floatValue]] ;
    
}



/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    
    @weakify(self);
    
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"提现" backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

//到账银行
- (IBAction)TapdidSelectBank:(id)sender {
    LFSelectBankViewController * select = [[LFSelectBankViewController alloc]init];
    @weakify(self);
    select.didSelectBank =^(LFBanklistModel *model){
        @strongify(self);
        SLLog(model);
        model1 = model;
        self.bankName.text = model.bankName;
    };
    [self.navigationController pushViewController:select animated:YES];
    
}

//提现
- (IBAction)TapSelectExtract:(id)sender {
    SLVerifyText(self.bankName.text.length, @"请选择银行");
    SLVerifyText(self.drawTextF.text.length, @"请输入提取金额");
    
    [self HttpRequestIntegralExtrac];
    
    
}
-(void)HttpRequestIntegralExtrac{
    ///order/application.htm?user_id=&type=&remark=&bank_no=&price=
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    NSString * url =@"order/application.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.user_id = dic[@"user_id"];
    paeme.type = @"1";
    paeme.remark = @"";
    paeme.bankId = model1.bankId;
    paeme.loginKey = user_loginKey;
    paeme.price = self.drawTextF.text;
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            return ;
        }
            SVShowSuccess(request[@"msg"]);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failBlock:^(NSError *error) {
        SLLog(error);
    }];
}




@end
