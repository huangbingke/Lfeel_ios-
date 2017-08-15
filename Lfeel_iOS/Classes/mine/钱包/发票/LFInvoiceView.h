//
//  LFInvoiceView.h
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/4/16.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFInvoiceView : UIView
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (nonatomic, assign, getter=isSelected) BOOL selected;
- (void)setSelectedAll:(VoidBlcok)all submit:(VoidBlcok)sub;

@end
