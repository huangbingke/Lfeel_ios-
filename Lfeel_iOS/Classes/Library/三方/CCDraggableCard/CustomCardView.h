//
//  CustomCardView.h
//  CCDraggableCard-Master
//
//  Created by jzzx on 16/7/9.
//  Copyright © 2016年 Zechen Liu. All rights reserved.
//

#import "CCDraggableCardView.h"

@interface CustomCardView : CCDraggableCardView

- (void)installData:(LFHothirevModel *)element;

///<#title#>
@property (copy, nonatomic)  LFHothirevModel *model;



///<#name#>
@property (strong, nonatomic) void (^TapSelectAddVipBtn)();


@end
