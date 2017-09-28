//
//  LFLeiBaiPayView.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/5/1.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFLeiBaiPayView.h"
#import "YZMenuButton.h"
#import "LFBuyModels.h"

@interface LFLeiBaiPayView ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic,   weak) UIView * bgView;

@property (nonatomic,   weak) UIPickerView * pickerView;
@property (nonatomic, strong) NSArray * titles;
@end

@implementation LFLeiBaiPayView {
    
    /// 金额
    __weak IBOutlet UILabel *_amount;
    /// 分期期数
    __weak IBOutlet UILabel *_stagesCount;
    /// 分期view
    __weak IBOutlet UIView *_stagesView;
    
    /// 每期
    __weak IBOutlet UILabel *_everyMoney;
    // 手续费
    __weak IBOutlet UILabel *_handlingCharge;
    // 第一次
    __weak IBOutlet UILabel *_firstMoney;
    /// 往后每期
    __weak IBOutlet UILabel *_otherEveryMoney;
    /// 总金额
    __weak IBOutlet UILabel *_totalMoney;
    
    __weak IBOutlet UILabel *_protocal;

    void(^_sta)(NSInteger index) ;
    VoidBlcok _proBlock;
    VoidBlcok _nextBlock;
}
- (IBAction)_next:(id)sender {
    BLOCK_SAFE_RUN(_nextBlock);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self rm_fitAllConstraint];
    
    UITapGestureRecognizer * tap1 = [UITapGestureRecognizer new];
    @weakify(self);
    [tap1.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        [self _setupPickerView];
    }];
    [_stagesView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer * tap2 = [UITapGestureRecognizer new];
    [tap2.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        BLOCK_SAFE_RUN(self->_proBlock);
        
    }];
    _protocal.userInteractionEnabled = YES;
    [_protocal addGestureRecognizer:tap2];
    
    _selectedStage = 6;
    _stagesCount.text = self.titles[0];
}

- (void)_setupPickerView {
    UIView * bgView = [UIView viewWithBgColor:RGBColor2(0, 0, 0, 0.3) frame:[[UIScreen mainScreen] bounds]];
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    _bgView = bgView;
    
    UIView * bg = [UIView viewWithBgColor:RGBColor(234, 234, 234) frame:Rect(0, kScreenHeight, kScreenWidth, 200)];
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
    
    
    UIPickerView * pickerView = [[UIPickerView alloc] initWithFrame:Rect(0, 40, kScreenWidth, 200 - 40)];
    pickerView.delegate = self;
    pickerView.backgroundColor = RGBColor(246, 246, 246);
    pickerView.dataSource = self;
    [bg addSubview:pickerView];
    self.pickerView = pickerView;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    [self show];
}
- (void)tap {
    
    UIView * bg = [self.bgView viewWithTag:10];
    [UIView animateWithDuration:0.25 animations:^{
        bg.y = kScreenHeight;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
    }];
}
- (void)show {
    
    UIView * bg = [self.bgView viewWithTag:10];
    [UIView animateWithDuration:0.25 animations:^{
        bg.y = kScreenHeight - 200;
    }];
}
- (void)action:(UIButton *)btn {
    
    if ([btn.title isEqualToString:@"取消"]) {
        [self tap];
        return;
    }
    
    NSInteger i = [self.pickerView selectedRowInComponent:0];
    NSString * s = [self.titles[i] stringByReplacingOccurrencesOfString:@"期" withString:@""];
    NSInteger index = [s integerValue];
    _selectedStage = index;
    _stagesCount.text = self.titles[i];
    self.price = self.price;
    [self tap];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.titles.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.titles[row];
}

- (void)setProtocalBlock:(VoidBlcok)pro nextBlock:(VoidBlcok)next {
    _proBlock = pro;
    _nextBlock = next;
}

- (void)setPrice:(NSString *)price {
    _price = [price copy];
    double priceDouble = price.doubleValue / 100.0;
    _amount.text = [NSString stringWithFormat:@"￥%.2f", priceDouble];
    
    _totalMoney.text = [_amount.text substringFromIndex:1];
    double every = priceDouble / _selectedStage;
    NSString * p = stringWithDouble(every);
    _everyMoney.text = p;
    _firstMoney.text = p;
    _otherEveryMoney.text = p;
}

- (NSArray *)titles {
    if (!_titles) {
        NSMutableArray * arr = @[].mutableCopy;
        for (int i = 1; i < 3; i++) {
            [arr addObject:[NSString stringWithFormat:@"%zd期", i * 6]];
        }
        _titles = arr.copy;
    }
    return _titles;
}

@end

#pragma mark -----------------------------------------------------------------------------------------------------------------------

@implementation LFLeiBaiPayView2 {
    
    __weak IBOutlet UILabel *_placeHolder;
    VoidBlcok _send;
    VoidBlcok _sure;
}

+ (instancetype)creatView {
    return [self creatViewFromNibName:@"LFLeiBaiPayView" atIndex:1];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self rm_fitAllConstraint];
    
    @weakify(self);
    [_remark.rac_textSignal subscribeNext:^(NSString * x) {
        @strongify(self);
        self->_placeHolder.hidden = x.length > 0;
    }];
}

