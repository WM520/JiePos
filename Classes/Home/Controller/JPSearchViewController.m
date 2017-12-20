//
//  JPSearchViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/7/12.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPSearchViewController.h"
#import "JPSearchDealCell.h"
#import "JPDealFlowViewController.h"
#import "KYSDatePickerView.h"
#import "JPDealMesRequest.h"
#import "JPDealMesModel.h"

@interface JPSearchViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *ctntView;
@property (nonatomic, strong) UIView *navImageView;
@property (nonatomic, assign) BOOL canSelect;
@property (nonatomic, strong) JPDealMesModel *dealModel;
@property (nonatomic, assign) NSInteger merNameIndex;
@end

static NSString *const normalReuseIdentifier = @"normalReuseIdentifier";
static NSString *const headerReuseIdentifier = @"headerReuseIdentifier";
static NSString *const footerReuseIdentifier = @"footerReuseIdentifier";

@implementation JPSearchViewController

#pragma mark - Lazy
- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        _ctntView.rowHeight = JPRealValue(180);
        _ctntView.backgroundColor = JP_viewBackgroundColor;
        _ctntView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        _ctntView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_ctntView registerClass:[JPSearchDealCell class] forCellReuseIdentifier:normalReuseIdentifier];
        [_ctntView registerClass:[JPSearchHeaderView class] forHeaderFooterViewReuseIdentifier:headerReuseIdentifier];
        [_ctntView registerClass:[JPSearchFooterView class] forHeaderFooterViewReuseIdentifier:footerReuseIdentifier];
    }
    return _ctntView;
}

#pragma mark - View
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self layoutHomeView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.ctntView];
    
    weakSelf_declare;
    [IBHomeRequest initializeTransactionFlowConditionsWithAccount:[JPUserEntity sharedUserEntity].account merchantId:[JPUserEntity sharedUserEntity].merchantId callback:^(NSString *code, NSString *msg, id resp) {
        
        id obj = [IBAnalysis analysisWithEncryptString:resp privateKey:[JPUserEntity sharedUserEntity].privateKey];
        
        JPLog(@"obj - %@", obj);
        if ([obj isKindOfClass:[NSString class]]) {
            weakSelf.canSelect = NO;
            return;
        }
        if ([obj isKindOfClass:[NSDictionary class]]) {
            weakSelf.canSelect = YES;
            weakSelf.dealModel = [JPDealMesModel yy_modelWithJSON:obj];
            [weakSelf.ctntView reloadData];
        }
    }];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JPSearchDealCell *cell = [tableView dequeueReusableCellWithIdentifier:normalReuseIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.oneTitle = @"开始时间";
        cell.oneValue = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyy/M/dd"];
        cell.twoTitle = @"结束时间";
        cell.twoValue = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyy/M/dd"];
        cell.jp_oneRowClick = ^(JPSearchDealCell *cell) {
            
            [KYSDatePickerView KYSShowWithCompleteBlock:^(NSDate *date) {

                cell.oneValue = [NSDate stringFromDate:date withFormat:@"yyyy/M/dd"];
                
                NSDate *startDate = [NSDate dateFromString:cell.oneValue withFormat:@"yyyy/M/dd"];
                NSDate *endDate = [NSDate dateFromString:cell.twoValue withFormat:@"yyyy/M/dd"];
                
                if ([startDate compare:endDate] == NSOrderedAscending) {
                    //  开始时间早于结束时间
                    //  开始时间距结束时间差
                    NSTimeInterval timeDistance = [endDate timeIntervalSinceDate:startDate];
                    if (timeDistance > 30 * 24 * 60 * 60) {
                        //  开始时间和结束时间相差过长，系统默认为30天
                        [IBProgressHUD showInfoWithStatus:@"开始时间和结束时间相差过长，系统默认为31天"];
                        //  若开始时间距结束时间超过30天，则endDate = 开始时间 + 30天
                        cell.twoValue = [NSDate stringFromDate:[NSDate ThirtydaysLaterThanDate:startDate] withFormat:@"yyyy/M/dd"];
                    } else {
                        //  否则，endDate不变
                    }
                } else if ([startDate compare:endDate] == NSOrderedSame) {
                    //  开始时间等于结束时间
                } else {
                    //  开始时间晚于结束时间
                    [IBProgressHUD showInfoWithStatus:@"结束时间早于开始时间，系统将默认为开始时间"];
                    cell.twoValue = [NSDate stringFromDate:startDate withFormat:@"yyyy/M/dd"];
                }
            }];
        };
        cell.jp_twoRowClick = ^(JPSearchDealCell *cell) {
            
            [KYSDatePickerView KYSShowWithCompleteBlock:^(NSDate *date) {

                cell.twoValue = [NSDate stringFromDate:date withFormat:@"yyyy/M/dd"];
                
                NSDate *startDate = [NSDate dateFromString:cell.oneValue withFormat:@"yyyy/M/dd"];
                NSDate *endDate = [NSDate dateFromString:cell.twoValue withFormat:@"yyyy/M/dd"];
                
                if ([startDate compare:endDate] == NSOrderedAscending) {
                    //  开始时间早于结束时间
                    
                    //  开始时间距结束时间差 若开始时间距结束时间超过30天，则endDate = 开始时间 + 30天
                    NSTimeInterval timeDistance = [endDate timeIntervalSinceDate:startDate];
                    if (timeDistance > 30 * 24 * 60 * 60) {
                        [IBProgressHUD showInfoWithStatus:@"开始时间和结束时间相差过长，系统默认为31天"];
                        //  若开始时间距结束时间超过30天，则startDate = 结束时间 - 30天
                        cell.oneValue = [NSDate stringFromDate:[NSDate ThirtydaysEaralierThanDate:endDate] withFormat:@"yyyy/M/dd"];
                    }
                } else if ([startDate compare:endDate] == NSOrderedSame) {
                    //  开始时间等于结束时间
                } else {
                    //  开始时间晚于结束时间
                    [IBProgressHUD showInfoWithStatus:@"结束时间早于开始时间，系统将默认为开始时间"];
                    cell.oneValue = [NSDate stringFromDate:endDate withFormat:@"yyyy/M/dd"];
                }
            }];
        };
    } else {
        cell.oneTitle = @"交易状态";
        cell.oneValue = @"全部";
        cell.twoTitle = @"支付方式";
        cell.twoValue = @"全部";
        cell.jp_oneRowClick = ^(JPSearchDealCell *cell) {
            
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"全部"];
            for (JPDealStateModel *model in self.dealModel.tranStatList2) {
                [arr addObject:model.name];
            }
            //注意数据类型是数组包含数组
            [KYSNormalPickerView KYSShowWithDataArray:@[arr] completeBlock:^(NSArray * selectedArray) {
                NSInteger index = [[selectedArray lastObject] integerValue];
                NSString *selectStr = [arr objectAtIndex:index];
                
                cell.oneValue = selectStr;
            }];
        };
        cell.jp_twoRowClick = ^(JPSearchDealCell *cell) {
            
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"全部"];
            for (JPDealPayWayModel *model in self.dealModel.payList2) {
                [arr addObject:model.name];
            }
            //  注意数据类型是数组包含数组
            [KYSNormalPickerView KYSShowWithDataArray:@[arr] completeBlock:^(NSArray * selectedArray) {
                NSInteger index = [[selectedArray lastObject] integerValue];
                NSString *selectStr = [arr objectAtIndex:index];
                JPLog(@"选择交易方式 -- %@", selectStr);
                
                cell.twoValue = selectStr;
            }];
        };
    }
    return cell;
}

