//
//  JPCashDetailViewController.m
//  JiePos
//
//  Created by iBlocker on 2017/8/15.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPCashDetailViewController.h"
#import "JPNewsTitleView.h"
#import "JPCashModel.h"

@interface JPCashNoteCell : UITableViewCell
@property (nonatomic, strong) UIView *curView;
@property (nonatomic, strong) JPNewsTitleView *titleView;
@property (nonatomic, strong) UILabel *accountLab;
@property (nonatomic, strong) UILabel *statusLab;
@property (nonatomic, strong) UIView *lineView;
/** 商户号*/
@property (nonatomic, strong) UILabel *businessNoLab;
@property (nonatomic, strong) UILabel *businessNo;
/** 实到金额*/
@property (nonatomic, strong) UILabel *actuallyMoneyLab;
@property (nonatomic, strong) UILabel *actuallyMoney;
/** 提现手续费*/
@property (nonatomic, strong) UILabel *feeMoneyLab;
@property (nonatomic, strong) UILabel *feeMoney;
/** 提现批次号*/
@property (nonatomic, strong) UILabel *cashNumberLab;
@property (nonatomic, strong) UILabel *cashNumber;
/** 垫资日息*/
@property (nonatomic, strong) UILabel *interestLab;
@property (nonatomic, strong) UILabel *interest;
/** 提现时间*/
@property (nonatomic, strong) UILabel *cashTimeLab;
@property (nonatomic, strong) UILabel *cashTime;
@property (nonatomic, strong) JPCashListModel *listModel;
@end
@implementation JPCashNoteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.curView];
        [self.curView addSubview:self.titleView];
        [self.curView addSubview:self.accountLab];
        [self.curView addSubview:self.statusLab];
        [self.curView addSubview:self.lineView];
        [self.curView addSubview:self.businessNoLab];
        [self.curView addSubview:self.businessNo];
        [self.curView addSubview:self.actuallyMoneyLab];
        [self.curView addSubview:self.actuallyMoney];
        [self.curView addSubview:self.feeMoneyLab];
        [self.curView addSubview:self.feeMoney];
        [self.curView addSubview:self.cashNumberLab];
        [self.curView addSubview:self.cashNumber];
        [self.curView addSubview:self.interestLab];
        [self.curView addSubview:self.interest];
        [self.curView addSubview:self.cashTimeLab];
        [self.curView addSubview:self.cashTime];
    }
    return self;
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.curView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(30));
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-30));
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
    }];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.curView.mas_top).offset(JPRealValue(20));
        make.centerX.equalTo(weakSelf.curView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(270), JPRealValue(40)));
    }];
    [self.accountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleView.mas_bottom).offset(JPRealValue(20));
        make.centerX.equalTo(weakSelf.titleView.mas_centerX);
        make.left.equalTo(weakSelf.curView.mas_left).offset(JPRealValue(30));
        make.height.equalTo(@(JPRealValue(50)));
    }];
    [self.statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.curView.mas_left).offset(JPRealValue(120));
        make.top.equalTo(weakSelf.accountLab.mas_bottom).offset(JPRealValue(10));
        make.centerX.equalTo(weakSelf.curView.mas_centerX);
        make.height.equalTo(@(JPRealValue(30)));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.curView.mas_left).offset(JPRealValue(120));
        make.top.equalTo(weakSelf.statusLab.mas_bottom).offset(JPRealValue(20));
        make.centerX.equalTo(weakSelf.curView.mas_centerX);
        make.height.equalTo(@0.5);
    }];

    [self.businessNoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.curView.mas_left).offset(JPRealValue(20));
        make.top.equalTo(weakSelf.lineView.mas_bottom).offset(JPRealValue(20));
        make.size.mas_equalTo(CGSizeMake(JPRealValue(180), JPRealValue(40)));
    }];
    [self.businessNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.curView.mas_right).offset(JPRealValue(-20));
        make.centerY.equalTo(weakSelf.businessNoLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - JPRealValue(300), JPRealValue(40)));
    }];

    [self.actuallyMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.businessNoLab.mas_left);
        make.top.equalTo(weakSelf.businessNoLab.mas_bottom).offset(JPRealValue(15));
        make.size.mas_equalTo(CGSizeMake(JPRealValue(180), JPRealValue(40)));
    }];
    [self.actuallyMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.actuallyMoneyLab.mas_top);
        make.centerY.equalTo(weakSelf.actuallyMoneyLab.mas_centerY);
        make.left.equalTo(weakSelf.businessNo.mas_left);
        make.right.equalTo(weakSelf.businessNo.mas_right);
    }];
    
    [self.feeMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.actuallyMoneyLab.mas_left);
        make.top.equalTo(weakSelf.actuallyMoneyLab.mas_bottom).offset(JPRealValue(15));
        make.size.mas_equalTo(CGSizeMake(JPRealValue(180), JPRealValue(40)));
    }];
    [self.feeMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.feeMoneyLab.mas_top);
        make.centerY.equalTo(weakSelf.feeMoneyLab.mas_centerY);
        make.left.equalTo(weakSelf.businessNo.mas_left);
        make.right.equalTo(weakSelf.businessNo.mas_right);
    }];
 
    [self.cashNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.actuallyMoneyLab.mas_left);
        make.top.equalTo(weakSelf.feeMoneyLab.mas_bottom).offset(JPRealValue(15));
        make.size.mas_equalTo(CGSizeMake(JPRealValue(180), JPRealValue(40)));
    }];
    [self.cashNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.cashNumberLab.mas_top);
        make.centerY.equalTo(weakSelf.cashNumberLab.mas_centerY);
        make.left.equalTo(weakSelf.businessNo.mas_left);
        make.right.equalTo(weakSelf.businessNo.mas_right);
    }];
    
    [self.interestLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.actuallyMoneyLab.mas_left);
        make.top.equalTo(weakSelf.cashNumberLab.mas_bottom).offset(JPRealValue(15));
        make.size.mas_equalTo(CGSizeMake(JPRealValue(180), JPRealValue(40)));
    }];
    [self.interest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.interestLab.mas_top);
        make.centerY.equalTo(weakSelf.interestLab.mas_centerY);
        make.left.equalTo(weakSelf.businessNo.mas_left);
        make.right.equalTo(weakSelf.businessNo.mas_right);
    }];
    
    [self.cashTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.actuallyMoneyLab.mas_left);
        make.top.equalTo(weakSelf.interestLab.mas_bottom).offset(JPRealValue(15));
        make.size.mas_equalTo(CGSizeMake(JPRealValue(180), JPRealValue(40)));
    }];
    [self.cashTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.cashTimeLab.mas_top);
        make.centerY.equalTo(weakSelf.cashTimeLab.mas_centerY);
        make.left.equalTo(weakSelf.businessNo.mas_left);
        make.right.equalTo(weakSelf.businessNo.mas_right);
    }];
}

