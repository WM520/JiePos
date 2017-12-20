//
//  JPPushManager.m
//  JiePos
//
//  Created by Jason_LJ on 2017/7/14.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPPushManager.h"

static JPPushManager *__pushManager = nil;

@implementation JPPushManager
//实现方法,判断是否为空,是就创建一个全局实例给它
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __pushManager = [[JPPushManager alloc] init];
    });
    return __pushManager;
}

//避免alloc/new创建新的实例变量--->增加一个互斥锁
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    @synchronized(self) {
        if (__pushManager == nil) {
            __pushManager = [super allocWithZone:zone];
        }
    }
    return __pushManager;
}

//避免copy,需要实现NSCopying协议
- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)makeIsBindAlias:(BOOL)isBindAlias {
    if (_isBindAlias != isBindAlias) {
        _isBindAlias = isBindAlias;
    }
}

- (void)makeIsBindService:(BOOL)isBindService {
    if (_isBindService != isBindService) {
        _isBindService = isBindService;
    }
}

@end
