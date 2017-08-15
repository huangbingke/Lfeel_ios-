//
//  LFCardBagViewController.h
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/7/24.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "BaseViewController.h"
#import "LFCheapCardModel.h"

typedef void(^CardModelBlock)(LFCheapCardModel *model);

@interface LFCardBagViewController : BaseViewController





@property (nonatomic, copy) NSString *jumpId;


@property (nonatomic, copy) CardModelBlock cardBlock;

- (void)passCardModelBlock:(CardModelBlock)block;








@end
