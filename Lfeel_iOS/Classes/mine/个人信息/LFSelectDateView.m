//
//  LFSelectDateView.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/14.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFSelectDateView.h"
@interface LFSelectDateView ()
@property (weak, nonatomic) IBOutlet UIView *pickView;
@property (weak, nonatomic)  UIPickerView *pickView1;
@property (nonatomic,   weak) UIDatePicker * datePicker;
@end

@implementation LFSelectDateView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self rm_fitAllConstraint];
    UIDatePicker * datePack = [[UIDatePicker alloc]initWithFrame:Rect(0, -10, self.pickView.size.width,Fit375(150))];
    datePack. datePickerMode = UIDatePickerModeDate ;
    datePack. locale = [ NSLocale localeWithLocaleIdentifier : @"zh" ];
    datePack.maximumDate = [NSDate date];
    [self.pickView addSubview:datePack];
    self.datePicker = datePack;
    
    datePack.backgroundColor = RGBColor(240, 241, 242);
}
 
//- ( void )datePickerValueChanged:( UIDatePicker *)datePicker
//{
//    NSDateFormatter *formatter = [[ NSDateFormatter alloc ] init ];
//    // 格式化日期格式
//    formatter. dateFormat = @"yyyy-MM-dd" ;
//    NSString *date1 = [formatter stringFromDate :datePicker. date ];
//    date = date1;
//    if (!self.didSelectBithday) {
//        self.didSelectBithday(date1);
//    }
// }
- (IBAction)TapSaveBtn:(id)sender {
    
    NSDateFormatter *formatter = [[ NSDateFormatter alloc ] init ];
    formatter. dateFormat = @"yyyy-MM-dd" ;
    NSString *date1 = [formatter stringFromDate :self.datePicker.date];
    if (self.didTapSaveBtn) {
        self.didTapSaveBtn(date1);
    }
    
}

- (IBAction)TapSelectCloseBtn:(id)sender {
    if (self.didTapCloseBtn) {
        self.didTapCloseBtn();
    }
}

@end
