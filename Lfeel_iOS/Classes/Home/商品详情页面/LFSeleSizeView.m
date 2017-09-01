//
//  LFSeleSizeView.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/6.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFSeleSizeView.h"
@interface LFSeleSizeView ()
@property (weak, nonatomic) IBOutlet UIView *sizeBgView;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sizeViewConstraint;
@property (weak, nonatomic) IBOutlet UIView *ColorBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorViewConstraint;

@property (weak, nonatomic) IBOutlet UIView *addNumberBgView;

@property (weak, nonatomic) IBOutlet UIImageView *AbridgeImgUrl;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *inventoryLabel;


@property (weak, nonatomic) IBOutlet UILabel *colorLabel;

@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ColorConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SizeConstaint;
@property (weak, nonatomic) IBOutlet UITextField *numberTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end


@implementation LFSeleSizeView
{
    NSArray * array ;
    NSInteger Sizeindex ,colorIndex;
    LFGoodsDetailModel *model2;
    NSString * goodsParm,*goodsId,*colorID,*sizeString ,*countString;
    UIButton * clolorSelectBtn,*sizeSelectBtn;
    NSInteger  number;
    NSDictionary * dict1111;
    
    LFGoodsDetailColourList *_selectedColor;
    LFGoodsDetailColourList *_selectedSize;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    [self.contentView rm_fitAllConstraint];
    self.sizeLabel.hidden = NO;
    self.colorLabel.hidden = NO;
    number = 1;
    
  
 
 
}
- (IBAction)TapSumitBtn:(id)sender {
    SLLog2(@"确定");
      if (colorID.length == 0) {
        if (sizeString.length == 0) {
            SVShowError(@"请选择颜色或尺寸");
            return;
        }
    }
    
    
    if (model2.colourList.count > 0) {
        if (colorID.length == 0) {
            SVShowError(@"请选择颜色");
            return;
        }
    }
    if (model2.sizList.count > 0){
        if (sizeString.length == 0) {
            SVShowError(@"请选择尺寸");
            return;
        }
    }
    
    
    
    if ([self.numberTextLabel.text integerValue] > [countString integerValue]) {
        SVShowError(@"超出库存");
        return;
    }
 
    NSMutableString * attr = [NSMutableString new];
    if (_selectedColor) {
        [attr appendFormat:@"%@", _selectedColor.name];
    }
    if (_selectedSize) {
        [attr appendFormat:@"%@", _selectedSize.name];
    }

    dict1111 = @{
                 @"count":self.numberTextLabel.text,
                 @"goodsId":goodsId,
                 @"gsp": attr
                 };
    if (self.didTapSureBtn) {
       
        self.didTapSureBtn (dict1111);
    }
    
 
}
- (IBAction)TapSelectMinus:(id)sender {
    SLLog2(@"减小");
    if (number == 0) {
        self.minusBtn.hidden = YES;
    }else{
        number --;
        self.minusBtn.hidden = NO;
        self.numberTextLabel.text  = [NSString stringWithFormat:@"%zd",number];
    }
 
    
}
- (IBAction)TapSelectAddBtn:(id)sender {
    SLLog2(@"添加");
    
    if (number > 0) {
        self.minusBtn.hidden = NO;
        number ++;
        self.numberTextLabel.text  = [NSString stringWithFormat:@"%zd",number];
    }else{
        number ++;
        self.numberTextLabel.text  = [NSString stringWithFormat:@"%zd",number];
        self.minusBtn.hidden = NO;
        
    }
   
}

