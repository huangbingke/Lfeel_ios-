//
//  LFUpdataCertificatView.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFUpdataCertificatView.h"

@interface LFUpdataCertificatView ()
///  <#Description#>
@property (nonatomic, strong) NSMutableArray * imageViews;
@property (weak, nonatomic) IBOutlet UIView *picView;

@end
@implementation LFUpdataCertificatView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self rm_fitAllConstraint];
}





@end
