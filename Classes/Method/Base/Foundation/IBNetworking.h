//
//  IBNetworking.h
//  JiePos
//
//  Created by iBlocker on 2017/8/28.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPNetworking.h"

@interface IBNetworking : NSObject
//  POST
+ (void)postWithServiceCode:(NSString *)serviceCode
                    account:(NSString *)account
                       data:(NSString *)data
                   callback:(JPNetCallback)callback;
@end
