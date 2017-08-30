//
//  LFGoodsDetailViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/1.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFGoodsDetailViewController.h"
#import "GoodSBannarView.h"
#import "LFSelectHeaderView.h"
#import "LFShopCartViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "SLShareHelper.h"
#import "LFShareView.h"
#import "LFGoodDetailCell.h"
#import "LFElutionViewController.h"
#import "LFSeleSizeView.h"
#import "LFSettleCenterVC.h"
#import "LFBuyModels.h"
#import "LFLoginViewController.h"
#import "SLShareHelper.h"
@interface LFGoodsDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView  * tabbleView;
@property (nonatomic, strong) LFGoodsDetailModel *detailModel;
@property (nonatomic, strong) LFSelectHeaderView * selectHeaderView;
@property (nonatomic, strong) LFSeleSizeView * SeleSizeView;
@property (nonatomic, strong) GoodSBannarView *goodBanner;
@property (copy,   nonatomic) NSDictionary  *parmeDict;
@property (nonatomic,   copy) NSDictionary *shareDict;


@property (nonatomic, copy) NSString *htmlString;


@end

@implementation LFGoodsDetailViewController{
    UIView * headerView,*_bgView,*_sizeView;
    UIButton *CollotBtn;
    NSString *eluation;
    NSArray * array ;
    /// 是否为加入购物车(NO:立即购买)
    BOOL _isAddToCart,_isSelectSize;
    NSInteger btnIndex;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    btnIndex = 1;
    _isSelectSize = NO;
    [self RequestDetail];
    [self CreateView];
    [self setupNavigationBar];
    [self setupSelectSizeView];
 
    
}


/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    
//    @weakify(self);
//   self.ts_navgationBar = [TSNavigationBar navWithTitle:@"商品详情" rightItem:@"分享@2x" rightAction:^{
//       @strongify(self);
//       [self TapShareBtn];
//   } backAction:^{
//       @strongify(self);
//       [self.navigationController popViewControllerAnimated: YES];
//   }];
    
    UIView *nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    nav.backgroundColor = RGBColor(245, 245, 245);
    self.ts_navgationBar = (TSNavigationBar *)nav;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 27, kScreenWidth-200, 25)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = kFont(17);
    titleLabel.text = @"商品详情";
    [nav addSubview:titleLabel];
    
    
    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [backBtn setImage:[UIImage imageNamed:@"返回-黑"] forState:(UIControlStateNormal)];
    backBtn.frame = CGRectMake(10, 27, 25, 25);
    [backBtn addTarget:self action:@selector(backBtnAction)];
    [nav addSubview:backBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [shareBtn setImage:[UIImage imageNamed:@"分享@2x"] forState:(UIControlStateNormal)];
    shareBtn.frame = CGRectMake(kScreenWidth - 35, 27, 25, 25);
    [shareBtn addTarget:self action:@selector(shareAction)];
    [nav addSubview:shareBtn];
   
    UIButton *serviceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [serviceBtn setImage:[UIImage imageNamed:@"Home_service"] forState:(UIControlStateNormal)];
    serviceBtn.frame = CGRectMake(kScreenWidth - 70, 27, 25, 25);
    [serviceBtn addTarget:self action:@selector(serviceBtnAction)];
    [nav addSubview:serviceBtn];
    
}
- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareAction {
    [self TapShareBtn];
}

- (void)serviceBtnAction {
    ZCProductInfo *productInfo = [ZCProductInfo new];
    //thumbUrl 缩略图地址
    productInfo.thumbUrl = self.detailModel.goodsAbridgeImgUrl;
    //  title 标题 (必填)
    productInfo.title = self.detailModel.goodsName;
    //  desc 摘要
        productInfo.desc = self.detailModel.store_price;
    //  label 标签
    //    productInfo.label = @"运动";
    //  页面地址url（必填)
    productInfo.link = self.detailModel.goodsAbridgeImgUrl;
    
    //进入客服
    [self openZCServiceWithProduct:productInfo];
}



-(void)CreateView{
    
    UITableView *tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight-0) style:UITableViewStyleGrouped];
    tabbleView.delegate =self;
    tabbleView.dataSource = self;
    self.tabbleView = tabbleView;
    [self.view addSubview:tabbleView];
}


-(UIView * )CreateGoodsHeaderView{
    
    SLLog2(@"33333");
    if(headerView!= nil)return headerView;
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Fit375(709))];
    
