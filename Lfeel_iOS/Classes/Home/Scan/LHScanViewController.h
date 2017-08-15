//
//  LHScanViewController.h
//  LFeelAPP
//
//  Created by 黄冰珂 on 2017/7/18.
//  Copyright © 2017年 黄冰珂. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^InvoteCodeBlock)(NSString *invoteCode);

@interface LHScanViewController : BaseViewController


@property (nonatomic, copy) InvoteCodeBlock codeBlock;


- (void)invoteCodeBlock:(InvoteCodeBlock)block;


@property (nonatomic, copy) NSString *idString;//判断是哪个页面跳转过来的

@end
