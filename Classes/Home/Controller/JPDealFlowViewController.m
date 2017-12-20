//
//  JPDealFlowViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/17.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPDealFlowViewController.h"
#import "JPDealFlowCell.h"
#import "JPDealMesRequest.h"
#import "JPDealFlowModel.h"
#import "JPNewsViewController.h"

static NSString *const extentionCellReuseIdentifier = @"extentionCell";

@interface JPDealFlowViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) JPDealTextColorType colorType;
/** 背景*/
@property (nonatomic, strong) UIView *bgView;
/** 总计标签*/
@property (nonatomic, strong) UILabel *totalLab;
/** 总计金额*/
@property (nonatomic, strong) UILabel *totalCount;
/** 总交易金额标签*/
@property (nonatomic, strong) UILabel *totalDealLab;
/** 总交易金额*/
@property (nonatomic, strong) UILabel *totalDealAmount;
/** 总入账金额标签*/
@property (nonatomic, strong) UILabel *totalBookedLab;
/** 总入账金额*/
@property (nonatomic, strong) UILabel *totalBookedAmount;
@property (nonatomic, strong) UITableView *ctntView;
@property (nonatomic, strong) JPDealFlowHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSString *lastPageTime;
@property (nonatomic, strong) JPNoNewsView *resultView;
@property (nonatomic, strong) UIView *navImageView;
@property (nonatomic, strong) UIView *footBgView;
@end

@implementation JPDealFlowViewController {
    NSMutableDictionary *_headers;
}

#pragma mark - requestDealMessageList
- (void)requestDealMesListWithCurrentPageTime:(NSString *)currentPageTime startRow:(NSInteger)startRow {
    
    weakSelf_declare;
    //  监控网络状态变化
    [JPNetworkUtils netWorkState:^(NSInteger netState) {
        switch (netState) {
            case 1:
            case 2: {
                [IBHomeRequest getTransactionFlowListWithMerchantId:weakSelf.merchantId account:weakSelf.userName mercFlag:weakSelf.mercFlag merchantNo:weakSelf.merchantNo startTime:weakSelf.startTime endTime:weakSelf.endTime type:weakSelf.type payChannel:weakSelf.payChannel currentPageTime:currentPageTime startRow:startRow msgFlag:weakSelf.msgFlag callback:^(NSString *code, NSString *msg, id resp) {
                    id obj = [IBAnalysis analysisWithEncryptString:resp privateKey:[JPUserEntity sharedUserEntity].privateKey];
                    if (![obj isKindOfClass:[NSDictionary class]]) {
                        return;
                    }
                    NSDictionary *response = (NSDictionary *)obj;
                    if (startRow == 0) {
                        
                        [weakSelf.dataSource removeAllObjects];
                        NSArray *keys = response.allKeys;
                        if ([keys containsObject:@"total"] && [keys containsObject:@"totalMoney"] && [keys containsObject:@"allMoney"]) {
                            [weakSelf layoutTotalAmountWithTotal:response[@"total"] totalDealAmount:response[@"totalMoney"] totalBookedAmount:response[@"allMoney"]];
                        }
                    }
                    JPLog(@"response - %@", response);
                    if ([response[@"list"] isKindOfClass:[NSArray class]]) {
                        NSArray *list = response[@"list"];
                        for (NSDictionary *dic in list) {
                            JPDealFlowModel *model = [JPDealFlowModel yy_modelWithDictionary:dic];
                            [weakSelf.dataSource addObject:model];
                        }
                        _headers = [[NSMutableDictionary alloc] initWithCapacity:weakSelf.dataSource.count];
                        if (weakSelf.dataSource.count > 0) {
                            weakSelf.resultView.hidden = YES;
                            weakSelf.ctntView.hidden = NO;
                            weakSelf.footBgView.hidden = NO;
                        } else {
                            weakSelf.resultView.hidden = NO;
                            weakSelf.ctntView.hidden = YES;
                            weakSelf.footBgView.hidden = YES;
                        }
                        JPDealFlowModel *dealModel = [weakSelf.dataSource firstObject];
                        weakSelf.lastPageTime = dealModel.recCrtTs;
                        
                        weakSelf.ctntView.mj_footer.hidden = list.count != 10;
                        if (list.count == 10) {
                            [weakSelf.ctntView.mj_footer resetNoMoreData];
                        } else {
                            [IBProgressHUD showInfoWithStatus:@"数据已全部加载完成"];
                            [weakSelf.ctntView.mj_footer endRefreshingWithNoMoreData];
                        }
                    }
                    [weakSelf.ctntView reloadData];
                    [weakSelf.ctntView.mj_header endRefreshing];
                    [weakSelf.ctntView.mj_footer endRefreshing];
                }];
            }
                break;
            default: {
                JPLog(@"没网");
                weakSelf.resultView.hidden = NO;
                weakSelf.resultView.result = JPResultNoNet;
                weakSelf.ctntView.hidden = YES;
            }
                break;
        }
    }];
}

