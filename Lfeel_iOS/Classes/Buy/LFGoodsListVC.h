//
//  LFGoodsListVC.h
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/5.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "BaseViewController.h"

@interface LFGoodsListVC : BaseViewController
///  1=类型搜索2=品牌搜索3=商品名字
@property (nonatomic,   copy) NSString * searchType;
@property (nonatomic,   copy) NSString * ID;
@end


@interface LFMenuButton : UIButton

@end
