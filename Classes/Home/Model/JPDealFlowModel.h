//
//  JPDealFlowModel.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/20.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPDealFlowModel : NSObject
/** 交易金额*/
@property (nonatomic, copy) NSString *transAt;
/** 商户简称*/
@property (nonatomic, copy) NSString *merchantShortName;
/** 交易时间*/
@property (nonatomic, copy) NSString *recCrtTs;
/** 商户号*/
@property (nonatomic, copy) NSString *mchntCd;
/** 终端号*/
@property (nonatomic, copy) NSString *termId;
/** 交易状态*/
@property (nonatomic, copy) NSString *transIn;
/** 交易状态中文名*/
@property (nonatomic, copy) NSString *transName;
/** 支付卡号*/
@property (nonatomic, copy) NSString *priAcctNo;
/** 实到金额*/
@property (nonatomic, copy) NSString *realmoney;
/** 平台流水号*/
@property (nonatomic, copy) NSString *sysTraNo;
/** 服务商名称*/
@property (nonatomic, copy) NSString *instName;
/** 交易类型*/
@property (nonatomic, copy) NSString *platProcCd;
/** 交易类型中文名称*/
@property (nonatomic, copy) NSString *opeName;
/** 支付方式*/
@property (nonatomic, copy) NSString *payChannel;
/** 支付方式中文名*/
@property (nonatomic, copy) NSString *payName;
/** 手续费*/
@property (nonatomic, copy) NSString *merFee;
/** 签约费率*/
@property (nonatomic, copy) NSString *rate;
/** 返回码*/
@property (nonatomic, copy) NSString *respCd;
/** 原交易金额*/
@property (nonatomic, copy) NSString *originalMoney;
/** 优惠减免金额*/
@property (nonatomic, copy) NSString *favorableMoney;
@end
