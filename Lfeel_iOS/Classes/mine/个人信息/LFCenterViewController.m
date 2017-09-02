//
//  LFCenterViewController.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/14.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFCenterViewController.h"
#import "LFSexView.h"
#import "LFSelectDateView.h"
#import "UIButton+WebCache.h"
#import "LFSelectPickViewSizeView.h"
#import "SLImagePickerController.h"
#import "SLHud.h"

@interface LFCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *usericonBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *heightText;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

@property (weak, nonatomic) IBOutlet UITextField *IDCaridText;
@property (weak, nonatomic) IBOutlet UITextField *weightText;
@property (weak, nonatomic) IBOutlet UILabel *bithdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *SizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sanweiLabel;
///  <#Description#>
@property (nonatomic, strong) UITableView * tabbleView;

@property (nonatomic, strong) UIImage * m_head_picImg;

@end

@implementation LFCenterViewController{
    NSString * sex;
    NSArray * array1;
    
    NSString * bust,*waist,*hipline,*imageUrl;

 
}

- (void)viewDidLoad {
    [super viewDidLoad];
     array1 = @[@"S",@"M",@"L",@"XL",@"2XL",@"3XL"];
    [self setupNavigationBar];
    [self tapView];
    [self HttpRequestCenter];
}

-(void)TapEndView{
    [self.view endEditing:YES];
}
-(void)tapView{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapEndView)];
    [self.view addGestureRecognizer:tap];
}


-(void)HttpRequestCenter{
    NSString * url =@"personal/userInfo.htm?";
    LFParameter *paeme = [LFParameter new];
    paeme.loginKey = user_loginKey;
    SLHud * hud = [[SLHud alloc] initWithTitle:@"正在加载" frame:defaultRect()];
    [self.view addSubview:hud];
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        [hud removeFromSuperview];
        SLLog(request);
        [User saveCenterUserInfomation:request];
        [self _setupData];
        [self setUsericon];
        
    } failBlock:^(NSError *error) {
        [hud removeFromSuperview];
        SLLog(error);
    }];
}

/// 初始化NavigaitonBar
- (void)setupNavigationBar {
    
    @weakify(self);
    
    
    self.ts_navgationBar = [TSNavigationBar navWithTitle:@"个人信息" backAction:^{
        @strongify(self);
        [UIAlertView alertWithTitle:@"是否保存" message:@"" cancelButtonTitle:@"不保存" OtherButtonsArray:@[@"保存"] clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self HttpRequestChangeCenterMessage];
            }
            
        }];

       
    }];
    
}

///设置数据
-(void)_setupData{
    self.phoneText.text = [NSString stringWithFormat:@"%@",USER.lfuserinfo.phoneMoble];
    NSString * name = USER.lfuserinfo.userName.length ? USER.lfuserinfo.userName : USER.lfuserinfo.nickname;
    self.nameText.text = [NSString stringWithFormat:@"%@",name];
    self.heightText.text = [NSString stringWithFormat:@"%@",USER.lfuserinfo.height];
    self.weightText.text = [NSString stringWithFormat:@"%@",USER.lfuserinfo.weight];
    self.bithdayLabel.text = [NSString stringWithFormat:@"%@",USER.lfuserinfo.birthday];
    self.IDCaridText.text = [NSString stringWithFormat:@"%@",USER.lfuserinfo.identification];

    if (!USER.lfuserinfo.bust.integerValue || !USER.lfuserinfo.waist.integerValue || !USER.lfuserinfo.hipline.integerValue) {
        self.sanweiLabel.hidden = YES;
    } else {
        self.sanweiLabel.text = [NSString stringWithFormat:@"胸围:%@ - 腰围:%@ - 臀围:%@",USER.lfuserinfo.bust,USER.lfuserinfo.waist,USER.lfuserinfo.hipline];
    }
    [self setSex:[USER.lfuserinfo.sex integerValue]];
    self.SizeLabel.text = USER.lfuserinfo.size ? : @"";// [NSString stringWithFormat:@"%@",USER.lfuserinfo.size];
}


