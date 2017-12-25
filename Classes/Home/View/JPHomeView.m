//
//  JPHomeView.m
//  JiePos
//
//  Created by iBlocker on 2017/8/15.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPHomeView.h"

@implementation JPRollingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"ffefd7"];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRollingView:)]];
        
        [self addSubview:self.leftView];
        [self addSubview:self.horizontalMarquee];
        [self addSubview:self.rightButton];
        
        for (id obj in self.horizontalMarquee.subviews) {
            if ([obj isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)obj;
                label.textColor = [UIColor colorWithHexString:@"ff9800"];
            }
        }
    }
    return self;
}

- (UIImageView *)leftView {
    if (!_leftView) {
        _leftView = [[UIImageView alloc] initWithFrame:(CGRect){JPRealValue(30), JPRealValue(19.5), JPRealValue(22), JPRealValue(21)}];
        _leftView.image = [UIImage imageNamed:@"jp_home_notice"];
    }
    return _leftView;
}

- (JhtHorizontalMarquee *)horizontalMarquee {
    if (!_horizontalMarquee) {
        _horizontalMarquee = [[JhtHorizontalMarquee alloc] initWithFrame:(CGRect){JPRealValue(70), 0, kScreenWidth - JPRealValue(140), JPRealValue(60)} withSingleScrollDuration:10.0];
    }
    return _horizontalMarquee;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = (CGRect){kScreenWidth - JPRealValue(60), JPRealValue(10), JPRealValue(40), JPRealValue(40)};
        [_rightButton setImage:[UIImage imageNamed:@"jp_home_delete"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

#pragma mark - Action
- (void)tapRollingView:(UITapGestureRecognizer *)tap {
    if (self.tapBlock) {
        self.tapBlock();
    }
}

- (void)deleteButtonClick:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

@end


@implementation JPPieView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = JPRealValue(10);
        self.layer.shadowColor = JPBaseColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(2, 2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        self.layer.shadowRadius = 2;//阴影半径，默认3
        // 头部的竖线
        [self addSubview:self.cyanView];
        // 标题
        [self addSubview:self.titleLab];
        
        [self addSubview:self.bigView];
        [self addSubview:self.smallView];
        
        [self addSubview:self.ammountLab];
        [self addSubview:self.todayLab];
    }
    return self;
}

- (void)reloadData {
    self.chartView.segmentDataArray = self.segmentDataArray;
    //颜色数组，若不传入，则为随即色
    self.chartView.segmentColorArray = self.segmentColorArray;
    //标题，若不传入，则为“其他”
    self.chartView.segmentTitleArray = self.segmentTitleArray;
    [self.chartView updatePieView];
}

- (UIView *)cyanView {
    if (!_cyanView) {
        _cyanView = [[UIView alloc] initWithFrame:(CGRect){JPRealValue(30), JPRealValue(15), JPRealValue(5), JPRealValue(30)}];
        _cyanView.backgroundColor = [UIColor colorWithHexString:@"0ddddd"];
    }
    return _cyanView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:(CGRect){JPRealValue(45), JPRealValue(15), JPRealValue(300), JPRealValue(30)}];
        _titleLab.font = [UIFont systemFontOfSize:JPRealValue(30)];
        _titleLab.text = @"今日收款统计";
    }
    return _titleLab;
}

