//
//  IBVersionRequest.m
//  JiePos
//
//  Created by iBlocker on 2017/8/29.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "IBVersionRequest.h"

@implementation IBVersionRequest
/**
 检测App版本

 @param appCode APP编码   jbb,fym
 @param platform 操作平台   android,ios
 @param callback 回调
 */
+ (void)checkVersionWithAppCode:(NSString *)appCode
                       platform:(NSString *)platform
                       callback:(JPNetCallback)callback {
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:appCode forKey:@"appCode"];
    [dataDic setObject:platform forKey:@"platform"];
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    
    [self postWithServiceCode:@"JBB25" account:nil data:data callback:^(NSString *code, NSString *msg, id resp) {
        callback (code, msg, resp);
    }];
}
@end
