//
//  JP_HomeCell.m
//  JiePos
//
//  Created by Jason_LJ on 2017/7/12.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JP_HomeCell.h"

@implementation JPHomeHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        NSArray *imagesURLStrings = @[
                                      @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                      @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                      @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                      ];
        [self.contentView addSubview:self.cycleScrollView];
        
        //         --- 模拟加载延迟
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.cycleScrollView.imageURLStringsGroup = imagesURLStrings;
        });
    }
    return self;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    JPLog(@"Index - %ld", (long)index);
}

#pragma mark - Lazy
- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    }
    return _cycleScrollView;
}
@end

@implementation JPLineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor redColor];
        [self handleUserInterface];
    }
    return self;
}
- (void)handleUserInterface {
    [self.contentView addSubview:self.chartHeaderView];
    [self.chartHeaderView addSubview:self.chartLogoView];
    [self.chartHeaderView addSubview:self.chartTitleLab];
    [self.contentView addSubview:self.lineChart];
    [self.contentView addSubview:self.dataView];
    //  暂无数据提示默认隐藏
    self.dataView.hidden = YES;
}
#pragma mark - 设置dataSource数据源，画折线图
- (void)setPointDataSource:(NSArray *)pointDataSource {
    // !!!: 判断数据源是否有数据
    if (pointDataSource.count > 0) {
        self.lineChart.hidden = NO;
        self.dataView.hidden = YES;
    } else {
        self.lineChart.hidden = YES;
        self.dataView.hidden = NO;
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

- (UIView *)chartHeaderView {
    if (!_chartHeaderView) {
        _chartHeaderView = [UIView new];
    }
    return _chartHeaderView;
}
- (UIImageView *)chartLogoView {
    if (!_chartLogoView) {
        _chartLogoView = [UIImageView new];
        _chartLogoView.image = [UIImage imageNamed:@"jp_home_chartLogo"];
    }
    return _chartLogoView;
}
- (UILabel *)chartTitleLab {
    if (!_chartTitleLab) {
        _chartTitleLab = [UILabel new];
        _chartTitleLab.text = @"累计交易金额趋势";
        _chartTitleLab.textColor = [UIColor whiteColor];
        _chartTitleLab.font = JP_DefaultsFont;
    }
    return _chartTitleLab;
}
- (SJLineChart *)lineChart {
    if (!_lineChart) {
        _lineChart = [SJLineChart new];
        _lineChart.backgroundColor = [UIColor clearColor];
    }
    return _lineChart;
}
- (UIImageView *)dataView {
    if (!_dataView) {
        _dataView = [UIImageView new];
        _dataView.image = [UIImage imageNamed:@"jp_nHome_noData"];
    }
    return _dataView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.chartLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.bottom.equalTo(weakSelf.chartHeaderView);
        //        make.width.equalTo(@(JPRealValue(23)));
        make.size.mas_equalTo(CGSizeMake(JPRealValue(26), JPRealValue(26)));
    }];
    [self.chartTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.and.bottom.equalTo(weakSelf.chartHeaderView);
        make.left.equalTo(weakSelf.chartLogoView.mas_right).offset(JPRealValue(20));
    }];
    [self.chartHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(60));
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
    }];
    [self.lineChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.chartHeaderView.mas_bottom).offset(JPRealValue(20));
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 230));
    }];
    [self.dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.lineChart.mas_centerX);
        make.centerY.equalTo(weakSelf.lineChart.mas_centerY);
    }];
}
@end

@implementation JPPieCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        JPLog(@"subviews %@", self.contentView.subviews);
        [self.contentView addSubview:self.bgView];
        
        JPLog(@"subviews %@", self.contentView.subviews);
    }
    return self;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:(CGRect){JPRealValue(30), 5, kScreenWidth - JPRealValue(60), self.chartHeight + 10}];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = JPRealValue(10);
        _bgView.layer.shadowColor = JPBaseColor.CGColor;
        _bgView.layer.shadowOffset = CGSizeMake(2, 2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _bgView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _bgView.layer.shadowRadius = 2;//阴影半径，默认3
    }
    return _bgView;
}

