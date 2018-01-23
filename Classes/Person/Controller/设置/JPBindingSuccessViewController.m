//
//  JPBindingSuccessViewController.m
//  JiePos
//
//  Created by wangmiao on 2017/12/19.
//  Copyright © 2017年 WangMiao. All rights reserved.
//

#import "JPBindingSuccessViewController.h"
#import "JPLoginViewController.h"


@interface JPBindingSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *resultImage;
@property (nonatomic, strong) UIBarButtonItem *rightButtonItem;
@end

@implementation JPBindingSuccessViewController

#pragma mark - lifestyle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"绑定成功";
    _rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClicked)];
    self.navigationItem.rightBarButtonItem = self.rightButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Action
- (void)rightBarItemClicked {
    [JP_UserDefults setObject:self.numberPhone forKey:@"appPhone"];
//    NSArray * controllers = self.navigationController.viewControllers;
    JPNavigationController *nav = self.tabBarController.viewControllers[2];
    if (nav.viewControllers.count > 1) {
        [nav popToRootViewControllerAnimated:NO];
    }
    nav.tabBarController.selectedIndex = 0;
//    [self.navigationController popToViewController:controllers[1] animated:YES];
}

- (void)onBackItemClicked:(id)sender
{
    NSArray * controllers = self.navigationController.childViewControllers;
    [self.navigationController popToViewController:controllers[1] animated:YES];
}

// 跳转登录页
- (IBAction)backAction:(id)sender {
    [MobClick event:@"phone_logout"];
    weakSelf_declare;
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
        // 友盟解绑
        [UMessage removeAlias:[JPUserEntity sharedUserEntity].merchantNo type:JP_UMessageAliasType response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            if(responseObject) {
                JPLog(@"解绑成功！");
            } else {
                JPLog(@"解绑失败！ - %@", error.localizedDescription);
            }
            [[JPPushManager sharedManager] makeIsBindAlias:NO];
        }];
        
        //  本地账户置空
        [[JPUserEntity sharedUserEntity] setIsLogin:NO account:@"" merchantNo:nil merchantId:0 merchantName:@"" applyType:0 privateKey:@"" publicKey:@"" userId:@""];
        
        [JP_UserDefults setObject:weakSelf.numberPhone forKey:@"userLogin"];
        // 移除保存的密码
        [JP_UserDefults removeObjectForKey:@"passLogin"];
        //            [JP_UserDefults removeObjectForKey:@"deviceToken"];
        //  首页跑马灯
        [JP_UserDefults removeObjectForKey:@"isRolling"];
        [JP_UserDefults removeObjectForKey:@"roll"];
        
        // 移除手机账户
        [JP_UserDefults removeObjectForKey:@"appPhone"];
        // 移除第一次登录没有绑定手机提示
        [JP_UserDefults removeObjectForKey:@"FirstRemind"];
        // 本地同步
        [JP_UserDefults synchronize];
    
        [self dismissViewControllerClass:[JPLoginViewController class]];
    }
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
