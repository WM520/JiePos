//
//  IBDatePickerView.m
//  JPDatePickerDemo
//
//  Created by iBlocker on 2017/8/15.
//  Copyright © 2017年 iBlocker. All rights reserved.
//

#import "IBDatePickerView.h"
#import "IBDateButton.h"
#import "IBMenuView.h"
#import "IBDatePicker.h"

#define viewHeight 300

@interface IBDatePickerView ()
@property (nonatomic, copy) IBCompleteBlock completeBlock;//选择完成回调
@property (nonatomic, weak) UIWindow *window;
@property (nonatomic, strong) UIView *selectView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) IBMenuView *menuView;
@property (nonatomic, strong) UIDatePicker *leftPicker;
@property (nonatomic, strong) IBDatePicker *rightPicker;
@property (nonatomic, strong) UILabel *ymLab;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation IBDatePickerView

+ (instancetype)ibShowWithCompleteBlock:(IBCompleteBlock)completeBlock {
    IBDatePickerView *datePickerView = [[IBDatePickerView alloc] init];
    datePickerView.completeBlock = completeBlock;
    [datePickerView ibShow];
    return datePickerView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.frame = self.window.bounds;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
//        [self addGestureRecognizer:tap];
        
        //黑色半透明北京
        _selectView = [[UIView alloc] init];
        _selectView.backgroundColor = [UIColor whiteColor];
        _selectView.frame = CGRectMake(0, self.frame.size.height - viewHeight, self.frame.size.width, viewHeight);
        _selectView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_selectView];
        
        //左侧取消按钮
        UIButton *btn1 = [[UIButton alloc] init];
        btn1.tag = 1;
        btn1.frame = CGRectMake(15, 0, 50, 40);
        [btn1 setTitle:@"取消" forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [btn1 setTitleColor:JPBaseColor forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:btn1];
        
        //右侧确定按钮
        UIButton *btn2 = [[UIButton alloc] init];
        btn2.tag = 2;
        btn2.frame = CGRectMake(self.frame.size.width - 65, 0, 50, 40);
        [btn2 setTitle:@"完成" forState:UIControlStateNormal];
        btn2.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [btn2 setTitleColor:JPBaseColor forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:btn2];
        
        IBDateButton *dateButton = [[IBDateButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 - 40, 7, 80, 26)];
        self.scrollView.contentOffset = CGPointMake(self.frame.size.width * (1 - dateButton.isDay), 0);
        
        __weak typeof(self) weakSelf = self;
        dateButton.dateBlock = ^(BOOL isDay) {
            JPLog(@"当前状态 - isDay - %@", isDay == 1 ? @"按日查询" : @"按月查询");
            
            weakSelf.scrollView.contentOffset = CGPointMake(weakSelf.frame.size.width * (1 - isDay), 0);
        };
        [_selectView addSubview:dateButton];
        
        [_selectView addSubview:self.scrollView];
        [self.scrollView addSubview:self.leftView];
        [self.scrollView addSubview:self.rightView];
        [self.leftView addSubview:self.menuView];
        self.menuView.selectBlock = ^(BOOL isLeft) {
//            JPLog(@"%@", isLeft ? @"左边" : @"右边");
            weakSelf.leftPicker.date = [NSDate date];
            if (!isLeft) {
                NSDate *beginDate = [NSDate dateFromString:weakSelf.menuView.leftDate withFormat:@"yyyy-MM-dd"];
                NSDate *maxDate = [NSDate ThirtydaysLaterThanDate:beginDate];
                weakSelf.leftPicker.minimumDate = beginDate;
                weakSelf.leftPicker.maximumDate = maxDate;
                
            } else {
                weakSelf.leftPicker.minimumDate = [NSDate dateFromString:@"2000-01-01" withFormat:@"yyyy-MM-dd"];
            }
        };
        [self.leftView addSubview:self.leftPicker];
        
        [self.rightView addSubview:self.ymLab];
        [self.rightView addSubview:self.lineView];
        [self.rightView addSubview:self.rightPicker];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:kCFDatePickerValueNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            
            NSDate *date = [NSDate dateFromString:note.object withFormat:@"yyyy年MM月"];
            if ([date compareToDate:[NSDate date]]) {
                date = [NSDate date];
            }
            weakSelf.ymLab.text = [NSDate stringFromDate:date withFormat:@"yyyy-MM"];
        }];

    }
    return self;
}

- (void)ibShow {
    [self.window addSubview:self];
    self.selectView.frame = [self ib_hideSelectViewFrame];
    [UIView animateWithDuration:0.5 animations:^{
        self.selectView.frame = [self ib_showSelectViewFrame];
    } completion:^(BOOL finished) {
        self.selectView.frame = [self ib_showSelectViewFrame];
    }];
}

