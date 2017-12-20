//
//  JPHomeView.h
//  JiePos
//
//  Created by iBlocker on 2017/8/15.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JhtHorizontalMarquee.h"
#import "TXCustomPieView.h"
#import "SJLineChart.h"
#import "JPDealMoneyView.h"
#import "JPHomeModel.h"
#import "NSObject+JPExtention.h"

typedef void (^jp_tapMarqueeBlock)();
typedef void (^jp_deleteMarqueeBlock)();

@interface JPRollingView : UIView
@property (nonatomic, strong) UIImageView *leftView;
@property (nonatomic, strong) JhtHorizontalMarquee *horizontalMarquee;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, copy) jp_tapMarqueeBlock tapBlock;
@property (nonatomic, copy) jp_deleteMarqueeBlock deleteBlock;
@end

@interface JPPieView : UIView
@property (nonatomic, strong) UIView *cyanView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) TXCustomPieView *chartView;
@property (nonatomic, strong) UILabel *ammountLab;
@property (nonatomic, strong) UILabel *todayLab;
@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UIView *smallView;

@property (nonatomic, strong) NSMutableArray *segmentDataArray;
@property (nonatomic, strong) NSMutableArray *segmentTitleArray;
@property (nonatomic, strong) NSMutableArray *segmentColorArray;

- (void)reloadData;
@end


typedef void (^jp_cashDetailBlock)();
typedef void (^jp_getCashBlock)();
@interface JPCashView : UIView
/** 背景*/
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIView *orangeView;
/** 标题*/
@property (nonatomic, strong) UILabel *titleLab;
/** 明细*/
@property (nonatomic, strong) UIButton *detailButton;
/** 可提现金额*/
@property (nonatomic, strong) UILabel *cashLab;
/** 分割线*/
@property (nonatomic, strong) UIView *lineView;
/** 立即提现*/
@property (nonatomic, strong) UIButton *getCashButton;
@property (nonatomic, copy) jp_cashDetailBlock cashDetailBlock;
@property (nonatomic, copy) jp_getCashBlock getCashBlock;
@end


typedef void (^jp_home_dealSearchBlock)();
@interface JPLineView : UIView
//@property (nonatomic, copy) NSString *dayNum;
@property (nonatomic, copy) NSString *monthNum;
@property (nonatomic, strong) UIView *blueView;
/** 标题*/
@property (nonatomic, strong) UILabel *titleLab;
/** 折线图*/
@property (nonatomic, strong) SJLineChart *lineChart;
@property (nonatomic, strong) JPNoNewsView *resultView;
/** 提示暂无数据*/
@property (nonatomic, strong) UIImageView *dataView;
@property (nonatomic, strong) NSArray <NSDictionary *>*pointDataSource;

//@property (nonatomic, strong) JPDealMoneyView *daysView;
@property (nonatomic, strong) JPDealMoneyView *monthView;

@property (nonatomic, strong) UIView *lineView;
/** 交易查询*/
@property (nonatomic, strong) UIButton *dealSearchButton;
@property (nonatomic, copy) jp_home_dealSearchBlock dealSearchBlock;
@end



