//
//  LFMineAddressFooterView.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFMineAddressFooterView.h"
@interface LFMineAddressFooterView()
@property (weak, nonatomic) IBOutlet UIView *contenView;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImage;

@end
@implementation LFMineAddressFooterView {
    VoidBlcok _default;
    VoidBlcok _edit;
    VoidBlcok _delete;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contenView rm_fitAllConstraint];
}
- (IBAction)_didClickDefaultBtn:(id)sender {
    BLOCK_SAFE_RUN(_default);
}

- (void)setAddress:(LFAddressModel *)address {
    _address = address;
    _defaultImage.highlighted = address.defaultStatus;
}
- (IBAction)_didClickDelete:(id)sender {
    BLOCK_SAFE_RUN(_delete);
}
- (IBAction)_didClickEdit:(id)sender {
    BLOCK_SAFE_RUN(_edit);
}

- (void)setDidDefaultBtnBlock:(VoidBlcok)defaultB editBlock:(VoidBlcok)edit deleteBlcok:(VoidBlcok)deleteB {
    _default = defaultB;
    _edit = edit;
    _delete = deleteB;
}

@end
