//
//  LFHotHireViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/1.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFHotHireViewController.h"
#import "LFHotBottomView.h"
#import "YSLDraggableCardContainer.h"
#import "CardView.h"
#import "LFGoodsDetailViewController.h"
#import "LFVipViewController.h"
#import "LFLoginViewController.h"
#import "BaseNavigationController.h"
#import "SLEmptyView.h"
#import "LFClothesDetailViewController.h"

@interface LFHotHireViewController () <YSLDraggableCardContainerDelegate, YSLDraggableCardContainerDataSource>
@property (nonatomic, strong) YSLDraggableCardContainer *container;
@property (nonatomic, strong) NSMutableArray *dataSources;


@property (nonatomic, strong) UIButton * addVip;

@end

@implementation LFHotHireViewController
{
     NSInteger startPage,totalPage;
    NSInteger  upDataNumber , indexPage,selectUp ;
    NSMutableArray * deleDataArr;///,*coloctArr;
   

    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigationBar];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    upDataNumber = 0;
    selectUp = 0;
    
    _dataSources = [NSMutableArray array];
//    coloctArr = [NSMutableArray array];
    
    self.view.backgroundColor = HexColorInt32_t(f1f1f1);
    startPage = 0;
    totalPage = 0;
    
    [self CreateView];
}

///  设置自定义导航条
- (void)setupNavigationBar {
    @weakify(self);
    NSString * title ;
    
    if ([self.type isEqualToString:@"1"]) {
         title = self.title;
    }else{
         title = @"购买";
    }
    
    self.ts_navgationBar = [TSNavigationBar navWithTitle:title backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)CreateView{
    
    
    if ([self.type isEqualToString:@"1"]) {
        //租凭
        [self loadData: startPage];
    }else{
        /// 购买
        [self  loadDataGoodList:startPage];
    }
    
    [self loadUI];
    
    UIView * BottomView  = [[UIView alloc]init];
    BottomView.backgroundColor = HexColorInt32_t(f1f1f1);
    BottomView.frame = Rect(0, kScreenHeight-Fit375(30)-64, kScreenWidth, Fit375(60));
    [self.view addSubview:BottomView];
    
    LFHotBottomView *bottom = [LFHotBottomView creatViewFromNib];
    bottom.frame = Rect(0, 0, BottomView.width, BottomView.height);
    @weakify(self);
    //    @weakify(_container);
    bottom.didSelectSetpUpBtn = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
    bottom.didSelectColloctBtn = ^{
        @strongify(self);
        self ->selectUp = 0;
        IfUserIsNotLogin;
        [self.container movePositionWithDirection:YSLDraggableDirectionRight isAutomatic:YES];
        [self TapSelectColloctBtn];
        
    };
    bottom.didSelectDelegeteBtn = ^{
        @strongify(self);
        self ->selectUp = 0;
        [self.container movePositionWithDirection:YSLDraggableDirectionLeft isAutomatic:YES];
        [self TapSelectDeleteBtn];
    };
    [BottomView addSubview:bottom];
    
    
    
    if ([[User getUseDefaultsOjbectForKey:kVipStatus] integerValue] != 1) {
        self.addVip  =  [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addVip  setTitleColor:HexColorInt32_t(C00D23)];
        self.addVip.borderWidth = 1;
        self.addVip.borderColor = HexColorInt32_t(C00D23);
        [self.addVip setTitle:@"加入会员"];
        self.addVip.titleLabel.font = [UIFont systemFontOfSize:Fit375(Fit375(13))];
        [self.addVip addTarget:self action:@selector(TapAddVipBtn)];
        [self.view addSubview:self.addVip];
        [self.addVip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(BottomView.mas_top).offset(10);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(35);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
    }
    
    
}

- (void)TapAddVipBtn {
    if (user_loginKey == nil) {
        [self isLoginVC];
    }else{
        LFVipViewController * vip = [[LFVipViewController alloc]init];
        [self.navigationController pushViewController:vip animated:YES];
    }
}


- (void)loadUI {
    _container = [[YSLDraggableCardContainer alloc] init];
    _container.frame = CGRectMake(30, 94, kScreenWidth -60, (kScreenWidth -60)*1.3);
    _container.backgroundColor = [UIColor clearColor];
    _container.dataSource = self;
    _container.delegate = self;
    self.container.backgroundColor = HexColorInt32_t(f1f1f1);
    _container.canDraggableDirection = YSLDraggableDirectionLeft | YSLDraggableDirectionRight;
    [self.view addSubview:_container];
    
    [self.container reloadCardContainer];

}
/// 租凭
- (void)loadData:(NSInteger )starpage {
    NSString * url = @"manage/goodListLease.htm";
    LFParameter *paeme = [LFParameter new];
    paeme.id = self.ID;
    paeme.startPage = stringWithInt(starpage) ;
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        startPage = [request[@"startPage"] integerValue];
        totalPage = [request[@"totalPage"] integerValue];
        for (NSDictionary *dic in request[@"goodsList"]) {
            [self setImageModel:dic];
        }
    } failBlock:^(NSError *error) {
        
    }];
    
}