- (TXCustomPieView *)chartView {
    if (!_chartView) {
        //包含文本的视图frame
        _chartView = [[TXCustomPieView alloc] initWithFrame:CGRectMake(0, 5 + JPRealValue(80), kScreenWidth - JPRealValue(60), 200)];
        //数据源
        _chartView.segmentDataArray = self.segmentDataArray;
        //颜色数组，若不传入，则为随即色
        _chartView.segmentColorArray = self.segmentColorArray;
        //标题，若不传入，则为“其他”
        _chartView.segmentTitleArray = self.segmentTitleArray;
        //动画时间
        _chartView.animateTime = 2.0;
        //内圆的颜色
        _chartView.innerColor = [UIColor clearColor];
        //内圆的半径
        _chartView.innerCircleR = JPRealValue(140);
        //大圆的半径
        _chartView.pieRadius = JPRealValue(180);
        //整体饼状图的背景色
        _chartView.backgroundColor = [UIColor clearColor];
        //圆心位置，此属性会被centerXPosition、centerYPosition覆盖，圆心优先使用centerXPosition、centerYPosition
        _chartView.centerType = PieCenterTypeTopMiddle;
        //是否动画
        _chartView.needAnimation = NO;
        //动画类型，全部只有一个动画；各个部分都有动画
        _chartView.type = PieAnimationTypeTogether;
        //圆心，相对于饼状图的位置
        _chartView.centerXPosition = JPRealValue(200);
        //右侧的文本颜色是否等同于模块的颜色
        _chartView.isSameColor = NO;
        //文本的行间距
        _chartView.textSpace = JPRealValue(10);
        //文本的字号
        _chartView.textFontSize = JPRealValue(28);
        //文本的高度
        _chartView.textHeight = JPRealValue(40);
        //文本前的颜色块的高度
        _chartView.colorHeight = JPRealValue(20);
        //文本前的颜色块是否为圆
        _chartView.isRound = YES;
        //文本距离右侧的间距
        _chartView.textRightSpace = JPRealValue(30);
        //支持点击事件
        _chartView.canClick = NO;
//        //点击圆饼后的偏移量
//        _chartView.clickOffsetSpace = JPRealValue(20);
//        //不隐藏右侧的文本
//        _chartView.hideText = NO;
//        //点击触发的block，index与数据源对应
//        [_chartView clickPieView:^(NSInteger index) {
//            JPLog(@"Click Index:%ld",index);
//        }];
        
        //添加到视图上
        [_chartView showCustomViewInSuperView:self];
    }
    return _chartView;
}

- (UIView *)bigView {
    if (!_bigView) {
        _bigView = [UIView new];
        _bigView.center = CGPointMake(JPRealValue(200), 5 + JPRealValue(80) + 100);
        _bigView.bounds = CGRectMake(0, 0, JPRealValue(360), JPRealValue(360));
        _bigView.backgroundColor = JP_LineColor;
        _bigView.layer.cornerRadius = JPRealValue(180);
        _bigView.layer.masksToBounds = YES;
    }
    return _bigView;
}

- (UIView *)smallView {
    if (!_smallView) {
        _smallView = [UIView new];
        _smallView.center = CGPointMake(JPRealValue(200), 5 + JPRealValue(80) + 100);
        _smallView.bounds = CGRectMake(0, 0, JPRealValue(280), JPRealValue(280));
        _smallView.backgroundColor = [UIColor whiteColor];
        _smallView.layer.cornerRadius = JPRealValue(140);
        _smallView.layer.masksToBounds = YES;
    }
    return _smallView;
}

- (UILabel *)ammountLab {
    if (!_ammountLab) {
        _ammountLab = [UILabel new];
        _ammountLab.center = CGPointMake(JPRealValue(200), 5 + JPRealValue(80) + 100);
        _ammountLab.bounds = CGRectMake(0, 0, JPRealValue(260), JPRealValue(50));
        _ammountLab.text = @"10";
        _ammountLab.font = [UIFont boldSystemFontOfSize:JPRealValue(40)];
        _ammountLab.textColor = JP_Content_Color;
        _ammountLab.textAlignment = NSTextAlignmentCenter;
        _ammountLab.adjustsFontSizeToFitWidth = YES;
    }
    return _ammountLab;
}
// 圆中间的label
- (UILabel *)todayLab {
    if (!_todayLab) {
        _todayLab = [UILabel new];
        _todayLab.center = CGPointMake(JPRealValue(200), 5 + JPRealValue(130) + 100);
        _todayLab.bounds = CGRectMake(0, 0, JPRealValue(200), JPRealValue(30));
        _todayLab.font = [UIFont systemFontOfSize:JPRealValue(20)];
        _todayLab.textColor = JP_Content_Color;
        _todayLab.textAlignment = NSTextAlignmentCenter;
        _todayLab.text = @"今日收款（元）";
    }
    return _todayLab;
}