///选择颜色
-(void)_selectClassBtn:(UIButton * )button{
    SLLog2(@"buttonTag: %zd",button.tag);
    clolorSelectBtn.selected = NO;
    clolorSelectBtn.backgroundColor = [UIColor whiteColor];
    clolorSelectBtn.borderColor = HexColorInt32_t(D7D7D7);
    
    button.selected = YES;
    button.backgroundColor =HexColorInt32_t(C00D23);
    button.borderColor = [UIColor clearColor];
    
    clolorSelectBtn = button;
    
    LFGoodsDetailColourList * model3 = model2.colourList[button.tag - 10];
    colorID = model3.ID;
    _selectedColor = model3;
    
    if (colorID.length != 0) {
        if (sizeString.length != 0) {
            goodsParm = [NSString stringWithFormat:@"%@_%@_",colorID, sizeString];
        }else{
            goodsParm = [NSString stringWithFormat:@"%@_",colorID];
        }
    }else{
        if (sizeString.length != 0) {
            goodsParm = sizeString;
        }else{
            goodsParm = [NSString stringWithFormat:@"%@_",colorID];
        }
    }
    
    
    [self HTTPRequestshopping:goodsParm];

    
}
//选择尺寸
-(void)_selectSizeBtn:(UIButton *)sender{
    sizeSelectBtn.selected = NO;
    sizeSelectBtn.backgroundColor = [UIColor whiteColor];
    [sizeSelectBtn setTintColor:HexColorInt32_t(333333)];
    sizeSelectBtn.borderColor = HexColorInt32_t(D7D7D7);
    
    
    sender.selected = YES;
    
    sender.backgroundColor =HexColorInt32_t(C00D23);
    sender.borderColor = [UIColor clearColor];
    sizeSelectBtn = sender;
    LFGoodsDetailColourList * model3 = model2.sizList[sender.tag - 30];
    sizeString = model3.ID;
    _selectedSize = model3;
    
 
    if (sizeString.length != 0) {
        if (colorID.length != 0) {
            goodsParm = [NSString stringWithFormat:@"%@_%@_",colorID, model3.ID];
        }else{
            goodsParm = [NSString stringWithFormat:@"%@_",sizeString];
        }
    }else{
        if (colorID.length != 0) {
            goodsParm = [NSString stringWithFormat:@"%@_",colorID];
        }else{
            goodsParm = nil;
        }
    }
    
    [self HTTPRequestshopping:goodsParm];
    
}




-(void)HTTPRequestshopping:(NSString *)goodsParm1
{
    NSString * url = @"shoppingCart/goodsAttribute.htm?";
    LFParameter * param = [LFParameter new];
    
    param.goodsId = goodsId ;
    param.goodsParm = goodsParm;
    
    [TSNetworking POSTWithURL:url paramsModel:param completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"]integerValue] == 200 ) {
            [self setData:request[@"goodsInventoryDetailBean"]];
        }
    } failBlock:^(NSError *error) {
        
    }];
    
  
}


- (IBAction)TapSelectCloseBtn:(id)sender {
    SLLog2(@"关闭");
    if (self.didTapCloseBtn) {
        self.didTapCloseBtn();
    }
}