-(void)loadDataGoodList:(NSInteger)starpage{
    NSString * url =@"manage/goodList.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.id = self.ID;
    paeme.startPage =stringWithInt( starpage);
    paeme.sortType = @"11";
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        startPage = [request[@"startPage"] integerValue];
        totalPage = [request[@"totalPage"]integerValue];
        for (NSDictionary *dic in request[@"goodsList"]) {
            [self setImageModel:dic];
        }
        
        
    } failBlock:^(NSError *error) {
        
    }];
}

-(void)HTTPRequestAddpersonal:(NSString *)goodsid{
    
    NSString * url =@"personal/personalPreference.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.goodsId = goodsid;
    paeme.loginKey = user_loginKey;
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
    } failBlock:^(NSError *error) {
        SLLog(error);
    }];
}


-(void)TapGoodsBtn:(NSInteger)index{
    SLLog2(@"跳转去商品详情页面");
    LFClothesDetailViewController *goods = [[LFClothesDetailViewController alloc]init];
//        LFGoodsDetailViewController *goods = [[LFGoodsDetailViewController alloc]init];
    if (self.dataSources.count>0) {
        LFHothirevModel * model = self.dataSources[index];
        goods.goodsId = model.goodsId;
    }
    [self.navigationController pushViewController: goods animated:YES];
}


-(void)setImageModel:(NSDictionary *)dic{
    
    NSError * error;
    LFHothirevModel *hotModel = [[LFHothirevModel alloc]initWithDictionary:dic error:&error];
    [self.dataSources addObject:hotModel];
    [self.container reloadCardContainer];
}


#pragma mark -- YSLDraggableCardContainer DataSource
- (UIView *)cardContainerViewNextViewWithIndex:(NSInteger)index {
    
    LFHothirevModel * model;
    
    model = _dataSources[index];
   
    CardView *view = [[CardView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 60, self.view.frame.size.height - Fit375(250) )];
//    @weakify(self);
    view.backgroundColor = [UIColor whiteColor];

    
    [view.imageView sd_setImageWithURL:[NSURL URLWithString:model.goodsUrl]];
    
    view.label.text = model.goodsName;
    return view;
}

- (NSInteger)cardContainerViewNumberOfViewInIndex:(NSInteger)index
{
    return _dataSources.count;
  
}

#pragma mark -- YSLDraggableCardContainer Delegate
- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didEndDraggingAtIndex:(NSInteger)index draggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection {
   
    if (draggableDirection == YSLDraggableDirectionLeft) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
     IfUserIsNotLogin;
    if (draggableDirection == YSLDraggableDirectionRight) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == YSLDraggableDirectionUp) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
}

- (void)cardContainderView:(YSLDraggableCardContainer *)cardContainderView updatePositionWithDraggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio {
    
//    SLLog2(@"xxxxx");
    CardView *view = (CardView *)draggableView;
    
    if (draggableDirection == YSLDraggableDirectionDefault) {
        view.selectedView.alpha = 0;
    }
    
    if (draggableDirection == YSLDraggableDirectionLeft) {

    }
    
    if (draggableDirection == YSLDraggableDirectionRight) {
        
        
        IfUserIsNotLogin;
        [self TapSelectColloctBtn];
        
    }
    
    if (draggableDirection == YSLDraggableDirectionUp) {
        
    }
}

- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didSelectAtIndex:(NSInteger)index draggableView:(UIView *)draggableView {
    [self TapGoodsBtn:index];
    
}

- (void)cardContainerViewDidCompleteAll:(YSLDraggableCardContainer *)container {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (totalPage == startPage) {
            SVShowError(@"没有更多了");
            SLEmptyView * emptyView = [[SLEmptyView alloc]init];
            [self.container addSubview:emptyView];
            [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.left.offset(0);
                make.right.offset(0);
                make.bottom.offset(0);
            }];
            return ;
        }else{
            
            if ([self.type isEqualToString:@"1"]) {
                //租凭
                [self loadData:startPage];
            }else{
                /// 购买
                [self  loadDataGoodList:startPage];
            }
        }
    });
}
 

-(void)TapSelectColloctBtn{
    @weakify(self);
    self.container.didSectindex = ^(NSInteger index){
        @strongify(self);
        SLLog2(@"index LOG :%zd   dataSuroen :%zd",index,self.dataSources.count);
        if (index - 1 == -1) {
            self->indexPage++;
            LFHothirevModel * model = self.dataSources[self->indexPage];
            [self HTTPRequestAddpersonal:model.goodsId];
        }else{
            LFHothirevModel * model = self.dataSources[index-1];
            [self HTTPRequestAddpersonal:model.goodsId];
        }
    };
}


-(void)TapSelectDeleteBtn{
    
    @weakify(self);
    self.container.didSectindex = ^(NSInteger index){
        
        SLLog(index);
        
        @strongify(self);
        if (index - 1 == -1) {
            self->indexPage++;
        }else{
            self->indexPage = index  - 1;
        }
  
    };
    
}


-(void)isLoginVC{
    BaseNavigationController * b = [[BaseNavigationController alloc] initWithRootViewController:[LFLoginViewController new]];
    [self presentViewController:b animated:YES completion:nil];
}

@end
