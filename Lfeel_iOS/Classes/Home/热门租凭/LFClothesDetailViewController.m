//
//  LFClothesDetailViewController.m
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/8/2.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFClothesDetailViewController.h"
#import "GoodSBannarView.h"
#import "LFGoodDetailCell.h"
#import "LFShopCartViewController.h"
#import "LFLoginViewController.h"
#import "LFChooseSizeView.h"
#import "LFClothesHeaderView.h"
#import "LFShareView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "SLShareHelper.h"

@interface LFClothesDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView  * tabbleView;
@property (nonatomic, strong) GoodSBannarView *goodBanner;
@property (nonatomic, strong) LFGoodsDetailModel *detailModel;
@property (nonatomic, strong) LFClothesHeaderView *selectHeaderView;
@property (nonatomic, copy) NSString *htmlString;
@property (nonatomic, strong) LFChooseSizeView * SeleSizeView;
@property (copy,   nonatomic) NSDictionary  *parmeDict;
@property (nonatomic,   copy) NSDictionary *shareDict;


@end

@implementation LFClothesDetailViewController {
    UIView * headerView,*_bgView,*_sizeView;
    BOOL _isAddToCart,_isSelectSize;

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigationBar];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self CreateView];
    [self RequestDetail];
    
    [self setupSelectSizeView];

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



-(UIView * )CreateGoodsHeaderView{
    
    SLLog2(@"33333");
    if(headerView!= nil)return headerView;
//    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Fit375(709))];
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*1.6)];

//    UIView * banner = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Fit375(414))];
    UIView * banner = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*1.5)];
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

    UIButton *serBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor clearColor] backgroundColor:[UIColor clearColor] font:Fit375(14) image:@"Service" frame:Rect(kScreenWidth-btnH-Fit375(17)- btnW , ShareView.height/2-btnH/2-2, btnH, btnH)];
    serBtn.cornerRadius = btnH/2;
    [serBtn addTarget:self action:@selector(serBtn)];
    [ShareView addSubview:serBtn];
    
    self.selectHeaderView = [LFClothesHeaderView creatViewFromNib];
    self.selectHeaderView.frame = Rect(0, CGRectGetMaxY(banner.frame), kScreenWidth, Fit375(295));
    
    [headerView addSubview:self.selectHeaderView];
    [headerView setHeight:CGRectGetMaxY(self.selectHeaderView.frame)];
    @weakify(self);
    self.selectHeaderView.didSelectShopCarBtn =^{
        @strongify(self);
        SLLog2(@"加入我的盒子");
        self->_isAddToCart = YES;
        if (self.parmeDict.count == 0) {
            [self setSizeViewHidden:NO];
        }else{
            if (user_loginKey == nil) {
                [self isLoginVC];
            }else{
                [self HTTPRequestAddpersonal:self.goodsId];
            }
        }
    };

     return headerView;
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
        
        self.SeleSizeView = [LFChooseSizeView creatViewFromNib];
        self.SeleSizeView.frame = Rect(0, 0, kScreenWidth, contentView.height);
        [contentView addSubview:self.SeleSizeView];
        @weakify(self);
        self.SeleSizeView.didTapCloseBtn =^{
            @strongify(self);
            [self setSizeViewHidden:YES];
        };
        self.SeleSizeView.didTapSureBtn = ^(NSDictionary * dict){
            @strongify(self);
                IfUserIsNotLogin;
                [self HTTPRequestAddpersonal:self.goodsId];
                [self setSizeViewHidden:YES];
        };
    }
    [view addSubview:contentView];
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

-(void)CreateView{
    UITableView *tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    tabbleView.delegate =self;
    tabbleView.dataSource = self;
    self.tabbleView = tabbleView;
    [self.view addSubview:tabbleView];
}

/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    
    @weakify(self);
    
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"商品详情" rightItem:@"分享@2x" rightAction:^{
        @strongify(self);
        [self TapShareBtn];
    } backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated: YES];
    }];
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

-(void)setData {
    [self.goodBanner setBannarPic:self.detailModel];

    [self.selectHeaderView setSelectModelData:self.detailModel];
    [self.SeleSizeView setModelData:self.detailModel];
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
//    return  Fit375(560);
    return kScreenWidth*1.8;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self CreateGoodsHeaderView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Fit(100);
}

-(void)TapPushShopCarBtn{
    IfUserIsNotLogin;
    LFShopCartViewController * shop = [[LFShopCartViewController alloc]init];
    shop.subPage = YES;
    [self.navigationController pushViewController:shop animated:YES];
}
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

- (void)serBtn {
    IfUserIsNotLogin;
    
    ZCProductInfo *productInfo = [ZCProductInfo new];
    //thumbUrl 缩略图地址
    productInfo.thumbUrl = self.detailModel.goodsAbridgeImgUrl;
    //  title 标题 (必填)
    productInfo.title = self.detailModel.goodsName;
    //  desc 摘要

    //  页面地址url（必填)
    productInfo.link = self.detailModel.goodsAbridgeImgUrl;
    
    //进入客服
    [self openZCServiceWithProduct:productInfo];
    
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
-(void)isLoginVC{
    BaseNavigationController * b = [[BaseNavigationController alloc] initWithRootViewController:[LFLoginViewController new]];
    [self presentViewController:b animated:YES completion:nil];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
