//
//  LFHomeViewController.m
//  Lfeel_iOS
//
//  Created by apple on 2017/2/22.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFHomeViewController.h"
#import "HJScrollImage.h"
#import "HJScrollBanner.h"
#import "LFHotHireViewController.h"
#import "LFBaseModel.h"
#import "LFHomeHeaderView.h"
#import "LFBuyViewController.h"
#import "MJRefresh.h"
#import "LHNewHandsViewController.h"
#import <IQKeyboardManager.h>
#import "LHScanViewController.h"
@interface LFHomeViewController ()
<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,   weak) UITableView * tableView;
@property (nonatomic, strong) HJScrollImage * bannar;
@property (nonatomic, strong)  LFBaseModel * model;
@property (nonatomic, strong)NSMutableArray * bannerData;
@property (nonatomic, strong) NSMutableArray * tabbleViewData;


@end

@implementation LFHomeViewController

#pragma mark - Life circle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    
    //直接获取未读消息数
    NSLog(@"************  %d  ***********", [[ZCLibClient getZCLibClient] getUnReadMessage]);
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bannerData = [NSMutableArray array];
    self.tabbleViewData = [NSMutableArray array];
    
    [self setupSubViews];
    
   
     [self setupNavigationBar];
    
    [self _requestBanner];
    
    [self _requestGoodsCollection];
    
    NSLog(@"欢迎进入乐荟盒子");

}


    
///  初始化子控件
- (void)setupSubViews {
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight - 64 - 49) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
        
    @weakify(self);
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self _requestBanner];
        [self _requestGoodsCollection];
    }];
}

///  设置自定义导航条
- (void)setupNavigationBar {
    @weakify(self);
    NSString * title = @"乐荟";
    self.ts_navgationBar = [TSNavigationBar navWithTitle:title rightItem:@"Home_service" rightAction:^{
        @strongify(self)
        IfUserIsNotLogin;
        [self openZCServiceWithProduct:nil];
    } leftItem:@"Home_Scan" leftAction:^{
        @strongify(self)
        IfUserIsNotLogin;
        LHScanViewController *scanVC = [[LHScanViewController alloc] init];
        scanVC.idString = @"LFHomeViewController";
        [self.navigationController pushViewController:scanVC animated:YES];
        
    }];
}


#pragma mark - Actions


#pragma mark - Networking
///  请求轮播图
- (void)_requestBanner {
    
    NSString * url = @"manage/rotationPicture.htm?";
    LFParameter * parameter = [LFParameter new];
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:NO completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        [self.bannerData removeAllObjects];
        
        for( NSDictionary * dic in request[@"imgList"] ){
            [self setBannarData:dic];
        }
        NSMutableArray * pics = [NSMutableArray array];
        for (LFHomeModel *homemodel in self.bannerData) {
            [pics addObject:homemodel.imgUrl];
        }
        self.tableView.tableHeaderView = self.bannar;
        [HJScrollBanner bannerWithArray:pics scrollImage:self.bannar imageType:HJImageURLType];
        
    } failBlock:^(NSError *error) {
        
    }];
}
-(void)_requestGoodsCollection{
    NSString * url =@"manage/goodsCollection.htm?";
    LFParameter *paeme = [LFParameter new];
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        SLEndRefreshing(self.tableView);
        if (!([request[@"result"] integerValue] == 200)) {
            SVShowError(request[@"msg"]);
            return ;
        }
        [self.tabbleViewData removeAllObjects];
        for (NSDictionary * dic in request[@"imgList"]) {
            [self setTabbleViewAddData:dic];
        }
        [self.tableView reloadData];
        
    } failBlock:^(NSError *error) {
        SLEndRefreshing(self.tableView);
        SLShowNetworkFail;
        SLLog(error)
        
    }];
}

#pragma mark - Delegate

#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tabbleViewData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat f = 0;
    if (indexPath.row == 1) {
        f = 10;
    }
    return Fit(190) + f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Fit(180);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * ID = @"home";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        UIImageView * imageView = [UIImageView new];
        [cell.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(Fit(5));
            make.left.offset(Fit(5));
            make.right.offset(Fit(-5));
            make.bottom.offset(Fit(-5));
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.tabbleViewData.count > 0) {
    
        LFHomeModel * homeModel = self.tabbleViewData[indexPath.section];
        
        UIImageView * imagView = [cell.contentView.subviews lastObject];
        [imagView sd_setImageWithURL:[NSURL URLWithString:homeModel.imgUrl] placeholderImage:SLPlaceHolderFlat];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LFHotHireViewController *newRen = [[LFHotHireViewController alloc]init];
    if (self.tabbleViewData.count> 0) {
        LFHomeModel * homeModel = self.tabbleViewData[indexPath.section];
        newRen.ID = homeModel.ID;
        newRen.type = homeModel.type;
        newRen.title = homeModel.minorTitleName;
    }
    [self.navigationController pushViewController:newRen animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * header = [UIView viewWithBgColor:[UIColor whiteColor] frame:Rect(0, 0, kScreenWidth, Fit(65))];
    LFHomeHeaderView * view = [LFHomeHeaderView creatViewFromNib];
    view.frame  = header.frame;
    if (self.tabbleViewData.count >0) {
        LFHomeModel * homeModel =self.tabbleViewData[section];
        [view setHeaderMainTitleName:homeModel.mainTitleName andminorTitleName:homeModel.minorTitleName];
    }
    [header addSubview:view];
 
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return Fit(45);
}


-(void)setBannarData:(NSDictionary * )dic{
    NSError * error;
    LFHomeModel * homeModel  = [[LFHomeModel alloc]initWithDictionary:dic error:&error];
    [self.bannerData addObject:homeModel];
}
-(void)setTabbleViewAddData:(NSDictionary * )dic{
    NSError * error;
    LFHomeModel * homeModel  = [[LFHomeModel alloc]initWithDictionary:dic error:&error];
    
    
    [self.tabbleViewData addObject:homeModel];
    [self.tableView reloadData];
}


-(void)TapBannerGestureRecognizer:(UITapGestureRecognizer *)tap{
//    LFHotHireViewController *newRen = [[LFHotHireViewController alloc]init];
    NSInteger index = self.bannar.pageControl.currentPage;
//    LFHomeModel * model = self.bannerData[index];
//    newRen.ID = model.ID;
    NSInteger type = index;// model.type.integerValue;

    if (type < 0 || type > 3) {
        return;
    }
    LHNewHandsViewController * controller = [[LHNewHandsViewController alloc] init];
    controller.index = type;
    [self.navigationController pushViewController:controller animated:YES];
    
}


#pragma mark - Private


#pragma mark - Public


#pragma mark - Getter\Setter
- (HJScrollImage *)bannar {
    if (!_bannar) {
        HJScrollImage * bannar = [[HJScrollImage alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenWidth*0.5)];
        self.bannar = bannar;
        bannar.pageControl.currentPageIndicatorTintColor = HexColorInt32_t(333333);
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapBannerGestureRecognizer:)];
        [self.bannar addGestureRecognizer:tap];
    }
    return _bannar;
}
@end