- (void)setListModel:(JPCashListModel *)listModel {
    self.accountLab.text = listModel.totalAmount;
    self.businessNo.text = listModel.merchantNo;
    self.actuallyMoney.text = listModel.realAmount;
    self.feeMoney.text = listModel.cashFee2;
    self.cashNumber.text = listModel.batchNo;
    self.interest.text = listModel.cashFee1;
    self.cashTime.text = listModel.cashTime;
    self.statusLab.text = listModel.status;
}

#pragma mark - Lazy
- (UIView *)curView {
    if (!_curView) {
        _curView = [UIView new];
        _curView.backgroundColor = [UIColor whiteColor];
        _curView.layer.cornerRadius = JPRealValue(10);
        _curView.layer.masksToBounds = YES;
        _curView.layer.borderColor = JP_LineColor.CGColor;
        _curView.layer.borderWidth = 0.5;
    }
    return _curView;
}

- (JPNewsTitleView *)titleView {
    if (!_titleView) {
        _titleView = [JPNewsTitleView new];
        _titleView.type = JPNewsTypeCash;
    }
    return _titleView;
}

- (UILabel *)accountLab {
    if (!_accountLab) {
        _accountLab = [UILabel new];
        _accountLab.font = [UIFont systemFontOfSize:JPRealValue(46)];
        _accountLab.textColor = JP_Dark_Color;
        _accountLab.textAlignment = NSTextAlignmentCenter;
    }
    return _accountLab;
}

