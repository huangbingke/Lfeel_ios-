//
//  LFNewRentViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFNewRentViewController.h"
#import "LFNewRentHeaderView.h"
#import "LFUpdataCertificatView.h"
#import "TZImagePickerController.h"


static NSString * const _URLKey = @"_URLKey";
@interface UIImage (_URL)
@property (nonatomic,   copy) NSString * urlString3;
@end
@implementation UIImage (_URL)
- (void)setUrlString3:(NSString *)urlString {
    objc_setAssociatedObject(self, &_URLKey, urlString, OBJC_ASSOCIATION_COPY);
}
- (NSString *)urlString3 {
    return objc_getAssociatedObject(self, &_URLKey);
}
@end

@interface LFNewRentViewController ()

@property (nonatomic, strong) UIView  * contentView;
@property (nonatomic, strong) UIView  * bgView;
@property (nonatomic, strong) UIScrollView * scro;
@property (nonatomic, strong) UIButton * addBtn;
@property (nonatomic, strong) NSMutableArray * imageViews;
@property (nonatomic, strong) NSMutableArray<UIImage *> * pics;
@property (nonatomic, strong) TZImagePickerController *imagePicker;
@end

@implementation LFNewRentViewController
{
    NSString * contactTel;
        NSString * goodsDescribe;
    NSDictionary * dicty;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pics = [NSMutableArray array];
    self.imageViews = [NSMutableArray array];
    [self  setupNavigationBar];
    [self CreateView];
    
}
/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    
    @weakify(self);
    
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"新增出租" backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

-(void)CreateView{
    
  
    UIScrollView * scro = [[UIScrollView alloc]init];
    scro.frame = Rect(0, 64, kScreenWidth, kScreenHeight - 64);
    scro.backgroundColor = HexColorInt32_t(f6f6f6);
    [self.view addSubview:scro];
    self.scro = scro;
    
    
    LFNewRentHeaderView * headerView = [LFNewRentHeaderView creatViewFromNib];
    headerView.frame = Rect(0, 0, kScreenWidth, Fit375(177));
    
    @weakify(self);
    headerView.didTextFeld = ^(NSMutableDictionary * Dict){
        @strongify(self);
        SLLog(Dict);
        self-> dicty = Dict;
    };
    [scro addSubview:headerView];
    LFUpdataCertificatView * updateCerti = [LFUpdataCertificatView creatViewFromNib];
    updateCerti.frame = Rect(0, CGRectGetMaxY(headerView.frame), kScreenWidth, Fit(46));
    
    [scro addSubview:updateCerti];
    
    
    UIView * bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.frame = Rect(0, updateCerti.maxY, kScreenWidth, Fit(111));
    [scro addSubview:bgView];
    self.bgView  = bgView;
    
    
    UIButton * addBtn = [UIButton buttonWithTitle:nil titleColor:nil backgroundColor:nil font:0 image:@"添加评论" frame:Rect(Fit(15), Fit(23), Fit(86), Fit(86))];
    [bgView addSubview:addBtn];
    self.addBtn = addBtn;
    [addBtn addTarget:self action:@selector(_didClickAddBtn)];
    for (int i = 0; i < 6; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:addBtn.bounds];
        [imageView setBorderWidth:0.8 borderColor:HexColorInt32_t(999999)];
        imageView.hidden = YES;
        [self.imageViews addObject:imageView];
        [bgView addSubview:imageView];
    }
    
    UIButton * button = [UIButton   buttonWithTitle:@"提 交" titleColor:HexColorInt32_t(c00d23) backgroundColor:HexColorInt32_t(f1f1f1) font:13 image:@"" frame:CGRectZero];
    button.frame = Rect(15,kScreenHeight - Fit(55),kScreenWidth-Fit(30), Fit(40));
    [self.view addSubview:button];
    
    button.borderColor = HexColorInt32_t(C00D23);
    button.borderWidth = 1;
    [button addTarget:self action:@selector(TapUpdateBtn)];
    
 
}






-(void)HTTRrequestsubmit{
    
    NSString * url =@"personal/addRent.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.contactTel = contactTel;
    paeme.goodsDescribe = goodsDescribe;
    

    NSMutableString * imagString = [[NSMutableString alloc]init];
    
//    for (NSString  * imageSr in self.imgurlarr) {
//        if (self.imgurlarr.count ==1) {
//            [imagString appendFormat:@"%@",imageSr];
//        }else{
//            [imagString appendFormat:@"%@;",imageSr];
//        }
//        
//    }
    paeme.goodsImg = imagString;
    paeme.loginKey = user_loginKey;

    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        SVShowSuccess(request[@"msg"]);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
        
    } failBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 提交
-(void)TapUpdateBtn{
    SLLog2(@"提交");
    contactTel = self->dicty[@"contactTel"];
    goodsDescribe = self-> dicty[@"goodsDescribe"];
    
    SLVerifyText(contactTel.length , @"请输入手机号码");
    SLVerifyText(goodsDescribe.length, @"请输入描述问题");
    
    
    if (self.pics.count == 0) {
        SVShowError(@"请上传凭证");
        return;
    }
    
 
    [self HTTRrequestsubmit];
    
}

-(void)_didClickAddBtn{
    self.imagePicker.maxImagesCount = 6 - self.pics.count;
    @weakify(self);
    [self.imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        @strongify(self);
        NSString * url = @"image/upload";
        for (UIImage *imge in photos) {
            [TSNetworking POSTImageWithURL:url paramsModel:nil image:imge imageParam:@"image" completeBlock:^(NSDictionary *request) {
                SLLog(request);
                if ([request[@"result"] integerValue] !=200) {
                    SVShowError(@"上传失败");
                    return ;
                }
                NSString * url = request[@"imgUrl"];
                imge.urlString3 = url;
                [self.pics addObject:imge];
                [self handleImages];
                
            } failBlock:^(NSError *error) {
                
            }];
        }
    }];
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}


- (void)handleImages {
    for (int i = 0; i < self.imageViews.count; i++) {
        UIImageView * imageView = self.imageViews[i];
        imageView.hidden = YES;
        
    }
    CGFloat margin = Fit(15);
    for (int i = 0; i < self.pics.count + 1; i++) {
        CGFloat x = i * (margin + Fit(86)) + margin;
        if (i == self.pics.count) {
            if (self.pics.count == 3) {
                self.addBtn.hidden = YES;
            } else {
                self.addBtn.x = x;
                self.addBtn.hidden = NO;
            }
            return;
        }
        UIImageView * imageView = self.imageViews[i];
        imageView.x = x;
        imageView.image = self.pics[i];
        imageView.hidden = NO;
    }
    
    self.bgView.height = self.addBtn.maxY + Fit(20);
}

- (TZImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:6 delegate:nil];
    }
    return _imagePicker;
}

@end
