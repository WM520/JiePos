//
//  JPTool.m
//  JiePos
//
//  Created by iBlocker on 2017/8/17.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPTool.h"

static NSString *const weixin = @"weixin://";

@implementation JPTool
//字典转json格式字符串：
+ (NSString *)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//json格式字符串转字典：
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        JPLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (BOOL)canOpenWeixin {    
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:weixin]];
}

+ (void)openWeixin {
    
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:weixin]];
    if(canOpen) {
        //打开微信
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weixin]];
    } else {
        [IBProgressHUD showInfoWithStatus:@"您还没有安装微信！"];
    }
}
@end