#pragma mark -tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? JPRealValue(326) : JPRealValue(24);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JPSearchHeaderView *headerView = (JPSearchHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:headerReuseIdentifier];
    if ([self.dealModel.merchantType isEqualToString:@"2"]) {
        //  总店
        headerView.merchantName = @"全部";
    } else {
        if (self.dealModel.mercList.count > 0) {
            JPDealBusinessNameModel *model = self.dealModel.mercList[0];
            headerView.merchantName = model.merchantName;
        } else {
            headerView.merchantName = [JPUserEntity sharedUserEntity].merchantName;
        }
    }
    
    weakSelf_declare;
    @weakify(headerView);
    headerView.jp_searchMerchantBlock = ^(UILabel *merchantName) {
//        JPLog(@"%@", merchantName.text);
        
        if ([weakSelf.dealModel.merchantType isEqualToString:@"2"]) {
            
            if (![JPUserEntity sharedUserEntity].merchantNo || self.dealModel.mercList.count <= 0) {
                [IBProgressHUD showInfoWithStatus:@"账户状态异常！"];
                return;
            }
            [MobClick event:@"deal_merchantName"];
            NSMutableArray *arr = @[].mutableCopy;
            [arr addObject:@"全部"];
            for (JPDealBusinessNameModel *model in self.dealModel.mercList) {
                NSString *merNo = [model.merchantNo substringWithRange:NSMakeRange(model.merchantNo.length - 5, 5)];
                [arr addObject:[NSString stringWithFormat:@"%@(No.%@)", model.merchantName, merNo]];
            }
            //注意数据类型是数组包含数组
            [KYSNormalPickerView KYSShowWithDataArray:@[arr] completeBlock:^(NSArray * selectedArray) {
                @strongify(headerView);
                
                weakSelf.merNameIndex = [[selectedArray lastObject] integerValue];
                NSString *selectStr = [arr objectAtIndex:weakSelf.merNameIndex];
                JPLog(@"全部 -- %@", selectStr);
                
                merchantName.text = selectStr;
                headerView.merchantName = selectStr;
            }];
        }
    };
    return section == 0 ? headerView : nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 1 ? JPRealValue(150) : 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    JPSearchFooterView *footerView = (JPSearchFooterView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:footerReuseIdentifier];
    if (self.canSelect) {
        footerView.searchDealButton.userInteractionEnabled = YES;
        [footerView.searchDealButton setBackgroundImage:[UIImage imageNamed:@"jp_button_normal"] forState:UIControlStateNormal];
    } else {
        footerView.searchDealButton.userInteractionEnabled = NO;
        [footerView.searchDealButton setBackgroundImage:[UIImage imageNamed:@"jp_button_disabled"] forState:UIControlStateNormal];
    }
    footerView.jp_searchDealBlock = ^{
        
        if (![JPUserEntity sharedUserEntity].merchantNo || self.dealModel.mercList.count <= 0) {
            [IBProgressHUD showInfoWithStatus:@"账户状态异常！"];
            return;
        }
        JPSearchHeaderView *headerView = (JPSearchHeaderView *)[tableView headerViewForSection:0];
        JPSearchDealCell *cell0 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        JPSearchDealCell *cell1 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        
        JPLog(@"%@ - %@ - %@ - %@ - %@", headerView.merchantName, cell0.oneValue, cell0.twoValue, cell1.oneValue, cell1.twoValue);
        JPLog(@"merNameIndex - %ld - %@", self.merNameIndex, headerView.merchantName);
        
        
        NSString *businessName = headerView.merchantName;
        
        NSString *startDate = cell0.oneValue;
        NSDate *startD = [NSDate dateFromString:startDate withFormat:@"yyyy/M/dd"];
        startDate = [NSDate stringFromDate:startD withFormat:@"yyyyMMdd"];
        
        NSString *endDate = cell0.twoValue;
        NSDate *endD = [NSDate dateFromString:endDate withFormat:@"yyyy/M/dd"];
        endDate = [NSDate stringFromDate:endD withFormat:@"yyyyMMdd"];
        
        NSString *dealType = cell1.oneValue;
        NSString *payWay = cell1.twoValue;
        
        //  查询交易流水
        JPDealFlowViewController *dealFlowVC = [[JPDealFlowViewController alloc] init];
        dealFlowVC.navigationItem.title = @"交易流水";
        dealFlowVC.msgFlag = 0;
        if (self.dealModel.merchantType.integerValue == 2) {
            //  总店
            if ([businessName isEqualToString:@"全部"]) {
                dealFlowVC.mercFlag = 0;
                dealFlowVC.merchantNo = [JPUserEntity sharedUserEntity].merchantNo;
                dealFlowVC.merchantId = [JPUserEntity sharedUserEntity].merchantId;
            } else {
                dealFlowVC.mercFlag = 1;
                
                JPDealBusinessNameModel *merModel = self.dealModel.mercList[self.merNameIndex - 1];
                dealFlowVC.merchantNo = merModel.merchantNo;
                dealFlowVC.merchantId = merModel.merchantId;
            }
        } else {
            dealFlowVC.mercFlag = 1;
            dealFlowVC.merchantNo = [JPUserEntity sharedUserEntity].merchantNo;
            dealFlowVC.merchantId = [JPUserEntity sharedUserEntity].merchantId;
        }
        
        dealFlowVC.userName = [JPUserEntity sharedUserEntity].account;
        dealFlowVC.startTime = startDate;
        dealFlowVC.endTime = endDate;
        
        if ([dealType isEqualToString:@"全部"]) {
            dealFlowVC.type = @"";
        } else {
            NSArray *typeArr = self.dealModel.tranStatList2;
            for (JPDealStateModel *model in typeArr) {
                if ([model.name isEqualToString:dealType]) {
                    dealFlowVC.type = model.type;
                }
            }
        }
        
        if ([payWay isEqualToString:@"全部"]) {
            dealFlowVC.payChannel = @"";
        } else {
            for (JPDealPayWayModel *model in self.dealModel.payList2) {
                if ([model.name isEqualToString:payWay]) {
                    dealFlowVC.payChannel = model.payChannel;
                }
            }
        }
        JPDealBusinessNameModel *model = self.dealModel.mercList[0];
        dealFlowVC.businessShortName = model.merchantName;
        dealFlowVC.isRed = ![dealType isEqualToString:@"全部"];
        weakSelf_declare;
        [JPNetworkUtils netWorkState:^(NSInteger netState) {
            switch (netState) {
                case 1:
                case 2:
                {
                    [MobClick event:@"deal_dealFlowSearch"];
                    [weakSelf.navigationController pushViewController:dealFlowVC animated:YES];
                }
                    break;
                default: {
                    [IBProgressHUD showInfoWithStatus:@"网络异常，请稍后再试"];
                }
                    break;
            }
        }];
    };
    return section == 1 ? footerView : nil;
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
//    // 是否是正在使用的视图
//    if (self.isViewLoaded && !self.view.window) {
//        // Add code to preserve data stored in the views that might be
//        // needed later.
//        // Add code to clean up other strong references to the view in
//        // the view hierarchy.
//        // 目的是再次进入时能够重新加载调用viewDidLoad函数。
//        self.view = nil;
//    }
}

#pragma mark - NavigationBar
- (void)layoutHomeView {
    _navImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _navImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navImageView];
    //    _navImageView.alpha = 0;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - 100, 20, 200, 44)];
    titleLab.text = @"交易查询";
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