/// 选择性别
- (IBAction)TapSelectSex:(id)sender {
    SLLog2(@"选择性别");
    
    [self TapEndView];
    UIView * view = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.view addSubview:view];
    
    
    LFSexView * sexView = [LFSexView creatViewFromNib];
    sexView.frame = Rect(0, kScreenHeight, kScreenWidth, Fit375(132));
    [view addSubview:sexView];
    sexView.selectedSex = sex;
    @weakify(self, sexView);
    sexView.didTapCloseBtn = ^{
        @strongify(sexView);
        [UIView animateWithDuration:0.25 animations:^{
            sexView.y = kScreenHeight;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    };
    
    sexView.didTapSelectBtn =^(NSInteger selectSex){
        SLLog2(@"select:%zd ", selectSex);
        @strongify(self, sexView);
        [self setSex:selectSex];
        sexView.didTapCloseBtn();
    };
    
    CGFloat y = kScreenHeight - sexView.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        sexView.y = y;
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        [UIView animateWithDuration:0.25 animations:^{
            sexView.y = kScreenHeight;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    [view addGestureRecognizer:tap];
    
}

/// 选择尺码
- (IBAction)TapSelectSizeXL:(id)sender {
    [self TapEndView ];
    UIView * view = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.view addSubview:view];
    
    UIView * contentView = [[UIView alloc] initWithFrame:Rect(0, kScreenHeight, kScreenWidth,Fit375(300) )];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.tag = 100;
    {
        
        UITableView * tabbleView = [[UITableView alloc]initWithFrame:Rect(0, 0,contentView.width,contentView.height) style:UITableViewStylePlain];
        tabbleView.dataSource = self;
        tabbleView.delegate =self;
        [contentView addSubview:tabbleView];
        self.tabbleView = tabbleView;
        tabbleView.tableFooterView = [UIView new];
    }
    [view addSubview:contentView];
    CGFloat y = kScreenHeight - contentView.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        contentView.y = y;
    }];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        [UIView animateWithDuration:0.25 animations:^{
            self.tabbleView.y = kScreenHeight;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    [view addGestureRecognizer:tap];


}

/// 选择出生日期
- (IBAction)TapSelectBithday:(id)sender {
    [self TapEndView];
    SLLog2(@"出生日期");
    UIView * bithdayView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight)];
    bithdayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.view addSubview:bithdayView];
    
    LFSelectDateView * selectDateView = [LFSelectDateView creatViewFromNib];
    selectDateView.frame = Rect(0, kScreenHeight, kScreenWidth, selectDateView.height);
    [bithdayView addSubview:selectDateView];
    @weakify(self, selectDateView);
    // 点击确定
    selectDateView.didTapSaveBtn =^(NSString * date){
        @strongify(self, selectDateView);
        self.bithdayLabel.text = [NSString stringWithFormat:@"%@",date];
        [UIView animateWithDuration:0.25 animations:^{
            selectDateView.y = kScreenHeight;
            bithdayView.alpha = 0;
        } completion:^(BOOL finished) {
            [bithdayView removeFromSuperview];
        }];
        
    };
    selectDateView.didTapCloseBtn =^{
        @strongify(selectDateView);
        [UIView animateWithDuration:0.25 animations:^{
            selectDateView.y = kScreenHeight;
            bithdayView.alpha = 0;
        } completion:^(BOOL finished) {
            [bithdayView removeFromSuperview];
        }];
    };
    CGFloat y = kScreenHeight - selectDateView.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        selectDateView.y = y;
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        [UIView animateWithDuration:0.25 animations:^{
            selectDateView.y = kScreenHeight;
        } completion:^(BOOL finished) {
            [bithdayView removeFromSuperview];
        }];
    }];
    [bithdayView addGestureRecognizer:tap];
}

/// 保存
- (IBAction)TapSaveBtn:(id)sender {
    [self HttpRequestChangeCenterMessage];
}


/// 选择头像
- (IBAction)TapSelectUsericon:(id)sender {
    [self TapEndView];
    [SLImagePickerController showInViewController:self libraryType:0 allowEdit:YES complete:^(UIImage *image) {
//        self.usericonBtn.image = image;
        self.m_head_picImg = image;
        [self HttpUpDataUserImageIcon];
    }];
    
    
}