- (TXCustomPieView *)chartView {
    if (!_chartView) {
        //包含文本的视图frame
        _chartView = [[TXCustomPieView alloc] initWithFrame:CGRectMake(0, 5, self.chartWidth, self.chartHeight)];
        _chartView.layer.cornerRadius = JPRealValue(10);
        _chartView.layer.masksToBounds = YES;
        //数据源
        _chartView.segmentDataArray = self.segmentDataArray;
        //颜色数组，若不传入，则为随即色
        _chartView.segmentColorArray = self.segmentColorArray;
        //标题，若不传入，则为“其他”
        _chartView.segmentTitleArray = self.segmentTitleArray;
        //动画时间
        _chartView.animateTime = 2.0;
        //内圆的颜色
        _chartView.innerColor = [UIColor whiteColor];
        //内圆的半径
        _chartView.innerCircleR = 55;
        //大圆的半径
        _chartView.pieRadius = 80;
        //整体饼状图的背景色
        _chartView.backgroundColor = [UIColor whiteColor];
        //圆心位置，此属性会被centerXPosition、centerYPosition覆盖，圆心优先使用centerXPosition、centerYPosition
        _chartView.centerType = PieCenterTypeTopMiddle;
        //是否动画
        _chartView.needAnimation = YES;
        //动画类型，全部只有一个动画；各个部分都有动画
        _chartView.type = PieAnimationTypeTogether;
        //圆心，相对于饼状图的位置
        _chartView.centerXPosition = 105;
        //右侧的文本颜色是否等同于模块的颜色
        _chartView.isSameColor = NO;
        //文本的行间距
        _chartView.textSpace = 10;
        //文本的字号
        _chartView.textFontSize = 14;
        //文本的高度
        _chartView.textHeight = 30;
        //文本前的颜色块的高度
        _chartView.colorHeight = 10;
        //文本前的颜色块是否为圆
        _chartView.isRound = YES;
        //文本距离右侧的间距
        _chartView.textRightSpace = 50;
        //支持点击事件
        _chartView.canClick = NO;
        //点击圆饼后的偏移量
        _chartView.clickOffsetSpace = 10;
        //不隐藏右侧的文本
        _chartView.hideText = NO;
        //点击触发的block，index与数据源对应
        [_chartView clickPieView:^(NSInteger index) {
            JPLog(@"Click Index:%ld",(long)index);
        }];
        
        //添加到视图上
//        [_chartView showCustomViewInSuperView:self.contentView];
    }
    return _chartView;
}
@end

@interface JPNormalCell ()
@property (nonatomic, strong) UIView *currentView;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *refreshView;
@property (nonatomic, strong) UILabel *refreshLab;
@property (nonatomic, strong) UILabel *ammountLab;
@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UIButton *searchButton;
@end
@implementation JPNormalCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.refreshView];
        [self.refreshView addSubview:self.refreshLab];
        [self.bgView addSubview:self.ammountLab];
        [self.bgView addSubview:self.lineView];
        [self.bgView addSubview:self.titleLab];
        
        [self.contentView addSubview:self.currentView];
        [self.currentView addSubview:self.logoView];
        [self.currentView addSubview:self.searchButton];
    }
    return self;
}

