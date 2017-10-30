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
#import "LFMineAddressViewController.h"
#import "LHPickView.h"
#define kColor(r, g, b)         [UIColor colorWithRed:(r)/256.0 green:(g)/256.0 blue:(b)/256.0 alpha:1.0]

@interface LFPackViewController ()<LHPickViewDelegate>

////////////////////////////////-------地址------/////////////////////
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;////////////
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;//////////
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;/////////////
/////////////////////////////////////////////////////////////////////
@property (weak, nonatomic) IBOutlet UILabel *selectAddressLabel;

//预约时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

//////////////////////////////-------商品------//////////////////////
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;///
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;///////////
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;///////////
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;////////////
////////////////////////////////////////////////////////////////////


@property (weak, nonatomic) IBOutlet UILabel *useTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *surplusTimeLabel;//剩余时间

@property (nonatomic, strong) LFAddressModel * addressModel;

@property (nonatomic, strong) LHPickView *linePickView;

@property (nonatomic, copy) NSString *product_id;

@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;

@end

@implementation LFPackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNavigationBar];
    
    [self _requestAddressList];
    
    [self requestData];
}


///  设置自定义导航条
- (void)setupNavigationBar {
    @weakify(self);
    NSString * title = @"寄回盒子";
    self.ts_navgationBar = [TSNavigationBar navWithTitle:title backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}




//选择地址
- (IBAction)selectAddress:(id)sender {
    LFMineAddressViewController * controller = [[LFMineAddressViewController alloc] init];
    controller.didSelectedAddressBlock = ^(LFAddressModel *model) {
        [self _setupAddress:model];
    };
    [self.navigationController pushViewController:controller animated:YES];
    
}
//选择预约时间
- (IBAction)selectTime:(id)sender {
    NSArray *timeArray = @[@"今天9:00 - 11:00", @"今天11:00 - 13:00", @"今天13:00 - 15:00", @"今天15:00 - 17:00", @"明天9:00 - 11:00", @"明天11:00 - 13:00", @"明天13:00 - 15:00", @"明天15:00 - 17:00"];
    [self createLineOnePickViewWithArray:timeArray];
}

//寄回盒子
- (IBAction)sendBox:(id)sender {
    if (!self.startTime) {
        SVShowError(@"请选择快递上门时间");
    } else {
        [self requestSubmitData];
    }
}

//获取今天日期
- (NSString *)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"今天currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}

//获取明天日期
- (NSString *)getTommorrowTimes {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *datenow = [NSDate date];
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:datenow];//后一天
    NSString *currentTimeString = [formatter stringFromDate:nextDay];
    NSLog(@"明天currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}



- (void)_setupAddress:(LFAddressModel *)model {
    self.selectAddressLabel.text = @"";
    self.nameLabel.text = [NSString stringWithFormat:@"寄件人: %@", model.contactName];
    self.phoneLabel.text = model.contact;
    self.addressLabel.text = model.address;
    
    [[NSUserDefaults standardUserDefaults] setObject:[model yy_modelToJSONObject] forKey:@"address"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///  请求默认地址
- (void)_requestAddressList {
    
    NSString * url = @"address/addressList.htm?";
    LFParameter * parameter = [LFParameter new];
    parameter.defaultStatus = @"1";
    
    [parameter appendBaseParam];
    
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        if ([(NSArray *)request[@"jsonAddressList"] count] == 0) {
            self.nameLabel.text = @"";
            self.addressLabel.text = @"";
            self.phoneLabel.text = @"";
            self.selectAddressLabel.text = @"请选择地址";
        } else {
            self.addressModel = [LFAddressModel yy_modelWithJSON:[(NSArray *)request[@"jsonAddressList"] firstObject]];
            NSLog(@"%@", self.addressModel.contact);
            [self _setupAddress:self.addressModel];
        }

    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
}

- (void)requestSubmitData {
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    NSString * url =@"order/application.htm?";
//    LFParameter *paeme = [LFParameter new];
//    paeme.user_id = dic[@"user_id"];
//    paeme.type = @"3";
//    paeme.addressId = self.addressModel.addressId;
//    paeme.start = self.startTime;
//    paeme.end = self.endTime;
    
    NSDictionary *dict = @{@"user_id": dic[@"user_id"], @"type": @"3", @"address_id": self.addressModel.addressId, @"start": self.startTime, @"end": self.endTime};
    
    [TSNetworking POSTWithURL:url paramsModel:dict needProgressHUD:YES completeBlock:^(NSDictionary *request) {
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

- (void)requestData {
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    NSString * url =@"order/backup.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.user_id = dic[@"user_id"];
    [TSNetworking GETWithURL:url paramsModel:paeme completeBlock:^(NSDictionary *request) {
        NSLog(@"%@", request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(@"请求出错");
        } else {
            if ([(NSArray *)request[@"data"] count] == 0) {
                SVShowError(@"寄回中...请稍候再试~~~");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            } else {
                [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:request[@"data"][@"product_url"]]];
                self.titleLabel.text = [NSString stringWithFormat:@"%@", request[@"data"][@"product_name"]];
                self.brandLabel.text = [NSString stringWithFormat:@"%@", request[@"data"][@"brand_name"]];
                self.sizeLabel.text = [NSString stringWithFormat:@"%@", request[@"data"][@"remark"]];
                self.useTimeLabel.text = [NSString stringWithFormat:@"已使用时间:%ld分钟", [request[@"data"][@"used_minutes"] integerValue]];
                self.surplusTimeLabel.text = [NSString stringWithFormat:@"剩余使用时间:%ld分钟", [request[@"data"][@"remain_minutes"] integerValue] - [request[@"data"][@"used_minutes"] integerValue]];
            }
            
            
        }
    } failBlock:^(NSError *error) {
        NSLog(@"%@", error);
        SVShowError(@"请求错误");
    }];
}


#pragma mark --------------------- LHPickViewDelegate ------------
//选中pickview走的回调
- (void)toobarDonBtnHaveClick:(LHPickView *)pickView resultString:(NSString *)resultString resultIndex:(NSInteger) index {
    if (pickView == self.linePickView) {
        NSLog(@"%@-----------%ld", resultString, index);
        self.timeLabel.text = resultString;
        
            if (index == 0) {
                self.startTime = [NSString stringWithFormat:@"%@ 9:00:00", [self getCurrentTimes]];
                self.endTime = [NSString stringWithFormat:@"%@ 11:00:00", [self getCurrentTimes]];
            } else if (index == 1) {
                self.startTime = [NSString stringWithFormat:@"%@ 11:00:00", [self getCurrentTimes]];
                self.endTime = [NSString stringWithFormat:@"%@ 13:00:00", [self getCurrentTimes]];
            } else if (index == 2) {
                self.startTime = [NSString stringWithFormat:@"%@ 13:00:00", [self getCurrentTimes]];
                self.endTime = [NSString stringWithFormat:@"%@ 15:00:00", [self getCurrentTimes]];
            } else if (index == 3) {
                self.startTime = [NSString stringWithFormat:@"%@ 15:00:00", [self getCurrentTimes]];
                self.endTime = [NSString stringWithFormat:@"%@ 17:00:00", [self getCurrentTimes]];
            } else if (index == 4) {
                self.startTime = [NSString stringWithFormat:@"%@ 9:00:00", [self getCurrentTimes]];
                self.endTime = [NSString stringWithFormat:@"%@ 11:00:00", [self getCurrentTimes]];
            } else if (index == 5) {
                self.startTime = [NSString stringWithFormat:@"%@ 11:00:00", [self getCurrentTimes]];
                self.endTime = [NSString stringWithFormat:@"%@ 13:00:00", [self getCurrentTimes]];
            } else if (index == 6) {
                self.startTime = [NSString stringWithFormat:@"%@ 13:00:00", [self getCurrentTimes]];
                self.endTime = [NSString stringWithFormat:@"%@ 15:00:00", [self getCurrentTimes]];
            } else if (index == 7) {
                self.startTime = [NSString stringWithFormat:@"%@ 15:00:00", [self getCurrentTimes]];
                self.endTime = [NSString stringWithFormat:@"%@ 17:00:00", [self getCurrentTimes]];
            }
        
        
        
        
        
    }
}

- (void)createLineOnePickViewWithArray:(NSArray *)array {
    self.linePickView = [[LHPickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
    self.linePickView.delegate = self;
    self.linePickView.toolbarTextColor = [UIColor blackColor];
    self.linePickView.toolbarBGColor = kColor(245, 245, 245);
    [self.linePickView show];
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















