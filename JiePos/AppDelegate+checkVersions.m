//
//  AppDelegate+checkVersions.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/26.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "AppDelegate+checkVersions.h"

@implementation AppDelegate (checkVersions)
#pragma mark - 监测版本更新
- (void)checkVersion {
    
    //获取本地软件的版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *localVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    JPLog(@"infoDic --- %@", infoDic);
    
    weakSelf_declare;
    [IBVersionRequest checkVersionWithAppCode:@"jbb" platform:@"ios" callback:^(NSString *code, NSString *msg, id resp) {
        
        JPLog(@"%@ - %@ - %@", code, msg, resp);
        
        if ([resp isKindOfClass:[NSDictionary class]]) {
            NSArray *keys = [(NSDictionary *)resp allKeys];
            if (![keys containsObject:@"isUpdate"] || ![keys containsObject:@"version"] || ![keys containsObject:@"description"] || ![keys containsObject:@"isVoice"]) {
                return;
            }
            NSString *onlineVersion = [resp objectForKey:@"version"];
            BOOL isUpdate = [[resp objectForKey:@"isUpdate"] boolValue];
            NSString *msg = [resp objectForKey:@"description"];
            
            [[IBSwitchManager sharedManager] setCanPlayMusic:[[resp objectForKey:@"isVoice"] boolValue]];
            
            if ([localVersion compare:onlineVersion] == NSOrderedAscending) {
                if (isUpdate) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.center = weakSelf.window.center;
                    btn.bounds = CGRectMake(0, 0, 100, 40);
                    [btn setTitle:@"立即更新" forState:UIControlStateNormal];
                    [btn setTitleColor:JP_NoticeRedColor forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(gotoItunes) forControlEvents:UIControlEventTouchUpInside];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [alert setValue:btn forKey:@"accessoryView"];
                    [alert show];
                } else {
                    JPLog(@"不更新");
                }
            }
        }
    }];
}

- (void)gotoItunes {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%e6%9d%b0%e5%ae%9d%e5%ae%9d/id1230357553?l=zh&ls=1&mt=8"]];
}
@end
