//
//  LFSelectPickViewSizeView.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/15.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFSelectPickViewSizeView.h"
@interface LFSelectPickViewSizeView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *pickViews;



@end


@implementation LFSelectPickViewSizeView
{
    NSArray * array;
    NSString * string,*string1,*string2;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    NSMutableArray * arr = @[].mutableCopy;
    for (int i = 50; i < 121; i++) {
        [arr addObject:[NSString stringWithFormat:@"%zd", i]];
    }
    array = arr.copy;
    
    UIPickerView * dataPack = [[UIPickerView alloc]initWithFrame:Rect(0, -10, self.pickViews.size.width,Fit375(150))];
    dataPack.delegate = self;
    dataPack.dataSource = self;
    [self.pickViews addSubview:dataPack];
    dataPack.backgroundColor = RGBColor(240, 241, 242);
  
    
    if (!USER.lfuserinfo.bust.integerValue || !USER.lfuserinfo.waist.integerValue || !USER.lfuserinfo.hipline.integerValue) {
        
//        [self pickerView:dataPack didSelectRow:0 inComponent:0];
//        [self pickerView:dataPack didSelectRow:0 inComponent:1];
//        [self pickerView:dataPack didSelectRow:0 inComponent:2];
//        [dataPack selectRow:[array indexOfObject:USER.lfuserinfo.bust] inComponent:0 animated:YES];
//        [dataPack selectRow:[USER.lfuserinfo.waist integerValue] inComponent:1 animated:YES];
//        [dataPack selectRow:[USER.lfuserinfo.hipline integerValue] inComponent:2 animated:YES];】
        
        NSString * first = [array firstObject];
        string = first;
        string1 = first;
        string2 = first;
    }else{
        
        NSInteger r1 = [array indexOfObject:USER.lfuserinfo.bust];
        NSInteger r2 = [array indexOfObject:USER.lfuserinfo.waist];
        NSInteger r3 = [array indexOfObject:USER.lfuserinfo.hipline];
        if (r1 == NSNotFound) r1 = 0;
        if (r2 == NSNotFound) r2 = 0;
        if (r3 == NSNotFound) r3 = 0;
        [self pickerView:dataPack didSelectRow:r1 inComponent:0];
        [self pickerView:dataPack didSelectRow:r2 inComponent:1];
        [self pickerView:dataPack didSelectRow:r3 inComponent:2];
        
        [dataPack selectRow:r1 inComponent:0 animated:YES];
        [dataPack selectRow:r2 inComponent:1 animated:YES];
        [dataPack selectRow:r3 inComponent:2 animated:YES];
        
        string = array[r1];
        string1 = array[r2];
        string2 = array[r3];
    }
    
    
    NSString * first = [array firstObject];
    string = first;
    string1 = first;
    string2 = first;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return array.count;
}

-(NSString * )pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return array[row];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = HexColorInt32_t(ffffff);
        }
    }
    //设置文字的属性
    UILabel *genderLabel = [UILabel new];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.text = array[row];
    genderLabel.textColor = HexColorInt32_t(333333);
    genderLabel.backgroundColor = HexColorInt32_t(fffffff);
    
    return genderLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
       string = [array objectAtIndex:row];
    }else if (component == 1){
        string1 = [array objectAtIndex:row];
    }else if (component == 2){
        string2 = [array objectAtIndex:row];
    }
    
}

- (IBAction)TapCloseBtn:(id)sender {
    if (self.didSelectCloseBtn) {
        self.didSelectCloseBtn();
    }
    
}

- (IBAction)TapSaveBtn:(id)sender {
    if (self.didSelectSaveBtn) {
        self.didSelectSaveBtn(string, string1,string2);
    }
    
}

@end
