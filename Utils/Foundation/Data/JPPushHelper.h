//
//  JPPushHelper.h
//  JPPlistDemo
//
//  Created by Jason_LJ on 2017/6/29.
//  Copyright © 2017年 杰博实. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPPushHelper : NSObject
/** 数据源*/
+ (NSMutableArray *)dataSource;

/** 路径*/
+ (NSString *)filePath;

/** 清除数据*/
+ (void)clearData;

/**
 插入数据
 
 @param transactionResult   交易结果
 @param transactionMoney    交易金额
 @param transactionTime     交易时间
 @param tenantsNumber       交易单号
 @param tenantsName         商户名
 @param transactionType     交易方式
 @param payType             付款方式
 @param orderNumber         订单号
 @param serialNumber        类别码
 @param answerBackCode      返回码
 @param transactionCode     交易码
 @param couponAmt           优惠金额
 @param totalAmt            应付金额
 @param unread              是否未读
 */
+ (void)insertTransactionResult:(NSString *)transactionResult
               transactionMoney:(NSString *)transactionMoney
                transactionTime:(NSString *)transactionTime
                  tenantsNumber:(NSString *)tenantsNumber
                    tenantsName:(NSString *)tenantsName
                transactionType:(NSString *)transactionType
                        payType:(NSString *)payType
                    orderNumber:(NSString *)orderNumber
                   serialNumber:(NSString *)serialNumber
                 answerBackCode:(NSString *)answerBackCode
                transactionCode:(NSString *)transactionCode
                      couponAmt:(NSString *)couponAmt
                       totalAmt:(NSString *)totalAmt
                         unread:(BOOL)unread;

/**
 修改unread值
 
 @param newsModel 模型
 */
+ (void)modifyUnreadWithNewsModel:(JPNewsModel *)newsModel;

/** 修改全部Unread值*/
+ (void)modifyAllUnread;

/** 未读数量*/
+ (NSInteger)badgeNumber;
@end
