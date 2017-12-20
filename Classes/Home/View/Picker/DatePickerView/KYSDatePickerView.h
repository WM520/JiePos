//
//  KYSDatePickerView.h
//  KYSKitDemo
//
//  Created by 康永帅 on 2016/11/8.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^KYSDatePickerViewCompleteSelectedBlock)(NSDate *date);

@interface KYSDatePickerView : UIView

@property (nonatomic) UIDatePickerMode datePickerMode;//默认 UIDatePickerModeDate
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;
@property(nonatomic,copy)KYSDatePickerViewCompleteSelectedBlock selectedBlock;//选择完成回调
+ (instancetype)KYSShowWithCompleteBlock:(KYSDatePickerViewCompleteSelectedBlock)selectedBlock;

- (instancetype)initWithCompleteBlock:(KYSDatePickerViewCompleteSelectedBlock)selectedBlock;

- (instancetype)init;

- (void)KYSShow;

- (void)KYSHide;

- (void)KYSReloadData;

/**
 if ([_datePicker.date earlierDate:_datePicker.minimumDate]) {
 _datePicker.date = _datePicker.minimumDate;
 [IBProgressHUD showInfoWithStatus:@"最早只能选择30天以前！"];
 }
 */
@end
