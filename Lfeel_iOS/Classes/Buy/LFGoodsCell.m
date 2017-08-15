//
//  LFGoodsCell.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/5.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFGoodsCell.h"
#import "LFBuyModels.h"

@implementation LFGoodsCell {
    
    __weak IBOutlet UIImageView *_pic;
    __weak IBOutlet UILabel *_name;
    __weak IBOutlet UILabel *_price;
    __weak IBOutlet UIButton *_collectBtn;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self rm_fitAllConstraint];
}
- (void)setGoods:(LFGoods *)goods {
    _goods = goods;
    
    [_pic sd_setImageWithURL:[NSURL URLWithString:goods.goodsUrl] placeholderImage:SLPlaceHolder];
    _name.text = goods.goodsName;
    if (self.needHiddenPrice) {
        _price.hidden = YES;
    } else {
        _price.hidden = NO;
        _price.text = [NSString stringWithFormat:@"乐荟价¥%@", goods.store_price.formatNumber];
        _price.font = kFont(12);
        
        
//        NSString *priStr = [NSString stringWithFormat:@"官网价¥%@", goods.sellingPrice.formatNumber];
//        NSMutableAttributedString *attributeMarket = [[NSMutableAttributedString alloc] initWithString:priStr];
//        [attributeMarket setAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,priStr.length)];
//        _marketPrice.attributedText = attributeMarket;
        
    }
}


- (IBAction)_didClickCollectBtn:(id)sender {
    BLOCK_SAFE_RUN(self.didClickCollectionBlock, self);
}












@end
