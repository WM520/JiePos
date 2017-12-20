//
//  IBProgressHUD.m
//  JiePos
//
//  Created by iBlocker on 2017/9/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "IBProgressHUD.h"
#import <UIImage+GIF.h>

@implementation IBProgressHUD
+ (void)loading {
//    // 设置背景颜色为透明色
//    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
//    
//    // 利用SVP提供类方法设置 通过UIImage分类方法返回的动态UIImage对象
//    [SVProgressHUD showImage:[UIImage sd_animatedGIFNamed:@"jiepos_loading"] status:@"加载中..."];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
}

+ (void)loadingWithStatus:(NSString *)status {
    [SVProgressHUD showWithStatus:status];
}

+ (void)showSuccessWithStatus:(NSString *)status {
    [SVProgressHUD showSuccessWithStatus:status];
}
+ (void)showErrorWithStatus:(NSString *)status {
    [SVProgressHUD showErrorWithStatus:status];
}
+ (void)showInfoWithStatus:(NSString *)status {
    [SVProgressHUD showInfoWithStatus:status];
}
+ (void)dismiss {
    [SVProgressHUD dismiss];
}
@end
