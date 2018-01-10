//
//  AppDelegate.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+checkVersions.h"
//  推送
#import <UserNotifications/UserNotifications.h>
#import <CommonCrypto/CommonCrypto.h>
#import <AdSupport/AdSupport.h>
//  语音播报
#import "iflyMSC/IFlyMSC.h"
#import "PcmPlayer.h"

#import "JPLaunchIntroView.h"
#import "JPDemoViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"

#import "JPGesturePasswordViewController.h"

#import <AVFoundation/AVFoundation.h>


@interface AppDelegate () <UNUserNotificationCenterDelegate,IFlySpeechSynthesizerDelegate>
@property (nonatomic, strong) PcmPlayer *audioPlayer;
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    {
//        // 注册后台播放
//        AVAudioSession *session = [AVAudioSession sharedInstance];
//        
//        // AVAudioSessionCategoryPlayback 后台播放
//        [session setCategory:AVAudioSessionCategoryPlayback error:NULL];
//        
//        // 开始接收远程控制事件
//        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//    }
    
    // !!!: 初始化友盟统计
    [self handleUMMobClick];
    // !!!: 初始化shareSDK
    [self handleShareSDK];
    // !!!: 测试数据
    /*******************************************************/
//    [self addTestDataWithMerchantNo:@"998320179320003"];
//    JPLog(@"%@", [JPPushHelper dataSource]);
    /*******************************************************/
    
    // !!!: 设置主Window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // !!!: 只执行一次，默认开关全部打开
    if (![JP_UserDefults boolForKey:@"firstIn"]) {
        [JP_UserDefults setBool:YES forKey:JP_Noti_Value];
        [JP_UserDefults setBool:YES forKey:JP_Voice_Value];
        [JP_UserDefults setBool:YES forKey:JP_Shake_Value];
        // 第一次登录的时候提醒用户设置手势密码
        [JP_UserDefults setBool:YES forKey:@"firstIn"];
    }
    
    // !!!: 设置键盘监听管理
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    //  隐藏键盘Toolbar
    //    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //  点击背景收起键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [self setupRootViewController];
    
    //  版本更新
    [self checkVersion];
    
    // !!!: 注册科大讯飞语音播报
    [self registerMSC];
    
    // !!!: 注册推送
    [self registerUMessageWithOptions:launchOptions];
    
    if (launchOptions) {
        NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        //  ...
        NSDictionary *info = [self dictionaryWithUserInfo:userInfo];
        if (!info || info.count <= 0) {
            return YES;
        }
        JPNewsModel *newsModel = [JPNewsModel yy_modelWithDictionary:info];
        [self playVoice:newsModel unread:YES];
    }
    
    return YES;
}

#pragma mark - 注册友盟统计
- (void)handleUMMobClick {
    UMConfigInstance.appKey = JP_UMMobClickAppKey;
    UMConfigInstance.ePolicy = SEND_INTERVAL;// 最小间隔发送
    [MobClick startWithConfigure:UMConfigInstance];
}

- (void)handleShareSDK
{
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ)
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
      
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx084e52beb21f50bd"
                                       appSecret:@"2454e7a52a7f4734d44141979271b82a"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1106542731"
                                      appKey:@"RMtrMbcFO4Lsu7qG"
                                    authType:SSDKAuthTypeBoth];
                 break;
            default:
                break;
        }
    }];
}

#pragma mark - 注册友盟推送
- (void)registerUMessageWithOptions:(NSDictionary *)launchOptions {
    //  设置 AppKey 及 LaunchOptions
//    [UMessage startWithAppkey:JP_UMessageAppKey launchOptions:launchOptions httpsEnable:YES ];
    [UMessage startWithAppkey:JP_UMessageAppKey launchOptions:launchOptions];
    //  打开开发模式，不写默认为生产模式
    //    [UMessage openDebugMode:YES];
    
    //  注册通知
    [UMessage registerForRemoteNotifications];
    if (iOS10) {
        //  iOS10必须加下面这段代码。
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        UNAuthorizationOptions types10 = UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //  点击允许
                //  这里可以添加一些自己的逻辑
            } else {
                //  点击不允许
                //  这里可以添加一些自己的逻辑
            }
        }];
    }
    //  打开日志，方便调试
    //    [UMessage setLogEnabled:YES];
}

