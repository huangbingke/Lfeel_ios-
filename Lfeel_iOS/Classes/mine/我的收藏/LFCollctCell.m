//
//  LFCollctCell.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFCollctCell.h"
#import "MGSwipeButton.h"

@interface LFCollctCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imdegeUrl;
@property (weak, nonatomic) IBOutlet UILabel *goodName;

@end

@implementation LFCollctCell


-(void)awakeFromNib{
    [super awakeFromNib];
    [self.contentView rm_fitAllConstraint];
    
    
    
    MGSwipeButton * btn = [MGSwipeButton buttonWithTitle:@"删除"
                                                    icon:nil
                                         backgroundColor:[UIColor redColor]];
    btn.size = Size(Fit(60), Fit(74));
    self.rightButtons = @[btn];
}

-(void)setModel:(LFCollectioListModel *)model{
    _model = model;
    [self.imdegeUrl sd_setImageWithURL:[NSURL URLWithString:model.goodsUrl] placeholderImage:SLPlaceHolder];
    self.goodName.text = [NSString stringWithFormat:@"%@",model.goodsName];
    
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString * ID = @"LFCollctCell";
    LFCollctCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LFCollctCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