//    UIView * banner = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Fit375(414))];
    UIView * banner = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*1.3)];

    banner.backgroundColor = HexColorInt32_t(111111);
    [headerView addSubview:banner];
   self.goodBanner  = [[GoodSBannarView alloc]initWithFrame:banner.frame];
    [banner addSubview: self.goodBanner];
    
    UIView * ShareView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(banner.frame)-Fit375(15)-Fit375(40), kScreenWidth, Fit375(40))];
    ShareView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:ShareView];
    
    
    CGFloat btnW = Fit375(38);
    CGFloat btnH = Fit375(38);
    
    UIButton *ShopCarBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor clearColor] backgroundColor:[UIColor clearColor] font:Fit375(14) image:@"购物车-拷贝" frame:Rect(kScreenWidth-Fit375(38)-Fit375(17), ShareView.height/2-Fit375(20) , btnW, btnW)]   ;
    [ShopCarBtn addTarget:self action:@selector(TapPushShopCarBtn)];
    [ShareView addSubview:ShopCarBtn];
    CollotBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor clearColor] backgroundColor:[UIColor clearColor] font:Fit375(14) image:@"喜欢-2" frame:Rect(kScreenWidth-btnH-Fit375(17)- btnW , ShareView.height/2-btnH/2 , btnH, btnH)];
    CollotBtn.selectImage = @"形状-3";
    CollotBtn.cornerRadius = btnH/2;
    [CollotBtn addTarget:self action:@selector(TapSelectCollotBtn)];
    [ShareView addSubview:CollotBtn];
    
       self.selectHeaderView = [LFSelectHeaderView creatViewFromNib];
    self.selectHeaderView.frame = Rect(0, CGRectGetMaxY(banner.frame), kScreenWidth, Fit375(295));
    
    [headerView addSubview:self.selectHeaderView];
    [headerView setHeight:CGRectGetMaxY(self.selectHeaderView.frame)];
    @weakify(self);
    self.selectHeaderView.didSelectShopCarBtn =^{
        @strongify(self);
        SLLog2(@"加入购物车");
        self->_isAddToCart = YES;
        if (self.parmeDict.count == 0) {
        [self setSizeViewHidden:NO];
        }else{
            if (user_loginKey == nil) {
                [self isLoginVC];
            }else{
            [self _requestAddToCartData:self.parmeDict];
            }
        }
    };
    self.selectHeaderView.didSelectXLBtn =^{
        @strongify(self);
        SLLog2(@"选择尺码");
        self->_isSelectSize = YES;
        [self setSizeViewHidden:NO];
    };
    self.selectHeaderView.didSelectBayNowBtn =^{
        @strongify(self);
        SLLog2(@"立即购买")
        self->_isAddToCart = NO;
        if (self.parmeDict.count == 0) {
            [self setSizeViewHidden:NO];
        }else{
            if (user_loginKey == nil) {
                [self isLoginVC];
            }else{
            [self _requestBuyGoodsData:self.parmeDict];
            }
            
        }
    };
    self.selectHeaderView.didSelectGoodEvationBtn =^{
        @strongify(self);
        SLLog2(@"商品评价");
        [self TapAllEvlationBtn];
    };
    
    self.selectHeaderView.didSelectGoodsDetailBtn = ^{
        @strongify(self);
        SLLog2(@"细节");
        [self TapGoodsDetailBtn];
    };
    
    return headerView;
}

#pragma mark - NetWork
-(void)RequestDetail{
    NSString * url =@"manage/goodsDetailed.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.goodsId  = self.goodsId;
    paeme.loginKey = user_loginKey;
    @weakify(self);
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        self.htmlString = request[@"goods_details"];
        NSLog(@"--------%@", request[@"goods_details"]);
        @strongify(self);
        NSError * error = nil;
        self.detailModel = [[LFGoodsDetailModel alloc]initWithDictionary:request error:&error];
        [self setData];
        [self.tabbleView reloadData];
    } failBlock:^(NSError *error) {
        
    }];
}

