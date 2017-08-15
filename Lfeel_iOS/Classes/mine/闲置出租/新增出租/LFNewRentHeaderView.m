//
//  LFNewRentHeaderView.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFNewRentHeaderView.h"
@interface   LFNewRentHeaderView ()<UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *PohoderlText;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextF;

@end
@implementation LFNewRentHeaderView
{
    NSMutableDictionary * dictD;
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        SLLog2(@"ssssss");
        
         self.textView.delegate = self;
        
    }
    return self;
    
}

-(void)textViewDidChange:(UITextView *)textView{
    if (self.textView.text.length >0) {
        self.PohoderlText.hidden = YES;
        if (self.phoneTextF.text.length > 0) {
            dictD[@"contactTel"] = self.textView.text;
            dictD[@"goodsDescribe"] = self.phoneTextF.text;
        }else{
            dictD[@"contactTel"] = self.textView.text;
            dictD[@"goodsDescribe"] = self.phoneTextF.text;
        }
        
        if (self.didTextFeld) {
            self.didTextFeld(dictD);
        }
    }else{
        self.PohoderlText.hidden = NO;
        if (self.phoneTextF.text.length > 0) {
            dictD[@"contactTel"] = self.textView.text;
            dictD[@"goodsDescribe"] = self.phoneTextF.text;
        }else{
            dictD[@"contactTel"] = self.textView.text;
            dictD[@"goodsDescribe"] = self.phoneTextF.text;
        }
        
        if (self.didTextFeld) {
            self.didTextFeld(dictD);
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length > 0) {
        if (self.textView.text.length> 0) {
            if (self.textView.text > 0) {
                dictD[@"goodsDescribe"] = self.textView.text;
                dictD[@"contactTel"] = self.phoneTextF.text;
            }else{
                dictD[@"contactTel"] = self.textView.text;
                dictD[@"goodsDescribe"] = self.phoneTextF.text;
            }
        }else{
            if (self.textView.text > 0) {
                dictD[@"goodsDescribe"] = self.textView.text;
                dictD[@"contactTel"] = self.phoneTextF.text;
            }else{
                dictD[@"contactTel"] = self.textView.text;
                dictD[@"goodsDescribe"] = self.phoneTextF.text;
            }
        }
        if (self.didTextFeld) {
            self.didTextFeld(dictD);
        }
        return YES;
    }
    
    return YES;
}






-(void)awakeFromNib{
    [super awakeFromNib];
    [self.contentView rm_fitAllConstraint];
    self.textView.delegate = self;
    self.phoneTextF.delegate = self;
    dictD = [NSMutableDictionary dictionary];
    dictD [@"contactTel"] = @"";
    dictD[@"goodsDescribe"]= @"";
    }

@end
