//
//  JPMacro_Define.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#ifndef JPMacro_Define_h
#define JPMacro_Define_h

#import <UIKit/UIKit.h>

//  移除GBEncodeTool中桥接警告
#pragma clang diagnostic ignored "-Warc-bridge-casts-disallowed-in-nonarc"

// !!!: Log
#ifdef DEBUG
#define JPLog(format, ...) printf("[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define JPLog(format, ...)
#endif

#define beforeIphone6 (kScreenWidth <= 320)

// !!!: iOS版本
//  iOS 7
#define iOS7 ([UIDevice currentDevice].systemVersion.floatValue >= 7.0 && [UIDevice currentDevice].systemVersion.floatValue < 8.0)
//  iOS 7之后（包含iOS 7）
#define iOS7Later [UIDevice currentDevice].systemVersion.floatValue >= 7.0
//  iOS 7 ~ 8
#define iOS7To8 ([UIDevice currentDevice].systemVersion.floatValue >= 7.0 && [UIDevice currentDevice].systemVersion.floatValue < 9.0)
//  iOS 8之后（包含iOS 8）
#define iOS8Later [UIDevice currentDevice].systemVersion.floatValue >= 8.0
//  iOS 9
#define iOS9 ([UIDevice currentDevice].systemVersion.floatValue >= 9.0 && [UIDevice currentDevice].systemVersion.floatValue < 10.0)
//  iOS 9之后（包含iOS 9）
#define iOS9Later [UIDevice currentDevice].systemVersion.floatValue >= 9.0
//  iOS 10
#define iOS10 ([UIDevice currentDevice].systemVersion.floatValue >= 10.0 && [UIDevice currentDevice].systemVersion.floatValue < 11.0)
//  iOS 10之后（包含iOS 10）
#define iOS10Later [UIDevice currentDevice].systemVersion.floatValue >= 10.0
//  iOS 11
#define iOS11 [UIDevice currentDevice].systemVersion.floatValue >= 11.0

// !!!: iPhone X
#define is_iPhone_X (kScreenWidth == 375 && kScreenHeight == 812)

//  状态栏高度
#ifdef is_iPhone_X
#define kStatusBarHeight 44
#else
#define kStatusBarHeight 20
#endif

// !!!: Size
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

#define JPRealValue(_f_) (_f_)/750.0f*[UIScreen mainScreen].bounds.size.width
#define JP_DefaultsFont [UIFont systemFontOfSize:JPRealValue(30)]

// !!!: weakSelf声明
#define weakSelf_declare    __weak typeof(self) weakSelf = self
// !!!: color
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define ThemeColor RGBA(245, 245, 245, 1.0f)
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define DominantColor [UIColor whiteColor]
/*****************************/
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif
/*********分割线************/
#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif
/*****************************/

#define JP_UserDefults [NSUserDefaults standardUserDefaults]

// !!!: 设置开关
//  推送通知
static NSString *const JP_Noti_Value = @"noti_value";
//  语音播报
static NSString *const JP_Voice_Value = @"voice_value";
// 应用内震动
static NSString *const JP_Shake_Value = @"shake_value";

#pragma mark - App配置信息
// !!!: 友盟推送
static NSString *const JP_UMessageAppKey = @"58feb5a2f43e48609c0001d7";
static NSString *const JP_UMessageAppSecret = @"0ycwbqj53iktsomljda3swwaozoybvbr";
static NSString *const JP_UMessageAliasType = @"tenantsNumber";

// !!!: 友盟统计
static NSString *const JP_UMMobClickAppKey = @"58feb5a2f43e48609c0001d7";

// !!!: 科大讯飞语音播报
static NSString *const JP_MSCAppKey = @"590fc971";

//  微信
//static NSString *const weixinAppID = @"wxbb1847b644a22f80";
//static NSString *const weixinAppSecret = @"90cf059df0de35ccd9b97fdd5624c0c0";
static NSString *const weixinAppID = @"wx084e52beb21f50bd";
static NSString *const weixinAppSecret = @"2454e7a52a7f4734d44141979271b82a";

#pragma mark - 通知
//  登录
static NSString *const kCFLoginNotification = @"kCFLoginNotification";
//  首页新公告
static NSString *const kCFNewNoticeNotification = @"kCFNewNoticeNotification";
//  下线通知
static NSString *const kCFDownLineNotification = @"kCFDownLineNotification";
//  推送消息
static NSString *const kCFUMMessageClickNotification = @"kCFUMMessageClick";

static NSString *const kCFUMMessageReceiveNotification = @"kCFUMMessageReceive";
//  图片数量通知
static NSString *const kCFCredentialsNotification = @"kCFCredentialsInfo";

// !!!: 数据库
static NSString *const JP_DataBaseName = @"dealinfo.sqlite";
static NSString *const JP_TableName = @"dealmessage";

static NSString *const jp_dealID = @"dealID";

static NSString *const jp_transactionResult = @"transactionResult";
static NSString *const jp_transactionMoney = @"transactionMoney";
static NSString *const jp_transactionTime = @"transactionTime";
static NSString *const jp_tenantsNumber = @"tenantsNumber";
static NSString *const jp_tenantsName = @"tenantsName";
static NSString *const jp_transactionType = @"transactionType";
static NSString *const jp_payType = @"payType";
static NSString *const jp_orderNumber = @"orderNumber";
static NSString *const jp_serialNumber = @"serialNumber";
static NSString *const jp_answerBackCode = @"answerBackCode";
static NSString *const jp_transactionCode = @"transactionCode";
static NSString *const jp_couponAmt = @"couponAmt";
static NSString *const jp_totalAmt = @"totalAmt";
static NSString *const jp_unread = @"unread";

// 输入新老支付密码存储
static NSString *const oldPayPass = @"oldPayPass";
static NSString *const newPayPass = @"newPayPass";

#endif /* JPMacro_Define_h */
