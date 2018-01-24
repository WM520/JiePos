//
//  JPTabBarController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPTabBarController.h"
#import "JPIndexViewController.h"
#import "JPSearchViewController.h"
#import "JPPersonViewController.h"

@interface JPTabBarController () <UITabBarDelegate,UITabBarControllerDelegate>

@end

@implementation JPTabBarController

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
    
//    NSString *badge = nil;
//    if ([JPPushHelper badgeNumber] > 0) {
//        badge = [NSString stringWithFormat:@"%ld", (long)[JPPushHelper badgeNumber]];
//    }
//    [[self.tabBar.items objectAtIndex:1] setBadgeValue:badge];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    //去掉tabBar顶部线条
//    CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [self.tabBar setBackgroundImage:img];
//    [self.tabBar setShadowImage:img];
    
    //  设置导航字体
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationController.navigationBar.translucent = NO;
    
    self.tabBar.translucent = NO;
    self.tabBarController.tabBar.delegate = self;
    self.delegate = self;
    [self addChildViewControllers];
    
//    weakSelf_declare;
    [[NSNotificationCenter defaultCenter] addObserverForName:kCFUMMessageClickNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        if ([JPUserEntity sharedUserEntity].isLogin) {
            JPNavigationController *nav = self.tabBarController.viewControllers[0];
            if (nav.viewControllers.count > 1) {
                [nav popToRootViewControllerAnimated:NO];
            }
            nav.tabBarController.selectedIndex = 2;
//            JPNavigationController *newsNav = self.tabBarController.viewControllers[1];
//            newsNav.tabBarItem.badgeValue = @"1";
            
//            JPNavigationController *newsNav = self.tabBarController.viewControllers[1];
//            NSString *badge = nil;
//            if ([JPPushHelper badgeNumber] > 0) {
//                badge = [NSString stringWithFormat:@"%ld", (long)[JPPushHelper badgeNumber]];
//            }
//            [newsNav.tabBarItem setBadgeValue:badge];
        }
    }];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    return YES;
}

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//    JPNavigationController *newsNav = self.tabBarController.viewControllers[1];
//    newsNav.tabBarItem.badgeValue = nil;
//}

- (void)addChildViewControllers {
    [self appendViewController:[JPIndexViewController new] WithTitle:@"首页" WithImageName:@"jp_home_normal" selectImageName:@"jp_home_selected"];
    [self appendViewController:[JPSearchViewController new] WithTitle:@"交易查询" WithImageName:@"jp_news_normal" selectImageName:@"jp_news_selected"];
    [self appendViewController:[JPPersonViewController new] WithTitle:@"我的" WithImageName:@"jp_person_normal" selectImageName:@"jp_person_selected"];
}

- (void)appendViewController:(UIViewController *)vc
                   WithTitle:(NSString *)title
               WithImageName:(NSString *)ImageName
             selectImageName:(NSString *)selectImageName {
    
    JPNavigationController *nav = [[JPNavigationController alloc]initWithRootViewController:vc];
    nav.navigationItem.title = title;
    nav.navigationBar.frame = CGRectMake(0, 20, kScreenWidth, 44);
    self.tabBar.tintColor = JPBaseColor;
    vc.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:ImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:JPBaseColor} forState:UIControlStateSelected];
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
