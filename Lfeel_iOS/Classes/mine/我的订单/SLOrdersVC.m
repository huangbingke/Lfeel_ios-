//
//  SLOrdersVC.m
//  TKLUser
//
//  Created by Seven Lv on 16/10/18.
//  Copyright © 2016年 Seven Lv. All rights reserved.
//

#import "SLOrdersVC.h"
#import "OrderListViewController.h"

@interface SLOrdersVC () <UIScrollViewDelegate>
@property(nonatomic,   weak) UIView* line;
@property(nonatomic,   weak) UIButton* selectedBtn;
@property(nonatomic, strong) UIScrollView * scrollView;
@property(nonatomic, strong) NSArray<UIButton*>* buttons;
@property(nonatomic, strong) NSArray* kInvestTitleCount;
@property (nonatomic, strong) NSArray * titles;
@end

@implementation SLOrdersVC {
    NSArray<NSString *> * _titles;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([User sharedUser].isNeedRefreshOrder) {
        [User sharedUser].needRefreshOrder = NO;
        [self makeAllControllerNeedRefreshNeedImmediately:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titles = @[ @"全部", @"待付款" ,@"待发货", @"待收货", @"待评价"];
    [self setupSubViews];
    [self _initNavigationBar];
    
    [self _didClickTopBtn:self.buttons[self.selectedType]];
}

/// 初始化NavigaitonBar
- (void)_initNavigationBar {
    
    @weakify(self);
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"全部" backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

///初始化view
- (void)setupSubViews {
    UIView* toolBar = [self setUptoolBar];
    
    UIScrollView* scroView = [UIScrollView scrollViewWithBgColor:nil frame:Rect(0, toolBar.maxY, kScreenWidth,kScreenHeight - toolBar.maxY)];
    [self.view addSubview:scroView];
    self.scrollView = scroView;
    scroView.delegate = self;
    scroView.pagingEnabled = YES;
    scroView.showsHorizontalScrollIndicator = NO;
    scroView.contentSize = Size(kScreenWidth  * _titles.count, 0);
    
    NSInteger type = 1;
    for (int i = 0; i < _titles.count; i++) {
        OrderListViewController* vc = [[OrderListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        if (i == _titles.count - 1) {
            vc.type = @"7";
        } else {
            vc.type = stringWithInteger(i + type);
        }
        @weakify(self);
        vc.vblock = ^{
            @strongify(self);
            [self makeAllControllerNeedRefreshNeedImmediately:NO];
        };
        [self addChildViewController:vc];
        if (i == 0) {
            vc.view.frame = Rect(0, 0, kScreenWidth, scroView.height);
            [scroView addSubview:vc.view];
        }
    }
}

///创建顶部
- (UIView*)setUptoolBar {
    UIView* toolbar = [UIView viewWithBgColor:[UIColor whiteColor]
                                        frame:Rect(0, 64, kScreenWidth, 40)];
    [self.view addSubview:toolbar];
    NSMutableArray* btns = @[].mutableCopy;
    NSArray * titles = self.titles;
    _titles = titles;
    CGFloat btnW = kScreenWidth / titles.count;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton* btn = [UIButton buttonWithTitle:titles[i]
                                       titleColor:HexColor(@"333333")
                                  backgroundColor:nil
                                             font:14
                                            image:nil
                                            frame:Rect(i * btnW, 0, btnW, 40)];
        
        [toolbar addSubview:btn];
        [btns addObject:btn];
        btn.tag = i;
        btn.selectTitleColor = HexColorInt32_t(db132a);
        [btn addTarget:self action:@selector(_didClickTopBtn:)];
        
        if (i == 0) {
            btn.selected = YES;
            UIView* blackLine = [UIView
                                 viewWithBgColor:HexColor(@"ffffff")
                                 frame:Rect(0, toolbar.height - 2, toolbar.width, 4)];
            [toolbar addSubview:blackLine];
            
            self.selectedBtn = btn;
        }
    }
    SLDevider * d = [[SLDevider alloc] initWithFrame:Rect(0, toolbar.height - 1, toolbar.width, 1)];
    [toolbar addSubview:d];
    self.buttons = btns.copy;
    
    [self.view addSubview:toolbar];
    return toolbar;
}

- (void)_didClickTopBtn:(UIButton *)btn {
    self.selectedBtn.selected = NO;
    
    btn.selected = YES;
    self.selectedBtn = btn;
    self.ts_navgationBar.titleLabel.text = self.titles[self.selectedBtn.tag];
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.line.centerX = self.selectedBtn.centerX;
                         [self.scrollView setContentOffset:CGPointMake(kScreenWidth * self.selectedBtn.tag, 0)];
                     }];
    
    OrderListViewController * orderView = self.childViewControllers[self.selectedBtn.tag];
    if (!orderView.isViewLoaded) {
        orderView.view.frame = Rect(self.selectedBtn.tag * kScreenWidth, 0, kScreenWidth, self.scrollView.height);
        [self.scrollView addSubview:orderView.view];
    } else {
        if ( orderView.isNeedRefresh) {
            [orderView reloadData];
        }
    }

    
}
///刷新子控制器
/// needRefresh 是否需要刷新
- (void)makeAllControllerNeedRefreshNeedImmediately:(BOOL)immediately {

    for (OrderListViewController* vc in self.childViewControllers) {
        vc.needRefresh = YES;
    }
    
    if (immediately) {
        OrderListViewController* vc = self.childViewControllers[self.selectedBtn.tag];
        [vc reloadData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView {
    NSInteger index = scrollView.contentOffset.x / kScreenWidth;
    UIButton* btn = self.buttons[index];
    if (self.selectedBtn == btn) {
        return;
    }
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
    self.ts_navgationBar.titleLabel.text = self.titles[index];
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.line.centerX = self.selectedBtn.centerX;
                     }];
    
    OrderListViewController* vc = self.childViewControllers[self.selectedBtn.tag];
    if (!vc.isViewLoaded) {
        vc.view.frame = Rect(self.selectedBtn.tag * kScreenWidth, 0, kScreenWidth,
                             self.scrollView.height);
        [self.scrollView addSubview:vc.view];
    } else {
        if (vc.isNeedRefresh) {
            [vc reloadData];
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    if (scrollView != self.scrollView) {
        return;
    }
    CGFloat x = scrollView.contentOffset.x;
    if (x <= 0 || x >= kScreenWidth * _titles.count) {
        return;
    }
    self.line.centerX = x / _titles.count + kScreenWidth / (_titles.count * 2);
}

- (NSArray<UIButton*>*)buttons {
    SLLazyArray(_buttons);
}

@end
