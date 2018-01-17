//
//  JPViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPViewController.h"
#import "JPNewsModel.h"
#import "YUAudioPlayer.h"
#import <CommonCrypto/CommonDigest.h>

@interface JPViewController () <UIGestureRecognizerDelegate>

@end

@implementation JPViewController
#pragma mark - FPS
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCFUMMessageClickNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [IBProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCFUMMessageClickNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    self.navigationController.navigationBarHidden = [self navigationBarHidden];
//    [self changeNavigationBarBackgroundColor:[UIColor clearColor]];
    
    //  监控网络状态变化
    [JPNetworkUtils netWorkState:^(NSInteger netState) {
        switch (netState) {
            case 1: case 2: {
                if ([JPUserEntity sharedUserEntity].merchantNo) {
                    
                    //  如果友盟没有成功绑定Alias，继续绑定，直到绑定成功
                    if (![JPPushManager sharedManager].isBindAlias) {
                        //  绑定友盟推送alias
                        [UMessage addAlias:[JPUserEntity sharedUserEntity].merchantNo type:JP_UMessageAliasType response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                            if(responseObject) {
                                JPLog(@"绑定成功！");
                                [[JPPushManager sharedManager] makeIsBindAlias:YES];
                            } else {
                                JPLog(@"绑定失败！ - %@", error.localizedDescription);
                                [[JPPushManager sharedManager] makeIsBindAlias:NO];
                            }
                        }];
                    }
                    //  如果推送服务器没有成功绑定Alias，继续绑定，直到绑定成功
                    if (![JPPushManager sharedManager].isBindService && [JP_UserDefults objectForKey:@"deviceToken"]) {
                        //  友盟Alias上传服务器
                        NSMutableDictionary *parameters = @{}.mutableCopy;
                        [parameters setObject:[JPUserEntity sharedUserEntity].merchantNo forKey:@"alias"];
                        [parameters setObject:JP_UMessageAliasType forKey:@"aliasType"];
                        //  appType 1：安卓飞燕，2：安卓杰宝宝，3：iOS杰宝宝，4：iOS飞燕
                        [parameters setObject:@"3" forKey:@"appType"];
                        
                        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
                        NSString *localVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
                        //  当前版本号
                        [parameters setObject:localVersion forKey:@"versionNo"];
                        [parameters setObject:[JP_UserDefults objectForKey:@"deviceToken"] forKey:@"deviceTokens"];
                        
                        [JPNetworking postUrl:jp_UMessageAlias_url params:parameters progress:nil callback:^(id resp) {
                            JPLog(@"------%@", resp);
                            JPLog(@"deviceToken - %@", [JP_UserDefults objectForKey:@"deviceToken"]);
                            if ([resp isKindOfClass:[NSString class]]) {
                                return;
                            }
                            if ([resp isKindOfClass:[NSDictionary class]]) {
                                BOOL suc = [resp[@"responseCode"] isEqualToString:@"0"];
                                [[JPPushManager sharedManager] makeIsBindService:suc];
                            }
                        }];
                    }
                }
            }
                break;
            default: {
                JPLog(@"没网");
            }
                break;
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = JP_viewBackgroundColor;
    
    // 导航栏背景颜色
    [self.navigationController.navigationBar setBarTintColor:JPBaseColor];
    // 导航栏标题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    // 导航栏左右按钮字体颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //  HUD字体颜色修改
//    [IBProgressHUD setDefaultStyle:IBProgressHUDStyleCustom];
//    [IBProgressHUD setForegroundColor:[UIColor whiteColor]];
//    [IBProgressHUD setBackgroundColor:JPBaseColor];
//    [IBProgressHUD setMaximumDismissTimeInterval:1];
    
//    //  设置ViewController可以滑动pop
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        if ([self.navigationController.viewControllers count] > 1) {
//            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//            self.navigationController.interactivePopGestureRecognizer.delegate = self;
//        } else {
//            
//            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//        }
//    }
    
    if ([JPUserEntity sharedUserEntity].isLogin) {
        if ([JPUserEntity sharedUserEntity].merchantNo) {
            //  绑定友盟推送alias
            [UMessage addAlias:[JPUserEntity sharedUserEntity].merchantNo type:JP_UMessageAliasType response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                if(responseObject) {
                    JPLog(@"绑定成功！");
                } else {
                    JPLog(@"绑定失败！ - %@", error.localizedDescription);
                }
            }];
        }
    }
    
    //  设置导航返回键
    if (self.navigationController.viewControllers.count > 1) {
        
        UIBarButtonItem *left = [[UIBarButtonItem alloc] init];
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setFrame:CGRectMake(15, 8, JPRealValue(30), JPRealValue(30))];
        leftButton.backgroundColor = [UIColor clearColor];
        [leftButton setBackgroundImage:[[UIImage imageNamed:@"jp_goBack1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(onBackItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [left setCustomView:leftButton];
        
        // 调整 leftBarButtonItem 在 iOS7 下面的位置
        if((iOS7Later ? 20 : 0)) {
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            //  距左侧的距离 默认为0
            //  negativeSpacer.width = 0;
            self.navigationItem.leftBarButtonItems = @[negativeSpacer, left] ;
        } else {
            self.navigationItem.leftBarButtonItem = left;
        }
        
        if (iOS7Later) {
            [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:JPRealValue(34)]}];
            self.navigationController.navigationBar.translucent = NO;
        }
    }
//    weakSelf_declare;
    [[NSNotificationCenter defaultCenter] addObserverForName:kCFUMMessageClickNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        if ([JPUserEntity sharedUserEntity].isLogin) {
            JPNavigationController *nav = self.tabBarController.viewControllers[0];
//            if (nav.viewControllers.count > 1) {
//                [nav popToRootViewControllerAnimated:NO];
//            }
            nav.tabBarController.selectedIndex = 3;
//
//            JPNavigationController *newsNav = self.tabBarController.viewControllers[1];
//            NSString *badge = nil;
//            if ([JPPushHelper badgeNumber] > 0) {
//                badge = [NSString stringWithFormat:@"%ld", (long)[JPPushHelper badgeNumber]];
//            }
//            [newsNav.tabBarItem setBadgeValue:badge];
        }
    }];
    
    weakSelf_declare;
    [[NSNotificationCenter defaultCenter] addObserverForName:kCFDownLineNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        if ([JPUserEntity sharedUserEntity].isLogin) {
            
            if ([JPUserEntity sharedUserEntity].merchantNo) {
                NSMutableDictionary *params = @{}.mutableCopy;
                [params setObject:[JPUserEntity sharedUserEntity].merchantNo forKey:@"alias"];
                if ([JP_UserDefults objectForKey:@"deviceToken"]) {
                    [params setObject:[JP_UserDefults objectForKey:@"deviceToken"] forKey:@"deviceTokens"];
                }
                
                //  appType 1：安卓飞燕，2：安卓杰宝宝，3：iOS杰宝宝，4：iOS飞燕
                [params setObject:@"3" forKey:@"appType"];
                
                //获取当前版本号
                NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
                NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
                [params setObject:currentAppVersion forKey:@"versionNo"];
                
                [JPNetworking postUrl:jp_UMessage_logout_url params:params progress:nil callback:^(id resp) {
                    JPLog(@"resp - %@", resp);
                }];
            }
            
            [UMessage removeAlias:[JPUserEntity sharedUserEntity].merchantNo type:JP_UMessageAliasType response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                if(responseObject) {
                    JPLog(@"解绑成功！");
                } else {
                    JPLog(@"解绑失败！ - %@", error.localizedDescription);
                }
                [[JPPushManager sharedManager] makeIsBindAlias:NO];
            }];
            
            [[JPUserEntity sharedUserEntity] setIsLogin:NO account:@"" merchantNo:nil merchantId:0 merchantName:@"" applyType:0 privateKey:@"" publicKey:@"" userId:@""];
        }
        
        NSString *message = (NSString *)note.object;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"下线通知" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
//            [JP_UserDefults removeObjectForKey:@"passLogin"];
//
//            //  首页跑马灯
//            [JP_UserDefults removeObjectForKey:@"isRolling"];
//            [JP_UserDefults removeObjectForKey:@"roll"];
            // 移除保存的密码
            [JP_UserDefults removeObjectForKey:@"passLogin"];
            //            [JP_UserDefults removeObjectForKey:@"deviceToken"];
            //  首页跑马灯
            [JP_UserDefults removeObjectForKey:@"isRolling"];
            [JP_UserDefults removeObjectForKey:@"roll"];
            // 移除手势密码
            [JP_UserDefults removeObjectForKey:@"tq_gesturesPassword"];
            // 移除手机账户
            [JP_UserDefults removeObjectForKey:@"appPhone"];
            //
            [JP_UserDefults removeObjectForKey:@"firstIn"];
            
            [JP_UserDefults synchronize];
            
            [weakSelf dismissViewControllerClass:[JPLoginViewController class]];
        }];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf dismissViewControllerClass:[JPLoginViewController class]];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:confirmAction];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void)onBackItemClicked:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 动态修改状态栏跟顶部导航栏的颜色
