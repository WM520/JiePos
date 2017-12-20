//
//  IBHomeRequest.m
//  JiePos
//
//  Created by iBlocker on 2017/8/29.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "IBHomeRequest.h"

@implementation IBHomeRequest

/**
 Banner数据

 @param account 账户
 @param callback 回调
 */
+ (void)bannerDataWithAccount:(NSString *)account
                     callback:(JPNetCallback)callback {
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    
    [self postWithServiceCode:@"JBB16"
                      account:account
                         data:data
                     callback:^(NSString *code, NSString *msg, id resp) {
        callback (code, msg, resp);
    }];
}

/**
 首页曲线图、交易金额汇总

 @param account 账号
 @param startDate 开始日期
 @param callback 回调
 */
+ (void)getCurveWithAccount:(NSString *)account
                  startDate:(NSString *)startDate
                   callback:(JPNetCallback)callback {
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:startDate forKey:@"startDate"];
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    
    [self postWithServiceCode:@"JBB31" account:account data:data callback:^(NSString *code, NSString *msg, id resp) {
        callback (code, msg, resp);
    }];
}

/**
 当月累计交易金额和手续费

 @param account 账号
 @param callback 回调
 */
+ (void)getHomeDataWithAccount:(NSString *)account
                      callback:(JPNetCallback)callback {
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    
    [self postWithServiceCode:@"JBB30" account:account data:data callback:^(NSString *code, NSString *msg, id resp) {
        callback (code, msg, resp);
    }];
}

/**
 获取二维码
 
 @param account 账号
 @param merchantId 商户标识
 @param callback 回调
 */
+ (void)getQrcodeWithAccount:(NSString *)account
                  merchantId:(NSInteger)merchantId
                    callback:(JPNetCallback)callback {
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:@(merchantId) forKey:@"merchantId"];
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    
    [self postWithServiceCode:@"JBB24" account:account data:data callback:^(NSString *code, NSString *msg, id resp) {
        callback (code, msg, resp);
    }];
}

/**
 可提现金额查询

 @param account 账号
 @param merchantNo 商户号
 @param callback 回调
 */
+ (void)canGetCashWithAccount:(NSString *)account
                   merchantNo:(NSString *)merchantNo
                     callback:(JPNetCallback)callback {
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:merchantNo forKey:@"merchantNo"];
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    
    [self postWithServiceCode:@"JBB12" account:account data:data callback:^(NSString *code, NSString *msg, id resp) {
        callback (code, msg, resp);
    }];
}

/**
 提现申请

 @param account         账号
 @param merchantNo      商户号
 @param cashWithdrawal  可提现金额
 @param beginTime       提现开始时间
 @param endTime         提现结束时间
 @param loan            垫资日息
 @param withdraw        固定费用
 @param cashFlow        提现流水
 @param withdrawPwd     提现密码
 @param callback        回调
 */
+ (void)getCashWithAccount:(NSString *)account
                merchantNo:(NSString *)merchantNo
            cashWithdrawal:(NSString *)cashWithdrawal
                 beginTime:(NSString *)beginTime
                   endTime:(NSString *)endTime
                      loan:(NSString *)loan
                  withdraw:(NSString *)withdraw
                  cashFlow:(NSString *)cashFlow
               withdrawPwd:(NSString *)withdrawPwd
                  callback:(JPNetCallback)callback {
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:merchantNo forKey:@"merchantNo"];
    [dataDic setObject:cashWithdrawal forKey:@"cashWithdrawal"];
    [dataDic setObject:beginTime forKey:@"beginTime"];
    [dataDic setObject:endTime forKey:@"endTime"];
    [dataDic setObject:loan forKey:@"loan"];
    [dataDic setObject:withdraw forKey:@"withdraw"];
    [dataDic setObject:cashFlow forKey:@"cashFlow"];
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    
    [self postWithServiceCode:@"JBB13" account:account data:data callback:^(NSString *code, NSString *msg, id resp) {
        callback (code, msg, resp);
    }];
}