- (UILabel *)statusLab {
    if (!_statusLab) {
        _statusLab = [UILabel new];
        _statusLab.font = [UIFont systemFontOfSize:JPRealValue(24)];
        _statusLab.textColor = JP_NoticeText_Color;
        _statusLab.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLab;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = JP_LineColor;
    }
    return _lineView;
}

- (UILabel *)businessNoLab {
    if (!_businessNoLab) {
        _businessNoLab = [UILabel new];
        _businessNoLab.font = JP_DefaultsFont;
        _businessNoLab.textColor = JP_NoticeText_Color;
        _businessNoLab.text = @"商户号";
    }
    return _businessNoLab;
}

- (UILabel *)businessNo {
    if (!_businessNo) {
        _businessNo = [UILabel new];
        _businessNo.font = JP_DefaultsFont;
        _businessNo.textColor = JP_Content_Color;
        _businessNo.textAlignment = NSTextAlignmentRight;
        _businessNo.text = @"T457878121";
    }
    return _businessNo;
}

- (UILabel *)actuallyMoneyLab {
    if (!_actuallyMoneyLab) {
        _actuallyMoneyLab = [UILabel new];
        _actuallyMoneyLab.font = JP_DefaultsFont;
        _actuallyMoneyLab.textColor = JP_NoticeText_Color;
        _actuallyMoneyLab.text = @"实到金额";
    }
    return _actuallyMoneyLab;
}

- (UILabel *)actuallyMoney {
    if (!_actuallyMoney) {
        _actuallyMoney = [UILabel new];
        _actuallyMoney.font = JP_DefaultsFont;
        _actuallyMoney.textColor = JP_Content_Color;
        _actuallyMoney.textAlignment = NSTextAlignmentRight;
        _actuallyMoney.text = @"9997.00元";
    }
    return _actuallyMoney;
}

- (UILabel *)feeMoneyLab {
    if (!_feeMoneyLab) {
        _feeMoneyLab = [UILabel new];
        _feeMoneyLab.font = JP_DefaultsFont;
        _feeMoneyLab.textColor = JP_NoticeText_Color;
        _feeMoneyLab.text = @"提现手续费";
    }
    return _feeMoneyLab;
}

- (UILabel *)feeMoney {
    if (!_feeMoney) {
        _feeMoney = [UILabel new];
        _feeMoney.font = JP_DefaultsFont;
        _feeMoney.textColor = JP_Content_Color;
        _feeMoney.textAlignment = NSTextAlignmentRight;
        _feeMoney.text = @"3.00元";
    }
    return _feeMoney;
}

- (UILabel *)cashNumberLab {
    if (!_cashNumberLab) {
        _cashNumberLab = [UILabel new];
        _cashNumberLab.font = JP_DefaultsFont;
        _cashNumberLab.textColor = JP_NoticeText_Color;
        _cashNumberLab.text = @"提现批次号";
    }
    return _cashNumberLab;
}

- (UILabel *)cashNumber {
    if (!_cashNumber) {
        _cashNumber = [UILabel new];
        _cashNumber.font = JP_DefaultsFont;
        _cashNumber.textColor = JP_Content_Color;
        _cashNumber.textAlignment = NSTextAlignmentRight;
        _cashNumber.text = @"000000";
    }
    return _cashNumber;
}

- (UILabel *)interestLab {
    if (!_interestLab) {
        _interestLab = [UILabel new];
        _interestLab.font = JP_DefaultsFont;
        _interestLab.textColor = JP_NoticeText_Color;
        _interestLab.text = @"垫资日息";
    }
    return _interestLab;
}

- (UILabel *)interest {
    if (!_interest) {
        _interest = [UILabel new];
        _interest.font = JP_DefaultsFont;
        _interest.textColor = JP_Content_Color;
        _interest.textAlignment = NSTextAlignmentRight;
        _interest.text = @"1元";
    }
    return _interest;
}

- (UILabel *)cashTimeLab {
    if (!_cashTimeLab) {
        _cashTimeLab = [UILabel new];
        _cashTimeLab.font = JP_DefaultsFont;
        _cashTimeLab.textColor = JP_NoticeText_Color;
        _cashTimeLab.text = @"提现时间";
    }
    return _cashTimeLab;
}

