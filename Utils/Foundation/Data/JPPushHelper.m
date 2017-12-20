//
//  JPPushHelper.m
//  JPPlistDemo
//
//  Created by Jason_LJ on 2017/6/29.
//  Copyright © 2017年 杰博实. All rights reserved.
//

#import "JPPushHelper.h"

@implementation JPPushHelper
/** 数据源*/
+ (NSMutableArray *)dataSource {
    NSString *filePath = [self filePath];
    return [NSMutableArray arrayWithContentsOfFile:filePath];
}

/** 清除数据*/
+ (void)clearData {
    NSMutableArray *mutableArr = [self dataSource];
    [mutableArr removeAllObjects];
    [self saveData:mutableArr];
}

/** 路径*/
+ (NSString *)filePath {
    NSString *path = NSHomeDirectory();
    NSString *docPath  = [path stringByAppendingPathComponent:@"Documents"];
    return [docPath stringByAppendingPathComponent:@"pushmsg.plist"];
}

/** 保存数据*/
+ (void)saveData:(NSMutableArray *)data {
    [data writeToFile:[self filePath] atomically:YES];
}

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
                         unread:(BOOL)unread {
    
    if (![tenantsNumber isEqualToString:[JPUserEntity sharedUserEntity].merchantNo]) {
        //  如果登陆的账号商户号和推送消息携带的商户号不一致，不执行插入操作
        return;
    }
    NSMutableArray *data = nil;
    if ([[self dataSource] count] > 0) {
        data = [self dataSource];
    } else {
        data = @[].mutableCopy;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:transactionResult forKey:jp_transactionResult];
    [params setObject:transactionMoney forKey:jp_transactionMoney];
    [params setObject:transactionTime forKey:jp_transactionTime];
    [params setObject:tenantsNumber forKey:jp_tenantsNumber];
    if (!tenantsName || tenantsName.length <= 0) {
        if ([JPUserEntity sharedUserEntity].merchantName) {
            [params setObject:[JPUserEntity sharedUserEntity].merchantName forKey:jp_tenantsName];
        }
    } else {
        [params setObject:tenantsName forKey:jp_tenantsName];
    }
    
    [params setObject:transactionType forKey:jp_transactionType];
    [params setObject:payType forKey:jp_payType];
    [params setObject:orderNumber forKey:jp_orderNumber];
    [params setObject:serialNumber forKey:jp_serialNumber];
    [params setObject:answerBackCode forKey:jp_answerBackCode];
    
    if (transactionCode == nil || transactionCode.length <= 0) {
        [params setObject:@"A00007" forKey:jp_transactionCode];
    } else {
        [params setObject:transactionCode forKey:jp_transactionCode];
    }
    
    if (couponAmt == nil || couponAmt.length <= 0) {
        [params setObject:@"0" forKey:jp_couponAmt];
    } else {
        [params setObject:couponAmt forKey:jp_couponAmt];
    }
    
    if (totalAmt == nil || totalAmt.length <= 0) {
        [params setObject:@"0" forKey:jp_totalAmt];
    } else {
        [params setObject:totalAmt forKey:jp_totalAmt];
    }
    [params setObject:@(unread) forKey:jp_unread];
    
    for (NSDictionary *dic in data) {
        if ([dic[@"orderNumber"] isEqualToString:orderNumber] && [dic[@"transactionTime"] isEqualToString:transactionTime]) {
            JPLog(@"已存在");
            return;
        }
    }
    if (data.count >= 50) {
        [data removeObjectAtIndex:0];
    }
    [data addObject:params];
    [self saveData:data];
}

/**
 修改unread值

 @param newsModel 模型
 */
+ (void)modifyUnreadWithNewsModel:(JPNewsModel *)newsModel {
    if (![newsModel.tenantsNumber isEqualToString:[JPUserEntity sharedUserEntity].merchantNo]) {
        //  如果登陆的账号商户号和推送消息携带的商户号不一致，不执行插入操作
        return;
    }
    NSMutableArray *data = [self dataSource];
    NSMutableDictionary *params = @{}.mutableCopy;
    
    [params setObject:newsModel.answerBackCode forKey:jp_answerBackCode];
    [params setObject:newsModel.couponAmt forKey:jp_couponAmt];
    [params setObject:newsModel.orderNumber forKey:jp_orderNumber];
    [params setObject:newsModel.payType forKey:jp_payType];
    [params setObject:newsModel.serialNumber forKey:jp_serialNumber];
    [params setObject:newsModel.tenantsName forKey:jp_tenantsName];
    [params setObject:newsModel.tenantsNumber forKey:jp_tenantsNumber];
    [params setObject:newsModel.totalAmt forKey:jp_totalAmt];
    [params setObject:newsModel.transactionCode forKey:jp_transactionCode];
    [params setObject:newsModel.transactionMoney forKey:jp_transactionMoney];
    [params setObject:newsModel.transactionResult forKey:jp_transactionResult];
    [params setObject:newsModel.transactionTime forKey:jp_transactionTime];
    [params setObject:newsModel.transactionType forKey:jp_transactionType];
    [params setObject:@(newsModel.unread) forKey:jp_unread];
    
    if (newsModel.unread == YES) {
        NSInteger index = [data indexOfObject:params];
        [params setObject:@(NO) forKey:jp_unread];
        [data replaceObjectAtIndex:index withObject:params];
        [self saveData:data];
    }
}

/** 修改全部Unread值*/
+ (void)modifyAllUnread {
    NSMutableArray *data = [self dataSource];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        JPLog(@"%@ - %ld", obj, idx);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)obj;
            if ([dic[jp_unread] boolValue] == YES) {
                //  存在该dic  去修改unread值
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
                [params setObject:@(NO) forKey:jp_unread];
                
                [data replaceObjectAtIndex:idx withObject:params];
                [self saveData:data];
            }
        }
    }];
}

/** 未读数量*/
+ (NSInteger)badgeNumber {
    
    __block NSInteger badgeNo = 0;
    NSMutableArray *data = [self dataSource];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        JPLog(@"%@ - %ld", obj, idx);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)obj;
            if ([dic[jp_unread] boolValue] == YES) {
                badgeNo ++;
            }
        }
    }];
    return badgeNo;
}
@end
