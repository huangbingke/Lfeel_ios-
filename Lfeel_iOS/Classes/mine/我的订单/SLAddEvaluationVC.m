//
//  SLAddEvaluationVC.m
//  PocketJC
//
//  Created by apple on 16/10/9.
//  Copyright © 2016年 CHY. All rights reserved.
//

#import "SLAddEvaluationVC.h"
#import "SLAddEvaluationCell.h"
#import "CWStarRateView.h"
#import "UIImage+Compress.h"

@interface SLAddEvaluationVC ()
<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,   weak) UITableView * tableView;
@property (nonatomic, strong) _SLOrderDetail * detail;
@end

@implementation SLAddEvaluationVC

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    setStatusBarLightContent(YES);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化数据
    [self setupInitialData];
    
    // 初始化导航条
    [self setupNavigationBar];
    
    // 初始化子控件
    [self setupSubViews];
    
    [self _requestOrderDetailData];
}
///  初始化数据
- (void)setupInitialData {
    
}

///  初始化子控件
- (void)setupSubViews {
    SetBackgroundGrayColor;
    UITableView * tableView = [[UITableView alloc] initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight - 64 - Fit414(74)) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.sectionHeaderHeight = 0;
    tableView.sectionFooterHeight = 0;
    
    UIButton * btn = [UIButton buttonWithTitle:@"发表评价" titleColor:[UIColor whiteColor] backgroundColor:HexColorInt32_t(27ce6f) font:Fit414(16) image:nil frame:Rect(Fit414(15), kScreenHeight - Fit414(59), kScreenWidth - Fit414(30), Fit414(44))];
    btn.cornerRadius = 3;
    [self.view addSubview:btn];
    @weakify(self);
    [[btn rac_signalForControlEvents:64] subscribeNext:^(id x) {
        @strongify(self);
        NSMutableArray * arr = @[].mutableCopy;
        _SLOrderDetail * model = self.detail;
        if (!model.sl_evalutionText.length && !model.sl_images.count) {
            SVShowError(@"您还有商品未输入评价或者选择图片");
            return ;
        }
        NSMutableString * pics = [NSMutableString new];
        for (NSString * s in model.sl_imagesIDs) {
            [pics appendFormat:@"%@,", s];
        }
        if ([pics hasSuffix:@","]) {
            [pics deleteCharactersInRange:NSMakeRange(pics.length - 1, 1)];
        }
        
        NSMutableDictionary * dict = @{}.mutableCopy;
        dict[@"goods_id"] = model.goods_id;
        dict[@"grade"] = stringWithInteger(model.sl_score * 5);
        dict[@"merchant_score"] = stringWithInteger(model.sl_merchant_score * 5);
        dict[@"comment"] = model.sl_evalutionText ? : @"";
        dict[@"comment_pic"] = pics;
        [arr addObject:dict];
        [self _requestUploadEvaluationData:[arr yy_modelToJSONString]];
    }];
    
}

///  初始化导航条
- (void)setupNavigationBar {
    @weakify(self);
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"评价" backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

#pragma mark - Actions

#pragma mark - network
///  请求详情数据
- (void)_requestOrderDetailData {
    NSString * url = @"UOrder/orderInfo";
    SLParameter * params = [SLParameter new];
    params.order_id = self.order_id;
    
    [TSNetworking POSTWithURL:url paramsModel:params needProgressHUD:YES completeBlock:^(SLBaseModel *request) {
        SLLog(request);
        if ([request.flag isEqualToString:@"error"]) {
            SVShowError(request.message); return ;
        }
        
        self.detail = [_SLOrderDetail yy_modelWithDictionary:request.data];
        [self.tableView reloadData];
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
    
}

///  评价
- (void)_requestUploadEvaluationData:(NSString *)contentJSON {
    
    NSString * url = @"UOrder/commentOrder";
    SLParameter * params = [SLParameter new];
    params.m_id = user_m_id;
    params.order_id = self.order_id;
    params.comment_json = contentJSON;
    
    [TSNetworking POSTWithURL:url paramsModel:params needProgressHUD:YES completeBlock:^(SLBaseModel *request) {
        SLLog(request);
        if ([request.flag isEqualToString:@"error"]) {
            SVShowError(request.message); return ;
        }
        SVShowSuccess(request.message);
        BLOCK_SAFE_RUN(self.vBlock);
        USER.needRefreshOrder = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
}

#pragma mark - Delegate

#pragma mark UITaleView delegate, datasoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static CGFloat _height;
    if (_height == 0) {
        CGFloat _pandding = 7;
        // 图片容器高度
        CGFloat wh = (kScreenWidth - 30 - 3 * _pandding) / 4 + 7;
        _height = 15 /*顶部间距*/ + Fit414(77) /*头像高度*/ + 10 /*头像与图片容器间距*/ + wh + 15 /*图片容器到底部间距*/ + 60;
        SLLog(_height);
    }
    return _height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SLAddEvaluationCell * cell = [SLAddEvaluationCell cellWithTableView:tableView];
    cell.detail = self.detail;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * header = [UIView viewWithBgColor:nil frame:Rect(0, 0, kScreenWidth, 55)];
    UIView * container = [UIView viewWithBgColor:[UIColor whiteColor] frame:Rect(0, 0, kScreenWidth, 50)];
    [header addSubview:container];
    header.tag = section;
    
    UILabel * label = [UILabel labelWithText:@"商家评分：" font:15 textColor:HexColorInt32_t(333333) frame:Rect(15, 0, 100, 100)];
    [label sizeToFit];
    label.centerY = container.halfHeight;
    [container addSubview:label];
    // 星星
    CWStarRateView * star = [[CWStarRateView alloc] initWithFrame:Rect(95, 0, 110, 16) numberOfStars:5];
    star.centerY = 25;
    star.userInteractionEnabled = YES;
    [container addSubview:star];
    star.delegate = (id<CWStarRateViewDelegate>)self;
    star.scorePercent = self.detail.sl_merchant_score;
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55;
}

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent {
    self.detail.sl_merchant_score = newScorePercent;
}
#pragma mark - Private

#pragma mark - Getter \ Setter
@end