- (UILabel *)cashTime {
    if (!_cashTime) {
        _cashTime = [UILabel new];
        _cashTime.font = JP_DefaultsFont;
        _cashTime.textColor = JP_Content_Color;
        _cashTime.textAlignment = NSTextAlignmentRight;
        _cashTime.text = @"2017-08-17 09:42:34";
    }
    return _cashTime;
}

@end

@interface JPCashDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *navImageView;
@property (nonatomic, strong) UITableView *ctntView;
@property (nonatomic, copy) NSString *lastTime;
@property (nonatomic, strong) JPCashNoteModel *noteModel;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) JPNoNewsView *resultView;
@end

@implementation JPCashDetailViewController

- (void)requestWithBeginDate:(NSString *)beginDate endDate:(NSString *)endDate month:(NSString *)month lastTime:(NSString *)lastTime page:(NSInteger)page {
    weakSelf_declare;
    [IBHomeRequest getCashNoteWithAccount:[JPUserEntity sharedUserEntity].account beginDate:beginDate endDate:endDate month:month lastTime:lastTime page:page callback:^(NSString *code, NSString *msg, id resp) {
        JPLog(@"体现明细 --- %@", resp);
        
        id obj = [IBAnalysis analysisWithEncryptString:resp privateKey:[JPUserEntity sharedUserEntity].privateKey];
        if (code.integerValue == 0) {
            //  查询成功
            weakSelf.noteModel = [JPCashNoteModel yy_modelWithJSON:obj];
            if (page == 1) {
                [weakSelf.dataSource removeAllObjects];
                
                UILabel *cashTotal = [self.view viewWithTag:201708311647];
                UILabel *cashActuallyTotal = [self.view viewWithTag:201708311648];
                UILabel *numberTotal = [self.view viewWithTag:201708311649];
                
                cashTotal.text = [NSString stringWithFormat:@"提现 ¥%@", weakSelf.noteModel.totalAmount];
                cashActuallyTotal.text = [NSString stringWithFormat:@"实到 ¥%@", weakSelf.noteModel.realAmount];
                numberTotal.text = [NSString stringWithFormat:@"总计 %@笔", weakSelf.noteModel.total];
            }
            [weakSelf.dataSource addObjectsFromArray:weakSelf.noteModel.cashList];
            weakSelf.lastTime = weakSelf.noteModel.lastTime;
            
            weakSelf.ctntView.mj_footer.hidden = weakSelf.noteModel.cashList.count != 10;
            if (weakSelf.noteModel.cashList.count == 10) {
                [weakSelf.ctntView.mj_footer resetNoMoreData];
            } else {
                [weakSelf.ctntView.mj_footer endRefreshingWithNoMoreData];
            }
            //  判断是否有数据
            weakSelf.resultView.hidden = weakSelf.dataSource.count > 0;
        } else {
            //  查询失败
            [IBProgressHUD showInfoWithStatus:msg];
        }
        [weakSelf.ctntView reloadData];
        [weakSelf.ctntView.mj_header endRefreshing];
        [weakSelf.ctntView.mj_footer endRefreshing];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lastTime = @"";
    [self.view addSubview:self.ctntView];
    [self.view addSubview:self.resultView];
    [self layoutHomeView];
    
    [self requestWithBeginDate:[NSDate stringFromDate:[NSDate date] withFormat:@"yyyyMMdd"] endDate:[NSDate stringFromDate:[NSDate date] withFormat:@"yyyyMMdd"] month:@"" lastTime:self.lastTime page:1];
    
    weakSelf_declare;
    
    __block NSInteger monthPage = 1;
    __block NSInteger dayPage = 1;
    __block NSInteger todayPage = 1;
    self.ctntView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        UILabel *dateLab = [self.view viewWithTag:1708220939];
        NSString *dateString = dateLab.text;
        if (dateString.length <= 7) {
            //  按月查询
            NSString *month = [NSDate stringFromDate:[NSDate dateFromString:dateString withFormat:@"yyyy-MM"] withFormat:@"yyyyMM"];
            
            weakSelf.lastTime = @"";
            [weakSelf requestWithBeginDate:nil endDate:nil month:month lastTime:weakSelf.lastTime page:1];
        } else {
            //  按日查询
            if ([dateString containsString:@" 至 "]) {
                //  查询一段时间
                NSArray *dateArr = [dateString componentsSeparatedByString:@" 至 "];
                NSString *startDate = [dateArr firstObject];
                NSString *endDate = [dateArr lastObject];
                
                NSString *start = [NSDate stringFromDate:[NSDate dateFromString:startDate withFormat:@"yyyy-MM-dd"] withFormat:@"yyyyMMdd"];
                NSString *end = [NSDate stringFromDate:[NSDate dateFromString:endDate withFormat:@"yyyy-MM-dd"] withFormat:@"yyyyMMdd"];
                
                weakSelf.lastTime = @"";
                [weakSelf requestWithBeginDate:start endDate:end month:nil lastTime:weakSelf.lastTime page:1];
            } else {
                //  查询当天
                weakSelf.lastTime = @"";
                NSString *date = [NSDate stringFromDate:[NSDate dateFromString:dateString withFormat:@"yyyy-MM-dd"] withFormat:@"yyyyMMdd"];
                
                [weakSelf requestWithBeginDate:date endDate:date month:nil lastTime:weakSelf.lastTime page:1];
            }
        }
    }];
    self.ctntView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        UILabel *dateLab = [self.view viewWithTag:1708220939];
        NSString *dateString = dateLab.text;
        if (dateString.length <= 7) {
            //  按月查询
            monthPage ++;
            
            NSString *month = [NSDate stringFromDate:[NSDate dateFromString:dateString withFormat:@"yyyy-MM"] withFormat:@"yyyyMM"];
            
            weakSelf.lastTime = @"";
            [weakSelf requestWithBeginDate:nil endDate:nil month:month lastTime:weakSelf.lastTime page:monthPage];
        } else {
            //  按日查询
            if ([dateString containsString:@" 至 "]) {
                //  查询一段时间
                dayPage ++;
                
                NSArray *dateArr = [dateString componentsSeparatedByString:@" 至 "];
                NSString *startDate = [dateArr firstObject];
                NSString *endDate = [dateArr lastObject];
                
                NSString *start = [NSDate stringFromDate:[NSDate dateFromString:startDate withFormat:@"yyyy-MM-dd"] withFormat:@"yyyyMMdd"];
                NSString *end = [NSDate stringFromDate:[NSDate dateFromString:endDate withFormat:@"yyyy-MM-dd"] withFormat:@"yyyyMMdd"];
                
                weakSelf.lastTime = @"";
                [weakSelf requestWithBeginDate:start endDate:end month:nil lastTime:weakSelf.lastTime page:dayPage];
            } else {
                //  查询当天
                todayPage ++;
                weakSelf.lastTime = @"";
                NSString *date = [NSDate stringFromDate:[NSDate dateFromString:dateString withFormat:@"yyyy-MM-dd"] withFormat:@"yyyyMMdd"];
                
                [weakSelf requestWithBeginDate:date endDate:date month:nil lastTime:weakSelf.lastTime page:todayPage];
            }
        }
    }];
    self.ctntView.mj_footer.hidden = YES;
}

