//
//  LFPreferenceViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFPreferenceViewController.h"
#import "SLWaterLayout.h"
#import "SLShopCell.h"
#import "LFGoodsCell.h"
#import "LFBuyModels.h"
#import "LFGoodsDetailViewController.h"
#import "SLEmptyView.h"

static NSString * const kIdentifier = @"LFGoodsCell";

@interface LFPreferenceViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray<LFGoods *> * datas;
@property (nonatomic, strong) UICollectionView * collectionView;

@end

@implementation LFPreferenceViewController{
    NSInteger startPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    self.datas = [NSMutableArray array];
    startPage = 0;
    
    
//    SLWaterLayout * layout = [[SLWaterLayout alloc] init];
//    layout.heightBlock =  ^(NSInteger row, CGFloat width){
//      
//        LFerenceViewModel * model = self.datas[row];
//
//        CGFloat h = width * [model.height floatValue]/[model.width floatValue];
//        
//        return h;
//    };
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = Fit(7);
    CGFloat f = (kScreenWidth - 3 * margin) / 2;
    CGFloat itemWH = floor(f);
    layout.itemSize = CGSizeMake(itemWH, Fit(305));
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight - 64)];
    [self.view addSubview:bgView];
    
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:bgView.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [bgView addSubview:collectionView];
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LFGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:kIdentifier];
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    
    @weakify(self);
    collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self HTTPRequset];
    }];
    
    [self HTTPRequset];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LFGoodsCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifier forIndexPath:indexPath];
    cell.needHiddenPrice = YES;
    cell.goods = self.datas[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LFGoodsDetailViewController * controller = [[LFGoodsDetailViewController alloc] init];
    controller.goodsId = self.datas[indexPath.item].goodsId;
    [self.navigationController pushViewController:controller animated:YES];
}
/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    @weakify(self);
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"我的喜爱" backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

 

-(void)HTTPRequset{
    NSString * url =@"personal/perPreferenceList.htm?";
    
    LFParameter *paeme = [LFParameter new];
    paeme.loginKey = user_loginKey;
    paeme.startPage =stringWithInt( startPage);
    @weakify(self);
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        @strongify(self);
        SLLog(request);
        if ([request[@"result"] integerValue]!= 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        NSArray *arr = [NSArray  yy_modelArrayWithClass:[LFGoods class] json:request[@"collectioList"]];

        if (!arr.count) {
            SLEmptyView * empty = [[SLEmptyView alloc] initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight - 64)];
            [self.view addSubview:empty];
            return;
        }
        
        startPage  = [request[@"startPage"] integerValue];
        NSString * totalPage  = request[@"totalPage"];
        if (startPage == [totalPage integerValue]) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
        [self.datas addObjectsFromArray:arr];
        [self.collectionView reloadData];
        
    } failBlock:^(NSError *error) {
        
    }];
}


@end
