//
//  LFBuyViewController.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/5.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFBuyViewController.h"
#import "LFBuyModels.h"
#import "LFGoodsListVC.h"
#import "LFBrandCell.h"

static NSString * const kIdentifier = @"LFBrandCell";

@interface LFBuyViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>
@property (weak,   nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak,   nonatomic) IBOutlet UITextField *searchField;
@property (nonatomic, strong) UIView * headerView;
///  分类
@property (nonatomic,   copy) NSArray<LFBuyCategory *> * categorys;
///  品牌
@property (nonatomic, strong) NSMutableArray<LFBuyBrand *> * brands;
@property (nonatomic, assign) BOOL isNeedBeginSearch;
@property (nonatomic,   copy) NSString * startPage;
@end

@implementation LFBuyViewController {
    BOOL _isRefreshing;
}

#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    
    [self _requestCategoryData];
    
    [self _requestHotBrandData];
    
    if (self.isNeedBeginSearch) {
        [self.searchField becomeFirstResponder];
    }

    self.tabBarController.tabBar.translucent = NO;
    
}
///  初始化子控件
- (void)setupSubViews {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = Fit(0);
    CGFloat f = (kScreenWidth - 3 * margin) / 2;
    CGFloat itemWH = floor(f);
    layout.itemSize = CGSizeMake(itemWH,Fit(244));
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
//    layout.itemSize = CGSizeMake((kScreenWidth-15)/3, 260);
    
    UICollectionView * collectionView = self.collectionView;
    collectionView.collectionViewLayout = layout;
    collectionView.alwaysBounceHorizontal = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.alwaysBounceVertical = YES;
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LFBrandCell class]) bundle:nil] forCellWithReuseIdentifier:kIdentifier];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    self.startPage = @"0";
    @weakify(self);
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self->_isRefreshing = YES;
        self.startPage = @"0";
        [self _requestCategoryData];
        [self _requestHotBrandData];
    }];
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self _requestHotBrandData];
    }];
    self.searchField.delegate = self;
}


#pragma mark - Actions


#pragma mark - Networking

///  请求分类
- (void)_requestCategoryData {
    NSString * url = @"category/goodsCategory.htm?";
    
    [TSNetworking POSTWithURL:url paramsModel:nil completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        self.categorys = [[NSArray yy_modelArrayWithClass:[LFBuyCategory class] json:request[@"goodsCategoryList"]] copy];
//        self.tableView.tableHeaderView = self.headerView;
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
    }];
}
///  请求热门品牌
- (void)_requestHotBrandData {
    
    NSString * url = @"category/hotBrandList.htm?";
    LFParameter * par = [LFParameter new];
    par.startPage = self.startPage;
    [self.collectionView.mj_footer resetNoMoreData];
    [TSNetworking POSTWithURL:url paramsModel:par completeBlock:^(NSDictionary *request) {
        SLLog(request);
        SLEndRefreshing(self.collectionView);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        NSArray * arr = [NSArray yy_modelArrayWithClass:[LFBuyBrand class] json:request[@"brandList"]];
        if (_isRefreshing) {
            [self.brands removeAllObjects];
            _isRefreshing = NO;
        }
        [self.brands addObjectsFromArray:arr];
        [self.collectionView reloadData];
        self.startPage = request[@"startPage"];
        if (self.startPage.integerValue == [request[@"totalPage"] integerValue]) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLEndRefreshing(self.collectionView);
    }];
}


#pragma mark - Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {return self.brands.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LFBrandCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifier forIndexPath:indexPath];
    LFBuyBrand * brand = self.brands[indexPath.row];
    cell.brand = brand;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView * v = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        if (!self.categorys.count) return v;
        [v addSubview:self.headerView];
        return v;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (!self.categorys.count) return CGSizeZero;
    return self.headerView.size;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LFGoodsListVC * controller = [[LFGoodsListVC alloc] init];
    controller.searchType = @"2";
    controller.ID = self.brands[indexPath.row].brandName;
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    LFGoodsListVC * controller = [[LFGoodsListVC alloc] init];
    controller.searchType = @"3";
    controller.ID = textField.text;
    [self.navigationController pushViewController:controller animated:YES];
    
    return YES;
}