///  请求加入购物车
- (void)_requestAddToCartData:(NSDictionary * )dict {
    /*
     count	商品数量	string	@mock=5
     goodsId	商品ID	string	@mock=123
     gsp	属性，以;隔开	string	@mock=XL;黑色
     loginKey		string	@mock=00fa95958febf957bf48ce2aebde71db
     phoneMark		string	@mock=123
     */
    NSString * url =@"shoppingCart/addCart.htm?";
    LFParameter *param = [LFParameter new];
    param.goodsId  = dict[@"goodsId"];
    param.count = dict[@"count"];
    param.gsp = dict [@"gsp"];
    param.loginKey = user_loginKey;
    param.phoneMark = [User getDeviceId];
    
    [TSNetworking POSTWithURL:url paramsModel:param needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        SVShowSuccess(@"添加购物车成功");
        
    } failBlock:^(NSError *error) {
        SLLog(error);
    }];
}

///  请求立即购买
- (void)_requestBuyGoodsData:(NSDictionary * )dict {
    /*
     count	商品数量	string	@mock=5
     goodsId	商品ID	string	@mock=123
     gsp	属性，以;隔开	string	@mock=XL;黑色
     loginKey		string	@mock=00fa95958febf957bf48ce2aebde71db
     phoneMark		string	@mock=123
     */
    NSString * url =@"shoppingCart/immediately.htm?";
    LFParameter *param = [LFParameter new];
    param.goodsId  = dict[@"goodsId"];
    param.count = dict[@"count"];
    param.gsp = dict [@"gsp"];
    param.loginKey = user_loginKey;
    param.phoneMark = @"123";
    
    [TSNetworking POSTWithURL:url paramsModel:param needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        NSArray *arr = [NSArray yy_modelArrayWithClass:[LFGoods class] json:request[@"orderGoodsList"]];
        LFSettleCenterVC * controller = [[LFSettleCenterVC alloc] init];
        controller.goodses = [arr copy];
        [self.navigationController pushViewController:controller animated:YES];
        
    } failBlock:^(NSError *error) {
        SLLog(error);
    }];
}

-(void)HTTPRequestAddCollection {
    NSString * url =@"personal/addCollectio.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.loginKey = user_loginKey;
    paeme.goodsId = self.goodsId;
    
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        
        self.detailModel.collectionStatus = !self.detailModel.collectionStatus;
        [self setData];
        
    } failBlock:^(NSError *error) {
        
    }];
}

-(void)HTTPRequestDeleteCollection {
    NSString * url =@"personal/delCollectio.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.goodsId = self.goodsId;
    
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        self.detailModel.collectionStatus = !self.detailModel.collectionStatus;
        [self setData];
        
        
    } failBlock:^(NSError *error) {
        
    }];
}






/**
 显示\隐藏选择尺寸view

 @param hidden 显示\隐藏
 */
- (void)setSizeViewHidden:(BOOL)hidden {
    
    if (hidden) {
        [UIView animateWithDuration:0.25 animations:^{
            self.SeleSizeView.superview.y = kScreenHeight;
        } completion:^(BOOL finished) {
            _sizeView.hidden = YES;
        }];
    } else {
        _sizeView.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.SeleSizeView.superview.maxY = kScreenHeight;
        }];
    }
}

/// 设置选择尺寸view
-(void)setupSelectSizeView{
    UIView * view = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelView:)]];
    [self.view addSubview:view];
    view.hidden = YES;
    _sizeView = view;
    
    UIView * contentView = [[UIView alloc] initWithFrame:Rect(0, kScreenHeight, kScreenWidth,Fit375(467))];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.tag = 101;
    {
        
        self.SeleSizeView = [LFSeleSizeView creatViewFromNib];
        self.SeleSizeView.frame = Rect(0, 0, kScreenWidth, contentView.height);
        [contentView addSubview:self.SeleSizeView];
        @weakify(self);
        self.SeleSizeView.didTapCloseBtn =^{
            @strongify(self);
            [self setSizeViewHidden:YES];
        };
        self.SeleSizeView.didTapSureBtn = ^(NSDictionary * dict){
            @strongify(self);
            self.parmeDict = dict;
            if (self->_isSelectSize == YES) {
            }else{
                IfUserIsNotLogin;
                self->_isAddToCart ? [self _requestAddToCartData:dict] : [self _requestBuyGoodsData:dict];
                [self setSizeViewHidden:YES];
            }
            [self setSizeViewHidden:YES];
        };
    }
    [view addSubview:contentView];
}

///  请求分享参数
- (void)_requestShareData:(VoidBlcok)vb {
    NSString * url =@"comm/shareGoods.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.goodsId = self.goodsId;
    
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        _shareDict = request.copy;
        BLOCK_SAFE_RUN(vb);
    } failBlock:^(NSError *error) {
        
    }];
}