- (NSMutableArray *)segmentDataArray {
    if (!_segmentDataArray) {
        _segmentDataArray = @[].mutableCopy;
    }
    return _segmentDataArray;
}

- (NSMutableArray *)segmentColorArray {
    if (!_segmentColorArray) {
        _segmentColorArray = @[].mutableCopy;
    }
    return _segmentColorArray;
}

- (NSMutableArray *)segmentTitleArray {
    if (!_segmentTitleArray) {
        _segmentTitleArray = @[].mutableCopy;
    }
    return _segmentTitleArray;
}

@end


@implementation JPCashView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = JPRealValue(10);
        self.layer.shadowColor = JPBaseColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(2, 2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        self.layer.shadowRadius = 2;//阴影半径，默认3
        
        [self addSubview:self.bgView];
        [self addSubview:self.orangeView];
        [self addSubview:self.titleLab];
        [self addSubview:self.detailButton];
        [self addSubview:self.cashLab];
        [self addSubview:self.lineView];
        [self addSubview:self.getCashButton];
    }
    return self;
}

#pragma mark - Subviews
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth - JPRealValue(60), JPRealValue(108)}];
        _bgView.image = [UIImage imageNamed:@"jp_home_cashBg"];
    }
    return _bgView;
}
- (UIView *)orangeView {
    if (!_orangeView) {
        _orangeView = [[UIView alloc] initWithFrame:(CGRect){JPRealValue(30), JPRealValue(15), JPRealValue(5), JPRealValue(30)}];
        _orangeView.backgroundColor = [UIColor colorWithHexString:@"r5b87a"];
    }
    return _orangeView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:(CGRect){JPRealValue(45), JPRealValue(15), JPRealValue(300), JPRealValue(30)}];
        _titleLab.font = JP_DefaultsFont;
        _titleLab.text = @"可提现金额";
    }
    return _titleLab;
}

- (UIButton *)detailButton {
    if (!_detailButton) {
        _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailButton.frame = (CGRect){kScreenWidth - JPRealValue(220), JPRealValue(15), JPRealValue(150), JPRealValue(30)};
        [_detailButton setTitle:@"提现明细" forState:UIControlStateNormal];
        [_detailButton setTitleColor:JPBaseColor forState:UIControlStateNormal];
        _detailButton.titleLabel.font = JP_DefaultsFont;
        [_detailButton addTarget:self action:@selector(detailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailButton;
}
- (UILabel *)cashLab {
    if (!_cashLab) {
        _cashLab = [[UILabel alloc] initWithFrame:(CGRect){JPRealValue(30), JPRealValue(80), kScreenWidth - JPRealValue(120), JPRealValue(50)}];
        _cashLab.font = [UIFont boldSystemFontOfSize:JPRealValue(44)];
        _cashLab.textAlignment = NSTextAlignmentCenter;
        _cashLab.text = @"¥0";
    }
    return _cashLab;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:(CGRect){0, JPRealValue(160), kScreenWidth - JPRealValue(60), 0.7}];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    }
    return _lineView;
}
- (UIButton *)getCashButton {
    if (!_getCashButton) {
        _getCashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _getCashButton.frame = (CGRect){0, JPRealValue(170), kScreenWidth - JPRealValue(60), JPRealValue(60)};
        [_getCashButton setTitle:@"立即提现" forState:UIControlStateNormal];
        [_getCashButton setTitleColor:JPBaseColor forState:UIControlStateNormal];
        _getCashButton.titleLabel.font = JP_DefaultsFont;
        //  点击方法
        [_getCashButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getCashButton;
}

#pragma mark - Action
- (void)detailButtonClick:(UIButton *)sender {
    //  提现明细
    if (self.cashDetailBlock) {
        self.cashDetailBlock();
    }
}
- (void)buttonClick:(UIButton *)sender {
    //  立即提现
    NSLog(@"立即提现");
    if (self.getCashBlock) {
        self.getCashBlock();
    }
}
@end



@implementation JPLineView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = JPRealValue(10);
        self.layer.shadowColor = JPBaseColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(2, 2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        self.layer.shadowRadius = 2;//阴影半径，默认3
        
        [self addSubview:self.blueView];
        [self addSubview:self.titleLab];
        [self addSubview:self.lineChart];
        [self addSubview:self.resultView];
//        [self addSubview:self.daysView];
        [self addSubview:self.monthView];
        [self addSubview:self.lineView];
//        [self addSubview:self.dealSearchButton];
    }
    return self;
}

//- (void)setDayNum:(NSString *)dayNum {
//    self.daysView.money = dayNum;
//}

- (void)setMonthNum:(NSString *)monthNum {
    self.monthView.money = monthNum;
}

#pragma mark - Subviews
- (UIView *)blueView {
    if (!_blueView) {
        _blueView = [[UIView alloc] initWithFrame:(CGRect){JPRealValue(30), JPRealValue(15), JPRealValue(5), JPRealValue(30)}];
        _blueView.backgroundColor = [UIColor colorWithHexString:@"7a93f5"];
    }
    return _blueView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:(CGRect){JPRealValue(45), JPRealValue(15), JPRealValue(300), JPRealValue(30)}];
        _titleLab.font = [UIFont systemFontOfSize:JPRealValue(30)];
        _titleLab.text = @"累计交易金额趋势";
    }
    return _titleLab;
}

