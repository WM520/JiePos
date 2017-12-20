//
//  JPUserEntity.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/14.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPUserEntity.h"

static JPUserEntity *__userEntity = nil;

@implementation JPUserEntity
//实现方法,判断是否为空,是就创建一个全局实例给它
+ (JPUserEntity *)sharedUserEntity {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __userEntity = [[JPUserEntity alloc] init];
    });
    return __userEntity;
}

//避免alloc/new创建新的实例变量--->增加一个互斥锁
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    @synchronized(self) {
        if (__userEntity == nil) {
            __userEntity = [super allocWithZone:zone];
        }
    }
    return __userEntity;
}

//避免copy,需要实现NSCopying协议
- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)setIsLogin:(BOOL)isLogin
           account:(NSString *)account
        merchantNo:(NSString *)merchantNo
        merchantId:(NSInteger)merchantId
      merchantName:(NSString *)merchantName
         applyType:(NSInteger)applyType
        privateKey:(NSString *)privateKey
         publicKey:(NSString *)publicKey {
        
    if (_isLogin != isLogin) {
        _isLogin = isLogin;
    }
    if (_account != account) {
        _account = [account copy];
    }
    if (_merchantNo != merchantNo) {
        _merchantNo = [merchantNo copy];
    }
    if (_merchantId != merchantId) {
        _merchantId = merchantId;
    }
    if (_merchantName != merchantName) {
        _merchantName = [merchantName copy];
    }
    if (_applyType != applyType) {
        _applyType = applyType;
    }
    if (_privateKey != privateKey) {
        _privateKey = [privateKey copy];
    }
    if (_publicKey != publicKey) {
        _publicKey = [publicKey copy];
    }
}

@end