#pragma mark - Action

-(void)TapShareBtn{
    SLLog2(@"分享");
    if (_shareDict) {
        [self setupSharedView];
    } else {
        @weakify(self);
        [self _requestShareData:^{
            @strongify(self);
            [self setupSharedView];
        }];
    }
}
-(void)TapSelectCollotBtn{
    IfUserIsNotLogin;
    
    if (self.detailModel.collectionStatus == YES ) {
        [self HTTPRequestDeleteCollection];
    }else{
        [self HTTPRequestAddCollection];
    }
 
    
}
-(void)TapPushShopCarBtn{
    IfUserIsNotLogin;
    
    LFShopCartViewController * shop = [[LFShopCartViewController alloc]init];
    shop.subPage = YES;
    [self.navigationController pushViewController:shop animated:YES];
 

}


-(void)TapAllEvlationBtn{
    
    LFElutionViewController * evlation = [[LFElutionViewController alloc]init];
    evlation.commentTotal = eluation;
    evlation.goodsId = self.detailModel.goodsId;
    [self.navigationController pushViewController:evlation animated:YES];
}

- (void)TapGoodsDetailBtn {
//    LFHTMLViewController *htmlVC = [[LFHTMLViewController alloc] init];
//    htmlVC.htmlString = self.htmlString;
//    [self.navigationController pushViewController:htmlVC animated:YES];
}



#pragma mark - tableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LFGoodDetailCell * cell = [LFGoodDetailCell cellWithTableView:tableView];
    
    cell.detailTextView.attributedText = [self setHtmlStr:self.htmlString];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSAttributedString *)setHtmlStr:(NSString *)html {
    NSAttributedString *briefAttrStr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:briefAttrStr];
    [attr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} range:NSMakeRange(0, attr.string.length)];
    
    return [attr copy];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  Fit375(709);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self CreateGoodsHeaderView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Fit(350);
}

//
-(void)setData {
    CollotBtn.selected = self.detailModel.collectionStatus;
    [self.selectHeaderView setSelectModelData:self.detailModel];
    [self.goodBanner setBannarPic:self.detailModel];
    eluation = self.detailModel.commentTotal;
    
    [self.SeleSizeView setModelData:self.detailModel];    
}

-(void)setSelectSizeData{
    SLLog(array);
}

#pragma mark 分享view
- (void)cancelView:(UITapGestureRecognizer *)tap {
    
    UIView * contentView = [_bgView viewWithTag:100];
    [UIView animateWithDuration:0.25 animations:^{
        contentView.y = kScreenHeight;
        _bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        _bgView = nil;
    }];
}


-(void)setColloct{
}

- (void)setupSharedView {
    UIView * view = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelView:)]];
    [self.view addSubview:view];
    _bgView = view;
    
    UIView * contentView = [[UIView alloc] initWithFrame:Rect(0, kScreenHeight, kScreenWidth, Fit375(142))];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.tag = 100;
    {
        LFShareView * shareView = [LFShareView creatViewFromNib];
        shareView.frame = Rect(0, 0, kScreenWidth, contentView.height);
        [contentView addSubview:shareView];
        shareView.didClickBtnBlock = ^(BOOL cancel, NSInteger index) {
            if (!cancel) {
                UMSocialPlatformType types[] = {UMSocialPlatformType_WechatSession, UMSocialPlatformType_WechatTimeLine, UMSocialPlatformType_QQ, UMSocialPlatformType_Sina};
                [SLShareHelper shareTitle:_shareDict[@"title"] desc:_shareDict[@"subTitle"] url:_shareDict[@"linkUrl"] image:_shareDict[@"imgUrl"] Plantform:types[index] callBack:^(BOOL success) {
                    NSString * txt = (success ? @"分享成功" : @"分享失败");
                    SVShowSuccess(txt);
                }];
            }
            [self cancelView:nil];
        };
        
        contentView.height = contentView.subviews.lastObject.maxY + 10;
    }
    [view addSubview:contentView];
    CGFloat y = kScreenHeight - contentView.height;
    [UIView animateWithDuration:0.25 animations:^{
        contentView.y = y;
    }];
}

-(void)isLoginVC{
    BaseNavigationController * b = [[BaseNavigationController alloc] initWithRootViewController:[LFLoginViewController new]];
    [self presentViewController:b animated:YES completion:nil];
}


@end