-(void)setModelData:(LFGoodsDetailModel *)model{

    
    model2 = model;
    
    goodsId = model2.goodsId;
    UIButton * lastButton = nil;
    for (NSInteger i  = 0; i< model.colourList.count; i++) {
        Sizeindex  = i;
        UIButton  * buttom = [UIButton buttonWithType:(UIButtonTypeCustom)];
        buttom.contentMode = UIViewContentModeScaleAspectFit;
        buttom.tag = 10+i;
        LFGoodsDetailColourList * model1 = model.colourList[i];
        [buttom setTitle:model1.name];
        if (model1.name.length > 4) {
            buttom.titleFont = Fit(11);
        } else {
            buttom.titleFont = Fit(12);
        }
        
        [buttom setTitleColor:HexColorInt32_t(333333)];
        
        buttom.borderColor = HexColorInt32_t(D7D7D7);
        buttom.borderWidth = 1;
        buttom.selectTitleColor = HexColorInt32_t(ffffff);
        
        [buttom addTarget:self action:@selector(_selectClassBtn:)];
        [self.ColorBgView addSubview:buttom];
        
        [buttom mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (lastButton) {
                if (i == 5) {
                    make.top.equalTo(lastButton.mas_bottom).offset(Fit375(8));
                    make.left.offset(Fit375(Fit375(10)));
                }else{
                    if (i > 5) {
                        make.top.equalTo(lastButton.mas_top).offset(Fit375(0));
                    }else{
                        make.top.offset(Fit375(7));
                    }
                    make.left.equalTo(lastButton.mas_right).offset(Fit375(10));
                }
            }else{
                make.top.offset(Fit375(7));
                make.left.offset(Fit375(10));
            }
            make.width.mas_equalTo((self.sizeBgView.width- Fit375(50))/4);
            make.height.mas_equalTo(Fit375(36));
            [buttom setNeedsLayout];
            [buttom setNeedsDisplay];
            
            
        }];
        lastButton = buttom;
    }
    
    
    
    

    if (model.sizList.count == 0) {
        [self.sizeViewConstraint setConstant:Fit375(0)];
    self.sizeLabel.hidden = YES;
    }else{
        self.sizeLabel.hidden = NO;
    }
    
    if (Sizeindex <=5) {
        [self.sizeViewConstraint setConstant:Fit375(50)];
    }else if(Sizeindex > 5){
        [self.sizeViewConstraint setConstant:Fit375(100)];
    }
    UIButton * lastButton1 = nil;
    for (NSInteger i  = 0; i< model.sizList.count; i++) {
        
        
        colorIndex  = i;
        UIButton  * buttom = [UIButton buttonWithType:(UIButtonTypeCustom)];
        buttom.contentMode = UIViewContentModeScaleAspectFit;
        buttom.tag = 30+i;
        LFGoodsDetailColourList * model1 = model.sizList[i];
        [buttom setTitle:model1.name];
        [buttom setTitleColor:HexColorInt32_t(333333)];
        
        buttom.borderColor = HexColorInt32_t(D7D7D7);
        buttom.borderWidth = 1;
        buttom.selectTitleColor = HexColorInt32_t(ffffff);
        buttom.titleFont = Fit(12);
        [buttom addTarget:self action:@selector(_selectSizeBtn:)];
        [self.sizeBgView addSubview:buttom];
        
        [buttom mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (lastButton1) {
                if (i == 5) {
                    make.top.equalTo(lastButton1.mas_bottom).offset(Fit375(8));
                    make.left.offset(Fit375(Fit375(10)));
                }else{
                    if (i > 5) {
                        make.top.equalTo(lastButton1.mas_top).offset(Fit375(0));
                    }else{
                        make.top.offset(Fit375(7));
                    }
                    make.left.equalTo(lastButton1.mas_right).offset(Fit375(10));
                }
            }else{
                make.top.offset(Fit375(7));
                make.left.offset(Fit375(10));
            }
            make.width.mas_equalTo((self.ColorBgView.width- Fit375(50))/4);
            make.height.mas_equalTo(Fit375(36));
            [buttom setNeedsLayout];
            [buttom setNeedsDisplay];
        }];
        lastButton1 = buttom;
    }
   if (model.colourList.count == 0) {
        [self.colorViewConstraint setConstant:Fit375(0)];
        self.colorLabel.hidden = YES;
   }else{
        self.colorLabel.hidden = NO;
   }
        if (colorIndex <=5) {
        [self.colorViewConstraint setConstant:Fit375(50)];
    }else if(colorIndex > 5){
        [self.colorViewConstraint setConstant:Fit375(100)];
    }
    [self.AbridgeImgUrl sd_setImageWithURL:[NSURL URLWithString:model.goodsAbridgeImgUrl]];
    self.inventoryLabel.text = [NSString stringWithFormat:@"库存%@件",model.inventory];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.store_price];
    countString = model.inventory;
    
}

-(void)setData:(NSDictionary *)dict1{

    
    
    countString = dict1[@"count"];
    
    self.inventoryLabel.text = [NSString stringWithFormat:@"库存%@件",dict1[@"count"]];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",dict1[@"price"]];
    
}


@end