#pragma mark - Lazy
- (UITableView *)ctntView {
    if (_ctntView == nil) {
        _ctntView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JPRealValue(242) - JPRealValue(164)) style:UITableViewStyleGrouped];
        _ctntView.delegate = self;
        _ctntView.dataSource = self;
        _ctntView.showsHorizontalScrollIndicator = NO;
        _ctntView.showsVerticalScrollIndicator = NO;
        _ctntView.tableFooterView = [UIView new];
        _ctntView.backgroundColor = JP_viewBackgroundColor;
        _ctntView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _ctntView.estimatedSectionHeaderHeight = 0;
        _ctntView.estimatedSectionFooterHeight = 0;
    }
    return _ctntView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}
- (JPDealFlowHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[JPDealFlowHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, JPRealValue(242))];
    }
    return _headerView;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:(CGRect){0, JPRealValue(242), kScreenWidth, kScreenHeight - JPRealValue(172)}];
        _bgView.backgroundColor = JP_viewBackgroundColor;
    }
    return _bgView;
}
- (JPNoNewsView *)resultView {
    if (!_resultView) {
        _resultView = [[JPNoNewsView alloc] initWithFrame:self.ctntView.frame];
        _resultView.result = JPResultNoData;
    }
    return _resultView;
}
- (UIView *)footBgView {
    if (!_footBgView) {
        _footBgView = [[UIView alloc] initWithFrame:(CGRect){0, kScreenHeight - JPRealValue(242) - JPRealValue(164), kScreenWidth, JPRealValue(164)}];
        _footBgView.backgroundColor = [UIColor redColor];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"7a93f5"].CGColor, (__bridge id)[UIColor colorWithHexString:@"68b2f2"].CGColor, (__bridge id)[UIColor colorWithHexString:@"51dbf0"].CGColor];
        gradientLayer.locations = @[@0, @0.5, @1.0];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1.0, 0);
        gradientLayer.frame = (CGRect){0, 0, kScreenWidth, JPRealValue(164)};
        [_footBgView.layer addSublayer:gradientLayer];
    }
    return _footBgView;
}

#pragma mark - View
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self layoutHomeView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.ctntView];
    [self.bgView addSubview:self.footBgView];
    [self.bgView addSubview:self.resultView];
    
    self.resultView.hidden = YES;
//    self.resultView.hidden = NO;
//    self.ctntView.hidden = YES;
    self.footBgView.hidden = YES;
    
    weakSelf_declare;
    self.ctntView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            weakSelf.pageNo = 0;
            [weakSelf requestDealMesListWithCurrentPageTime:@"" startRow:weakSelf.pageNo];
        });
    }];
    self.ctntView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            weakSelf.pageNo ++;
            [weakSelf requestDealMesListWithCurrentPageTime:weakSelf.lastPageTime startRow:weakSelf.pageNo * 10];
        });
    }];
    self.ctntView.mj_footer.hidden = YES;
    
    [self.ctntView.mj_header beginRefreshing];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JPDealFlowHeadButton *header = _headers[@(section)];
    NSInteger count = header.isOpen ? 1 : 0;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JPDealFlowExtentionCell *cell = [tableView dequeueReusableCellWithIdentifier:extentionCellReuseIdentifier];
    if (!cell) {
        cell = [[JPDealFlowExtentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:extentionCellReuseIdentifier];
    }
    cell.colorType = self.isRed;
    cell.dealModel = self.dataSource[indexPath.section];
    return cell;
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat applyType1 = beforeIphone6 ? JPRealValue(328 + 30) : JPRealValue(288 + 30);
    CGFloat applyType2 = beforeIphone6 ? JPRealValue(294 + 25) : JPRealValue(254 + 25);
    return [JPUserEntity sharedUserEntity].applyType == 1 ? applyType1 : applyType2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return JPRealValue(10);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JPDealFlowHeadButton *header = _headers[@(section)];
    if (!header) {
        header = [JPDealFlowHeadButton buttonWithType:UIButtonTypeCustom];
        header.backgroundColor = JP_viewBackgroundColor;
        header.bounds = CGRectMake(0, 0, kScreenWidth, 60);
        header.shortName = self.businessShortName;
        header.colorType = self.isRed;
        header.dealFlowModel = self.dataSource[section];
        header.userInteractionEnabled = YES;
//        [header addTarget:self action:@selector(expandFriends:) forControlEvents:UIControlEventTouchUpInside];
        [_headers setObject:header forKey:@(section)];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, kScreenWidth, 60);
        [button addTarget:self action:@selector(expandFriends:) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:button];
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    footerView.backgroundColor = JP_viewBackgroundColor;
    return footerView;
}

