//
//  IBNetworking.m
//  JiePos
//
//  Created by iBlocker on 2017/8/28.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "IBNetworking.h"

@implementation IBNetworking
//  POST
+ (void)postWithServiceCode:(NSString *)serviceCode
                    account:(NSString *)account
                       data:(NSString *)data
                   callback:(JPNetCallback)callback {
    
    NSMutableDictionary *parameters = @{}.mutableCopy;
    NSMutableDictionary *header = @{}.mutableCopy;
    NSMutableDictionary *body = @{}.mutableCopy;
    
    /** 服务编码*/
    [header setObject:serviceCode forKey:@"serviceCode"];
    /** 终端设备号*/
    [header setObject:[IBUUIDManager getUUID] forKey:@"serialNo"];
    /** 登陆账号*/
    if (account) {
        [header setObject:account forKey:@"account"];
    }
    if ([JPUserEntity sharedUserEntity].merchantNo) {
        [header setObject:[JPUserEntity sharedUserEntity].merchantNo forKey:@"merchantNo"];
    }
    
    NSString *random = [NSString random];
    /** 随机数*/
    [header setObject:random forKey:@"random"];
    /** 签名方式(1-MD5，2-RSA)*/
    [header setObject:@"2" forKey:@"signType"];
    /** 经过签名的业务参数*/
    if ([JPUserEntity sharedUserEntity].isLogin && ![serviceCode isEqualToString:@"JBB03"] && ![serviceCode isEqualToString:@"JBB04"] && ![serviceCode isEqualToString:@"JBB20"] && ![serviceCode isEqualToString:@"JBB05"] && ![serviceCode isEqualToString:@"JBB06"] && ![serviceCode isEqualToString:@"JBB10"] && ![serviceCode isEqualToString:@"JBB21"] && ![serviceCode isEqualToString:@"JBB22"]) {
        //  RSA加密
        [body setObject:[GBEncodeTool rsaEncryptString:data publicKey:[JPUserEntity sharedUserEntity].publicKey] forKey:@"data"];
    } else {
        [body setObject:data forKey:@"data"];
    }    
    [parameters setObject:header forKey:@"header"];
    [parameters setObject:body forKey:@"body"];
    
    JPLog(@"data - %@, parameters - %@", data, parameters);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 8;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    JPLog(@"%@", JPNewServerUrl);
    [manager POST:JPNewServerUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        JPLog(@"%@", responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resp = (NSDictionary *)responseObject;
            NSArray *keys = resp.allKeys;
            if ([keys containsObject:@"header"]) {
                if ([resp[@"header"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *headerDic = resp[@"header"];
                    NSArray *headerKeys = headerDic.allKeys;
                    if ([keys containsObject:@"body"] && [headerKeys containsObject:@"responseCode"] && [headerKeys containsObject:@"responseMsg"] && [headerKeys containsObject:@"random"]) {
                        
                        if ([random isEqualToString:headerDic[@"random"]]) {
                            if ([headerDic[@"responseCode"] isEqualToString:@"00"]) {
                                
                                callback (@"0", headerDic[@"responseMsg"], resp[@"body"][@"data"]);
                            } else if ([headerDic[@"responseCode"] isEqualToString:@"05"]) {
                                //  账号已在其他设备
                                [IBProgressHUD dismiss];
                                [[NSNotificationCenter defaultCenter] postNotificationName:kCFDownLineNotification object:headerDic[@"responseMsg"]];
                            } else if ([headerDic[@"responseCode"] isEqualToString:@"46"]) {
                                //  商户状态发生改变
                                [IBProgressHUD dismiss];
                                [[NSNotificationCenter defaultCenter] postNotificationName:kCFDownLineNotification object:headerDic[@"responseMsg"]];
                            } else {
                                callback (@"-1", headerDic[@"responseMsg"], nil);
                            }
                        } else {
                            callback (@"-2", @"非法数据异常", nil);
                        }
                        return;
                    }
                }
                callback (@"-1", @"网络异常，请稍后再试", nil);
            } else {
                callback (responseObject[@"status"], responseObject[@"msg"], nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *code = [NSString stringWithFormat:@"%ld", (long)error.code];
        if (callback) {
            if ([code isEqualToString:@"-1001"]) {
                callback (@"-1001", @"网络超时", nil);
            } else {
                callback (@"-1", @"网络异常，请稍后再试", nil);
            }
        }
    }];
}

@end
