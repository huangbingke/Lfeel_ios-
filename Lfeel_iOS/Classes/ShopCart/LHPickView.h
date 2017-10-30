//
//  LHPickView.h
//  LFeelAPP
//
//  Created by 黄冰珂 on 2017/7/10.
//  Copyright © 2017年 黄冰珂. All rights reserved.
//

@class LHPickView;

@protocol LHPickViewDelegate <NSObject>
@optional
- (void)toobarDonBtnHaveClick:(LHPickView *)pickView resultString:(NSString *)resultString resultIndex:(NSInteger) index;
@end

@interface LHPickView : UIView
@property (nonatomic,assign)    id<LHPickViewDelegate>  delegate;
@property (nonatomic,readonly)  UIDatePicker            *datePicker;//获取时间控件
@property (nonatomic,copy)      NSString                *title;//toolbar上的title
@property (nonatomic,strong)    UIColor                 *pickViewBGColor;//设置PickView的背景色
@property (nonatomic,strong)    UIColor                 *datePickerBGColor;//设置datePicker的背景色
@property (nonatomic,strong)    UIColor                 *toolbarBGColor;//设置toobar的背景颜色
@property (nonatomic,strong)    UIColor                 *toolbarTextColor;//设置toobar的文字颜色

/**
 *  通过plistName添加一个pickView
 *
 *  @param plistName          plist文件的名字
 
 *  @param isHaveNavControler 是否在NavControler之内
 *
 *  @return 带有toolbar的pickview
 */
- (instancetype)initPickviewWithPlistName:(NSString *)plistName isHaveNavControler:(BOOL)isHaveNavControler;

/**
 *  通过array添加一个pickView
 *
 *  @param array              需要显示的数组
 *  @param isHaveNavControler 是否在NavControler之内
 *
 *  @return 带有toolbar的pickview
 */
- (instancetype)initPickviewWithArray:(NSArray *)array isHaveNavControler:(BOOL)isHaveNavControler;
- (instancetype)initPickviewWithArray:(NSArray *)array isHaveNavControler:(BOOL)isHaveNavControler Block:(void (^)(LHPickView *pickView,NSString *resutStr,NSInteger index)) resutBlock;

/**
 *  通过时间创建一个DatePicker
 *
 *  @param defaulDate          默认选中时间
 *  @param isHaveNavControler  是否在NavControler之内
 *
 *  @return 带有toolbar的datePicker
 */
- (instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler;
- (instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler  Block:(void (^)(LHPickView *pickView,NSString *resutStr,NSInteger index)) resutBlock;

/**
 *   移除本控件
 */
- (void)remove;

/**
 *  显示本控件
 */
- (void)show;

/**
 *  设置PickView的背景色
 */
- (void)setPickViewBGColor:(UIColor *)pickViewBGColor;

/**
 *  设置datePicker的背景色
 */
- (void)setDatePickerBGColor:(UIColor *)datePickerBGColor;

/**
 *  设置toobar的文字颜色
 */
- (void)setToolbarTextColor:(UIColor *)toolbarTextColor;

/**
 *  设置toobar的背景颜色
 */
- (void)setToolbarBGColor:(UIColor *)toolbarBGColor;



@end











