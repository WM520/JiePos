//
//  IBMenuView.h
//  JPDatePicker
//
//  Created by iBlocker on 2017/8/16.
//  Copyright © 2017年 iBlocker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^IBSelectBlock)(BOOL isLeft);
@interface IBMenuView : UIView

@property (nonatomic, assign) BOOL isLeft;
@property (nonatomic, copy) IBSelectBlock selectBlock;
@property (nonatomic, copy) NSString *leftDate;
@property (nonatomic, copy) NSString *rightDate;

@end
