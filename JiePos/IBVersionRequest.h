//
//  IBVersionRequest.h
//  JiePos
//
//  Created by iBlocker on 2017/8/29.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "IBNetworking.h"

@interface IBVersionRequest : IBNetworking
/**
 检测App版本
 
 @param appCode APP编码   jbb,fym
 @param platform 操作平台   android,ios
 @param callback 回调
 */
+ (void)checkVersionWithAppCode:(NSString *)appCode
                       platform:(NSString *)platform
                       callback:(JPNetCallback)callback;
@end