#pragma mark - tableViewDataSource
static NSString *const cellReuseIdentifier = @"cellReuseIdentifier";

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JPCashNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.listModel = self.dataSource[indexPath.section];
    return cell;
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return JPRealValue(20);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = JP_viewBackgroundColor;
    return headerView;
}

#pragma mark - Action
- (void)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemClicked:(UIButton *)sender {
    //  筛选
    weakSelf_declare;
    [IBDatePickerView ibShowWithCompleteBlock:^(IBDateType type, IBDateModel *dateModel) {
        
        UILabel *dateLab = [weakSelf.view viewWithTag:1708220939];
        if (type == IBDateTypeYMD) {
            NSString *startDate = dateModel.startDate;
            NSString *endDate = dateModel.endDate;
            if (!startDate) {
                startDate = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd"];
            }
            if (!endDate) {
                endDate = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd"];
            }
            if ([startDate isEqualToString:endDate]) {
                dateLab.text = [NSString stringWithFormat:@"%@", startDate];
            } else {
                dateLab.text = [NSString stringWithFormat:@"%@ 至 %@", startDate, endDate];
            }
            JPLog(@"%@ - %@", dateModel.startDate, dateModel.endDate);
            if (!dateModel.startDate) {
                dateModel.startDate = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd"];
            }
            if (!dateModel.endDate) {
                dateModel.endDate = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd"];
            }
            NSString *start = [NSDate stringFromDate:[NSDate dateFromString:dateModel.startDate withFormat:@"yyyy-MM-dd"] withFormat:@"yyyyMMdd"];
            NSString *end = [NSDate stringFromDate:[NSDate dateFromString:dateModel.endDate withFormat:@"yyyy-MM-dd"] withFormat:@"yyyyMMdd"];
            
            weakSelf.lastTime = @"";
            [weakSelf requestWithBeginDate:start endDate:end month:nil lastTime:weakSelf.lastTime page:1];
        } else {
            JPLog(@"%@", dateModel.monthCaledar);
//            NSDate *monthDate = [NSDate dateFromString:dateModel.monthCaledar withFormat:@"yyyy-MM"];
//            if ([monthDate compareToDate:[NSDate date]]) {
//                monthDate = [NSDate date];
//            }
//            dateLab.text = [NSDate stringFromDate:monthDate withFormat:@"yyyy-ZMM"];
//            NSString *month = [NSDate stringFromDate:monthDate withFormat:@"yyyyMM"];
            
            dateLab.text = dateModel.monthCaledar;
            
            NSString *month = [NSDate stringFromDate:[NSDate dateFromString:dateModel.monthCaledar withFormat:@"yyyy-MM"] withFormat:@"yyyyMM"];
            
            weakSelf.lastTime = @"";
            [weakSelf requestWithBeginDate:nil endDate:nil month:month lastTime:weakSelf.lastTime page:1];
        }
        // 根据字体得到NSString的尺寸
        CGSize size = [dateLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:JPRealValue(24)], NSFontAttributeName, nil]];
        dateLab.frame = CGRectMake(JPRealValue(30), 64 + JPRealValue(10), size.width + JPRealValue(20), JPRealValue(40));
    }];
}

