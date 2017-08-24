//
//  LFMineViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/22.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFMineViewController.h"
#import "LFMineHearderView.h"
#import "LFChangeCloseViewController.h"
#import "LFMoneyBagViewController.h"
#import "LFCollctViewController.h"
#import "LFUsedViewController.h"
#import "LFRetailViewController.h"
#import "LFMineAddressViewController.h"
#import "LFVipViewController.h"
#import "LfSettingViewController.h"
#import "LFCenterViewController.h"
#import "LFFLowViewController.h"
#import "SLOrdersVC.h"
#import "LFDistributionViewController.h"
#import "LFCardBagViewController.h"

@interface LFMineViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (nonatomic,   weak) UITableView * minetabbleView;
@property (nonatomic, strong) LFMineHearderView * headerView;
@property (nonatomic, assign) CGFloat dragDelta;

@property (nonatomic, assign) NSInteger isAgentID;

@end

@implementation LFMineViewController
{
    UIView * _header;
//    BOOL _first;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    setStatusBarLightContent(YES);

    if (user_loginKey == nil) {
        
    }else{
        [self HttpRequestCenter];
    }
    
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    self.isAgentID = [dic[@"isAgent"] integerValue];
    NSLog(@"~~~~~~%ld", _isAgentID);
    if (_isAgentID == 0) {
        self.headerView.QRCodeBtn.hidden = YES;
    } else {
        self.headerView.QRCodeBtn.hidden = NO;
    }
    

    
    
    [self.minetabbleView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    setStatusBarLightContent(NO);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self CreateTabbleView];

    
//    _first = YES;
}
///创建界面
-(void)CreateTabbleView{
    UITableView * tableView = [[UITableView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight-50) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.sectionHeaderHeight = 0;
    tableView.sectionFooterHeight = 10;
    [self.view addSubview:tableView];
    
    self.minetabbleView = tableView;
  
}
#pragma mark  -- 创建headerView
-(UIView *)CreateMineHeadView{
    if (_header) {
        return _header;
    }
    _header  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Fit375(302))];
    _header.backgroundColor = [UIColor redColor];
    self.headerView = [LFMineHearderView creatViewFromNib];
    self.headerView.frame = Rect(0, 0, kScreenWidth, Fit375(302));
    @weakify(self);
    self.headerView.didInvoteBtn = ^{
         @strongify(self);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入邀请码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alert show];
        
    };
    if ([[User getUseDefaultsOjbectForKey:kVipStatus] integerValue] != 1) {
        self.headerView.addVipBtn.hidden = NO;
        self.headerView.didSelectAddVip = ^{
            @strongify(self);
            [self TapAddvip];
        };
    } else {
        self.headerView.addVipBtn.hidden = YES;
    }

    self.headerView.didSettingBtn =^{
        @strongify(self);
        [self TapSettingVC];
    };
    self.headerView.didCenterBtn =^{
          @strongify(self);
        [self TapCenterVC];
    };
    self.headerView.didCodeBtn = ^{
        @strongify(self);
        [self showQRCode];
        
        NSLog(@"二维码");
    };
    if (self.isAgentID != 0) {
        self.headerView.QRCodeBtn.hidden = NO;
    } else {
        self.headerView.QRCodeBtn.hidden = YES;
    }
    self.headerView.didClickOrderBlock = ^(NSInteger index) {
        @strongify(self);
        SLOrdersVC * controller = [[SLOrdersVC alloc] init];
        controller.selectedType = index;
        [self.navigationController pushViewController:controller animated:YES];
    };
    
    [_header addSubview:self.headerView];
    return _header;
}

- (void)showQRCode {
    [self HttpRequestQRCode];
}
- (void)handleWindowAction:(UITapGestureRecognizer *)sender {
    [sender.view removeFromSuperview];
}
-(void)HttpRequestQRCode {
    NSString * url =@"personal/Qrcode.htm?";
    LFParameter *paeme = [LFParameter new];
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    paeme.loginKey = user_loginKey;
    [TSNetworking POSTWithURL:url paramsModel:@{@"id": dic[@"user_id"]} needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        } else {
            UIView * bgView = [UIView viewWithBgColor:[HexColorInt32_t(000000) colorWithAlphaComponent:0.5] frame:[UIScreen mainScreen].bounds];
            [[UIApplication sharedApplication].keyWindow addSubview:bgView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleWindowAction:)];
            [bgView addGestureRecognizer:tap];
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(80, 150, kScreenWidth-160, kScreenWidth-160)];
            [bgView addSubview:view];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:request[@"url"]] placeholderImage:[UIImage imageNamed:@""]];
            [view addSubview:imageView];
        }
    } failBlock:^(NSError *error) {
        SLLog(error);
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UITextField *txt = [alertView textFieldAtIndex:1];
        [self HttpRequestChangeCenterMessage:txt.text];
    }
}


-(void)HttpRequestChangeCenterMessage:(NSString *)txt {
    NSString * url =@"personal/addinviteCode.htm?";
    LFParameter *parameter = [LFParameter new];
//    parameter.loginKey = user_loginKey;
    NSDictionary *dic = [User getUseDefaultsOjbectForKey:KLogin_Info];
    parameter.user_id = dic[@"user_id"];
    parameter.inviteCode = txt;
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        if ([request[@"result"] integerValue]!=200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        SVShowSuccess(request[@"msg"]);
        BLOCK_SAFE_RUN(self.vBlock);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failBlock:^(NSError *error) {
        SLLog(error);
    }];
}