/// 选择三围
- (IBAction)TapSelectSizeBtn:(id)sender {
    [self TapEndView];
    UIView * view = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.view addSubview:view];
    
    LFSelectPickViewSizeView * sizeViews = [LFSelectPickViewSizeView creatViewFromNib];
    sizeViews.frame = Rect(0, kScreenHeight, kScreenWidth, sizeViews.height);
    [view addSubview:sizeViews];
    @weakify(self, sizeViews);
    
    
    sizeViews.didSelectCloseBtn = ^ {
        @strongify(sizeViews);
        [UIView animateWithDuration:0.25 animations:^{
            sizeViews.y = kScreenHeight;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    };
    
    sizeViews.didSelectSaveBtn =^(NSString * string , NSString * string1,NSString * string2){
        @strongify(self, sizeViews);
        self.sanweiLabel.text = [NSString stringWithFormat:@"胸围:%@ - 腰围:%@ - 臀围:%@",string,string1,string2];
        self.sanweiLabel.hidden = NO;
        self->bust = string ;self->waist = string1;self->hipline =string2;
        
        [UIView animateWithDuration:0.25 animations:^{
            sizeViews.y = kScreenHeight;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    };
    
    CGFloat y = kScreenHeight - sizeViews.height;
    [UIView animateWithDuration:0.25 animations:^{
        sizeViews.y = y;
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        [UIView animateWithDuration:0.25 animations:^{
            sizeViews.y = kScreenHeight;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    [view addGestureRecognizer:tap];
}



-(void)setSex:(NSInteger)selectSex{
    sex = [NSString stringWithFormat:@"%zd",selectSex];
    NSArray * array = @[@"女",@"男"];
    self.sexLabel.text = array[selectSex];
    
}

///设置头像
-(void)setUsericon{
    
    NSString * getus = USER.lfuserinfo.userIoc;
    SLLog(getus);
    
    
    if ([USER.lfuserinfo.userIoc isEqualToString:@""]) {
        [self.usericonBtn setImage:[UIImage imageNamed:@"头像空"]];
    }else{
        [self.usericonBtn sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@",USER.lfuserinfo.userIoc]] forState:UIControlStateNormal];
    }
}


#pragma Http
-(void)HttpRequestChangeCenterMessage{
    SLVerifyText(self.nameText.text.length, @"请输入姓名");
    SLVerifyText(self.weightText.text.length, @"请输入体重");
    SLVerifyText(self.heightText.text.length, @"请输入身高");
    SLVerifyText(self->hipline.length, @"请输入臀围");
    SLVerifyText(self->bust.length, @"请输入胸围");
    SLVerifyText(self->waist.length, @"请输入腰围");
    SLVerifyText(self.sexLabel.text.length, @"请输入性别");
    SLVerifyText(self.SizeLabel.text.length, @"请输入尺码");

    // 加入正则判断
    if (self.phoneText.hasText) {
        SLVerifyPhone(self.phoneText.text, @"手机号码不正确");
    }
    if (self.IDCaridText.hasText) {
        SLAssert([self.IDCaridText.text validateIdentityCard], @"身份证号码格式不正确");
    }
 
    NSString * url =@"personal/updateUserInfo.htm?";
    LFParameter *parameter = [LFParameter new];
    parameter.loginKey = user_loginKey;
    parameter.userName = self.nameText.text;
    parameter.weight = self.weightText.text;
    parameter.height = self.heightText.text;
    parameter.hipline = self->hipline;
    parameter.waist = self->waist;
    parameter.bust =self->bust;
    parameter.birthday = self.bithdayLabel.text;
    parameter.sex = [self.sexLabel.text isEqualToString:@"女"] ? @"0" : @"1";
    parameter.userIocUrl = imageUrl ? : USER.lfuserinfo.userIoc;
   
    parameter.size = self.SizeLabel.text;
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        
        if ([request[@"result"] integerValue]!=200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        SVShowSuccess(request[@"msg"]);
        BLOCK_SAFE_RUN(self.vBlock);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failBlock:^(NSError *error) {
        SLLog(error);
        
        
        
    }];
}

/// 上传头像
-(void)HttpUpDataUserImageIcon{
    NSString * url =@"image/upload";
    LFParameter *parameter = [LFParameter new];
    [TSNetworking POSTImageWithURL:url paramsModel:parameter image:self.m_head_picImg imageParam:@"m_head_picImg" completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue]!=200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        imageUrl = request[@"imgUrl"];
        [self.usericonBtn sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:(UIControlStateNormal)];
    } failBlock:^(NSError *error) {
        
    }];
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array1.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString * ID = @"Reg";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    UIButton * buttom = [UIButton buttonWithType:UIButtonTypeCustom];
    buttom.frame = Rect(0, 0, cell.width, cell.height);
    buttom.tag = 10+indexPath.row;
    [buttom addTarget:self action:@selector(TapSeleceXL:)];
    [cell addSubview:buttom];
    cell.textLabel.text = array1[indexPath.row];
    return cell;
 
}






-(void)TapSeleceXL:(UIButton *)sender{
    self.SizeLabel.text = array1[sender.tag -10];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tabbleView.superview.y = kScreenHeight;
    } completion:^(BOOL finished) {
        [self.tabbleView.superview.superview removeFromSuperview];
    }];

}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Fit(44);
}


@end
