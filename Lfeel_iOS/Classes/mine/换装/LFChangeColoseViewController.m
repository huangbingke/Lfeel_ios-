//
//  LFChangeColoseViewController.m
//  Lfeel_iOS
//
//  Created by 陈泓羽 on 17/3/21.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFChangeColoseViewController.h"
#import "LFHeaderView.h"
#import "LFTwoHeaderView.h"
#import "TZImagePickerController.h"
#import "LFMineAddressViewController.h"
#import "LFChangeCloseCell.h"
#import "LFChangeShowView.h"


static NSString * const _URLKey = @"_URLKey";
@interface UIImage (_URL)
@property (nonatomic,   copy) NSString * urlString2;
@end
@implementation UIImage (_URL)
- (void)setUrlString2:(NSString *)urlString {
    objc_setAssociatedObject(self, &_URLKey, urlString, OBJC_ASSOCIATION_COPY);
}
- (NSString *)urlString2 {
    return objc_getAssociatedObject(self, &_URLKey);
}
@end

@interface LFChangeColoseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) LFHeaderView  * oneHeaderView;

@property (nonatomic, strong) NSMutableArray<UIImage *> * pics;
@property (nonatomic, strong) NSMutableArray * imageViews;
@property (nonatomic,   weak) UIView * picView;
@property (nonatomic,   weak) UIButton * addBtn;
@property (nonatomic, strong) UITableView * tabbleView;

@property (nonatomic,   strong) LFAddressModel *model;

@end

@implementation LFChangeColoseViewController
{
    UIView * _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavtitleVew];
    [self CreateView];
}

-(void)setNavtitleVew{
    
    @weakify(self);
  self.ts_navgationBar= [TSNavigationBar navWithTitle:@"申请换衣" backAction:^{
      @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

-(void)CreateView{
    
 
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight - 64 - Fit(36 + 44)) style:UITableViewStyleGrouped];
    tabbleView.backgroundColor= HexColorInt32_t(ffffff);
    tabbleView.dataSource = self;
    tabbleView.delegate = self;
    [self.view addSubview:tabbleView];
    self.tabbleView = tabbleView;

    
    
    
    
    UIButton * submitBtn = [UIButton buttonWithTitle:@"提交" titleColor:HexColorInt32_t(C00D23) backgroundColor:nil font:Fit(14) image:nil frame:Rect(Fit(15), 0, kScreenWidth -Fit(30), Fit(36))];
    submitBtn.maxY = kScreenHeight - Fit(22);
    [submitBtn addTarget:self action:@selector(TapSelectSubmitBtn)];
    submitBtn.borderColor = HexColorInt32_t(C00D23);
    submitBtn.borderWidth = 1;
    [self.view addSubview:submitBtn];
 
}

 
#pragma mark  -- 创建headerView
-(UIView *)CreateMineHeadView{
    if (_headerView) {
        return _headerView;
    }
    _headerView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Fit375(265))];
    _headerView.backgroundColor = HexColorInt32_t(ffffff);

    self.oneHeaderView = [LFHeaderView creatViewFromNib];
    self.oneHeaderView.frame = Rect(0, 0, kScreenWidth, Fit375(120));
    [_headerView addSubview:self.oneHeaderView];
    @weakify(self);
    
    
    self.oneHeaderView.didSelectAddressBtn =^{
        @strongify(self);
        LFMineAddressViewController * controller = [[LFMineAddressViewController alloc] init];
        controller.didSelectedAddressBlock = ^(LFAddressModel *model) {
            @strongify(self);
            self.model = model;
            [self.oneHeaderView addressData:model];
        };
        [self.navigationController pushViewController:controller animated:YES];
    };
    SLDevider * devider = [[SLDevider alloc] initWithFrame:Rect(0, self.oneHeaderView.height - 1, kScreenWidth, 1)];
    [self.oneHeaderView addSubview:devider];
    
    LFTwoHeaderView * header2 = [LFTwoHeaderView creatViewFromNib];
    header2.backgroundColor = HexColorInt32_t(754fff);
    header2.frame =Rect(0, CGRectGetMaxY(self.oneHeaderView.frame), kScreenWidth, Fit375(46));
    [_headerView addSubview:header2];
    
    
    SLDevider * devider1 = [[SLDevider alloc] initWithFrame:Rect(0, header2.height - 1, kScreenWidth, 1)];
    [header2 addSubview:devider1];
    
    
    UIView * picView = [UIView viewWithBgColor:nil frame:Rect(0, header2.maxY, kScreenWidth, Fit(111))];
    picView.backgroundColor = HexColorInt32_t(ffffff);
    [_headerView addSubview:picView];
    self.picView = picView;

    SLDevider * devider2 = [[SLDevider alloc] initWithFrame:Rect(0, picView.height - 1, kScreenWidth, 1)];
    [picView addSubview:devider2];
    
    UIButton * addBtn = [UIButton buttonWithTitle:nil titleColor:nil backgroundColor:nil font:0 image:nil frame:Rect(Fit(15), 0, Fit(86), Fit(86))];
    addBtn.centerY = picView.halfHeight;
    [addBtn setBackgroundImage:[UIImage imageNamed:@"添加评论"] forState:UIControlStateNormal];
    [picView addSubview:addBtn];
    self.addBtn = addBtn;
    
    [addBtn addTarget:self action:@selector(_didClickAddBtn)];
    for (int i = 0; i < 3; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:addBtn.frame];
        [self.imageViews addObject:imageView];
        [picView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i + 1;
        imageView.hidden = YES;
        UITapGestureRecognizer * tap = [UITapGestureRecognizer new];
        @weakify(self);
        [tap.rac_gestureSignal subscribeNext:^(UITapGestureRecognizer * x) {
            @strongify(self);
            NSInteger index= x.view.tag - 1;
            [self.pics removeObjectAtIndex:index];
            [self handleImages];
        }];
        [imageView addGestureRecognizer:tap];
    }

    _headerView.height = picView.maxY;
    return _headerView;
}

