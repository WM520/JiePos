//
//  IBDatePicker.h
//  JPDatePicker
//
//  Created by iBlocker on 2017/8/16.
//  Copyright © 2017年 iBlocker. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *__nonnull const kCFDatePickerValueNotification;

@interface IBDatePicker : UIView
/** 开始年份  Default is 2001*/
@property (nonatomic, assign) int startYear;
/** 结束年份 Default is current*/
@property (nonatomic, assign) int endYear;
@end
