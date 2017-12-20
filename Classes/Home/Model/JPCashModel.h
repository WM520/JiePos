//
//  JPCashModel.h
//  JiePos
//
//  Created by iBlocker on 2017/8/31.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPCashModel : NSObject
/** 商户号*/
@property (nonatomic, copy) NSString *merchantNo;
/** 可提现时间段*/
@property (nonatomic, copy) NSString *cashWithdrawalTime;
/** 起提金额*/
@property (nonatomic, copy) NSString *enabledCashAmount;
/** 可提现金额*/
@property (nonatomic, copy) NSString *cashWithdrawal;
/** 提现手续费*/
@property (nonatomic, copy) NSString *cashFee;
/** 实际可提现金额*/
@property (nonatomic, copy) NSString *realCashWithdrawal;
/** 是否可提现*/
@property (nonatomic, copy) NSString *isCash;
/** 可提现开始时间*/
@property (nonatomic, copy) NSString *beginTime;
/** 可提现结束时间*/
@property (nonatomic, copy) NSString *endTime;
/** 垫资日息*/
@property (nonatomic, copy) NSString *loan;
/** 固定费用*/
@property (nonatomic, copy) NSString *withdraw;
/** 提现流水号*/
@property (nonatomic, copy) NSString *cashFlow;
/** 提示信息*/
@property (nonatomic, copy) NSString *message;
@end

@interface JPCashListModel : NSObject
/** 提现金额*/
@property (nonatomic, copy) NSString *totalAmount;
/** 提现状态*/
@property (nonatomic, copy) NSString *status;
/** 商户号*/
@property (nonatomic, copy) NSString *merchantNo;
/** 实到金额*/
@property (nonatomic, copy) NSString *realAmount;
/** 提现手续费*/
@property (nonatomic, copy) NSString *cashFee2;
/** 提现批次号*/
@property (nonatomic, copy) NSString *batchNo;
/** 垫资日息*/
@property (nonatomic, copy) NSString *cashFee1;
/** 提现时间*/
@property (nonatomic, copy) NSString *cashTime;
@end
@interface JPCashNoteModel : NSObject
/** 提现记录列表*/
@property (nonatomic, strong) NSArray *cashList;
/** 最新一条的时间*/
@property (nonatomic, copy) NSString *lastTime;
/** 总实到金额*/
@property (nonatomic, copy) NSString *realAmount;
/** 总笔数*/
@property (nonatomic, copy) NSString *total;
/** 总提现金额*/
@property (nonatomic, copy) NSString *totalAmount;
@end
