//
//  LFRegisterMinuteView.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/23.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFRegisterMinuteView : UIView

///  选择大小
@property (nonatomic, copy) void (^didClickSelectedXLBtnBlock) ();
///保存
@property (nonatomic, copy) void (^didClickSaveBtnBlock) (NSDictionary *dicMessage);
///  <#Description#>
@property (nonatomic,   copy) void(^didClickCannceBtnBlock) ();
/////<#name#>
//@property (strong, nonatomic)  RACSubject * seleceXLBtnRac;

///  身高 ---- 体重 ----- 胸围 ----- 腰围 ----- 臀围 ------ 尺码
//-(void)setHeight:(NSString  *)height andWeight:(NSString *)weight andThechest:(NSString *)thechest   andwaistline:(NSString *)waistline andHipline:(NSString *)hipline
//      andFootage:(NSString *)footage;
-(void)setHeight:(NSString *)height andWeight:(NSString *)weight andThechest:(NSString *)thechest  andWaistline:(NSString *)waistline andHipline:(NSString *)hipline andFootage:(NSString *)footage;


@end