#pragma mark - Lazy
- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:CGRectMake(0, JPRealValue(240), kScreenWidth, kScreenHeight - JPRealValue(240)) style:UITableViewStylePlain];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        _ctntView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ctntView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        _ctntView.rowHeight = JPRealValue(550);
        _ctntView.estimatedSectionHeaderHeight = 0;
        _ctntView.estimatedSectionFooterHeight = 0;
        _ctntView.backgroundColor = JP_viewBackgroundColor;
        
        [_ctntView registerClass:NSClassFromString(@"JPCashNoteCell") forCellReuseIdentifier:cellReuseIdentifier];
    }
    return _ctntView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

- (JPNoNewsView *)resultView {
    if (!_resultView) {
        _resultView = [JPNoNewsView new];
        _resultView.center = self.ctntView.center;
        _resultView.result = JPResultNoData;
    }
    return _resultView;
}

#pragma mark - Header
- (void)layoutHomeView {
    _navImageView = [[UIView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, JPRealValue(240)}];
    [self.view addSubview:_navImageView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"7a93f5"].CGColor, (__bridge id)[UIColor colorWithHexString:@"68b2f2"].CGColor, (__bridge id)[UIColor colorWithHexString:@"51dbf0"].CGColor];
    gradientLayer.locations = @[@0, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = (CGRect){0, 0, kScreenWidth, JPRealValue(240)};
    [_navImageView.layer addSublayer:gradientLayer];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:(CGRect){kScreenWidth / 2.0 - 100, 20, 200, 44}];
    titleLab.text = @"提现记录";
    titleLab.font = [UIFont systemFontOfSize:JPRealValue(34)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor whiteColor];
    [_navImageView addSubview:titleLab];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = (CGRect){10, 25, JPRealValue(60), JPRealValue(60)};
    leftButton.imageEdgeInsets = (UIEdgeInsets){JPRealValue(15), JPRealValue(15), JPRealValue(15), JPRealValue(15)};
    [leftButton setImage:[[UIImage imageNamed:@"jp_goBack1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_navImageView addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(kScreenWidth - JPRealValue(90), 25, JPRealValue(60), JPRealValue(60));
    [rightButton setImage:[[UIImage imageNamed:@"jp_cash_filter"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets = (UIEdgeInsets){JPRealValue(15), JPRealValue(15), JPRealValue(15), JPRealValue(15)};
    [rightButton addTarget:self action:@selector(rightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_navImageView addSubview:rightButton];
    
    UILabel *dateLab = [self.view viewWithTag:1708220939];
    if (!dateLab) {
        dateLab = [UILabel new];
        dateLab.layer.cornerRadius = JPRealValue(20);
        dateLab.layer.masksToBounds = YES;
        dateLab.font = [UIFont systemFontOfSize:JPRealValue(24)];
        dateLab.textColor = [UIColor whiteColor];
        dateLab.textAlignment = NSTextAlignmentCenter;
        dateLab.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        dateLab.tag = 1708220939;
        dateLab.text = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd"];
        // 根据字体得到NSString的尺寸
        CGSize size = [dateLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:JPRealValue(24)], NSFontAttributeName, nil]];
        dateLab.frame = CGRectMake(JPRealValue(30), 64 + JPRealValue(10), size.width + JPRealValue(20), JPRealValue(40));
        [_navImageView addSubview:dateLab];
    }
    
    UILabel *cashTotal = [self.view viewWithTag:201708311647];
    if (!cashTotal) {
        cashTotal = [[UILabel alloc] initWithFrame:CGRectMake(JPRealValue(30), JPRealValue(128) + JPRealValue(60), (kScreenWidth - JPRealValue(60)) / 3.0 - JPRealValue(1), JPRealValue(30))];
        cashTotal.font = [UIFont systemFontOfSize:JPRealValue(24)];
        cashTotal.textColor = [UIColor whiteColor];
        cashTotal.textAlignment = NSTextAlignmentCenter;
        cashTotal.text = @"提现 ¥0";
        cashTotal.tag = 201708311647;
        [_navImageView addSubview:cashTotal];
    }
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(JPRealValue(30) + (kScreenWidth - JPRealValue(60)) / 3.0 - JPRealValue(1), JPRealValue(128) + JPRealValue(60), JPRealValue(2), JPRealValue(30))];
    leftLine.backgroundColor = [UIColor whiteColor];
    [_navImageView addSubview:leftLine];
    
    UILabel *cashActuallyTotal = [self.view viewWithTag:201708311648];
    if (!cashActuallyTotal) {
        cashActuallyTotal = [[UILabel alloc] initWithFrame:CGRectMake(JPRealValue(30) + (kScreenWidth - JPRealValue(60)) / 3.0 - JPRealValue(1), JPRealValue(128) + JPRealValue(60), (kScreenWidth - JPRealValue(60)) / 3.0 - JPRealValue(1), JPRealValue(30))];
        cashActuallyTotal.font = [UIFont systemFontOfSize:JPRealValue(24)];
        cashActuallyTotal.textColor = [UIColor whiteColor];
        cashActuallyTotal.textAlignment = NSTextAlignmentCenter;
        cashActuallyTotal.text = @"实到 ¥0";
        cashActuallyTotal.tag = 201708311648;
        [_navImageView addSubview:cashActuallyTotal];
    }
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(JPRealValue(30) + (kScreenWidth - JPRealValue(60)) / 3.0 * 2 - JPRealValue(1), JPRealValue(128) + JPRealValue(60), JPRealValue(2), JPRealValue(30))];
    rightLine.backgroundColor = [UIColor whiteColor];
    [_navImageView addSubview:rightLine];
    
    UILabel *numberTotal = [self.view viewWithTag:201708311649];
    if (!numberTotal) {
        numberTotal = [[UILabel alloc] initWithFrame:CGRectMake(JPRealValue(30) + (kScreenWidth - JPRealValue(60)) / 3.0 * 2 - JPRealValue(1), JPRealValue(128) + JPRealValue(60), (kScreenWidth - JPRealValue(60)) / 3.0 - JPRealValue(1), JPRealValue(30))];
        numberTotal.font = [UIFont systemFontOfSize:JPRealValue(24)];
        numberTotal.textColor = [UIColor whiteColor];
        numberTotal.textAlignment = NSTextAlignmentCenter;
        numberTotal.text = @"总计 0笔";
        numberTotal.tag = 201708311649;
        [_navImageView addSubview:numberTotal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
