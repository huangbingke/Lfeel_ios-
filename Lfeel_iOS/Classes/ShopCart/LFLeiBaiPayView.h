//
//  LFLeiBaiPayView.h
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/5/1.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFLeiBaiPayView : UIView

@property (nonatomic,   copy) NSString * price;

@property (nonatomic, assign, readonly) NSInteger selectedStage;

- (void)setProtocalBlock:(VoidBlcok)pro nextBlock:(VoidBlcok)next;

@end


@interface LFLeiBaiPayView2 : UIView

@property (nonatomic, weak) IBOutlet UITextField * name;
@property (weak, nonatomic) IBOutlet UITextField *identifyCardID;
@property (weak, nonatomic) IBOutlet UITextField *cardNum;
@property (weak, nonatomic) IBOutlet UITextField *month;
@property (weak, nonatomic) IBOutlet UITextField *year;
@property (weak, nonatomic) IBOutlet UITextField *cnv2;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *verify;
@property (weak, nonatomic) IBOutlet UITextView *remark;
@property (weak, nonatomic) IBOutlet UIButton *sendVerifyBtn;

- (void)setDidSendVerifyBlock:(VoidBlcok)send sureBlock:(VoidBlcok)sure;

@end


@class YZMenuButton, LFCardInfo;
@interface LFLeiBaiPayView3 : UIView
///  银行卡列表
@property (nonatomic,   copy) NSArray<LFCardInfo *> * bankCardList;
@property (nonatomic, strong, readonly) LFCardInfo * selectedCard;

@property (weak, nonatomic) IBOutlet YZMenuButton *cardBtn;
@property (weak, nonatomic) IBOutlet UITextField *month;
@property (weak, nonatomic) IBOutlet UITextField *year;
@property (weak, nonatomic) IBOutlet UITextField *cnv2;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *verify;
@property (weak, nonatomic) IBOutlet UITextView *remark;
@property (weak, nonatomic) IBOutlet UIButton *sendVerifyBtn;

- (void)setDidSendVerifyBlock:(VoidBlcok)send sureBlock:(VoidBlcok)sure addNewCardBlock:(VoidBlcok)add;

@end
