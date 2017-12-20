//
//  JPNewsModel.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/25.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPNewsModel.h"

@implementation JPNewsModel
- (NSInteger)dealID {
    if (!_dealID) {
        _dealID = 0;
    }
    return _dealID;
}

- (NSString *)transactionResult {
    if (!_transactionResult) {
        _transactionResult = @"";
    }
    return _transactionResult;
}

- (NSString *)transactionMoney {
    if (!_transactionMoney) {
        _transactionMoney = @"0";
    }
    return _transactionMoney;
}

- (NSString *)transactionTime {
    if (!_transactionTime) {
        _transactionTime = @"";
    }
    return _transactionTime;
}

- (NSString *)tenantsNumber {
    if (!_tenantsNumber) {
        _tenantsNumber = @"";
    }
    return _tenantsNumber;
}

- (NSString *)tenantsName {
    if (!_tenantsName) {
        _tenantsName = @"";
    }
    return _tenantsName;
}

- (NSString *)transactionType {
    if (!_transactionType) {
        _transactionType = @"";
    }
    return _transactionType;
}

- (NSString *)payType {
    if (!_payType) {
        _payType = @"";
    }
    return _payType;
}

- (NSString *)orderNumber {
    if (!_orderNumber) {
        _orderNumber = @"";
    }
    return _orderNumber;
}

- (NSString *)serialNumber {
    if (!_serialNumber) {
        _serialNumber = @"";
    }
    return _serialNumber;
}

- (NSString *)answerBackCode {
    if (!_answerBackCode) {
        _answerBackCode = @"";
    }
    return _answerBackCode;
}

- (NSString *)transactionCode {
    if (!_transactionCode) {
        _transactionCode = @"";
    }
    return _transactionCode;
}

- (NSString *)couponAmt {
    if (!_couponAmt) {
        _couponAmt = @"0";
    }
    return _couponAmt;
}

- (NSString *)totalAmt {
    if (!_totalAmt) {
        _totalAmt = @"0";
    }
    return _totalAmt;
}

//- (void)setTransactionCode:(NSString *)transactionCode {
//    if (!transactionCode) {
//        transactionCode = @"";
//    }
//    _transactionCode = transactionCode;
//}
//- (void)setTenantsName:(NSString *)tenantsName {
//    if (!tenantsName || tenantsName.length <= 0) {
//        tenantsName = [JPUserEntity sharedUserEntity].merchantName;
//    }
//    _tenantsName = tenantsName;
//}
//- (void)setCouponAmt:(NSString *)couponAmt {
//    if (!couponAmt || couponAmt.length <= 0) {
//        couponAmt = @"0";
//    }
//    _couponAmt = couponAmt;
//}
//- (void)setTotalAmt:(NSString *)totalAmt {
//    if (!totalAmt || totalAmt.length <= 0) {
//        totalAmt = @"0";
//    }
//    _totalAmt = totalAmt;
//}
@end
