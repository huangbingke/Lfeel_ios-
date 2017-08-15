//
//  LFMineAddressFooterView.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFMineAddressFooterView : UIView
@property (nonatomic, strong) LFAddressModel * address;

- (void)setDidDefaultBtnBlock:(VoidBlcok)defaultB
                    editBlock:(VoidBlcok)edit
                  deleteBlcok:(VoidBlcok)deleteB;
@end
