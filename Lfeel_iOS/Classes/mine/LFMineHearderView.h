//
//  LFMineHearderView.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/22.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFMineHearderView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightCons;
///  <#Description#>
@property (nonatomic,   copy)void (^didSelectAddVip) ();

@property (nonatomic,   copy)void (^didSettingBtn) ();
@property (nonatomic,   copy)void (^didRechargeBtn) ();

@property (nonatomic,   copy)void (^didCenterBtn) ();
@property (nonatomic, copy) void (^didInvoteBtn) ();
@property (nonatomic, copy) void (^didCodeBtn) ();

@property (weak, nonatomic) IBOutlet UIButton *QRCodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *addVipBtn;
//显示时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//充值
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;

-(void)setdata:(NSDictionary *)dict;

///  点击订单
@property (nonatomic,   copy) void (^didClickOrderBlock)(NSInteger type);

@end
