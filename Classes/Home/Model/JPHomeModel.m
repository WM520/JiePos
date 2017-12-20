//
//  JPHomeModel.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/19.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPHomeModel.h"
@implementation JPHomeChartModel
- (void)setSumDayTransAt:(NSString *)sumDayTransAt {
    double sumDay = [sumDayTransAt doubleValue];
    _sumDayTransAt = [NSString stringWithFormat:@"%.2lf", sumDay];
}
- (void)setRecCrtDt:(NSString *)recCrtDt {
    NSDate *date = [NSDate dateFromString:recCrtDt withFormat:@"yyyyMMdd"];
    _recCrtDt = [NSDate stringFromDate:date withFormat:@"yyyy/MM/dd"];
}
@end

@implementation JPHomeModel
- (NSString *)curMonthMerFee {
    if (!_curMonthMerFee) {
        _curMonthMerFee = @"0";
    }
    return _curMonthMerFee;
}

- (NSString *)curMonthTransAt {
    if (!_curMonthTransAt) {
        _curMonthTransAt = @"0";
    }
    return _curMonthTransAt;
}

- (NSString *)todayTotal {
    if (!_todayTotal) {
        _todayTotal = @"0";
    }
    return _todayTotal;
}
@end

@implementation IBAdvertisementModel

@end
