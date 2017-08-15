//
//  LFParameter.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/2/26.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFParameter.h"

@implementation LFParameter

- (instancetype)init {
    if (self = [super init]) {
        _phoneMark = [User getDeviceId];
        if (user_is_login) {
            _loginKey = user_loginKey;
        }
    }
    return self;
}

- (void)appendBaseParam {
    
    _phoneMark = [User getDeviceId];
    if (user_is_login) {
        _loginKey = user_loginKey;
    }
}
@end