- (IBAction)_sure:(id)sender {
//    SLAssert(_name.hasText, @"请填写持卡人姓名");
//    SLAssert(_identifyCardID.hasText, @"请填写持卡人身份证号");
//    SLAssert(_cardNum.hasText, @"请填写信用卡卡号");
//    SLAssert(_month.hasText, @"请填写月份");
//    SLAssert(_year.hasText, @"请填写年份");
//    SLAssert(_cnv2.hasText, @"请输入卡背面最后三位数字");
//    SLAssert(_phone.hasText, @"请输入预留手机号码");
//    SLAssert(_phone.text.validateMobile, @"手机号码格式不正确")
//    SLAssert(_verify.hasText, @"请输入验证码");
    BLOCK_SAFE_RUN(_sure);
}

- (IBAction)_didClickSendVerify:(id)sender {
//    SLAssert(_phone.hasText, @"请输入预留手机号码");
//    SLAssert(_phone.text.validateMobile, @"手机号码格式不正确")
    BLOCK_SAFE_RUN(_send);
}

- (void)setDidSendVerifyBlock:(VoidBlcok)send sureBlock:(VoidBlcok)sure {
    _send = send; _sure = sure;
}



@end


#pragma mark -----------------------------------------------------------------------------------------------------------------------


@interface LFLeiBaiPayView3 ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic,   weak) UIView * bgView;
@property (nonatomic,   weak) UIPickerView * pickerView;
@property (nonatomic, strong) NSArray * titles;
@end

@implementation LFLeiBaiPayView3 {
    
    __weak IBOutlet UILabel *_placeHolder;
    VoidBlcok _send;
    VoidBlcok _sure;
    VoidBlcok _add;
}

+ (instancetype)creatView {
    return [self creatViewFromNibName:@"LFLeiBaiPayView" atIndex:2];
}

- (IBAction)_selectCard:(id)sender {
    [self _setupPickerView];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self rm_fitAllConstraint];
    
    @weakify(self);
    [_remark.rac_textSignal subscribeNext:^(NSString * x) {
        @strongify(self);
        self->_placeHolder.hidden = x.length > 0;
    }];
}
- (IBAction)_addNewCard:(id)sender {
    BLOCK_SAFE_RUN(_add);
}

- (IBAction)_sure:(id)sender {
    
//    SLAssert(_month.hasText, @"请填写月份");
//    SLAssert(_year.hasText, @"请填写年份");
//    SLAssert(_cnv2.hasText, @"请输入卡背面最后三位数字");
//    SLAssert(_phone.hasText, @"请输入预留手机号码");
//    SLAssert(_phone.text.validateMobile, @"手机号码格式不正确")
//    SLAssert(_verify.hasText, @"请输入验证码");
    BLOCK_SAFE_RUN(_sure);
}

- (IBAction)_didClickSendVerify:(id)sender {
//    SLAssert(_phone.hasText, @"请输入预留手机号码");
//    SLAssert(_phone.text.validateMobile, @"手机号码格式不正确")
    BLOCK_SAFE_RUN(_send);
}

- (void)setDidSendVerifyBlock:(VoidBlcok)send sureBlock:(VoidBlcok)sure addNewCardBlock:(VoidBlcok)add {
    _send = send; _sure = sure; _add = add;
}

- (void)setBankCardList:(NSArray<LFCardInfo *> *)bankCardList {
    _bankCardList = bankCardList;
    LFCardInfo * info = [bankCardList firstObject];
    _cardBtn.title = [NSString stringWithFormat:@"%@", info.bankName];
    _selectedCard = info;
}

- (void)_setupPickerView {
    UIView * bgView = [UIView viewWithBgColor:RGBColor2(0, 0, 0, 0.3) frame:[[UIScreen mainScreen] bounds]];
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    _bgView = bgView;
    
    UIView * bg = [UIView viewWithBgColor:RGBColor(234, 234, 234) frame:Rect(0, kScreenHeight, kScreenWidth, 200)];
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
    
    
    UIPickerView * pickerView = [[UIPickerView alloc] initWithFrame:Rect(0, 40, kScreenWidth, 200 - 40)];
    pickerView.delegate = self;
    pickerView.backgroundColor = RGBColor(246, 246, 246);
    pickerView.dataSource = self;
    [bg addSubview:pickerView];
    self.pickerView = pickerView;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    [self show];
}
- (void)tap {
    
    UIView * bg = [self.bgView viewWithTag:10];
    [UIView animateWithDuration:0.25 animations:^{
        bg.y = kScreenHeight;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
    }];
}
- (void)show {
    
    UIView * bg = [self.bgView viewWithTag:10];
    [UIView animateWithDuration:0.25 animations:^{
        bg.y = kScreenHeight - 200;
    }];
}
- (void)action:(UIButton *)btn {
    
    if ([btn.title isEqualToString:@"取消"]) {
        [self tap];
        return;
    }
    
    NSInteger i = [self.pickerView selectedRowInComponent:0];
    _selectedCard = self.bankCardList[i];
    _cardBtn.title = self.titles[i];
    [self tap];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.titles.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.titles[row];
}

- (NSArray *)titles {
    if (!_titles) {
        NSMutableArray * arr = @[].mutableCopy;
        for (LFCardInfo * info in self.bankCardList) {
            [arr addObject:[NSString stringWithFormat:@"%@", info.bankName]];
        }
        _titles = [arr copy];
    }
    return _titles;
}

@end

