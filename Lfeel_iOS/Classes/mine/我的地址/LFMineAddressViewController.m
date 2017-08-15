//
//  LFMineAddressViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFMineAddressViewController.h"
#import "LFMineAddressCell.h"
#import "LFMineAddressFooterView.h"
#import "LFAddressViewController.h"
#import "SLEmptyView.h"

@interface LFMineAddressViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray<LFAddressModel *> * addresses;
@property (nonatomic,   weak) UITableView * tableView;
@property (nonatomic, strong) SLEmptyView * empty;
@end

@implementation LFMineAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self CreateView];
    
    [self _requestAddressList];
}



/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    @weakify(self);
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"我的地址" rightItem:@"新增" rightAction:^{
        @strongify(self);
        LFAddressViewController * add  =[[LFAddressViewController alloc]init];
        add.vBlock = ^{
            [self.addresses removeAllObjects];
            [self _requestAddressList];
        };
        [self.navigationController pushViewController:add animated:YES];
        SLLog2(@"新增");
    } backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];

}

-(void)CreateView{
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    tabbleView.dataSource = self;
    tabbleView.delegate = self;
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabbleView.rowHeight = Fit375(84);
    tabbleView.tableFooterView = [UIView new];
    [self.view addSubview:tabbleView];
    tabbleView.backgroundColor = HexColorInt32_t(f1f1f1);
    self.tableView = tabbleView;
}

///  请求地址列表
- (void)_requestAddressList {
    
    NSString * url = @"address/addressList.htm?";
    LFParameter * parameter = [LFParameter new];
    [parameter appendBaseParam];
    
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        
        [self.addresses addObjectsFromArray:[NSArray yy_modelArrayWithClass:[LFAddressModel class] json:request[@"jsonAddressList"]]];
        [self.tableView reloadData];
        if (!self.addresses.count) {
            [self.view addSubview:self.empty];
        } else {
            [self.empty removeFromSuperview];
        }
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
}


/**
 设置默认地址

 @param index 索引
 */
- (void)_requestSetDefaultData:(NSInteger)index {
    /*
     默认状态1默认0非默认	addressStatus	string	地址默认状态，1默认0非默认
     loginKey	string
     地址ID	addressId	string	地址ID*/
    LFAddressModel * address = self.addresses[index];
    NSString * url = @"address/updateDefaultAddress.htm?";
    LFParameter * parameter = [LFParameter new];
    parameter.addressStatus = address.defaultStatus ? @"0" : @"1";
    parameter.addressId = address.addressId;
    [parameter appendBaseParam];
    
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        address.defaultStatus = !address.defaultStatus;
        for (LFAddressModel * model in self.addresses) {
            if (model == address) {
                continue;
            }
            model.defaultStatus = NO;
        }
        [self.tableView reloadData];
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
}

/**
 删除地址
 
 @param index 索引
 */
- (void)_requestDeleteAddressData:(NSInteger)index {
    /*
     默认状态1默认0非默认	addressStatus	string	地址默认状态，1默认0非默认
     loginKey	string
     地址ID	addressId	string	地址ID*/
    LFAddressModel * address = self.addresses[index];
    NSString * url = @"address/deleteAddress.htm?";
    LFParameter * parameter = [LFParameter new];
    parameter.addressId = address.addressId;
    [parameter appendBaseParam];
    
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        SVShowSuccess(@"删除成功");
        [self.addresses removeObjectAtIndex:index];
        [self.tableView reloadData];
        if (self.addresses.count == 0) {
            [self.view addSubview:self.empty];
        }
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.addresses.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.addresses.count == 0) return 0;
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LFMineAddressCell * cell = [LFMineAddressCell cellWithTableView:tableView];
    cell.address = self.addresses[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.didSelectedAddressBlock) return;
    BLOCK_SAFE_RUN(self.didSelectedAddressBlock ,self.addresses[indexPath.section]);
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView * footerView = [[UIView alloc]initWithFrame:Rect(0, 0, kScreenWidth, Fit375(56))];
    footerView.backgroundColor = [UIColor clearColor];
    LFMineAddressFooterView * mineAddressFooterView = [LFMineAddressFooterView creatViewFromNib];
    mineAddressFooterView.frame = Rect(0, 0, footerView.width, mineAddressFooterView.height);
    [footerView addSubview:mineAddressFooterView];
    mineAddressFooterView.address = self.addresses[section];
    @weakify(self);
    [mineAddressFooterView setDidDefaultBtnBlock:^{
        @strongify(self);
        [self _requestSetDefaultData:section];
    } editBlock:^{
        @strongify(self);
        LFAddressViewController * add  =[[LFAddressViewController alloc]init];
        add.address = self.addresses[section];
        add.vBlock = ^{
            [self.addresses removeAllObjects];
            [self _requestAddressList];
        };
        [self.navigationController pushViewController:add animated:YES];
    } deleteBlcok:^{
        @strongify(self);
        [SLAlertView alertViewWithTitle:@"确定要删除吗?" cancelBtn:@"取消" destructiveButton:@"删除" otherButtons:nil clickAtIndex:^(NSInteger buttonIndex) {
            [self _requestDeleteAddressData:section];
        }];
    }];
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return Fit375(56);
}


- (NSMutableArray<LFAddressModel *> *)addresses {
    SLLazyMutableArray(_addresses);
}

- (SLEmptyView *)empty {
    if (!_empty) {
        _empty = [[SLEmptyView alloc] initWithFrame:self.tableView.frame];
    }
    return _empty;
}

@end
