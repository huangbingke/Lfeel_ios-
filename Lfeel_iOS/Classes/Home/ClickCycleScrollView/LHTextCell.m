//
//  LHTextCell.m
//  LFeelAPP
//
//  Created by 黄冰珂 on 2017/6/16.
//  Copyright © 2017年 黄冰珂. All rights reserved.
//
#define kFont(size)  [UIFont systemFontOfSize:size]
#define kRatio kScreenWidth/375

#import "LHTextCell.h"

@implementation LHTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void)setUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(10, 10, kScreenWidth-20, 25);
    self.titleLabel.textColor = [UIColor redColor];
    [self addSubview:_titleLabel];
    _titleLabel.font = kFont(15*kRatio);
    _titleLabel.numberOfLines = 0;

    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = kFont(14*kRatio);
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+10, kScreenWidth-20, 20);
    [self addSubview:self.contentLabel];

}


//重新布局cell
- (void)adjustCellWithString:(NSString *)string {
    //改变contentLabel的frame
    CGRect labelFrame = self.contentLabel.frame;
    labelFrame.size.height = [LHTextCell labelHeightWithString:string];
    self.contentLabel.frame = labelFrame;
}

//重新计算label高度
+ (CGFloat)labelHeightWithString:(NSString *)string {
    //根据内容计算label的高度
    //注意: 字典的字体要和label的字体一致, 给定的尺寸宽度要和label的宽度一致
    CGRect rect = [string boundingRectWithSize:CGSizeMake(kScreenWidth - 2 * 10, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14*kRatio]} context:nil];
    return rect.size.height;
}

+ (CGFloat)cellHeightWithString:(NSString *)string {
    return 55 + [LHTextCell labelHeightWithString:string];
}















@end
