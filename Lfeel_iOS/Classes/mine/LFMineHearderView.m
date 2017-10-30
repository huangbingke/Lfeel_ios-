//
//  LFMineHearderView.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/22.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFMineHearderView.h"
@interface LFMineHearderView ()
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UIButton *userIcon;
@property (weak, nonatomic) IBOutlet UIView *orderView;
@property (weak, nonatomic) IBOutlet UIView *orderTypeView;

@end


@implementation LFMineHearderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


//邀请码
- (IBAction)invoteAction:(UIButton *)sender {
    if (self.didInvoteBtn) {
        self.didInvoteBtn();
    }
}

//充值
- (IBAction)Recharge:(UIButton *)sender {
    if (self.didRechargeBtn) {
        self.didRechargeBtn();
    }
}

- (IBAction)TapSelectAddVipBtn:(id)sender {
    if (self.didSelectAddVip) {
        self.didSelectAddVip();
    }
}
- (IBAction)TapSettingBtn:(id)sender {
    if (self.didSettingBtn) {
        self.didSettingBtn();
    }
}
- (IBAction)TapCenterSelectBtn:(id)sender {
    SLLog2(@"跳转到个人设置");

    if (self.didCenterBtn) {
        self.didCenterBtn();
    }
    
}

//二维码
- (IBAction)qrcode:(UIButton *)sender {
    if (self.didCodeBtn) {
        self.didCodeBtn();
    }
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self rm_fitAllConstraint];
//    [self setData];
    
    UITapGestureRecognizer * tap = [UITapGestureRecognizer new];
    @weakify(self);
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        BLOCK_SAFE_RUN(self.didClickOrderBlock, 0);
    }];
    [self.orderView addGestureRecognizer:tap];
    
    for (int i = 0; i < 4; i++) {
        UIView * view = [self.orderTypeView viewWithTag:i + 1011];
        
        UITapGestureRecognizer * tap2 = [UITapGestureRecognizer new];
        [tap2.rac_gestureSignal subscribeNext:^(UITapGestureRecognizer * x) {
            @strongify(self);
            NSInteger index = x.view.tag - 1011;
            BLOCK_SAFE_RUN(self.didClickOrderBlock, index+1);
        }];
        [view addGestureRecognizer:tap2];
    }
}


-(void)setdata:(NSDictionary * )dict{
    NSString * name = [dict[@"userName"] length] ? dict[@"userName"] : dict[@"nickname"];
    if (!name.length) {
        name = [dict[@"phoneMoble"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"剩余时间: %@分钟", dict[@"minutes"]];
    self.namelabel.text = name;
    NSString * userIoc = [NSString stringWithFormat:@"%@",dict[@"userIoc"]];
    if (userIoc.length == 0) {
        [self.userIcon setBackgroundImage:[UIImage imageNamed:@"头像空"] forState:UIControlStateNormal];
    }else{
        [self.userIcon sd_setBackgroundImageWithURL:[NSURL URLWithString:userIoc] forState:UIControlStateNormal placeholderImage:SLPlaceHolder];
    }
 
}
@end
