//
//  IBSwitchManager.h
//  JiePos
//
//  Created by iBlocker on 2017/8/28.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBSwitchManager : NSObject
@property (nonatomic, assign) BOOL canPlayMusic;
+ (instancetype)sharedManager;
@end