/**
 提现记录查询

 @param account     账号
 @param beginDate   查询开始日期
 @param endDate     查询结束日期
 @param month       查询月份
 @param lastTime    最新一条的时间
 @param page        当前页码
 @param callback    回调
 */
+ (void)getCashNoteWithAccount:(NSString *)account
                     beginDate:(NSString *)beginDate
                       endDate:(NSString *)endDate
                         month:(NSString *)month
                      lastTime:(NSString *)lastTime
                          page:(NSInteger)page
                      callback:(JPNetCallback)callback {
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    if (beginDate) {
        [dataDic setObject:beginDate forKey:@"beginDate"];
    }
    if (endDate) {
        [dataDic setObject:endDate forKey:@"endDate"];
    }
    if (lastTime) {
        [dataDic setObject:lastTime forKey:@"lastTime"];
    }
    if (month) {
        [dataDic setObject:month forKey:@"month"];
    }
    if (page <= 1) {
        page = 1;
    }
    [dataDic setObject:@(page) forKey:@"page"];
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    
    [self postWithServiceCode:@"JBB14" account:account data:data callback:^(NSString *code, NSString *msg, id resp) {
        callback (code, msg, resp);
    }];
}

/**
 交易流水查询条件初始化

 @param account 账号
 @param merchantId 商户标识
 @param callback 回调
 */
+ (void)initializeTransactionFlowConditionsWithAccount:(NSString *)account
                                            merchantId:(NSInteger)merchantId
                                              callback:(JPNetCallback)callback {
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:@(merchantId) forKey:@"merchantId"];
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    
    [self postWithServiceCode:@"JBB33" account:account data:data callback:^(NSString *code, NSString *msg, id resp) {
        callback (code, msg, resp);
    }];
}

/**
 交易流水列表

 @param merchantId      商户唯一标识
 @param account         登陆账号
 @param mercFlag        0:不选择下拉框，1：选择下拉框条件，不可为空
 @param merchantNo      商户号
 @param startTime       流水开始日期
 @param endTime         流水结束日期
 @param type            交易状态
 @param payChannel      支付方式
 @param currentPageTime 上一页的最后一行数据的交易日期：20170326162749
 @param startRow        开始行数
 @param msgFlag         1:消息通知的交易列表；否则，为交易查询列表
 @param callback        回调
 */
+ (void)getTransactionFlowListWithMerchantId:(NSInteger)merchantId
                                     account:(NSString *)account
                                    mercFlag:(NSInteger)mercFlag
                                  merchantNo:(NSString *)merchantNo
                                   startTime:(NSString *)startTime
                                     endTime:(NSString *)endTime
                                        type:(NSString *)type
                                  payChannel:(NSString *)payChannel
                             currentPageTime:(NSString *)currentPageTime
                                    startRow:(NSInteger)startRow
                                     msgFlag:(NSInteger)msgFlag
                                    callback:(JPNetCallback)callback {
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:@(merchantId) forKey:@"merchantId"];
    [dataDic setObject:account forKey:@"account"];
    [dataDic setObject:@(mercFlag) forKey:@"mercFlag"];
    [dataDic setObject:merchantNo forKey:@"merchantNo"];
    [dataDic setObject:startTime forKey:@"startTime"];
    [dataDic setObject:endTime forKey:@"endTime"];
    [dataDic setObject:type forKey:@"type"];
    [dataDic setObject:payChannel forKey:@"payChannel"];
    [dataDic setObject:currentPageTime forKey:@"currentPageTime"];
    [dataDic setObject:@(startRow) forKey:@"startRow"];
    [dataDic setObject:@(msgFlag) forKey:@"msgFlag"];
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    
    [self postWithServiceCode:@"JBB28" account:account data:data callback:^(NSString *code, NSString *msg, id resp) {
        callback (code, msg, resp);
    }];
}
@end
