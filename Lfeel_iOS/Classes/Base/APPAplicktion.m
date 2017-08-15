//
//  APPAplicktion.m
//  PocketJC
//
//  Created by kvi on 16/11/29.
//  Copyright © 2016年 CHY. All rights reserved.
//

#import "APPAplicktion.h"

@interface APPAplicktion ()
@property (nonatomic, strong) UIImageView * imageV;
@property (nonatomic, strong) UIImageView * imageV1;


@property (nonatomic,   weak) UIView * bgView;
@property (nonatomic,   weak) UIButton * btn;
@end

@implementation APPAplicktion
{
    NSInteger count;
    NSTimer *_timer;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
//    [self requestOpenImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
      count = 2;
    NSDictionary * dict = [User getUseDefaultsOjbectForKey:@"APPlicktion"];
    
    UIView *bgView = [[UIView alloc]init];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.width.mas_equalTo(kScreenWidth);
        make.left.offset(0);
        make.height.mas_equalTo(kScreenHeight);
    }];
    self.bgView = bgView;
    
    
    UIImage *name;
    if (kScreenWidth == 320) {
        if (kScreenHeight == 480 ) {
            name = [UIImage imageNamed:@"640-960"];
        }else{
            name = [UIImage imageNamed:@"640-1136"];
        }
    }else if(kScreenWidth == 375){
        name = [UIImage imageNamed:@"750-1334"];
    }else if(kScreenWidth ==414){
        name = [UIImage imageNamed:@"1242-2208"];
    }
    
    UIImageView * imagew1 =[[UIImageView alloc]init];
    imagew1.image = name;
    [bgView addSubview:imagew1];
    [imagew1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.width.mas_equalTo(kScreenWidth);
        make.left.offset(0);
        make.height.mas_equalTo(kScreenHeight);
    }];
    
    self.imageV1  = imagew1;
    self.imageV1.image = name;
    
    UIImageView * imagew =[[UIImageView alloc]init];
    imagew.hidden = YES;
    [bgView addSubview:imagew];
    [imagew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.width.mas_equalTo(kScreenWidth);
        make.left.offset(0);
        make.height.mas_equalTo(kScreenHeight);
    }];
    self.imageV  = imagew;
    
    UIButton * btn = [UIButton buttonWithTitle:@"3 s跳过" titleColor:HexColorInt32_t(ffffff) backgroundColor:ThemeColor font:14 image:nil frame:Rect(0, kScreenHeight - 50, 60, 25)];
    btn.cornerRadius = 3;
    self.imageV.userInteractionEnabled = YES;
    [self.imageV addSubview:btn];
    btn.maxX = kScreenWidth - 15;
    _btn = btn;
    @weakify(self);
    [[btn rac_signalForControlEvents:64] subscribeNext:^(id x) {
        @strongify(self);
        [self.bgView removeFromSuperview];
        [self->_timer invalidate];
        self->_timer = nil;
        MainViewController * main = [[MainViewController alloc] init];
        self.view.window.rootViewController = main;
        
        
    }];

    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:dict[@"picture"]] placeholderImage:name];
    });
    
    [self setdata:dict];
}




-(void)setdata:(NSDictionary *)responseObject{
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      self.imageV.hidden = NO;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countD:) userInfo:nil repeats:YES];
  self.imageV1.hidden = YES;
    });
    
}

- (void)countD:(NSTimer *)timer {
    count--;
    self.btn.title = [NSString stringWithFormat:@"%zd s跳过", count];
    
    if (count == 0) {
        [timer invalidate];
        timer = nil;
        MainViewController * main = [[MainViewController alloc] init];
        self.view.window.rootViewController = main;
    }
}

- (void)tapImageV:(UITapGestureRecognizer *)ges {
    [self.bgView removeFromSuperview];
    self.bgView = nil;
}

 

@end
