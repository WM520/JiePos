//
//  IBDatePicker.m
//  JPDatePicker
//
//  Created by iBlocker on 2017/8/16.
//  Copyright © 2017年 iBlocker. All rights reserved.
//

#import "IBDatePicker.h"

NSString *__nonnull const kCFDatePickerValueNotification = @"kCFDatePickerValueNotification";

@interface IBDatePicker () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) UIPickerView *datePicker;
@property (strong, nonatomic) NSMutableArray *yearArray;
@property (strong, nonatomic) NSMutableArray *monthArray;
@property (strong, nonatomic) NSString *year;
@property (strong, nonatomic) NSString *month;

@end

@implementation IBDatePicker

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //初始时间选择文字
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM月"];
        self.month = [formatter stringFromDate:[NSDate date]];
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"yyyy年"];
        self.year = [formatter1 stringFromDate:[NSDate date]];
//        self.defaultDate = [NSString stringWithFormat:@"%@%@",self.year, self.month];
        
        //设置pickerview初始默认
        NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
        [formatter3 setDateFormat:@"yyyy"];
        NSString *str222 = [formatter3 stringFromDate:[NSDate date]];
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"MM"];
        NSString *str111 = [formatter2 stringFromDate:[NSDate date]];
        
        int row0 = [str222 intValue];
        int row1 = [str111 intValue];
        
        [self.datePicker selectRow:row0 - self.startYear - 1 inComponent:0 animated:NO];
        [self.datePicker selectRow:row1 - 1 inComponent:1 animated:NO];
        
        [self addSubview:self.datePicker];
    }
    return self;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.yearArray.count;
    } else {
        return self.monthArray.count;
    }
}

#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return  self.yearArray[row];
    } else {
        return  self.monthArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *year = nil;
    NSString *month = nil;
    if (component == 0) {
        self.year = self.yearArray[row];
        year = [self pickerView:pickerView titleForRow:row forComponent:component];
        //  比较选择的年月和当前时间
    } else {
        self.month = self.monthArray[row];
        month = [self pickerView:pickerView titleForRow:row forComponent:component];
        //  比较选择的年月和当前时间
    }
    //  获取选择的年月
    NSString *selectYear = nil;
    NSString *selectMonth = nil;
    if (self.year && month) {
        selectYear = self.year;
        selectMonth = month;
    } else {
        selectYear = year;
        selectMonth = self.month;
    }
//    JPLog(@"%@%@", selectYear, selectMonth);
    NSInteger select = [[NSDate stringFromDate:[NSDate dateFromString:[NSString stringWithFormat:@"%@%@", selectYear, selectMonth] withFormat:@"yyyy年MM月"] withFormat:@"yyyyMM"] integerValue];
    NSInteger now = [[NSDate stringFromDate:[NSDate date] withFormat:@"yyyyMM"] integerValue];
//    JPLog(@"%ld ---- %ld", select, now);
    if (select < now) {
        //  选择的时间在现在之前
    } else if (select == now) {
        //  选择的时间就是现在
    } else {
        //  选择的时间在现在之后
        NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
        [formatter3 setDateFormat:@"yyyy"];
        NSString *str222 = [formatter3 stringFromDate:[NSDate date]];
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"MM"];
        NSString *str111 = [formatter2 stringFromDate:[NSDate date]];
        
        int row0 = [str222 intValue];
        int row1 = [str111 intValue];
        
        [self.datePicker selectRow:row0 - self.startYear - 1 inComponent:0 animated:NO];
        [self.datePicker selectRow:row1 - 1 inComponent:1 animated:YES];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCFDatePickerValueNotification object:[NSString stringWithFormat:@"%@%@", selectYear, selectMonth]];
}

#pragma mark - Setter or Getter
- (int)startYear {
    if (!_startYear) {
        _startYear = 2000;
    }
    return _startYear;
}

- (int)endYear {
    if (!_endYear) {
        _endYear = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyy"].intValue;
    }
    return _endYear;
}

- (UIPickerView *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _datePicker.backgroundColor = [UIColor clearColor];
        _datePicker.dataSource = self;
        _datePicker.delegate = self;
    }
    return _datePicker;
}

- (NSMutableArray *)yearArray {
    if (!_yearArray) {
        _yearArray = @[].mutableCopy;
        for (int i = self.startYear + 1; i <= self.endYear; i ++) {
            NSString *str = [NSString stringWithFormat:@"%d%@", i, @"年"];
            [_yearArray addObject:str];
        }
    }
    return _yearArray;
}

- (NSMutableArray *)monthArray {
    if (!_monthArray) {
        _monthArray = @[].mutableCopy;
        for (int i = 1; i < 13; i ++) {
            NSString *str = [NSString stringWithFormat:@"%d%@", i, @"月"];
            [_monthArray addObject:str];
        }
    }
    return _monthArray;
}

@end
