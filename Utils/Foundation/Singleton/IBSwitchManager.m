//
//  IBSwitchManager.m
//  JiePos
//
//  Created by iBlocker on 2017/8/28.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "IBSwitchManager.h"

static IBSwitchManager *__switchManager = nil;

@implementation IBSwitchManager
//实现方法,判断是否为空,是就创建一个全局实例给它
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __switchManager = [[IBSwitchManager alloc] init];
    });
    return __switchManager;
}

//避免alloc/new创建新的实例变量--->增加一个互斥锁
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    @synchronized(self) {
        if (__switchManager == nil) {
            __switchManager = [super allocWithZone:zone];
        }
    }
    return __switchManager;
}

//避免copy,需要实现NSCopying协议
- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

@end
