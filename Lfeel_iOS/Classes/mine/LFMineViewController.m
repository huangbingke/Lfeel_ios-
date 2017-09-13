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
#import "LFShareView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "SLShareHelper.h"

@interface LFMineViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic,   weak) UITableView * minetabbleView;
@property (nonatomic, strong) LFMineHearderView * headerView;
@property (nonatomic, assign) CGFloat dragDelta;

@property (nonatomic, assign) NSInteger isAgentID;
@property (nonatomic, copy) NSString *parent_id;
@property (nonatomic, strong) LFShareView * shareView;
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
    self.parent_id = (NSString *)[User getUseDefaultsOjbectForKey:kParent_id];
    if (self.parent_id.length <= 0) {
        self.parent_id = (NSString *)dic[@"user_id"];
    }
    
    
    self.isAgentID = [dic[@"isAgent"] integerValue];
    NSLog(@"~~~~~~%ld------%@", _isAgentID, self.parent_id);
    if (_isAgentID == 0) {
        if (self.parent_id.length > 0) {
            self.headerView.QRCodeBtn.hidden = NO;

        } else {
            self.headerView.QRCodeBtn.hidden = YES;
            
        }
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
        if (self.parent_id.length > 0) {
            self.headerView.QRCodeBtn.hidden = NO;
            
        } else {
            self.headerView.QRCodeBtn.hidden = YES;
            
        }
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

- (void)setQRcodeViewWith:(NSString *)url {
    UIView * bgView = [UIView viewWithBgColor:[HexColorInt32_t(000000) colorWithAlphaComponent:0.5] frame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleWindowAction:)];
    tap.delegate = self;
    [bgView addGestureRecognizer:tap];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-200)/2, (kScreenHeight-250)/2, 200, 250)];
    [bgView addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.width)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"place_flat"]];
    imageView.userInteractionEnabled = YES;
    [view addSubview:imageView];
    
    UIButton *shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    shareBtn.frame = CGRectMake(0, view.frame.size.width + 10, view.frame.size.width, 40);
    [shareBtn setTitle:@"分享给好友" forState:(UIControlStateNormal)];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    shareBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    shareBtn.layer.borderWidth = 1;
    [view addSubview:shareBtn];
    [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.shareView = [LFShareView creatViewFromNib];
    self.shareView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, Fit(140));
    @weakify(self);
    self.shareView.didClickBtnBlock = ^(BOOL cancel, NSInteger index) {
        if (!cancel) {
            @strongify(self);
            UMSocialPlatformType types[] = {UMSocialPlatformType_WechatSession, UMSocialPlatformType_WechatTimeLine, UMSocialPlatformType_QQ, UMSocialPlatformType_Sina};
            [SLShareHelper shareTitle:@"乐荟盒子 | 500元现金券不拿白不拿" desc:@"晚了就没有啦!!!" url:[NSString stringWithFormat:@"http://120.76.215.11:8021/leHuiShop/htdocs/index.html?agent_user_id=%@", self.parent_id] image:[UIImage imageNamed:@"APPPhoto"] Plantform:types[index] callBack:^(BOOL success) {
                NSString * txt = (success ? @"分享成功" : @"分享失败");
                SVShowSuccess(txt);
            }];
        }
    };
    [bgView addSubview:self.shareView];
    
}

- (void)shareBtnAction {
    NSLog(@"分享");
    [UIView animateWithDuration:0.2 animations:^{
       CGPoint point = self.shareView.center;
        point.y = point.y-Fit(140);
        self.shareView.center = point;
    } completion:^(BOOL finished) {
        
    }];
    
}
//防止手势冲突——防止UITableView的点击事件和手势事件冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 输出点击的view的类名
    // NSLog(@"%@", NSStringFromClass([touch.view class]));
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIImageView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"]) {
        return NO;
    }
    return  YES;
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
    NSString *parent_id = [User getUseDefaultsOjbectForKey:kParent_id];
    NSString *id_ = nil;
    if (parent_id.length > 0) {
        id_ = parent_id;
    } else {
        id_ = dic[@"user_id"];
    }
    
    [TSNetworking POSTWithURL:url paramsModel:@{@"id": id_} needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        } else {
            [self setQRcodeViewWith:request[@"url"]];
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
