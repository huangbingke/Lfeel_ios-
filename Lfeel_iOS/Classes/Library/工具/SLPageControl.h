//
//  SLPageControl.h
//  RunningMan
//
//  Created by Seven Lv on 16/1/15.
//  Copyright © 2016年 Toocms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLPageControl : UIView

@property(nonatomic) NSInteger currentPage;

+ (nonnull instancetype)pageControlWithNumber:(NSInteger)count
                                    imageName:(nonnull NSString *)name
                             currentImageName:(nonnull NSString *)current
                                        frame:(CGRect)frame;

@end
