//
//  LFDistributionHeaderView.m
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/7/5.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFDistributionHeaderView.h"

@implementation LFDistributionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = HexColor(@"cc3e2e");
        
        [self setUpUI];
        
    }
    return self;
}




- (void)setUpUI {
    UILabel *getRMBLabel = [[UILabel alloc] init];
    getRMBLabel.text = @"累计收益(元)";
    getRMBLabel.textAlignment = NSTextAlignmentCenter;
    getRMBLabel.textColor = [UIColor whiteColor];
    getRMBLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:getRMBLabel];
    [getRMBLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.mas_top).offset(90);
    }];
    
    self.allGetLabel = [[UILabel alloc] init];
    self.allGetLabel.textAlignment = NSTextAlignmentCenter;
    self.allGetLabel.textColor = [UIColor whiteColor];
    self.allGetLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:self.allGetLabel];
    [self.allGetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(getRMBLabel.mas_bottom).offset(0);
    }];
    
    
    UILabel *restRMBLabel = [[UILabel alloc] init];
    restRMBLabel.textColor = [UIColor whiteColor];
    restRMBLabel.textAlignment = NSTextAlignmentCenter;
    restRMBLabel.text = @"总余额(元)";
    restRMBLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:restRMBLabel];
    [restRMBLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self.allGetLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(self.size.width/2);
    }];
    
    self.allRestLabel = [[UILabel alloc] init];
    self.allRestLabel.textColor = [UIColor whiteColor];
    self.allRestLabel.textAlignment = NSTextAlignmentCenter;
    self.allRestLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.allRestLabel];
    [self.allRestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(restRMBLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(self.size.width/2);
    }];
    
    
    UILabel *mouthRMBLabel = [[UILabel alloc] init];
    mouthRMBLabel.textColor = [UIColor whiteColor];
    mouthRMBLabel.textAlignment = NSTextAlignmentCenter;
    mouthRMBLabel.text = @"当月收益(元)";
    mouthRMBLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:mouthRMBLabel];
    [mouthRMBLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(restRMBLabel.mas_right).offset(0);
        make.top.equalTo(self.allGetLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(self.size.width/2);
    }];
    
    self.mouthGetLabel = [[UILabel alloc] init];
    self.mouthGetLabel.textColor = [UIColor whiteColor];
    self.mouthGetLabel.textAlignment = NSTextAlignmentCenter;
    self.mouthGetLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.mouthGetLabel];
    [self.mouthGetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.allRestLabel.mas_right).offset(0);
        make.top.equalTo(mouthRMBLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(self.size.width/2);
    }];
    
    
    
    self.getBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.getBtn setTitle:@"提现" forState:(UIControlStateNormal)];
    [self addSubview:self.getBtn];
    [self.getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(30);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);
    }];
    
    
    self.backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [self.backBtn setTitle:@"返回" forState:(UIControlStateNormal)];
    [self.backBtn setImage:[UIImage imageNamed:@"形状-6-拷贝-7"] forState:(UIControlStateNormal)];
    [self addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(30);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);
    }];
      
//    LHSegmentControlView *segView = [[LHSegmentControlView alloc] initWithFrame:CGRectMake(0, 250, self.frame.size.width, 40) titleArray:@[@"代理商", @"用户", @"明细"] titleFont:[UIFont systemFontOfSize:15] titleDefineColor:[UIColor blackColor] titleSelectedColor:[UIColor redColor]];
//    segView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:segView];
//    [segView clickTitleButtonBlock:^(NSInteger index) {
//        if (self.clickBlock) {
//            self.clickBlock(index);
//        }
//    }];
}


//
//- (void)clickSegmentBlock:(ClickSegmentBlock)block {
//    self.clickBlock = block;
//}












@end
