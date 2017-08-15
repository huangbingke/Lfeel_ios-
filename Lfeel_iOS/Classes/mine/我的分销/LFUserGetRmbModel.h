//
//  LFUserGetRmbModel.h
//  Lfeel_iOS
//
//  Created by 黄冰珂 on 2017/7/12.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFUserGetRmbModel : NSObject

@property (nonatomic, copy) NSString *customersName;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *finishTime;



@end



@interface LFAgentGetRmbModel : NSObject

@property (nonatomic, copy) NSString *agentName;
@property (nonatomic, copy) NSString *agents_this_month;
@property (nonatomic, copy) NSString *agents_total_month;

@property (nonatomic, copy) NSString *user_id;


@end
@interface LFDetailRmbModel : NSObject

@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *finishTime;



@end
