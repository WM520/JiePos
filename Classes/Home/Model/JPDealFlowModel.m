//
//  JPDealFlowModel.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/20.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPDealFlowModel.h"

@implementation JPDealFlowModel
- (NSString *)transAt {
    if (!_transAt) {
        _transAt = @"0";
    }
    return _transAt;
}
- (NSString *)merchantShortName {
    if (!_merchantShortName) {
        _merchantShortName = @"";
    }
    return _merchantShortName;
}
- (NSString *)recCrtTs {
    if (!_recCrtTs) {
        _recCrtTs = @"";
    }
    return _recCrtTs;
}
- (NSString *)mchntCd {
    if (!_mchntCd) {
        _mchntCd = @"";
    }
    return _mchntCd;
}
- (NSString *)termId {
    if (!_termId) {
        _termId = @"";
    }
    return _termId;
}
- (NSString *)transIn {
    if (!_transIn) {
        _transIn = @"";
    }
    return _transIn;
}
- (NSString *)transName {
    if (!_transName) {
        _transName = @"";
    }
    return _transName;
}
- (NSString *)priAcctNo {
    if (!_priAcctNo) {
        _priAcctNo = @"";
    }
    return _priAcctNo;
}
- (NSString *)realmoney {
    if (!_realmoney) {
        _realmoney = @"0";
    }
    return [NSString stringWithFormat:@"%.2lf", [_realmoney doubleValue]];
}
- (NSString *)sysTraNo {
    if (!_sysTraNo) {
        _sysTraNo = @"";
    }
    return _sysTraNo;
}
- (NSString *)instName {
    if (!_instName) {
        _instName = @"";
    }
    return _instName;
}
- (NSString *)platProcCd {
    if (!_platProcCd) {
        _platProcCd = @"";
    }
    return _platProcCd;
}
- (NSString *)opeName {
    if (!_opeName) {
        _opeName = @"";
    }
    return _opeName;
}
- (NSString *)payChannel {
    if (!_payChannel) {
        _payChannel = @"";
    }
    return _payChannel;
}
- (NSString *)payName {
    if (!_payName) {
        _payName = @"";
    }
    return _payName;
}
- (NSString *)merFee {
    if (!_merFee) {
        _merFee = @"";
    }
    return _merFee;
}
- (NSString *)rate {
    if (!_rate) {
        _rate = @"";
    }
    return _rate;
}
- (NSString *)respCd {
    if (!_respCd) {
        _respCd = @"";
    }
    return _respCd;
}
- (NSString *)originalMoney {
    if (!_originalMoney) {
        _originalMoney = @"0";
    }
    return _originalMoney;
}
- (NSString *)favorableMoney {
    if (!_favorableMoney) {
        _favorableMoney = @"0";
    }
    return _favorableMoney;
}
@end
