//
//  LFTwoHeaderView.m
//  Lfeel_iOS
//
//  Created by 陈泓羽 on 17/3/21.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFTwoHeaderView.h"
#import "TZImagePickerController.h"
@interface LFTwoHeaderView ()<TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
///  <#Description#>
@property (nonatomic, strong) NSMutableArray * photos;

@end
@implementation LFTwoHeaderView
{
    NSInteger maxCount;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.photos = [NSMutableArray   array];
    maxCount = 3;
    
    
    [self.bgView rm_fitAllConstraint];
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount - self.photos.count delegate:self];
    
    
    
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        [self.photos addObjectsFromArray:photos];
//        [self handleImages];
    }];
    
//    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}


@end
