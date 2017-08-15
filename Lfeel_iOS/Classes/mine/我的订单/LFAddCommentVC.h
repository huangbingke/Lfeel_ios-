//
//  LFAddCommentVC.h
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "BaseViewController.h"
#import "LFBuyModels.h"

@interface LFAddCommentVC : BaseViewController
@property (nonatomic, strong) LFGoods * goods;
@property (nonatomic,   copy) NSString * order_id;
@end


@interface UIImage (_URL)
@property (nonatomic,   copy) NSString * urlString;
@end
