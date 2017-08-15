//
//  LFHeaderView.m
//  Lfeel_iOS
//
//  Created by 陈泓羽 on 17/3/21.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFHeaderView.h"
#import "TSAddressPickerView.h"
@interface LFHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbael;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;

@end


@implementation LFHeaderView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self rm_fitAllConstraint];
}


- (IBAction)TapSelectBtn:(id)sender {
    if (self.didSelectAddressBtn) {
        self.didSelectAddressBtn();
    }
}

-(void)addressData:(LFAddressModel *)model{
    self.nameLabel.text = model.contactName;
    self.phoneLbael.text = model.contact;
    self.cityLabel.text = [NSString stringWithFormat:@"%@", [TSAddressPickerView addressForCityId:model.cityId]];;
    self.detailAddressLabel.text = model.address;
    self.placeholder.hidden = YES;
}


@end
