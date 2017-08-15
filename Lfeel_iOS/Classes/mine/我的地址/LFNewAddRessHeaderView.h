//
//  LFNewAddRessHeaderView.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFNewAddRessHeaderView : UIView

///  点击省市区
@property (nonatomic,   copy) void (^didClickProvinceBlock)();
@property (nonatomic,   copy) NSString * address;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UILabel *province;
@property (weak, nonatomic) IBOutlet UITextField *detail;
@end
