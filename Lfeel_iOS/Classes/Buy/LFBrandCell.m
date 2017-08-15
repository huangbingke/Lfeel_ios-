//
//  LFBrandCell.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 2017/6/30.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFBrandCell.h"
#import "LFBuyModels.h"

@implementation LFBrandCell {
    
    __weak IBOutlet UIImageView *_pic;
    __weak IBOutlet UILabel *_name;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self rm_fitAllConstraint];
}

- (void)setBrand:(LFBuyBrand *)brand {
    _brand = brand;
    [_pic sd_setImageWithURL:[NSURL URLWithString:brand.brandUrl] placeholderImage:SLPlaceHolder];
    _name.text = brand.brandName;
}

@end
