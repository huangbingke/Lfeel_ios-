//
//  LFBagHeader.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFBagHeader.h"
@interface LFBagHeader ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *intrerGralLabel;

@end

@implementation LFBagHeader

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.bgView rm_fitAllConstraint];
}

-(void)Setintegral:(NSString *)integral{
    
    if ([integral integerValue ]== 0) {
        
        self.intrerGralLabel.text = [NSString stringWithFormat:@"%@",integral] ;
    }else{
        
        self.intrerGralLabel.text = [NSString stringWithFormat:@"%@",integral.formatNumber];
    
    }
}

@end
