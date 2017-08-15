//
//  LFApplyReturnOrderVC.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/4/4.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFApplyReturnOrderVC.h"
#import "LFOrderDetailView.h"
#import "LFApplyReturnOrderView.h"

@interface LFApplyReturnOrderVC ()
@property (nonatomic,   weak) LFApplyReturnOrderView * returnView;
@end

@implementation LFApplyReturnOrderVC

#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    
    [self setupNavigationBar];
    
}

///  初始化子控件
- (void)setupSubViews {
    
    UIScrollView * scrollView = [UIScrollView defaultScrollView];
    scrollView.height = kScreenHeight - 64 - Fit(36 + 44);
    [self.view addSubview:scrollView];
    
    LFApplyReturnOrderView * view = [LFApplyReturnOrderView creatViewFromNib];
    view.frame = Rect(0, 0, kScreenWidth, Fit(view.height));
    [scrollView addSubview:view];
    scrollView.contentSize = Size(0, view.maxY + 30);
    self.returnView = view;
    [view setPrice:self.price];
    
    UIButton * submitBtn = [UIButton buttonWithTitle:@"提交申请" titleColor:HexColorInt32_t(C00D23) backgroundColor:nil font:Fit(14) image:nil frame:Rect(Fit(15), 0, kScreenWidth - Fit(30), Fit(36))];
    submitBtn.maxY = kScreenHeight - Fit(22);
    [submitBtn addTarget:self action:@selector(_submitApply)];
    submitBtn.borderColor = HexColorInt32_t(C00D23);
    submitBtn.borderWidth = 1;
    [self.view addSubview:submitBtn];
}

///  设置自定义导航条
- (void)setupNavigationBar {
    @weakify(self);
    NSString * title = @"申请退货";
    self.ts_navgationBar = [TSNavigationBar navWithTitle:title backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Actions
///  提交申请
- (void)_submitApply {
    /*loginKey		string	@mock=00fa95958febf957bf48ce2aebde71db
     orderId	订单ID	string
     refund	退款金额	string
     refund_img_urls	凭证图片	string	凭证图片
     refund_log	退款原因	string
     refund_remark	退款备注	string
     refund_status	退款状态	number	1=已经收货，0=未收货*/
    
    SLAssert(self.returnView.reasonText, @"请选择退货原因");
    SLAssert(self.returnView.amountText, @"请输入退款金额");
    SLAssert(self.price.doubleValue > self.returnView.amountText.doubleValue, @"退款金额不能超过订单金额");
    
    NSString * url = @"shoppingCart/refundOrder.htm?";
    LFParameter * parameter = [LFParameter new];
    parameter.orderId = self.order_id;
    parameter.refund_log = self.returnView.reasonText;
    parameter.refund_remark = self.returnView.remarkText;
    if (self.returnView.imageUrls) {
        NSMutableString * refund_img_urls = [NSMutableString new];
        for (NSString * s in self.returnView.imageUrls) {
            [refund_img_urls appendFormat:@"%@;", s];
        }
        [refund_img_urls deleteCharactersInRange:NSMakeRange(refund_img_urls.length - 1, 1)];
        parameter.refund_img_urls = refund_img_urls;
    }
    [parameter appendBaseParam];
    parameter.orderId = self.order_id;
    parameter.refund_status = stringWithInteger(self.returnView.status);
    parameter.refund = self.returnView.amountText;
    
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        
        SVShowSuccess(@"申请成功");
        BLOCK_SAFE_RUN(self.vBlock);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
}
#pragma mark - Networking


#pragma mark - Delegate

#pragma mark - Private


#pragma mark - Public


#pragma mark - Getter\Setter

@end