- (SJLineChart *)lineChart {
    if (!_lineChart) {
        _lineChart = [[SJLineChart alloc] initWithFrame:(CGRect){0, JPRealValue(10), kScreenWidth - JPRealValue(60), 230}];
        _lineChart.backgroundColor = [UIColor clearColor];
    }
    return _lineChart;
}

- (JPNoNewsView *)resultView {
    if (!_resultView) {
        _resultView = [[JPNoNewsView alloc] initWithFrame:(CGRect){0, JPRealValue(45), kScreenWidth - JPRealValue(60), 230}];
        _resultView.result = JPResultNoData;
    }
    return _resultView;
}

//- (JPDealMoneyView *)daysView {
//    if (!_daysView) {
//        _daysView = [[JPDealMoneyView alloc] initWithFrame:(CGRect){0, 230 + JPRealValue(74), kScreenWidth - JPRealValue(60), JPRealValue(80)} image:[UIImage imageNamed:@"jp_home_days"] title:@"当天累计交易金额"];
//    }
//    return _daysView;
//}

- (JPDealMoneyView *)monthView {
    if (!_monthView) {
//        _monthView = [[JPDealMoneyView alloc] initWithFrame:(CGRect){0, 230 + JPRealValue(172), kScreenWidth - JPRealValue(60), JPRealValue(80)} image:[UIImage imageNamed:@"jp_home_month"] title:@"当月累计交易金额"];
        _monthView = [[JPDealMoneyView alloc] initWithFrame:(CGRect){0, 230 + JPRealValue(74), kScreenWidth - JPRealValue(60), JPRealValue(80)} image:[UIImage imageNamed:@"jp_home_month"] title:@"当月累计交易金额"];
    }
    return _monthView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:(CGRect){0, 230 + JPRealValue(272) - JPRealValue(98), kScreenWidth - JPRealValue(60), 0.7}];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    }
    return _lineView;
}

