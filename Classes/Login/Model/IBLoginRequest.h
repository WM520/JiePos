//
//  IBLoginRequest.h
//  JiePos
//
//  Created by iBlocker on 2017/8/29.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "IBNetworking.h"

@interface IBLoginRequest : IBNetworking
/**
 登录

 @param account 账号
 @param loginPwd 密码
 @param callback 回调
 */
+ (void)loginWithAccount:(NSString *)account
                loginPwd:(NSString *)loginPwd
                callback:(JPNetCallback)callback;
/**
 获取验证码
 
 @param account 账号
 @param phone 手机号  注册商户时预留手机号码
 @param isCashPass 是否是提现密码
 @param callback 回调
 */
+ (void)getCodeWithAccount:(NSString *)account
                     phone:(NSString *)phone
                isCashPass:(BOOL)isCashPass
                  callback:(JPNetCallback)callback;

/**
 重置登录或提现密码
 
 @param account 登录账号
 @param code 验证码
 @param phone 手机号码
 @param isCashPass 是否是提现密码
 @param callback 回调
 */
+ (void)resetPswWithAccount:(NSString *)account
                       code:(NSString *)code
                      phone:(NSString *)phone
                 isCashPass:(BOOL)isCashPass
                   callback:(JPNetCallback)callback;


/**
 验证原提现密码

 @param account     账户
 @param oldPwd      原密码
 @param callback    回调
 */
+ (void)checkPayPswWithAccount:(NSString *)account
                        oldPwd:(NSString *)oldPwd
                      callback:(JPNetCallback)callback;

/**
 修改登录或提现密码
 
 @param account 登录账号
 @param oldPwd 原密码
 @param newPwd 新密码
 @param isCashPass 是否是提现密码
 @param callback 回调
 */
+ (void)modifyPswWithAccount:(NSString *)account
                      oldPwd:(NSString *)oldPwd
                      newPwd:(NSString *)newPwd
                  isCashPass:(BOOL)isCashPass
                    callback:(JPNetCallback)callback;
@end
