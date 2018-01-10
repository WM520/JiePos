//
//  IBDatePickerView.h
//  JPDatePickerDemo
//
//  Created by iBlocker on 2017/8/15.
//  Copyright © 2017年 iBlocker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBDateModel.h"

typedef NS_ENUM(NSUInteger, IBDateType) {
    IBDateTypeYMD = 0,  //  年月日
    IBDateTypeYM,       //  年月
};

typedef void (^IBCompleteBlock)(IBDateType type, IBDateModel *dateModel);

@interface IBDatePickerView : UIView

+ (instancetype)ibShowWithCompleteBlock:(IBCompleteBlock)completeBlock;

@end
