//
//  LFMineAddressCell.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFMineAddressCell.h"
#import "TSAddressPickerView.h"

@implementation LFMineAddressCell {
    
    __weak IBOutlet UILabel *_detail;
    __weak IBOutlet UILabel *_phone;
    __weak IBOutlet UILabel *_name;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView rm_fitAllConstraint];
}

- (void)setAddress:(LFAddressModel *)address {
    _address = address;
    _name.text = address.contactName;
    _phone.text = address.contact;
    _detail.text = [NSString stringWithFormat:@"%@", address.address];
}

@end
