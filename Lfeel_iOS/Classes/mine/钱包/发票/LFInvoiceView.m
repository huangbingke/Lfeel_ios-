//
//  LFInvoiceView.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/4/16.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFInvoiceView.h"

@implementation LFInvoiceView {
    VoidBlcok _all;
    VoidBlcok _submit;
    __weak IBOutlet UIButton *_allBtn;
}
- (IBAction)_selectedAll:(id)sender {
    BLOCK_SAFE_RUN(_all);
}
- (IBAction)_submit:(id)sender {
    BLOCK_SAFE_RUN(_submit);
}
- (void)setSelectedAll:(VoidBlcok)all submit:(VoidBlcok)sub {
    _all = all;
    _submit = sub;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self rm_fitAllConstraint];
}
- (void)setSelected:(BOOL)selected {
    _selected = selected;
    _allBtn.selected = selected;
}
@end
