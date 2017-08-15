//
//  LFPayModule.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFPayModule.h"
@interface LFPayModule ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextF;

@property (weak, nonatomic) IBOutlet UILabel *integralProportioninteLabel;
@end

@implementation LFPayModule


-(void)awakeFromNib{
    [super awakeFromNib];
    [self.bgView rm_fitAllConstraint];
    self.moneyTextF.delegate = self;
    self.integralProportioninteLabel.text = @"0";
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    SLLog2(@"jiessss");
    [self Httprequest];
}
-(void)Httprequest{
    NSString * url =@"personal/integralProportion.htm";
    LFParameter *paeme = [LFParameter new];
    [TSNetworking POSTWithURL:url paramsModel:paeme needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue ] != 200) {
            SVShowError(request[@"msg"]);
        }
        self.integralProportioninteLabel.text = [NSString stringWithFormat:@"%.0lf",[self.moneyTextF.text floatValue] /[request[@"integralProportion"] floatValue]];
        self.integralProportioninteLabel.text = self.integralProportioninteLabel.text.formatNumber;
        if (self.didSelectAmount!= nil) {
            self.didSelectAmount(self.integralProportioninteLabel.text);
        }
        
    } failBlock:^(NSError *error) {
        
    }];
}




@end