- (void)ibHidden {
    [UIView animateWithDuration:0.5 animations:^{
        self.selectView.frame = [self ib_hideSelectViewFrame];
    } completion:^(BOOL finished) {
        self.selectView.frame = [self ib_hideSelectViewFrame];
        [self removeFromSuperview];
    }];
}

- (CGRect)ib_showSelectViewFrame {
    return CGRectMake(0, CGRectGetHeight(self.frame) - viewHeight, CGRectGetWidth(self.frame), viewHeight);
}

- (CGRect)ib_hideSelectViewFrame {
    return CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), viewHeight);
}

// 获取当前处于activity状态的Window
- (UIWindow *)window {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows) {
            if(tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}
#pragma mark - Action
- (void)tap {
    [self ib_getSelected];
    [self ibHidden];
}

- (void)btnAction:(UIButton *)btn {
    if (2 == btn.tag) {
        [self ib_getSelected];
    } else if (1 == btn.tag) {
        
    }
    [self ibHidden];
}

#pragma mark - Priate
- (void)ib_getSelected {
    
    if (self.scrollView.contentOffset.x / self.frame.size.width == 0) {
        //  按日查询
        IBDateModel *dateModel = [IBDateModel new];
        dateModel.startDate = self.menuView.leftDate;
        dateModel.endDate = self.menuView.rightDate;
        
        if (self.completeBlock) {
            self.completeBlock(IBDateTypeYMD, dateModel);
        }
    } else {
        //  按月查询
        IBDateModel *dateModel = [IBDateModel new];
        dateModel.monthCaledar = self.ymLab.text;
        
        if (self.completeBlock) {
            self.completeBlock(IBDateTypeYM, dateModel);
        }
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){0, 40, self.frame.size.width, viewHeight - 40}];
        _scrollView.contentSize = CGSizeMake(self.frame.size.width * 2, viewHeight - 40);
        //设置是否可以回弹(上下左右)(默认yes)
        _scrollView.bounces = YES;
        //设置滚动条的风格
        _scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        //打开翻页效果
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
        //设置代理
//        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [[UIView alloc] initWithFrame:(CGRect){0, 0, self.frame.size.width, viewHeight - 40}];
    }
    return _leftView;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:(CGRect){self.frame.size.width, 0, self.frame.size.width, viewHeight - 40}];
    }
    return _rightView;
}

- (IBMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[IBMenuView alloc] initWithFrame:(CGRect){0, 0, self.frame.size.width, 50}];
        _menuView.leftDate = [NSDate stringFromDate:self.leftPicker.date withFormat:@"yyyy-MM-dd"];
        _menuView.rightDate = [NSDate stringFromDate:self.leftPicker.date withFormat:@"yyyy-MM-dd"];
    }
    return _menuView;
}

- (UIDatePicker *)leftPicker {
    if (!_leftPicker) {
        _leftPicker = [[UIDatePicker alloc] init];
        _leftPicker.backgroundColor = [UIColor whiteColor];
        _leftPicker.datePickerMode = UIDatePickerModeDate;
        _leftPicker.minimumDate = [NSDate dateFromString:@"2000-01-01" withFormat:@"yyyy-MM-dd"];
        _leftPicker.maximumDate = [NSDate date];
        _leftPicker.frame = CGRectMake(0, 50, self.frame.size.width, 216);
        [_leftPicker addTarget:self action:@selector(dateValueChange:)forControlEvents:UIControlEventValueChanged];
    }
    return _leftPicker;
}

- (IBDatePicker *)rightPicker {
    if (!_rightPicker) {
        _rightPicker = [[IBDatePicker alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, 216)];
        _rightPicker.backgroundColor = [UIColor whiteColor];
        
        NSString *endYear = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyy"];
        _rightPicker.endYear = [endYear intValue];
    }
    return _rightPicker;
}

- (UILabel *)ymLab {
    if (!_ymLab) {
        _ymLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 49)];
        _ymLab.font = [UIFont systemFontOfSize:15];
        _ymLab.textColor = JPBaseColor;
        _ymLab.textAlignment = NSTextAlignmentCenter;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM"];
        _ymLab.text = [formatter stringFromDate:[NSDate date]];
    }
    return _ymLab;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 49, self.frame.size.width - 30, 1)];
        _lineView.backgroundColor = JPBaseColor;
    }
    return _lineView;
}

#pragma mark - 监听datePicker
- (void)dateValueChange:(UIDatePicker *)datePicker {
    BOOL isLeft = self.menuView.isLeft;
    if (isLeft) {
        self.menuView.leftDate = [NSDate stringFromDate:datePicker.date withFormat:@"yyyy-MM-dd"];
    } else {
        self.menuView.rightDate = [NSDate stringFromDate:datePicker.date withFormat:@"yyyy-MM-dd"];
    }
}

@end
