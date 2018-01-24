//
//  JPTool.h
//  JiePos
//
//  Created by iBlocker on 2017/8/17.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPTool : NSObject
//字典转json格式字符串：
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;
//json格式字符串转字典：
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (BOOL)canOpenWeixin;
+ (void)openWeixin;

@end
