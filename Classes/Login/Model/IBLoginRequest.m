//
//  IBLoginRequest.m
//  JiePos
//
//  Created by iBlocker on 2017/8/29.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "IBLoginRequest.h"

@implementation IBLoginRequest
/**
 登录
 
 @param account 账号
 @param loginPwd 密码
 @param callback 回调
 */
+ (void)loginWithAccount:(NSString *)account
                loginPwd:(NSString *)loginPwd
                callback:(JPNetCallback)callback {
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:account forKey:@"account"];
    [dataDic setObject:[loginPwd MD5] forKey:@"loginPwd"];
    [dataDic setObject:[IBUUIDManager getUUID] forKey:@"serialNo"];
    NSString * regex = @"^(99[68])\\d{12}$";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    // 添加正则是否是商户号登录判断
    if ([predicate evaluateWithObject:account]) {
        [dataDic setObject:@"1" forKey:@"typeFlag"];
    } else {
        [dataDic setObject:@"2" forKey:@"typeFlag"];
    }
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    
//    NSString *data = [NSString stringWithFormat:@"{\"account\":\"%@\",\"loginPwd\":%@}",account , loginPwd];
    
    [self postWithServiceCode:@"JBB20" account:nil data:data callback:^(NSString *code, NSString *msg, id resp) {
        callback (code, msg, resp);
    }];
}

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
                  callback:(JPNetCallback)callback {
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    if (!isCashPass) {
        [dataDic setObject:account forKey:@"account"];
    }
    [dataDic setObject:phone forKey:@"phone"];
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    NSString *user = isCashPass ? account : nil;
    
    [self postWithServiceCode:@"JBB21" account:user data:data callback:^(NSString *code, NSString *msg, id resp) {
        callback (code, msg, resp);
    }];
}

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
                   callback:(JPNetCallback)callback {
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    if (!isCashPass) {
        [dataDic setObject:account forKey:@"account"];
    }
    [dataDic setObject:code forKey:@"code"];
    [dataDic setObject:phone forKey:@"phone"];
    
    //  pwdType 密码类型    1-登陆密码(默认值)，2-提现密码
    NSString *pwdType = isCashPass ? @"2" : @"1";
    [dataDic setObject:pwdType forKey:@"pwdType"];
    
    NSString *user = isCashPass ? account : nil;
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    
    [self postWithServiceCode:@"JBB22" account:user data:data callback:^(NSString *code, NSString *msg, id resp) {
        callback (code, msg, resp);
    }];
}

/**
 验证原提现密码
 
 @param account     账户
 @param oldPwd      原密码
 @param callback    回调
 */
+ (void)checkPayPswWithAccount:(NSString *)account
                        oldPwd:(NSString *)oldPwd
                      callback:(JPNetCallback)callback {
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:oldPwd forKey:@"oldPwd"];
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    
    [self postWithServiceCode:@"JBB15" account:account data:data callback:^(NSString *code, NSString *msg, id resp) {
        callback (code, msg, resp);
    }];
}

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
                    callback:(JPNetCallback)callback {
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:oldPwd forKey:@"oldPwd"];
    [dataDic setObject:newPwd forKey:@"newPwd"];
    
    //  pwdType 密码类型    1-登陆密码(默认值)，2-提现密码
    NSInteger pwdType = isCashPass ? 2 : 1;
    [dataDic setObject:@(pwdType) forKey:@"pwdType"];
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    
    [self postWithServiceCode:@"JBB23" account:account data:data callback:^(NSString *code, NSString *msg, id resp) {
        callback (code, msg, resp);
    }];
}
@end
