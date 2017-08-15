//
//  LFSexView.m
//  Lfeel_iOS
//
//  Created by kvi on 2017/3/14.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFSexView.h"
@interface LFSexView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *womanSelct;
@property (weak, nonatomic) IBOutlet UIImageView *manSelect;

@end


@implementation LFSexView
{
    NSInteger selectSex;
}

-(void)awakeFromNib{

    [super awakeFromNib];
    [self.contentView rm_fitAllConstraint];
}

- (void)setSelectedSex:(NSString *)selectedSex {
    _selectedSex = [selectedSex copy];
    selectSex = [selectedSex integerValue];
    [self TapSelect];
}

- (IBAction)TapSelectSex:(id)sender {
    SLLog2(@"女");
    selectSex = 0;
    [self TapSelect];
    if (self.didTapSelectBtn) {
        self.didTapSelectBtn(selectSex);
    }
}
- (IBAction)TapSelectManBtn:(id)sender {
    SLLog2(@"男");
    selectSex = 1;
    [self TapSelect];
    if (self.didTapSelectBtn) {
        self.didTapSelectBtn(selectSex);
    }
    
}

- (IBAction)TapCloseBtn:(id)sender {
    if (self.didTapCloseBtn) {
        self.didTapCloseBtn();
    }
}




-(void)TapSelect{
    
    NSArray * array = @[@"椭圆-4",@"椭圆-4-拷贝-2"];
    
    if (selectSex == 0) {
        self.womanSelct.image = [UIImage imageNamed:array[0]];
        self.manSelect.image = [UIImage imageNamed:array[1]];
    }else{
        self.womanSelct.image = [UIImage imageNamed:array[1]];
        self.manSelect.image = [UIImage imageNamed:array[0]];
    }
}





 
@end
