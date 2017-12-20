//
//  JP_HomeCell.h
//  JiePos
//
//  Created by Jason_LJ on 2017/7/12.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJAxisView.h"
#import "SJChartLineView.h"
#import "SJLineChart.h"
#import "JPHomeModel.h"
#import "NSObject+JPExtention.h"
#import "TXCustomPieView.h"

@interface JPHomeHeaderView : UITableViewHeaderFooterView <SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@end

typedef NS_ENUM(NSUInteger, JPCashType) {
    JPCashTypeDefault = 0,
    JPCashTypeCash,
};

@interface JPPieCell : UITableViewCell
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) TXCustomPieView *chartView;
@property (nonatomic, strong) NSMutableArray *segmentDataArray;
@property (nonatomic, strong) NSMutableArray *segmentTitleArray;
@property (nonatomic, strong) NSMutableArray *segmentColorArray;
@property (nonatomic, assign) NSInteger chartWidth;
@property (nonatomic, assign) NSInteger chartHeight;
@end

@interface JPLineCell : UITableViewCell
@property (nonatomic, strong) UIView *chartHeaderView;
@property (nonatomic, strong) UIImageView *chartLogoView;
@property (nonatomic, strong) UILabel *chartTitleLab;
/** 折线图*/
@property (nonatomic, strong) SJLineChart *lineChart;
/** 提示暂无数据*/
@property (nonatomic, strong) UIImageView *dataView;
@property (nonatomic, strong) NSArray <NSDictionary *>*pointDataSource;
@end

typedef NS_ENUM(NSUInteger, JPNormalCellType) {
    JPNormalCellTypeDay     = 0,//  日
    JPNormalCellTypeMonth,      //  月
    JPNormalCellTypeSearch,     //  搜索
};

@interface JPNormalCell : UITableViewCell
@property (nonatomic, copy) void (^jp_home_searchBlock)();
@property (nonatomic, assign) JPNormalCellType type;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *ammount;
@property (nonatomic, copy) NSString *unit;
@end
