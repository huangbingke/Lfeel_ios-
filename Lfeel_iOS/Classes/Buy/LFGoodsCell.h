//
//  LFGoodsCell.h
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/5.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LFGoods;
@interface LFGoodsCell : UICollectionViewCell
@property (nonatomic, strong) LFGoods * goods;
///  点击收藏
@property (nonatomic,   copy) void (^didClickCollectionBlock)(LFGoodsCell * cell);
///  是否需要显示价格
@property (nonatomic, assign) BOOL needHiddenPrice;
@property (weak, nonatomic) IBOutlet UILabel *marketPrice;
@end
