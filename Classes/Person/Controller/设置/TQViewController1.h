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
@property (nonatomic, assign) BOOL isModification;
@property (nonatomic, assign) BOOL isFirstLogin;
@end