- (void)changeNavigationBarBackgroundColor:(UIColor *)barBackgroundColor {
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        NSArray *subviews = self.navigationController.navigationBar.subviews;
        for (id viewObj in subviews) {
            if (iOS10) {
                //iOS10,改变了状态栏的类为_UIBarBackground
                NSString *classStr = [NSString stringWithUTF8String:object_getClassName(viewObj)];
                if ([classStr isEqualToString:@"_UIBarBackground"]) {
                    UIImageView *imageView = (UIImageView *)viewObj;
                    imageView.hidden = YES;
                }
                if ([classStr isEqualToString:@"UIView"]) {
                    UIView *view = (UIView *)viewObj;
                    view.backgroundColor = [UIColor clearColor];
                }
                if ([classStr isEqualToString:@"UIImageView"]) {
                    UIImageView *imgView = (UIImageView *)viewObj;
                    imgView.backgroundColor = [UIColor clearColor];
                }
                
            } else {
                //iOS9以及iOS9之前使用的是_UINavigationBarBackground
                NSString *classStr = [NSString stringWithUTF8String:object_getClassName(viewObj)];
                if ([classStr isEqualToString:@"_UINavigationBarBackground"]) {
                    UIImageView *imageView = (UIImageView *)viewObj;
                    imageView.hidden = YES;
                }
            }
        }
        
        UIImageView *imageView = [self.navigationController.navigationBar viewWithTag:111];
        if (!imageView) {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, kScreenWidth, 64)];
            imageView.tag = 111;
            [imageView setBackgroundColor:barBackgroundColor];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController.navigationBar insertSubview:imageView atIndex:0];
            });
        } else {
            [imageView setBackgroundColor:barBackgroundColor];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController.navigationBar sendSubviewToBack:imageView];
            });
        }
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"7a93f5"].CGColor, (__bridge id)[UIColor colorWithHexString:@"68b2f2"].CGColor, (__bridge id)[UIColor colorWithHexString:@"51dbf0"].CGColor];
        gradientLayer.locations = @[@0, @0.5, @1.0];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1.0, 0);
        gradientLayer.frame = (CGRect){0, 0, kScreenWidth, 64};
        [imageView.layer addSublayer:gradientLayer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)navigationBarHidden {
    return NO;
}

// 模态退到指定的控制器
- (void)dismissViewControllerClass:(Class)class {
    UIViewController *vc = self;
    while (![vc isKindOfClass:class] && vc != nil) {
        vc = vc.presentingViewController;
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController *)vc).viewControllers.lastObject;
        }
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}

@end
