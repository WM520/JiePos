//
//  JPUserEntity.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/14.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

//  用户实体
@interface JPUserEntity : NSObject
/** 是否已登录*/
@property (nonatomic, assign, readonly) BOOL isLogin;
/** 账号*/
@property (nonatomic, copy, readonly) NSString *account;
/** 商户号*/
@property (nonatomic, copy, readonly) NSString *merchantNo;
/** 商户ID*/
@property (nonatomic, assign, readonly) NSInteger merchantId;
/** 商户名称*/
@property (nonatomic, copy, readonly) NSString *merchantName;
/** 商户类型：1 K9商户    2 一码付商户 */
@property (nonatomic, assign, readonly) NSUInteger applyType;
/** 私钥*/
@property (nonatomic, copy, readonly) NSString *privateKey;
/** 公钥*/
@property (nonatomic, copy, readonly) NSString *publicKey;

@property (nonatomic, copy, readonly) NSString * userId;

//  单例方法
+ (JPUserEntity *)sharedUserEntity;

/**
 商户实体类属性赋值

 @param isLogin 登录状态
 @param account 账号
 @param merchantNo 商户号
 @param merchantId 商户ID
 @param merchantName 商户名称
 @param applyType 商户类型：1 K9商户    2 一码付商户
 @param privateKey 私钥
 @param publicKey 公钥
 */
- (void)setIsLogin:(BOOL)isLogin
           account:(NSString *)account
        merchantNo:(NSString *)merchantNo
        merchantId:(NSInteger)merchantId
      merchantName:(NSString *)merchantName
         applyType:(NSInteger)applyType
        privateKey:(NSString *)privateKey
         publicKey:(NSString *)publicKey
            userId:(NSString *)userId;
@end