#pragma mark - 注册科大讯飞
- (void)registerMSC {
    //  设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_NONE];
    
    //  打开输出在console的log开关
    [IFlySetting showLogcat:NO];
    
    //  设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //  Appid是应用的身份信息，具有唯一性，初始化时必须要传入Appid。
    //  创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", JP_MSCAppKey];
    
    //  所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    [[IFlySpeechUtility getUtility] handleOpenURL:url];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [JP_UserDefults setObject:token forKey:@"deviceToken"];
    });
    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //如果注册不成功，打印错误信息，可以在网上找到对应的解决方案
    //1.2.7版本开始自动捕获这个方法，log以application:didFailToRegisterForRemoteNotificationsWithError开头
    JPLog(@"UMessage - error - %@", error);
}

#pragma mark - 推送过来的消息进行处理的方法
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // 系统会根据UIBackgroundFetchResult来判断后台处理的有效性,如果后台处理效率较低,会延迟发送后台推送通知
    completionHandler (UIBackgroundFetchResultNewData);
}

// !!!: 静默推送(远程推送通知)
/**
 *  已经接收到后台远程通知后调用 (如果实现了该方法,默认的接收通知的方法就不会再被调用didReceiveRemoteNotification↑)
 *
 *  @param application       应用对象
 *  @param userInfo          推送信息
 *  @param completionHandler 完成回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSDictionary *info = [self dictionaryWithUserInfo:userInfo];
    if (!info || info.count <= 0) {
        return;
    }
    JPNewsModel *newsModel = [JPNewsModel yy_modelWithDictionary:info];
    [self playVoice:newsModel unread:YES];
    
    // 系统会根据UIBackgroundFetchResult来判断后台处理的有效性,如果后台处理效率较低,会延迟发送后台推送通知
    completionHandler (UIBackgroundFetchResultNewData);
}

// !!!: iOS10以下：处理前台收到通知的代理方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSDictionary *transInfo = [self dictionaryWithUserInfo:userInfo];
    //  关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    
    //  统计点击数   也可以不交给友盟处理 自己处理消息【不要删除】
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //  定制自定的的弹出框
    if (transInfo.count > 0) {
        // 是否震动
        if ([JP_UserDefults boolForKey:JP_Shake_Value]) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        JPNewsModel *model = [JPNewsModel yy_modelWithDictionary:transInfo];
        [self playVoice:model unread:YES];
    }
}

// !!!: iOS10新增：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSDictionary *transInfo = [self dictionaryWithUserInfo:userInfo];
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        if (transInfo.count > 0) {
            //  关闭U-Push自带的弹出框
            [UMessage setAutoAlert:NO];
            
            JPNewsModel *model = [JPNewsModel yy_modelWithDictionary:transInfo];
            [self playVoice:model unread:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kCFUMMessageClickNotification object:nil userInfo:transInfo];
        }
        //应用处于前台时的远程推送接受    必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    } else {
        //应用处于前台时的本地推送接受
    }
    // 是否震动
    if ([JP_UserDefults boolForKey:JP_Shake_Value]) {
        completionHandler (UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert);
    } else {
        completionHandler (UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert);
    }

}

// !!!: iOS10以下：处理后台点击通知的代理方法
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    
    NSDictionary *transInfo = [self dictionaryWithUserInfo:userInfo];
    if (transInfo.count > 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kCFUMMessageClickNotification object:nil userInfo:transInfo];
        
        //  关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        
        JPNewsModel *model = [JPNewsModel yy_modelWithDictionary:transInfo];
        [self playVoice:model unread:YES];
    }
    //这个方法用来做action点击的统计
    [UMessage sendClickReportForRemoteNotification:userInfo];
    
    completionHandler (UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert);
}

// !!!: iOS10新增：处理后台点击通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSDictionary *transInfo = [self dictionaryWithUserInfo:userInfo];
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        if (transInfo.count > 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kCFUMMessageClickNotification object:nil userInfo:transInfo];
            
            JPNewsModel *model = [JPNewsModel yy_modelWithDictionary:transInfo];
            [self playVoice:model unread:YES];
        }
        //应用处于后台时的远程推送接受    必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        //这个方法用来做action点击的统计
        [UMessage sendClickReportForRemoteNotification:userInfo];
    } else {
        //应用处于后台时的本地推送接受
    }
    completionHandler (UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert);
}

#pragma mark - App的各种状态
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    JPLog(@"applicationWillResignActive");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    JPLog(@"applicationDidEnterBackground");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    JPLog(@"applicationWillEnterForeground");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    JPLog(@"applicationDidBecomeActive");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    JPLog(@"applicationWillTerminate");
    
    [JP_UserDefults removeObjectForKey:@"isRolling"];
    [JP_UserDefults removeObjectForKey:@"roll"];
    [JP_UserDefults synchronize];
    
    if (![JPUserEntity sharedUserEntity].isLogin) {
        [UMessage removeAlias:[JP_UserDefults objectForKey:@"merchantNo"] type:JP_UMessageAliasType response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            if(responseObject) {
                JPLog(@"解绑成功！");
            } else {
                JPLog(@"解绑失败！ - %@", error.localizedDescription);
            }
            [[JPPushManager sharedManager] makeIsBindAlias:NO];
        }];
    }
}

#pragma mark - 设置根视图控制器
- (void)setupRootViewController {
    
//    JPDemoViewController *demoVC = [[JPDemoViewController alloc] init];
//    self.window.rootViewController = demoVC;
    
    //  设置登录界面为根视图
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"tq_gesturesPassword"] isEqualToString:@""] || [[NSUserDefaults standardUserDefaults] stringForKey:@"tq_gesturesPassword"] == NULL) {
        JPLoginViewController * vc = [JPLoginViewController new];
        vc.isGesturePush = NO;
        JPNavigationController *loginNav = [[JPNavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = loginNav;
    } else { // 有手势密码走手势密码登录逻辑
        JPGesturePasswordViewController * vc = [JPGesturePasswordViewController new];
        self.window.rootViewController = vc;
    }
 
    JPLaunchIntroView *launchView = [JPLaunchIntroView sharedWithImages:@[@"guide_01", @"guide_02", @"guide_03", @"guide_04"] buttonFrame:CGRectMake(kScreenWidth/2 - JPRealValue(112), kScreenHeight - JPRealValue(126), JPRealValue(224), JPRealValue(64))];
    [self.window bringSubviewToFront:launchView];
}

#pragma mark - 推送消息本地缓存
- (void)insertModel:(JPNewsModel *)newsModel unread:(BOOL)unread {
    [JPPushHelper insertTransactionResult:newsModel.transactionResult
                         transactionMoney:newsModel.transactionMoney
                          transactionTime:newsModel.transactionTime
                            tenantsNumber:newsModel.tenantsNumber
                              tenantsName:newsModel.tenantsName
                          transactionType:newsModel.transactionType
                                  payType:newsModel.payType
                              orderNumber:newsModel.orderNumber
                             serialNumber:newsModel.serialNumber
                           answerBackCode:newsModel.answerBackCode
                          transactionCode:newsModel.transactionCode
                                couponAmt:newsModel.couponAmt
                                 totalAmt:newsModel.totalAmt
                                   unread:unread];
}

#pragma mark - 科大讯飞文本合成声音
- (void)playVoice:(JPNewsModel *)model  unread:(BOOL)unread {
    
    [self insertModel:model unread:unread];
    
    float num = [model.transactionMoney floatValue] * 100;
    NSString *voice = nil;
    if ((int)num % 100 == 0) {
        voice = [NSString stringWithFormat:@"%.f", num / 100];
    } else if ((int)num % 100 != 0 && (int)num % 10 == 0) {
        voice = [NSString stringWithFormat:@"%.1f", num / 100];
    } else {
        voice = [NSString stringWithFormat:@"%.2f", num / 100];
    }
    
    BOOL canSound = [JP_UserDefults boolForKey:JP_Voice_Value];
    if (canSound) {
        if ([model.transactionCode isEqualToString:JPAvailDealTypeT00002] ||
            [model.transactionCode isEqualToString:JPAvailDealTypeT00003] ||
            [model.transactionCode isEqualToString:JPAvailDealTypeT00009] ||
            [model.transactionCode isEqualToString:JPAvailDealTypeW00003] ||
            [model.transactionCode isEqualToString:JPAvailDealTypeW00004] ||
            [model.transactionCode isEqualToString:JPAvailDealTypeA00003] ||
            [model.transactionCode isEqualToString:JPAvailDealTypeA00004] ||
            [model.transactionCode isEqualToString:JPAvailDealTypeJ00004] ||
            [model.transactionCode isEqualToString:JPAvailDealTypeQ00004] ||
            [model.transactionCode isEqualToString:JPAvailDealTypeU00004]) {
            [self playVoiceWithString:[NSString stringWithFormat:@"退款%@元！", voice]];
        } else {
            [self playVoiceWithString:[NSString stringWithFormat:@"收款%@元！", voice]];
        }
    }
}

- (void)playVoiceWithString:(NSString *)string {
    
    //  合成服务单例
    if (self.iFlySpeechSynthesizer == nil) {
        self.iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    self.iFlySpeechSynthesizer.delegate = self;
    //  设置语速1-100
    [self.iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];
    //  设置音量1-100
    [self.iFlySpeechSynthesizer setParameter:@"100" forKey:[IFlySpeechConstant VOLUME]];
    //  设置音调1-100
    [self.iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant PITCH]];
    //  设置采样率
    [self.iFlySpeechSynthesizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    //  设置发音人
    [self.iFlySpeechSynthesizer setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
    //  设置文本编码格式
    [self.iFlySpeechSynthesizer setParameter:@"unicode" forKey:[IFlySpeechConstant TEXT_ENCODING]];
    
    if (self.audioPlayer != nil && self.audioPlayer.isPlaying == YES) {
        [self.audioPlayer stop];
    }
    [self.iFlySpeechSynthesizer startSpeaking:string];
}

#pragma mark - IFlySpeechSynthesizerDelegate
- (void)onCompleted:(IFlySpeechError *)error {
    JPLog(@"IFly error - %@", error);
}

#pragma mark - 解析推送消息数据
- (NSDictionary *)dictionaryWithUserInfo:(NSDictionary *)userInfo {
    
    // FIXME: 需注释
//    NSError *parseError = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:&parseError];
//    
//    NSString *mes = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:mes delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
//    [alert show];
    
    if (userInfo.count <= 0) {
        return nil;
    }

    NSArray *keys = userInfo.allKeys;
    if ([keys containsObject:@"extra"]) {
        NSDictionary *infoDic = userInfo[@"extra"];
        NSString *jsonString = infoDic[@"transInfo"];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        
        if(err) {
            JPLog(@"json解析失败：%@",err);
            return nil;
        }
        return dic;
    } else if ([keys containsObject:@"transInfo"]) {
        
        NSString *jsonString = userInfo[@"transInfo"];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        
        if(err) {
            JPLog(@"json解析失败：%@",err);
            return nil;
        }
        return dic;
    } else {
        return nil;
    }
}

#pragma mark - 插入测试数据 模拟用户机器原有数据
- (void)addTestDataWithMerchantNo:(NSString *)merchantNo {
    NSDictionary *dic1 = @{
                           @"transactionResult":@"交易成功",
                           @"transactionMoney":@"1.00",
                           @"transactionTime":@"2017-05-01 11:05:48",
                           @"tenantsNumber":merchantNo,
                           @"tenantsName":@"商户1",
                           @"transactionType":@"刷卡",
                           @"payType":@"银行",
                           @"orderNumber":@"20170512181706531041",
                           @"serialNumber":@"000648",
                           @"answerBackCode":@"006"};
    [self insertModel:[JPNewsModel yy_modelWithDictionary:dic1] unread:YES];
    
    NSDictionary *dic2 = @{
                           @"transactionResult":@"交易成功",
                           @"transactionMoney":@"2.00",
                           @"transactionTime":@"2017-05-02 11:05:48",
                           @"tenantsNumber":merchantNo,
                           @"tenantsName":@"商户1",
                           @"transactionType":@"刷卡",
                           @"payType":@"银行",
                           @"orderNumber":@"20170512181706531042",
                           @"serialNumber":@"000648",
                           @"answerBackCode":@"006"};
    [self insertModel:[JPNewsModel yy_modelWithDictionary:dic2] unread:YES];
    
    NSDictionary *dic3 = @{
                           @"transactionResult":@"交易成功",
                           @"transactionMoney":@"3.00",
                           @"transactionTime":@"2017-05-03 11:05:48",
                           @"tenantsNumber":merchantNo,
                           @"tenantsName":@"商户1",
                           @"transactionType":@"刷卡",
                           @"payType":@"银行",
                           @"orderNumber":@"20170512181706531043",
                           @"serialNumber":@"000648",
                           @"answerBackCode":@"006"};
    [self insertModel:[JPNewsModel yy_modelWithDictionary:dic3] unread:YES];
    
    NSDictionary *dic4 = @{
                           @"transactionResult":@"交易成功",
                           @"transactionMoney":@"4.00",
                           @"transactionTime":@"2017-05-03 11:12:26",
                           @"tenantsNumber":merchantNo,
                           @"tenantsName":@"商户1",
                           @"transactionType":@"刷卡",
                           @"payType":@"银行",
                           @"orderNumber":@"20170512181706531044",
                           @"serialNumber":@"000648",
                           @"answerBackCode":@"006"};
    [self insertModel:[JPNewsModel yy_modelWithDictionary:dic4] unread:YES];
    
    NSDictionary *dic5 = @{
                           @"transactionResult":@"交易成功",
                           @"transactionMoney":@"5.00",
                           @"transactionTime":@"2017-05-04 11:05:48",
                           @"tenantsNumber":merchantNo,
                           @"tenantsName":@"商户1",
                           @"transactionType":@"刷卡",
                           @"payType":@"银行",
                           @"orderNumber":@"20170512181706531045",
                           @"serialNumber":@"000648",
                           @"answerBackCode":@"006"};
    [self insertModel:[JPNewsModel yy_modelWithDictionary:dic5] unread:YES];
    
    NSDictionary *dic6 = @{
                           @"transactionResult":@"交易成功",
                           @"transactionMoney":@"6.00",
                           @"transactionTime":@"2017-05-05 11:05:48",
                           @"tenantsNumber":merchantNo,
                           @"tenantsName":@"商户1",
                           @"transactionType":@"刷卡",
                           @"payType":@"银行",
                           @"orderNumber":@"20170512181706531046",
                           @"serialNumber":@"000648",
                           @"answerBackCode":@"006"};
    [self insertModel:[JPNewsModel yy_modelWithDictionary:dic6] unread:YES];
    
    NSDictionary *dic7 = @{
                           @"transactionResult":@"交易成功",
                           @"transactionMoney":@"7.00",
                           @"transactionTime":@"2017-05-06 11:05:48",
                           @"tenantsNumber":merchantNo,
                           @"tenantsName":@"商户1",
                           @"transactionType":@"刷卡",
                           @"payType":@"银行",
                           @"orderNumber":@"20170512181706531047",
                           @"serialNumber":@"000648",
                           @"answerBackCode":@"006"};
    [self insertModel:[JPNewsModel yy_modelWithDictionary:dic7] unread:YES];
    
    NSDictionary *dic8 = @{
                           @"transactionResult":@"交易成功",
                           @"transactionMoney":@"8.00",
                           @"transactionTime":@"2017-05-07 11:05:48",
                           @"tenantsNumber":merchantNo,
                           @"tenantsName":@"商户1",
                           @"transactionType":@"刷卡",
                           @"payType":@"银行",
                           @"orderNumber":@"20170512181706531048",
                           @"serialNumber":@"000648",
                           @"answerBackCode":@"006"};
    [self insertModel:[JPNewsModel yy_modelWithDictionary:dic8] unread:YES];
    
    NSDictionary *dic9 = @{
                           @"transactionResult":@"交易成功",
                           @"transactionMoney":@"9.00",
                           @"transactionTime":@"2017-06-29 15:33:13",
                           @"tenantsNumber":merchantNo,
                           @"tenantsName":@"商户1",
                           @"transactionType":@"刷卡",
                           @"payType":@"银行",
                           @"orderNumber":@"20170512181706531049",
                           @"serialNumber":@"000648",
                           @"answerBackCode":@"006"};
    [self insertModel:[JPNewsModel yy_modelWithDictionary:dic9] unread:YES];
    
    NSDictionary *dic10 = @{
                            @"transactionResult":@"交易成功",
                            @"transactionMoney":@"10.00",
                            @"transactionTime":@"2017-06-29 15:34:48",
                            @"tenantsNumber":merchantNo,
                            @"tenantsName":@"商户1",
                            @"transactionType":@"刷卡",
                            @"payType":@"银行",
                            @"orderNumber":@"20170512181706531010",
                            @"serialNumber":@"000648",
                            @"answerBackCode":@"006"};
    [self insertModel:[JPNewsModel yy_modelWithDictionary:dic10] unread:YES];
}

@end