- (UIButton *)dealSearchButton {
    if (!_dealSearchButton) {
        _dealSearchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dealSearchButton.frame = (CGRect){0, 230 + JPRealValue(292) - JPRealValue(98), kScreenWidth - JPRealValue(60), JPRealValue(60)};
        [_dealSearchButton setTitle:@"交易查询" forState:UIControlStateNormal];
        [_dealSearchButton setTitleColor:[UIColor colorWithHexString:@"607ef4"] forState:UIControlStateNormal];
        _dealSearchButton.titleLabel.font = JP_DefaultsFont;
        [_dealSearchButton addTarget:self action:@selector(dealSearchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dealSearchButton;
}

#pragma mark - 设置dataSource数据源，画折线图
- (void)setPointDataSource:(NSArray *)pointDataSource {
    // !!!: 判断数据源是否有数据
    if (pointDataSource.count > 0) {
        self.lineChart.hidden = NO;
        self.resultView.hidden = YES;
    } else {
        self.lineChart.hidden = YES;
        self.resultView.hidden = NO;
        return;
    }
    // !!!: 设置纵坐标及其最大值
    NSMutableArray *amountArr = @[].mutableCopy;
    for (JPHomeChartModel *model in pointDataSource) {
        double amount = [model.sumDayTransAt doubleValue];
        [amountArr addObject:[NSNumber numberWithDouble:amount]];
    }
    CGFloat maxValue = [[amountArr valueForKeyPath:@"@max.floatValue"] floatValue];
    
    int value = (int)ceilf(maxValue);
    
    // 最大值
    //  设置纵坐标
    NSMutableArray *values = @[].mutableCopy;
    if (value >= 1000) {
        
        self.lineChart.maxValue = value;
        
        [values addObject:@"0"];
        [values addObject:[NSString stringWithFormat:@"%.f", ceil((float)value / 5.0)]];
        [values addObject:[NSString stringWithFormat:@"%.f", ceil((float)value / 5.0 * 2)]];
        [values addObject:[NSString stringWithFormat:@"%.f", ceil((float)value / 5.0 * 3)]];
        [values addObject:[NSString stringWithFormat:@"%.f", ceil((float)value / 5.0 * 4)]];
        [values addObject:[NSString stringWithFormat:@"%.f", ceil((float)value)]];
    } else {
        
        self.lineChart.maxValue = maxValue;
        
        [values addObject:@"0"];
        [values addObject:[NSString stringWithFormat:@"%.2f", maxValue / 5.0]];
        [values addObject:[NSString stringWithFormat:@"%.2f", maxValue / 5.0 * 2]];
        [values addObject:[NSString stringWithFormat:@"%.2f", maxValue / 5.0 * 3]];
        [values addObject:[NSString stringWithFormat:@"%.2f", maxValue / 5.0 * 4]];
        [values addObject:[NSString stringWithFormat:@"%.2f", maxValue / 5.0 * 5]];
    }
    
    self.lineChart.yMarkTitles = values;
    
    // !!!: 设置横坐标
    //  获取最近30天的日期数组
    NSArray *lastDays = [NSDate getLastDaysWithFormat:@"yyyy/MM/dd"];
    self.lineChart.xMarkTitles = lastDays;
    
    NSMutableArray *defaultsArray = @[].mutableCopy;
    for (NSString *date in lastDays) {
        NSMutableDictionary *defaultsDic = @{}.mutableCopy;
        [defaultsDic setObject:date forKey:@"recCrtDt"];
        //  默认金额为0
        [defaultsDic setObject:@"0" forKey:@"sumDayTransAt"];
        [defaultsArray addObject:defaultsDic];
    }
    //  模型转化为json
    NSArray *arr = [JPHomeChartModel idFromObject:pointDataSource];
    //    JPLog(@"%@ - %@", defaultsArray, arr);
    for (int i = 0; i < arr.count; i ++) {
        NSDictionary *dic = arr[i];
        NSString *date = dic[@"recCrtDt"];
        /**数据源中数据在横轴的位置，即点的数组中的位置*/
        if ([lastDays containsObject:date]) {
            NSInteger index = [lastDays indexOfObject:date];
            [defaultsArray replaceObjectAtIndex:index withObject:dic];
        }
    }
    //  设置点的数据源
    [self.lineChart setXMarkTitlesAndValues:defaultsArray titleKey:@"recCrtDt" valueKey:@"sumDayTransAt"]; // X轴刻度标签及相应的值
    //  把点画到折线图上
    [self.lineChart mapping];
}

#pragma mark - Action
- (void)dealSearchButtonClick:(UIButton *)sender {
    //  交易查询
    if (self.dealSearchBlock) {
        self.dealSearchBlock();
    }
}

@end