#pragma  mark - 请求网络数据
-(void)HttpRequestCenter{
    NSString * url =@"personal/userInfo.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.loginKey = user_loginKey;
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);return ;
        }
//        _first = NO;
        [User saveCenterUserInfomation:request];
        [self.headerView setdata:request];
    } failBlock:^(NSError *error) {
        SLLog(error);
    }];
}

#pragma mark - TabbleviewDataSourse

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isAgentID == 0) {
        NSInteger counts[] = {2, 1, 1};
        return counts[section];
    } else {
        NSInteger counts[] = {2, 2, 1};
        return counts[section];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self CreateMineHeadView];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * ID = @"profile";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
      cell = [[[NSBundle mainBundle] loadNibNamed:@"ProfileView" owner:self options:nil] objectAtIndex:0];
        
    }
    NSArray<NSArray<NSString *> *> * titles = nil;
    NSArray<NSArray<NSString *> *> * images = nil;
    if (self.isAgentID == 0) {
        if (!titles) {
            titles = @[
                       @[/*@"我要换装",*/ @"我的卡包", @"我的收藏"],
                       @[/* @"我的闲置",*/ /*@"我的分销",*/@"收货地址"/*,@"租用流程"*/],
                       @[@"客服热线"]
                       ];
        }
        //
        if (!images) {
            images = @[
                       @[/*@"衣服icon-122438",*/ @"钱包", @"收藏"],
                       @[/*@"休闲",*//* @"分销",*/@"收货地址"/*,@"流程"*/],
                       @[@"电话-(1)"]
                       ];
        }
    } else {
        if (!titles) {
            titles = @[
                       @[/*@"我要换装",*/ @"我的卡包", @"我的收藏"],
                       @[/* @"我的闲置",*/ @"我的分销",@"收货地址"/*,@"租用流程"*/],
                       @[@"客服热线"]
                       ];
        }
        //
        if (!images) {
            images = @[
                       @[/*@"衣服icon-122438",*/ @"钱包", @"收藏"],
                       @[/*@"休闲",*/ @"分销",@"收货地址"/*,@"流程"*/],
                       @[@"电话-(1)"]
                       ];
        }
    }
    UIImageView * imageV = [cell.contentView viewWithTag:-1];
    UILabel * label = [cell.contentView viewWithTag:-2];
    SLDevider * devider = [cell.contentView viewWithTag:-3];
    
    imageV.image = [UIImage imageNamed:images[indexPath.section][indexPath.row]];
    label.text = titles[indexPath.section][indexPath.row];
    devider.hidden = indexPath.row == [titles[indexPath.section] count] - 1;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Fit375(50);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return Fit375(302);
    }
    else{
        return 0;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    static NSArray * classes = nil;
    if (self.isAgentID == 0) {
        if (!classes) {
            classes = @[
                        @[
                            //   [LFChangeCloseViewController class],
                            [LFCardBagViewController class],
                            [LFCollctViewController class]
                            ],
                        @[
                            //   [LFUsedViewController class],
                            //   [LFRetailViewController class],
//                            [LFDistributionViewController class],
                            [LFMineAddressViewController class]]
                        //                        [LFFLowViewController class]]
                        
                        ];
        }
        
    } else {
        if (!classes) {
            classes = @[
                        @[
                            //  [LFChangeCloseViewController class],
                            [LFCardBagViewController class],
                            [LFCollctViewController class]
                            ],
                        @[
                            //  [LFUsedViewController class],
                            //  [LFRetailViewController class],
                            [LFDistributionViewController class],
                            [LFMineAddressViewController class]]
                        //                        [LFFLowViewController class]]
                        
                        ];
        }
    }
 
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self TapCallPhone];
    } else {
        UIViewController * controller = [[classes[indexPath.section][indexPath.row] alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 计算往下拽的距离
    CGFloat dragDelta = -scrollView.contentOffset.y;
    if (dragDelta < 0) dragDelta = 0;
    self.headerView.imageHeightCons.constant = Fit(169) + dragDelta;
    self.dragDelta = dragDelta;
}

#pragma mark - Action



-(void)TapAddvip{
    LFVipViewController * vip = [[LFVipViewController alloc]init];
    [self.navigationController pushViewController:vip animated:YES];
}

-(void)TapSettingVC{
    LfSettingViewController * setting = [[LfSettingViewController alloc]init];
    [self.navigationController pushViewController:setting animated:YES];
}

-(void)TapCenterVC{
    LFCenterViewController * center = [[LFCenterViewController alloc]init];
    @weakify(self);
    center.vBlock=^{
        @strongify(self);
        [self HttpRequestCenter];
    };
    [self.navigationController pushViewController:center animated:YES];
}
-(void)TapCallPhone{
//    [UIAlertView alertWithTitle:@"拨打客服" message:[NSString stringWithFormat:@"%@",[User sharedUser].lfuserinfo.customerPhone] cancelButtonTitle:@"取消" OtherButtonsArray:@[@"确定"] clickAtIndex:^(NSInteger buttonIndex) {
//        if (buttonIndex == 1) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[User sharedUser].lfuserinfo.customerPhone]]];
//        }
//    }];
    //拨打客服电话
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://020-37889773"] options:@{} completionHandler:nil];
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"020-37889773"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}



















@end
