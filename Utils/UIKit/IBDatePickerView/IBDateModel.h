//
//  IBDateModel.h
//  JPDatePickerDemo
//
//  Created by iBlocker on 2017/8/15.
//  Copyright © 2017年 iBlocker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBDateModel : NSObject
/** 开始日期*/
@property (nonatomic, copy) NSString *startDate;
/** 结束日期*/
@property (nonatomic, copy) NSString *endDate;
/** 月份*/
@property (nonatomic, copy) NSString *monthCaledar;

@end
