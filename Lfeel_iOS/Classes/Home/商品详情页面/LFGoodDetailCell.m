//
//  LFGoodDetailCell.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/6.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFGoodDetailCell.h"
@interface LFGoodDetailCell ()


@property (weak, nonatomic) IBOutlet UIView *bgView;

@end


@implementation LFGoodDetailCell



-(void)awakeFromNib{
    [super awakeFromNib];
//    [self.bgView rm_fitAllConstraint];
}


//重新布局cell
- (void)adjustCellWithString:(NSString *)string {
    //改变contentLabel的frame
    CGRect labelFrame = self.detailTextView.frame;
    labelFrame.size.height = [LFGoodDetailCell labelHeightWithString:string];
    self.detailTextView.frame = labelFrame;
}

//重新计算label高度
+ (CGFloat)labelHeightWithString:(NSString *)string {
    //根据内容计算label的高度
    //注意: 字典的字体要和label的字体一致, 给定的尺寸宽度要和label的宽度一致
    CGRect rect = [string boundingRectWithSize:CGSizeMake(kScreenWidth - 2 * 10, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    NSLog(@"-------%fld", rect.size.height);
    return rect.size.height;
}

+ (CGFloat)cellHeightWithString:(NSString *)string {
    return [LFGoodDetailCell labelHeightWithString:string];
}


@end
