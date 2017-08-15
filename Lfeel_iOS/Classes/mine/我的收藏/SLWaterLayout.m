//
//  SLWaterLayout.m
//  WaterLayout
//
//  Created by Seven Lv on 16/4/6.
//  Copyright © 2016年 Toocms. All rights reserved.
//


#import "SLWaterLayout.h"


@interface SLWaterLayout ()
@property (nonatomic, strong) NSMutableArray * attrs;
@property (nonatomic, strong) NSMutableArray * heights;
@end

@implementation SLWaterLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    [self.attrs removeAllObjects];
    [self.heights removeAllObjects];
    
    for (int i = 0; i < coloumsCount; i++) {
        [self.heights addObject:@(rowMargin)];
    }
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (int i = 0; i < count; i++) {
        UICollectionViewLayoutAttributes * attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attrs addObject:attr];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return self.attrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes * attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    CGFloat minHeight = MAXFLOAT;
    NSUInteger minRowIndex = 0;
    for (int i = 0; i < self.heights.count; i++) {
        CGFloat h = [self.heights[i] doubleValue];
        if (h < minHeight) {
            minHeight = h;
            minRowIndex = i;
        }
    }
    
    CGFloat screenW = CGRectGetWidth(self.collectionView.bounds);
    CGFloat w = (screenW - (coloumsCount + 1) * coloumsMargin) / coloumsCount;
    CGFloat x = minRowIndex * (w + coloumsMargin) + coloumsMargin;
    CGFloat y = minHeight + rowMargin;
    CGFloat h = self.heightBlock(indexPath.item, w);
    attr.frame = CGRectMake(x, y, w, h);
    
    self.heights[minRowIndex] = @(CGRectGetMaxY(attr.frame));
    
    return attr;
}

- (CGSize)collectionViewContentSize {
    CGFloat maxHeight = 0;
    for (int i = 0; i < self.heights.count; i++) {
        CGFloat h = [self.heights[i] doubleValue];
        if (h > maxHeight) {
            maxHeight = h;
        }
    }
    return CGSizeMake(0, maxHeight + coloumsMargin);
}

- (NSMutableArray *)attrs {
    if (!_attrs) {
        _attrs = [NSMutableArray array];
    }
    return _attrs;
}

- (NSMutableArray *)heights {
    if (!_heights) {
        _heights = [NSMutableArray array];
    }
    return _heights;
}
@end
