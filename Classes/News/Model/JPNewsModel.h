//
//  JPNewsModel.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/25.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPNewsModel : NSObject

@property (nonatomic, assign) NSInteger dealID;
/** 交易结果*/
@property (nonatomic, copy) NSString *transactionResult;
/** 交易金额*/
@property (nonatomic, copy) NSString *transactionMoney;
/** 交易时间*/
@property (nonatomic, copy) NSString *transactionTime;
/** 商户号*/
@property (nonatomic, copy) NSString *tenantsNumber;
/** 商户名称*/
@property (nonatomic, copy) NSString *tenantsName;
/** 支付方式*/
@property (nonatomic, copy) NSString *transactionType;
/** 交易方式*/
@property (nonatomic, copy) NSString *payType;
/** 订单号*/
@property (nonatomic, copy) NSString *orderNumber;
/** 种类编号*/
@property (nonatomic, copy) NSString *serialNumber;
/** 应答码*/
@property (nonatomic, copy) NSString *answerBackCode;
/** 交易类型码*/
@property (nonatomic, copy) NSString *transactionCode;
/** 优惠金额*/
@property (nonatomic, copy) NSString *couponAmt;
/** 应付金额*/
@property (nonatomic, copy) NSString *totalAmt;
/** 未读*/
@property (nonatomic, assign) BOOL unread;

@end
