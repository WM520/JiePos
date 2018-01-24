//
//  JPPushManager.h
//  JiePos
//
//  Created by Jason_LJ on 2017/7/14.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

//  判断Alias是否已对友盟、本地推送服务器绑定
@interface JPPushManager : NSObject
/** 是否成功向友盟绑定Alias*/
@property (nonatomic, assign, readonly) BOOL isBindAlias;
/** 是否成功向服务器绑定推送信息*/
@property (nonatomic, assign, readonly) BOOL isBindService;
+ (instancetype)sharedManager;
- (void)makeIsBindAlias:(BOOL)isBindAlias;
- (void)makeIsBindService:(BOOL)isBindService;

@end
