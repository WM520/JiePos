//
//  JPNewsHeaderView.m
//  JiePos
//
//  Created by Jason_LJ on 2017/5/26.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPNewsHeaderView.h"

@interface JPNewsHeaderView ()
@property (nonatomic, strong) UILabel *timeLab;
@end
@implementation JPNewsHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        if (!self.timeLab) {
            self.timeLab = [UILabel new];
            self.timeLab.text = @"15:30";
            self.timeLab.textAlignment = NSTextAlignmentCenter;
            self.timeLab.textColor = [UIColor whiteColor];
            self.timeLab.font = [UIFont systemFontOfSize:JPRealValue(28)];
            self.timeLab.layer.cornerRadius = JPRealValue(10);
            self.timeLab.layer.masksToBounds = YES;
            self.timeLab.layer.borderColor = [UIColor whiteColor].CGColor;
            self.timeLab.layer.borderWidth = 1;
            [self.contentView addSubview:self.timeLab];
        }
        weakSelf_declare;
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.contentView.mas_centerX);
            make.centerY.equalTo(weakSelf.contentView.mas_centerY).offset(JPRealValue(-15));
            //  先写个0 后面setter方法会根据文本宽度更新
            make.size.mas_equalTo(CGSizeMake(0, JPRealValue(32)));
        }];
    }
    return self;
}

- (void)setTimeString:(NSString *)timeString {
    //  今天HH:mm、昨天HH:mm、其他显示MM-dd HH:mm
//    //  消息的时间
//    NSDate *newsDate = [NSDate dateFromString:timeString withFormat:@"yyyy-MM-dd HH:mm:ss"];
//    //  消息日期    yyyy-MM-dd
//    NSDate *newsDate2 = [NSDate dateFromString:[NSDate stringFromDate:newsDate withFormat:@"yyyy-MM-dd"] withFormat:@"yyyy-MM-dd"];
//    //  消息时间 年月日时分秒
//    NSDate *newsDate3 = [NSDate dateFromString:[NSDate stringFromDate:newsDate withFormat:@"yyyy-MM-dd HH:mm:ss"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
//    JPLog(@"newsDate3:%@", [NSDate stringFromDate:newsDate3 withFormat:@"yyyy-MM-dd HH"]);
//    
//    //  今天日期    yyyy-MM-dd
//    NSDate *todayDate = [NSDate dateFromString:[NSDate stringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd"] withFormat:@"yyyy-MM-dd"];
//    
//    //  昨天日期    yyyy-MM-dd
//    NSDate *yesterdayDate = [NSDate dateFromString:[NSDate stringFromDate:[NSDate getYesterday] withFormat:@"yyyy-MM-dd"] withFormat:@"yyyy-MM-dd"];
//    //  昨天时间    年月日时分秒
//    NSDate *yesterdayDate2 = [NSDate dateFromString:[NSDate stringFromDate:[NSDate getYesterday] withFormat:@"yyyy-MM-dd HH:mm:ss"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
//    JPLog(@"newsDate:%@ - todayHHmmss:%@ - yesterday:%@", timeString, [NSDate stringFromDate:todayDate withFormat:@"yyyy-MM-dd HH:mm:ss"], [NSDate stringFromDate:yesterdayDate withFormat:@"yyyy-MM-dd"]);
//    
//    
//    JPLog(@"todayDate - %ld", (long)[newsDate2 compare:todayDate]);
//    JPLog(@"yesterdayDate - %ld", (long)[newsDate2 compare:yesterdayDate]);
//    NSString *resultString = nil;
//    if ([newsDate2 compare:todayDate]) {
//        //  今天
//        resultString = [NSDate stringFromDate:newsDate3 withFormat:@"HH:mm"];
//    } else if ([newsDate2 compare:yesterdayDate]) {
//        //  昨天
//        resultString = [NSString stringWithFormat:@"昨天 %@", [NSDate stringFromDate:yesterdayDate2 withFormat:@"HH:mm"]];
//    } else {
//        //  昨天之前
//        resultString = [NSDate stringFromDate:newsDate3 withFormat:@"MM-dd HH:mm"];
//    }
    
    NSString *resultString = [self getTime:timeString];
    CGRect rect = [resultString boundingRectWithSize:CGSizeMake(MAXFLOAT, JPRealValue(28)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:JPRealValue(28)]} context:nil];
    float width = rect.size.width + JPRealValue(24);
    weakSelf_declare;
    [self.timeLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(width + 5, JPRealValue(40)));
    }];
    self.timeLab.text = resultString;
}

- (NSString *)getTime:(NSString *)newsTime {
    NSString *newsDayString = [newsTime substringToIndex:10];
    
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:- (24 * 60 * 60)];
    NSString *yesterdayString = [NSDate stringFromDate:yesterday withFormat:@"yyyy-MM-dd"];
    
    NSDate *today = [NSDate date];
    NSString *todayString = [NSDate stringFromDate:today withFormat:@"yyyy-MM-dd"];
    
    NSString *newsHours = [NSDate stringFromDate:[NSDate dateFromString:newsTime withFormat:@"yyyy-MM-dd HH:mm:ss"] withFormat:@"HH:mm"];
    
    if ([newsDayString isEqualToString:todayString]) {
        return newsHours;
    } else if ([newsDayString isEqualToString:yesterdayString]) {
        return [NSString stringWithFormat:@"昨天 %@", newsHours];
    } else {
        return [NSDate stringFromDate:[NSDate dateFromString:newsTime withFormat:@"yyyy-MM-dd HH:mm:ss"] withFormat:@"MM-dd HH:mm"];
    }
}

@end
