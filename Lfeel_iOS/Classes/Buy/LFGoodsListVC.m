//
//  LFGoodsListVC.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/5.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFGoodsListVC.h"
#import "LFGoodsCell.h"
#import "LFBuyModels.h"
#import "LFGoodsDetailViewController.h"
#import "SLEmptyView.h"

static NSString * const kIdentifier = @"LFGoodsCell";

@interface LFGoodsListVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>
//<UITableViewDelegate, UITableViewDataSource>
//@property (nonatomic,   weak) UITableView * tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<LFGoods *> * goodses;
@property (nonatomic,   weak) UIButton * selectedBtn;
@property (nonatomic,   copy) NSString * sortType;
@property (nonatomic,   copy) NSString * startPage;
@property (nonatomic, assign, getter=isRefreshing) BOOL refreshing;
@property (nonatomic, strong) SLEmptyView * emptyView;

@end

@implementation LFGoodsListVC {
    BOOL _isTop;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigationBar];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    _isTop = YES;
    self.startPage = @"0";
    self.sortType = @"22";
    
    [self setupSubViews];
    
    
    [self _requestGoodListData];
}

///  初始化子控件
- (void)setupSubViews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = Fit(7);
    CGFloat f = (kScreenWidth - 3 * margin) / 2;
    CGFloat itemWH = floor(f);
    layout.itemSize = CGSizeMake(itemWH, Fit(260));
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    
    UICollectionView * collectionView = self.collectionView;
    collectionView.collectionViewLayout = layout;
    collectionView.alwaysBounceHorizontal = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.alwaysBounceVertical = YES;
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LFGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:kIdentifier];
    
    @weakify(self);
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.startPage = @"0";
        self.refreshing = YES;
        [self _requestGoodListData];
    }];
    
    collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self _requestGoodListData];
    }];
    
    if (self.searchType.integerValue == 3) {
        self.searchField.text = self.ID;
    }
}

///  设置自定义导航条
- (void)setupNavigationBar {
}
- (IBAction)_back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

///  点击排序\筛选
- (IBAction)_didClickSort:(UIButton *)btn {
    self.startPage = @"0";
    self.refreshing = YES;
    if (btn.tag == 2 && btn.isSelected == YES) {
        _isTop = !_isTop;
        if (_isTop) {
            btn.image = @"3_up";
            self.sortType = @"12";
        } else {
            btn.image = @"2_down";
            self.sortType = @"11";
        }
        [self _requestGoodListData];
        return;
    }
    
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
    
    if (btn.tag == 1) {
        self.sortType = @"22";
    } else {
        if (_isTop) {
            self.sortType = @"12";
            btn.image = @"3_up";
        } else {
            self.sortType = @"11";
            self.sortType = @"11";
        }
    }
    [self _requestGoodListData];
}
#pragma mark - Actions


#pragma mark - Networking

///  请求热门品牌
- (void)_requestGoodListData {
    /*
     searchParam	搜索值	string	1、2为类型和品牌ID，3为商品名称
     searchType	1=类型搜索2=品牌搜索3=商品名字	string	1=类型搜索2=品牌搜索3=商品名字
     sortType	11价格降序 12价格升序、21最新降序，22最新升序	number	11-12价格、21-22最新
     startPage	起始页面	number	0 默认0
     */
    NSString * url = @"manage/goodList.htm?";
    LFParameter * par = [LFParameter new];
    par.startPage = self.startPage;
    par.searchType = self.searchType;
    par.sortType = self.sortType;
    par.searchParam = self.searchField.hasText ? self.searchField.text : self.ID;
    [self.collectionView.mj_footer resetNoMoreData];
    [TSNetworking POSTWithURL:url paramsModel:par completeBlock:^(NSDictionary *request) {
        SLLog(request);
        SLEndRefreshing(self.collectionView);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        
        if (self.isRefreshing) {
            self.refreshing = NO;
            [self.goodses removeAllObjects];
        }
        NSArray * arr = [NSArray yy_modelArrayWithClass:[LFGoods class] json:request[@"goodsList"]];
        if (!arr.count) {
            [self.collectionView addSubview:self.emptyView];
            [self.goodses removeAllObjects];
            [self.collectionView reloadData];
            return;
        }
        [self.emptyView removeFromSuperview];
        [self.goodses addObjectsFromArray:arr];
        [self.collectionView reloadData];
        self.startPage = request[@"startPage"];
        if (self.startPage.integerValue == [request[@"totalPage"] integerValue]) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
    } failBlock:^(NSError *error) {
        SLEndRefreshing(self.collectionView);
        SLShowNetworkFail;
    }];
 
}

#pragma mark - Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodses.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LFGoodsCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifier forIndexPath:indexPath];
    cell.goods = self.goodses[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LFGoodsDetailViewController * controller = [[LFGoodsDetailViewController alloc] init];
    controller.goodsId = self.goodses[indexPath.item].goodsId;
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.startPage = @"0";
    self.refreshing = YES;
    self.searchType = @"3";
    [self _requestGoodListData];
    return YES;
}
#pragma mark - Private


#pragma mark - Public


#pragma mark - Getter\Setter
- (NSMutableArray<LFGoods *> *)goodses { SLLazyMutableArray(_goodses) }
- (SLEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[SLEmptyView alloc] initWithFrame:self.collectionView.bounds];
    }
    return _emptyView;
}
@end


@implementation LFMenuButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageView.x < self.titleLabel.x) {
        
        self.titleLabel.x = self.imageView.x;
        
        self.imageView.x = self.titleLabel.maxX + 5;
    }
    
}

@end
