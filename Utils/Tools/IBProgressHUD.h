//
//  IBProgressHUD.h
//  JiePos
//
//  Created by iBlocker on 2017/9/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBProgressHUD : NSObject
+ (void)loading;
+ (void)loadingWithStatus:(NSString *)status;
+ (void)showSuccessWithStatus:(NSString *)status;
+ (void)showErrorWithStatus:(NSString *)status;
+ (void)showInfoWithStatus:(NSString *)status;
+ (void)dismiss;
@end
