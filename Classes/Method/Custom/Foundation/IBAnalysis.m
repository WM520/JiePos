//
//  IBAnalysis.m
//  JiePos
//
//  Created by iBlocker on 2017/9/5.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "IBAnalysis.h"

@implementation IBAnalysis
+ (id)analysisWithEncryptString:(NSString *)encryptString privateKey:(NSString *)privateKey {
    if (encryptString && [JPUserEntity sharedUserEntity].isLogin) {
        encryptString = [GBEncodeTool rsaDecryptString:encryptString privateKey:privateKey];
        
        NSData *jsonData = [encryptString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        
        if (jsonObject != nil && error == nil){
            return jsonObject;
        } else {
            // 解析错误
            return encryptString;
        }
    }
    return encryptString;
}
@end
