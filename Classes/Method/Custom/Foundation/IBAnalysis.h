//
//  IBAnalysis.h
//  JiePos
//
//  Created by iBlocker on 2017/9/5.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBAnalysis : NSObject
+ (id)analysisWithEncryptString:(NSString *)encryptString privateKey:(NSString *)privateKey;
@end