#pragma mark - Private


#pragma mark - Public
- (void)beginSearch {
    if (self.isViewLoaded) {
        [self.searchField becomeFirstResponder];
    } else {
        self.isNeedBeginSearch = YES;
    }
}

#pragma mark - Getter\Setter
- (UIView *)headerView {
    if (_headerView) return _headerView;
    
    UIView * header = [UIView viewWithBgColor:[UIColor whiteColor] frame:Rect(0, 0, kScreenWidth, 1)];
    _headerView = header;
    
    NSArray<LFBuyCategory *> * arr = self.categorys;
    CGFloat leading = Fit(15);
    CGFloat xMargin = Fit(7);
    CGFloat yMargin = Fit(10);
    CGFloat width = (kScreenWidth - 2 * leading - xMargin) / 2;
    CGFloat height = Fit(105);
    
    UIView * brandView = [UIView viewWithBgColor:nil frame:Rect(0, 0, header.width, 1)];
    [header addSubview:brandView];
    for (int i = 0; i < arr.count; i++) {
        int row = i / 2;
        int col = i % 2;
        LFBuyCategory * model = arr[i];
        CGRect frame = Rect(leading + col * (width + xMargin), leading + row * (height + yMargin), width, height);
        UIView * view = [UIView viewWithBgColor:[UIColor whiteColor] frame:frame];
        [brandView addSubview:view];
        
        UIImageView * imageView = [UIImageView imageViewWithUrl:[NSURL URLWithString:model.categoryImgUrl] frame:view.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [view addSubview:imageView];
        
        NSString * title = model.categoryName;
//        CGRect f = Rect(0, 0, width, 22);
        CGRect f = view.bounds;
        UILabel * name = [UILabel labelWithText:title font:Fit(18) textColor:HexColorInt32_t(FFFFFF) frame:f];
//        name.centerY = height * 0.5;
        name.textAlignment = NSTextAlignmentCenter;
        name.backgroundColor = [HexColorInt32_t(000000) colorWithAlphaComponent:0.5];
        [view addSubview:name];
        name.tag = i;
        UITapGestureRecognizer * tap = [UITapGestureRecognizer new];
        @weakify(self);
        [tap.rac_gestureSignal subscribeNext:^(UITapGestureRecognizer * x) {
            @strongify(self);
            LFGoodsListVC * controller = [[LFGoodsListVC alloc] init];
            controller.searchType = @"1";
            controller.ID = arr[x.view.tag].categoryName;
            [self.navigationController pushViewController:controller animated:YES];
        }];
        name.userInteractionEnabled = YES;
        [name addGestureRecognizer:tap];
        
    }
    brandView.height = brandView.subviews.lastObject.maxY + leading;
    
    UIView * v = [UIView viewWithBgColor:HexColorInt32_t(F8F8F8) frame:Rect(0, brandView.maxY, kScreenWidth, Fit(48))];
    [header addSubview:v];
    
    UILabel *label = [UILabel labelWithText:@"热门品牌" font:Fit(18) textColor:HexColorInt32_t(333333) frame:CGRectZero];
    [label sizeToFit];
    label.center = Point(kHalfScreenWidth, v.halfHeight);
    [v addSubview:label];
    
    SLDevider * devider = [[SLDevider alloc] initWithFrame:Rect(0, 0, kScreenWidth, 1)];
    [v addSubview:devider];
    
    SLDevider * devider2 = [[SLDevider alloc] initWithFrame:Rect(0, v.height - 1, kScreenWidth, 1)];
    [v addSubview:devider2];
    
    header.height = v.maxY;
    
    return _headerView;
}
- (NSMutableArray<LFBuyBrand *> *)brands { SLLazyMutableArray(_brands) }
@end
