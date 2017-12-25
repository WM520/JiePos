//
//  JPHomeModel.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/19.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPHomeChartModel : NSObject
/** 每日累计交易额*/
@property (nonatomic, copy) NSString *sumDayTransAt;
/** 交易日日期*/
@property (nonatomic, copy) NSString *recCrtDt;
@end

@interface JPHomeModel : NSObject
/** 当月累计交易金额*/
@property (nonatomic, copy) NSString *curMonthTransAt;
/** 当月累计手续费*/
@property (nonatomic, copy) NSString *curMonthMerFee;
/** 首页公告标题*/
@property (nonatomic, copy) NSString *title;
/** 发布时间*/
@property (nonatomic, copy) NSString *createTime;
/** 公告内容*/
@property (nonatomic, copy) NSString *content;
/** 是否可提现*/
@property (nonatomic, copy) NSString *isCash;
/** 可提现金额*/
@property (nonatomic, copy) NSString *cashWithdrawal;
/** 贷记卡总交易金额*/
@property (nonatomic, copy) NSString *bank;
/** 借记卡总交易金额*/
@property (nonatomic, copy) NSString *jieji;
/** 微信总交易金额*/
@property (nonatomic, copy) NSString *weixin;
/** 支付宝总交易金额*/
@property (nonatomic, copy) NSString *alipay;
/** 京东总交易金额 */
@property (nonatomic, copy) NSString *jdpay;
/** qq钱包 */
@property (nonatomic, copy) NSString *qqpay;
/** 银联二维码总交易金额*/
@property (nonatomic, copy) NSString *unionpay;
/** 微信总交易金额*/
@property (nonatomic, copy) NSString *wxqrcode;
/** 支付宝总交易金额*/
@property (nonatomic, copy) NSString *apqrcode;
/** 今日累计交易金额*/
@property (nonatomic, copy) NSString *todayTotal;


@end

@interface IBAdvertisementModel : NSObject
/** 轮播图链接*/
@property (nonatomic, copy) NSString *bannerUrl;
/** 详情链接*/
@property (nonatomic, copy) NSString *detailUrl;
/** 标题*/
@property (nonatomic, copy) NSString *title;
@end
