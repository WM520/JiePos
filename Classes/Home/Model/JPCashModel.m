//
//  JPCashModel.m
//  JiePos
//
//  Created by iBlocker on 2017/8/31.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPCashModel.h"

@implementation JPCashModel
- (NSString *)cashWithdrawal {
    if (!_cashWithdrawal) {
        _cashWithdrawal = @"0";
    }
    return _cashWithdrawal;
}
- (NSString *)cashFee {
    if (!_cashFee) {
        _cashFee = @"0";
    }
    return _cashFee;
}
- (NSString *)realCashWithdrawal {
    if (!_realCashWithdrawal) {
        _realCashWithdrawal = @"0";
    }
    return _realCashWithdrawal;
}
@end

@implementation JPCashListModel

@end
@implementation JPCashNoteModel
//把数组里面带有对象的类型专门按照这个方法，这个格式写出来*****
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    
    return @{
             @"cashList" : JPCashListModel.class,
             };
}
@end
