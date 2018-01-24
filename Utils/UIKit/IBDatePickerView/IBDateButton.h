//
//  IBDateButton.h
//  JPDatePickerDemo
//
//  Created by iBlocker on 2017/8/15.
//  Copyright © 2017年 iBlocker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^IBDateBlock)(BOOL isDay);
@interface IBDateButton : UIButton

@property (nonatomic, assign) BOOL isDay;
@property (nonatomic, copy) IBDateBlock dateBlock;

@end
