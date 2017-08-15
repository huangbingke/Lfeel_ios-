//
//  LFMoneyList.h
//  Lfeel_iOS
//
//  Created by kvi on 2017/2/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFMoneyList : UIView

///  <#Description#>
@property (nonatomic,   copy)void (^didClickSelectedText)() ;

///  <#Description#>
@property (nonatomic,   copy) NSString * starTimebag;
///  <#Description#>
@property (nonatomic,   copy) NSString * endtimeBag;

-(void)settitleLebelText:(NSString *)text;

@end