- (void)setType:(JPNormalCellType)type {
    switch (type) {
        case JPNormalCellTypeDay: {
            //  当天累计交易金额（元）
            self.bgView.hidden = NO;
            self.currentView.hidden = YES;
            
            self.bgView.image = [UIImage imageNamed:@"jp_home_refreshDay"];
            self.refreshView.image = [UIImage imageNamed:@"jp_home_refreshDayBg"];
            self.ammountLab.textColor = [UIColor colorWithHexString:@"1fcae4"];
//            self.titleLab.text = @"当天累计交易金额（元）";
        }
            break;
        case JPNormalCellTypeMonth: {
            //  当月累计交易金额（元）
            self.bgView.hidden = NO;
            self.currentView.hidden = YES;
            
            self.bgView.image = [UIImage imageNamed:@"jp_home_refreshMonth"];
            self.refreshView.image = [UIImage imageNamed:@"jp_home_refreshMonthBg"];
            self.ammountLab.textColor = [UIColor colorWithHexString:@"607ef4"];
//            self.titleLab.text = @"当月累计交易金额（元）";
        }
            break;
        case JPNormalCellTypeSearch: {
            //  交易查询
            self.bgView.hidden = YES;
            self.currentView.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)setTime:(NSString *)time {
    self.refreshLab.text = time;
}
- (void)setAmmount:(NSString *)ammount {
    self.ammountLab.text = ammount;
}
- (void)setUnit:(NSString *)unit {
    self.titleLab.text = unit;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.currentView.mas_centerX);
        make.centerY.equalTo(weakSelf.currentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(693), JPRealValue(175)));
    }];
    [self.refreshView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgView.mas_top).offset(JPRealValue(12));
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(12));
    }];
    [self.refreshLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.refreshView.mas_centerY);
        make.right.equalTo(weakSelf.refreshView.mas_right).offset(JPRealValue(-10));
        make.left.equalTo(weakSelf.refreshView.mas_left);
        make.height.equalTo(@15);
    }];
    [self.ammountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgView.mas_centerX);
        make.top.equalTo(weakSelf.bgView.mas_top);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.ammountLab.mas_centerX);
        make.top.equalTo(weakSelf.ammountLab.mas_bottom);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.lineView.mas_centerX);
        make.top.equalTo(weakSelf.lineView.mas_bottom).offset(JPRealValue(10));
    }];
    [self.currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(693), JPRealValue(167)));
    }];
    CGFloat margin = (JPRealValue(167) - JPRealValue(66) - JPRealValue(60)) / 3.0;
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.currentView.mas_centerX);
        make.top.equalTo(weakSelf.currentView.mas_top).offset(margin);
    }];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.currentView.mas_centerX);
        make.top.equalTo(weakSelf.logoView.mas_bottom).offset(margin);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(190), JPRealValue(60)));
    }];
}
- (UIView *)currentView {
    if (!_currentView) {
        _currentView = [UIView new];
        _currentView.backgroundColor = [UIColor whiteColor];
        _currentView.layer.cornerRadius = JPRealValue(10);
//        _currentView.layer.masksToBounds = YES;
        _currentView.layer.shadowColor = JPBaseColor.CGColor;
        _currentView.layer.shadowOffset = CGSizeMake(2, 2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _currentView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _currentView.layer.shadowRadius = 2;//阴影半径，默认3
    }
    return _currentView;
}
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
        _bgView.layer.shadowColor = JPBaseColor.CGColor;
        _bgView.layer.shadowOffset = CGSizeMake(2, 2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _bgView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _bgView.layer.shadowRadius = 2;//阴影半径，默认3
    }
    return _bgView;
}
- (UIImageView *)refreshView {
    if (!_refreshView) {
        _refreshView = [UIImageView new];
    }
    return _refreshView;
}
- (UILabel *)refreshLab {
    if (!_refreshLab) {
        _refreshLab = [UILabel new];
        _refreshLab.textColor = [UIColor whiteColor];
        _refreshLab.font = [UIFont systemFontOfSize:JPRealValue(18)];
        _refreshLab.textAlignment = NSTextAlignmentRight;
    }
    return _refreshLab;
}
- (UILabel *)ammountLab {
    if (!_ammountLab) {
        _ammountLab = [UILabel new];
        _ammountLab.font = [UIFont systemFontOfSize:JPRealValue(60)];
        _ammountLab.textAlignment = NSTextAlignmentCenter;
    }
    return _ammountLab;
}
- (UIImageView *)lineView {
    if (!_lineView) {
        _lineView = [UIImageView new];
        _lineView.image = [UIImage imageNamed:@"jp_home_normalLine"];
    }
    return _lineView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = [UIColor colorWithHexString:@"516aaa"];
        _titleLab.font = JP_DefaultsFont;
    }
    return _titleLab;
}
- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [UIImageView new];
        _logoView.image = [UIImage imageNamed:@"jp_home_searchLogo"];
    }
    return _logoView;
}
- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setTitle:@"交易查询" forState:UIControlStateNormal];
        [_searchButton setTitleColor:[UIColor colorWithHexString:@"516aaa"] forState:UIControlStateNormal];
        [_searchButton setImage:[UIImage imageNamed:@"jp_home_searchIndicator"] forState:UIControlStateNormal];
        _searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, JPRealValue(160), 0, JPRealValue(-20));
        _searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, JPRealValue(-20), 0, JPRealValue(20));
        
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:JPRealValue(34)];
        _searchButton.layer.cornerRadius = JPRealValue(6);
        _searchButton.layer.masksToBounds = YES;
        _searchButton.layer.borderWidth = 0.5;
        _searchButton.layer.borderColor = [UIColor colorWithHexString:@"608dff"].CGColor;
        [_searchButton addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

- (void)searchClick {
    if (self.jp_home_searchBlock) {
        self.jp_home_searchBlock();
    }
}
@end
