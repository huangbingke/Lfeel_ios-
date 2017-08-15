//
//  LFEmptyView.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/4/12.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFEmptyView.h"

@implementation LFEmptyView

{
    UIImageView * imgView;
    UILabel * titleLabel;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        imgView = [[UIImageView alloc]init];
        imgView.contentMode = UIViewContentModeScaleToFill;
        imgView.image = [UIImage imageNamed:@"空盒子"];
        
        [self addSubview:imgView];
        
        titleLabel = [[UILabel alloc]init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = HexColor(@"c2c2c2");
        
        [imgView addSubview:titleLabel];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.top.and.bottom.offset(0);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.offset(0);
            make.centerY.offset(40);
            make.height.mas_equalTo(20);
        }];
        [titleLabel layoutIfNeeded];
    }
    return self;
}
-(void)setTitleLabelText:(NSString *)labeltext{
    titleLabel.text = nil;
    titleLabel.text = labeltext;
    CGFloat titleHei = [titleLabel intrinsicContentSize].height;
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(titleHei);
    }];
}


@end
