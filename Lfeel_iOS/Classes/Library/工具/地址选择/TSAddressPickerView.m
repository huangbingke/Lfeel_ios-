//
//  TSAddressPickerView.m
//  RunningMan
//
//  Created by Seven Lv on 16/1/16.
//  Copyright © 2016年 Toocms. All rights reserved.
//

#import "TSAddressPickerView.h"
#import "TSAddress.h"
#import "LFAddressModel.h"


#define kHeight  300

@interface TSAddressPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic,   weak) UIView * bgView;

@property (nonatomic,   weak) UIPickerView * pickerView;
@property (nonatomic, assign) NSInteger selectProvince;
@property (nonatomic, assign) NSInteger selectCity;
@property (nonatomic, strong) NSArray * array;
@end

@implementation TSAddressPickerView

+ (instancetype)addressPickerView {
    
    TSAddressPickerView * view = [[self alloc] initWithFrame:CGRectZero];
    [view show];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.selectCity = 0;
    self.selectProvince = 0;
    
    self.size = Size(kScreenWidth, kScreenHeight);
    
    UIView * bgView = [UIView viewWithBgColor:RGBColor2(0, 0, 0, 0.3) frame:[[UIScreen mainScreen] bounds]];
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    self.bgView = bgView;
    
    UIView * bg = [UIView viewWithBgColor:RGBColor(234, 234, 234) frame:Rect(0, kScreenHeight - kHeight, kScreenWidth, kHeight)];
    [bgView addSubview:bg];
    bg.tag = 10;
    
    UIColor * color = RGBColor(117, 81, 191);
    UIButton * cancel = [UIButton buttonWithTitle:@"取消" titleColor:color backgroundColor:nil font:16 image:nil frame:Rect(0, 0, 80, 40)];
    [cancel addTarget:self action:@selector(action:)];
    [bg addSubview:cancel];
    
    
    UIButton * sure = [UIButton buttonWithTitle:@"确定" titleColor:color backgroundColor:nil font:16 image:nil frame:Rect(0, 0, 80, 40)];
    sure.maxX = kScreenWidth;
    [sure addTarget:self action:@selector(action:)];
    [bg addSubview:sure];
    
    
    UIPickerView * pickerView = [[UIPickerView alloc] initWithFrame:Rect(0, 40, kScreenWidth, kHeight - 40)];
    pickerView.delegate = self;
    pickerView.backgroundColor = RGBColor(246, 246, 246);
    pickerView.dataSource = self;
    [bg addSubview:pickerView];
    self.pickerView = pickerView;
    [self show];
    [self addSubview:bgView];
    
    return self;
}
- (void)tap {
    
    UIView * bg = [self.bgView viewWithTag:10];
    [UIView animateWithDuration:0.25 animations:^{
        bg.y = kScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)show {
    
    self.bgView.hidden = NO;
    UIView * bg = [self.bgView viewWithTag:10];
    [UIView animateWithDuration:0.25 animations:^{
        bg.y = kScreenHeight - kHeight;
    }];
}

- (void)hidden {
    [self tap];
}


- (void)action:(UIButton *)btn {
    
    if ([btn.title isEqualToString:@"取消"]) {
        [self tap];
        return;
    }
    
    NSInteger p = [self.pickerView selectedRowInComponent:0];
    NSInteger c = [self.pickerView selectedRowInComponent:1];
    NSInteger d = [self.pickerView selectedRowInComponent:2];
    
    NSLog(@"%ld---%ld---%ld", p, c, d);
    if (p < self.array.count) {
        LFProvince * pro = self.array[p];
        if (c < pro.cityList.count) {
            LFCity * city = pro.cityList[c];
            if (d < city.regionList.count) {
                LFRegion * dis = city.regionList[d];
                LFProvince * pro1 = pro;
                LFCity * city1 = city;
                LFRegion * dis1 = dis;
                pro1.cityList = nil;
                city1.regionList = nil;
                NSDictionary * dict = @{@"province" : pro1,
                                        @"city"     : city1,
                                        @"district" : dis1};
                
                if (self.resultBlock) {
                    self.resultBlock(dict);
                    self.array = nil;
                }
            }
        }
    }
    [self tap];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.array.count;
    } else if (component == 1) {
        LFProvince * p = self.array[self.selectProvince];
        return p.cityList.count;
    }
    
    LFProvince * p = self.array[self.selectProvince];
    LFCity * city = p.cityList[self.selectCity];
    return city.regionList.count;

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        
        LFProvince * p = self.array[row];
        return p.provinceName;
        
    } else if (component == 1) {
        
        LFProvince * p = self.array[self.selectProvince];
        LFCity * city = p.cityList[row];
        return city.cityName;
        
    } else {
        
        LFProvince * p = self.array[self.selectProvince];
        LFCity * city = p.cityList[self.selectCity];
        LFRegion * d = city.regionList[row];
        return d.regionName;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        self.selectProvince = row;
        self.selectCity = 0;
    } else if (component == 1) {
        self.selectCity = row;
    }
    [pickerView reloadAllComponents];
    
    if (component == 0) {
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    } else if (component == 1) {
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
}
- (NSArray *)array {
    if (!_array) {
        NSArray * arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"address.plist" ofType:nil]];
        _array = [NSArray yy_modelArrayWithClass:[LFProvince class] json:arr];
        
    }
    return _array;
}

+ (NSString *)addressForCityId:(NSString *)ID {
    
    NSArray * arr = getAddressList();
    NSInteger i = ID.integerValue;
    for (LFProvince * province in arr) {
        for (LFCity * city in province.cityList) {
//            for (LFRegion *regin in city.regionList) {
//                if (i == city.cityId.integerValue) {
//                    return [NSString stringWithFormat:@"%@%@%@", province.provinceName, city.cityName, regin.regionName];
//                }
//            }
            if (i == city.cityId.integerValue) {
                
                return city.cityName;
                return [NSString stringWithFormat:@"%@%@", province.provinceName, city.cityName];
            }
        }
    }
    return @"";
}



@end