-(void)_didClickAddBtn{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 - self.pics.count delegate:nil];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        NSString * url = @"image/upload";
        for (UIImage *imge in photos) {
            [TSNetworking POSTImageWithURL:url paramsModel:nil image:imge imageParam:@"image" completeBlock:^(NSDictionary *request) {
                SLLog(request);
                if ([request[@"result"] integerValue] !=200) {
                    SVShowError(@"上传失败");
                    return ;
                }
                NSString * url = request[@"imgUrl"];
                imge.urlString2 = url;
                [self.pics addObject:imge];
                [self handleImages];
                
            } failBlock:^(NSError *error) {
                
            }];
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
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
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self CreateMineHeadView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
       return Fit375(265);
    }
    else{
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LFChangeCloseCell * cell = [LFChangeCloseCell cellWithTableView:tableView];
    LFapplyFaceliftListModel * model = self.datasArray[indexPath.row];
    [cell setModel1:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Fit375(116);
}

-(void)TapSelectSubmitBtn{
    
    if (self.model == nil) {
        SVShowError(@"收货地址不能为空");
        return;
    }
    
    [self HTTPChangeapplyFacelift];
}


-(void)HTTPChangeapplyFacelift {
    
    NSMutableString * goodIds = [NSMutableString new];
    for (LFapplyFaceliftListModel * obj in self.datasArray) {
        [goodIds appendFormat:@"%@;", obj.goodsId];
    }
    if (goodIds.length) {
        [goodIds deleteCharactersInRange:NSMakeRange(goodIds.length - 1, 1)];
    }
    
    NSString * url =@"personal/applyFacelift.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.addressId = self.model.addressId;
    paeme.goodsIds = goodIds;
    paeme.loginKey = user_loginKey;
    
    NSMutableString * imagString = [[NSMutableString alloc] init];
    for (UIImage * image in self.pics) {
        if (!image.urlString2.length) continue;
        [imagString appendFormat:@"%@;", image.urlString2];
    }
    if (imagString.length) {
        [imagString deleteCharactersInRange:NSMakeRange(imagString.length - 1, 1)];
    }
    paeme.imgsVoucher = imagString;
    
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue]!= 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        
        BLOCK_SAFE_RUN(self.vBlock);
        [self _showSuccess];
        
    } failBlock:^(NSError *error) {
        
    }];
}

-(void)_showSuccess{
    
    UIView * view = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.view addSubview:view];
    
    LFChangeShowView * shareView = [LFChangeShowView creatViewFromNib];
    shareView.frame = Rect(0, 0, kScreenWidth - Fit(30), shareView.height);
    shareView.centerY = kHalfScreenHeight - Fit(50);
    shareView.centerX = kHalfScreenWidth;
    [view addSubview:shareView];
    @weakify(self);
    shareView.didselectBtn = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };

}


- (NSMutableArray *)pics { SLLazyMutableArray(_pics) }
- (NSMutableArray *)imageViews { SLLazyMutableArray(_imageViews)}

@end
