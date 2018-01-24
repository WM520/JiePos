//
//  TQViewController1.h
//  TQGestureLockViewDemo_Example
//
//  Created by TQTeam on 2017/11/3.
//  Copyright © 2017年 TQTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPViewController.h"

typedef void(^SUCCESSBLOCK)();

@interface TQViewController1 :JPViewController

@property (nonatomic, copy) SUCCESSBLOCK successblock;
/** 是否是修改密码的进入 */
@property (nonatomic, assign) BOOL isModification;
/** 是否是第一次登录时候的进入 */
@property (nonatomic, assign) BOOL isFirstLogin;
@end
