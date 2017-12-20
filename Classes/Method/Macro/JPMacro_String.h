
//
//  JPMacro_String.h
//  JiePos
//
//  Created by Jason_LJ on 2017/6/26.
//  Copyright © 2017年 Jason. All rights reserved.
//

#ifndef JPMacro_String_h
#define JPMacro_String_h

#import <Foundation/Foundation.h>

// !!!: 服务状态
static NSString *const JPServerNot00 = @"网络异常，请稍后再试";
static NSString *const JPServerNoNet = @"网络异常，请稍后再试";
static NSString *const JPServerNoFinish = @"网络异常，请稍后再试";

static NSString *const JPPushJBB = @"杰宝宝给您发来一条交易信息，请查收！";
static NSString *const JPPushSwitch = @"关闭后将不会接收到交易消息通知";
static NSString *const JPPushVoice = @"杰宝宝App在运行时，可以设置是否需要语音播报提醒消息通知";
static NSString *const JPBackNoti = @"返回将不保存你所编辑的信息，是否放弃入驻？";
//  相机关闭权限提示
static NSString *const JPCloseJurisdiction = @"您已关闭访问相册的权限，请前往设置开启后使用！";

static NSString *const JPBranchBank = @"暂无支行信息，请联系客户经理或者更换银行卡！";

//  扫码提示
static NSString *const JPScanChecking = @"扫码之后提示资料审核中，请耐心等待！";
static NSString *const JPScanChecThrough = @"扫码之后您的资料审核通过，可以使用收款码进行收款！";
static NSString *const JPScanChecNotThrough = @"扫码之后提示审核不通过，请重新上传正确资料！";

//  App介绍
static NSString *const JPJBBIntroduce = @"        “杰宝宝”是一款专业为商户量身定制的移动便捷软件，此APP支持商户在线注册、快速查看交易流水，并支持支付完成后语音播报、交易分析等。\n        “杰宝宝”由江苏杰博实信息技术有限公司自主研发，公司是一家专注于云支付解决方案与服务的互联网企业，由福建IT龙头星网锐捷旗下子公司升腾资讯于2016年7月在江苏南京设立。";

#endif /* JPMacro_String_h */