#pragma mark - Define
- (void)expandFriends:(UIButton *)button {
    JPDealFlowHeadButton *header = (JPDealFlowHeadButton *)button.superview;
    header.open = !header.isOpen;
    [self.ctntView reloadData];
}
//- (void)expandFriends:(JPDealFlowHeadButton *)header {
//    header.open = !header.isOpen;
//    [self.ctntView reloadData];
//}

#pragma mark - Layout
- (void)layoutTotalAmountWithTotal:(NSString *)total totalDealAmount:(NSString *)totalDealAmount totalBookedAmount:(NSString *)totalBookedAmount {
    weakSelf_declare;
    
    if (!self.totalLab) {
        self.totalLab = [UILabel new];
        self.totalLab.text = @"总           计：";
        self.totalLab.font = JP_DefaultsFont;
        self.totalLab.textColor = [UIColor whiteColor];
        [self.footBgView addSubview:self.totalLab];
    }
    if (!self.totalCount) {
        self.totalCount = [UILabel new];
        self.totalCount.textAlignment = NSTextAlignmentRight;
        self.totalCount.font = JP_DefaultsFont;
        self.totalCount.textColor = [UIColor whiteColor];
        [self.footBgView addSubview:self.totalCount];
    }
    self.totalCount.text = [NSString stringWithFormat:@"%@ 笔", total];
    
    if (!self.totalDealLab) {
        self.totalDealLab = [UILabel new];
        self.totalDealLab.text = @"总交易金额：";
        self.totalDealLab.font = JP_DefaultsFont;
        self.totalDealLab.textColor = [UIColor whiteColor];
        [self.footBgView addSubview:self.totalDealLab];
    }
    if (!self.totalDealAmount) {
        self.totalDealAmount = [UILabel new];
        self.totalDealAmount.textAlignment = NSTextAlignmentRight;
        self.totalDealAmount.font = JP_DefaultsFont;
        self.totalDealAmount.textColor = [UIColor whiteColor];
        [self.footBgView addSubview:self.totalDealAmount];
    }
    self.totalDealAmount.text = [NSString stringWithFormat:@"%@ 元", totalDealAmount];
    
    if (!self.totalBookedLab) {
        self.totalBookedLab = [UILabel new];
        self.totalBookedLab.text = @"总入账金额：";
        self.totalBookedLab.font = JP_DefaultsFont;
        self.totalBookedLab.textColor = [UIColor whiteColor];
        [self.bgView addSubview:self.totalBookedLab];
    }
    if (!self.totalBookedAmount) {
        self.totalBookedAmount = [UILabel new];
        self.totalBookedAmount.textAlignment = NSTextAlignmentRight;
        self.totalBookedAmount.font = JP_DefaultsFont;
        self.totalBookedAmount.textColor = [UIColor whiteColor];
        [self.bgView addSubview:self.totalBookedAmount];
    }
    self.totalBookedAmount.text = [NSString stringWithFormat:@"%@ 元", totalBookedAmount];
    
    /** 总入账金额*/
    [self.totalBookedLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.footBgView.mas_left).offset(JPRealValue(44));
        make.bottom.equalTo(weakSelf.footBgView.mas_bottom).offset(JPRealValue(-30));
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(88)) / 2.0, JPRealValue(30)));
    }];
    [self.totalBookedAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.totalBookedLab.mas_right);
        make.right.equalTo(weakSelf.footBgView.mas_right).offset(JPRealValue(-44));
        make.top.and.bottom.equalTo(weakSelf.totalBookedLab);
    }];
    
    /** 总交易金额*/
    [self.totalDealLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.totalBookedLab.mas_centerX);
        make.centerY.equalTo(weakSelf.footBgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(88)) / 2.0, JPRealValue(30)));
    }];
    [self.totalDealAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.totalBookedAmount.mas_centerX);
        make.centerY.equalTo(weakSelf.footBgView.mas_centerY);
        make.left.and.right.equalTo(weakSelf.totalBookedAmount);
    }];
    
    /** 总计金额*/
    [self.totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.totalBookedLab.mas_left);
        make.top.equalTo(weakSelf.footBgView.mas_top).offset(JPRealValue(30));
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(88)) / 2.0, JPRealValue(30)));
    }];
    [self.totalCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(weakSelf.totalLab);
        make.left.and.right.equalTo(weakSelf.totalBookedAmount);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NavigationBar
- (void)layoutHomeView {
    _navImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _navImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navImageView];
    //    _navImageView.alpha = 0;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - 100, 20, 200, 44)];
    titleLab.text = @"交易流水";
    titleLab.font = [UIFont systemFontOfSize:JPRealValue(34)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor whiteColor];
    [_navImageView addSubview:titleLab];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(10, 25, JPRealValue(60), JPRealValue(60));
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(JPRealValue(15), JPRealValue(15), JPRealValue(15), JPRealValue(15));
    [leftButton setImage:[[UIImage imageNamed:@"jp_goBack1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_navImageView addSubview:leftButton];
}

#pragma mark - Action
- (void)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)navigationBarHidden {
    return YES;
}
@end
