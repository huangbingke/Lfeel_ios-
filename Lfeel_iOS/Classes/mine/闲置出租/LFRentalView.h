//
//  LFRentalView.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/28.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFRentalView : UIView
///  <#Description#>
@property (nonatomic, strong) LFRecordListModel *model;

//@property (nonatomic, strong) NSDictionary *dict;

-(void)setDictData:(NSDictionary *)dict;
@end
