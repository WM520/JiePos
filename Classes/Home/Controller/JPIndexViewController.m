//
//  JPIndexViewController.m
//  JiePos
//
//  Created by iBlocker on 2017/8/11.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPIndexViewController.h"
#import "JPHomeModel.h"
#import "NSObject+JPExtention.h"
#import "JPHomeView.h"
#import "JPSearchViewController.h"
#import "JPCashViewController.h"
#import "JPCodeViewController.h"
#import "JPLastestNewsDetailViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "WMCustomAlert.h"
#import "JPBindingPhoneNumberViewController.h"
#import "JPNewsViewController.h"
//  背景音乐
#import "YUAudio.h"
#import "LXAlertView.h"

@interface JPIndexViewController () <UIScrollViewDelegate, SDCycleScrollViewDelegate> {
    YUAudioPlayer *audioPlayer;
    BOOL _isShare;
}
/** Header*/
@property (nonatomic, strong) UIImageView *navImageView;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton * rightBtn;
@property (nonatomic, strong) UIImageView *backImg;
@property (nonatomic, strong) UIImageView *backImgs;
@property (nonatomic, strong) UIImageView *backImg2;
@property (nonatomic, strong) UIImageView *backImgs2;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) JPRollingView *rollingView;

@property (nonatomic, assign) BOOL isRolling;

@property (nonatomic, strong) JPPieView *pieView;
//@property (nonatomic, strong) JPCashView *cashView;
@property (nonatomic, strong) JPLineView *lineView;

/** 折线图点的数值*/
@property (nonatomic, strong) NSMutableArray *dataSource;
/** Banner数据*/
@property (nonatomic, strong) NSMutableArray *adImageList;
@property (nonatomic, strong) NSMutableArray *adertisementList;
/** 是否可提现*/
//@property (nonatomic, assign) BOOL canGetCash;
@property (nonatomic, assign) BOOL isShow;
// 消费形式list
@property (nonatomic, strong) NSArray * segmentTitleArray;
// 未读消息红色提示
@property (nonatomic, strong) UILabel * redLabel;

@end

@implementation JPIndexViewController

- (void)dealloc {
    [audioPlayer stop];
    audioPlayer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - request
- (void)createRequest {
    weakSelf_declare;
    //  等折线图数据和首页金额数据数据都获取完毕后再进行下一步操作
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    
    NSMutableArray *lastMondays = @[].mutableCopy;
    NSArray *lastDays = [NSDate getLastDaysWithFormat:@"yyyyMMdd"];
    for (NSString *dateStr in lastDays) {
        NSDate *date = [NSDate dateFromString:dateStr withFormat:@"yyyyMMdd"];
        NSInteger weekends = [date dayOfWeek];
        if (weekends == 1) {
            [lastMondays addObject:dateStr];
        }
    }
    [IBHomeRequest getCurveWithAccount:[JPUserEntity sharedUserEntity].account startDate:[lastDays firstObject] callback:^(NSString *code, NSString *msg, id resp) {
        
        JPLog(@"%@ - %@ - %@", code, msg, resp);
        id obj = [IBAnalysis analysisWithEncryptString:resp privateKey:[JPUserEntity sharedUserEntity].privateKey];
        
        if (code.integerValue == 0) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                if ([obj[@"flowList"] isKindOfClass:[NSArray class]]) {
                    NSArray *arr = obj[@"flowList"];
                    NSMutableArray *dataSource = @[].mutableCopy;
                    for (NSDictionary *dic in arr) {
                        JPHomeChartModel *model = [JPHomeChartModel yy_modelWithDictionary:dic];
                        [dataSource addObject:model];
                    }
                    // !!!:给折线图数据源赋值
                    weakSelf.lineView.pointDataSource = dataSource;
                }
            }
        } else {
            [IBProgressHUD showInfoWithStatus:msg];
        }
        dispatch_group_leave(group);
    }];
    
    // !!!: Banner数据
    dispatch_group_enter(group);
    [IBHomeRequest bannerDataWithAccount:[JPUserEntity sharedUserEntity].account callback:^(NSString *code, NSString *msg, id resp) {
//        JPLog(@"Banner数据 - %@ - %@ - %@", code, msg, resp);
        id obj = [IBAnalysis analysisWithEncryptString:resp privateKey:[JPUserEntity sharedUserEntity].privateKey];
        if (code.integerValue == 0) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSArray *arr = obj[@"advertisements"];
                [weakSelf.adertisementList removeAllObjects];
                for (NSDictionary *dic in arr) {
                    IBAdvertisementModel *model = [IBAdvertisementModel yy_modelWithDictionary:dic];
                    [weakSelf.adertisementList addObject:model];
                }
                [weakSelf.adImageList removeAllObjects];
                for (IBAdvertisementModel *model in weakSelf.adertisementList) {
                    [weakSelf.adImageList addObject:model.bannerUrl];
                }
                // !!!:给banner赋值
                weakSelf.cycleScrollView.imageURLStringsGroup = weakSelf.adImageList;
            }
        } else {
            [IBProgressHUD showInfoWithStatus:msg];
        }
        dispatch_group_leave(group);
    }];
    
    // !!!: 首页金额数据
    dispatch_group_enter(group);
    

    [IBHomeRequest getHomeDataWithAccount:[JPUserEntity sharedUserEntity].account applyType:[JPUserEntity sharedUserEntity].applyType merchantId:[JPUserEntity sharedUserEntity].merchantId merchantNo:[JPUserEntity sharedUserEntity].merchantNo callback:^(NSString *code, NSString *msg, id resp) {
        id obj = [IBAnalysis analysisWithEncryptString:resp privateKey:[JPUserEntity sharedUserEntity].privateKey];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if (code.integerValue == 0) {
                NSDictionary *dic = (NSDictionary *)obj;
                if (dic.count > 0) {
                    JPLog(@"dic --- %@", dic);
                    JPHomeModel *model = [JPHomeModel yy_modelWithDictionary:dic];
                    //                    weakSelf.lineView.dayNum = homeModel.todayTotal;
                
                    NSInteger curMonthTransAt = [model.curMonthTransAt doubleValue] * 100;
                    weakSelf.lineView.monthNum = [NSString stringWithFormat:@"%.2f", curMonthTransAt / 100.0];
                    weakSelf.segmentTitleArray = [dic objectForKey:@"payList"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kCFNewNoticeNotification object:model];
                }
            } else {
                [IBProgressHUD showInfoWithStatus:msg];
            }
        } else {
            [IBProgressHUD showInfoWithStatus:msg];
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //  请求完毕后的处理
        [weakSelf reloadScrollSubviews];
        [weakSelf.scrollView.mj_header endRefreshing];
    });
}
#pragma mark - view
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    JPNavigationController *newsNav = self.tabBarController.viewControllers[1];
//    NSString *badge = nil;
//    if ([JPPushHelper badgeNumber] > 0) {
//        badge = [NSString stringWithFormat:@"%ld", (long)[JPPushHelper badgeNumber]];
//    }
//    [newsNav.tabBarItem setBadgeValue:badge];
    
    
    [self.scrollView.mj_header beginRefreshing];
    
    if (self.isRolling) {
        // 开启跑马灯
        [self.rollingView.horizontalMarquee marqueeOfSettingWithState:MarqueeStart_H];
    }
    
  
    if ([JP_UserDefults objectForKey:@"FirstRemind"] == NULL) {
        [JP_UserDefults setObject:@"FirstRemind" forKey:@"FirstRemind"];
        weakSelf_declare;
        LXAlertView * alert = [[LXAlertView alloc] initWithTitle:@"提醒" message:@"您还没有绑定手机号，请绑定手机号" cancelBtnTitle:@"取消" otherBtnTitle:@"设置" clickIndexBlock:^(NSInteger clickIndex) {
            if (clickIndex == 1) {
                JPBindingPhoneNumberViewController * vc = [[JPBindingPhoneNumberViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
            }
        }];
        [alert showLXAlertView];
    }
    
    //  播放背景音乐
#if TARGET_IPHONE_SIMULATOR //模拟器
    JPLog(@"现在是模拟器环境下");
#elif TARGET_OS_IPHONE //真机
    JPLog(@"现在是真机环境下");
    if ([IBSwitchManager sharedManager].canPlayMusic) {
        if (audioPlayer) {
            [audioPlayer stop];
            audioPlayer = nil;
        } else {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Fire" ofType:@"mp3"];
            audioPlayer = [[YUAudioPlayer alloc] init];
            [audioPlayer playWithUrl:path];
        }
    }
#endif
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.isRolling) {
        // 关闭跑马灯
        [self.rollingView.horizontalMarquee marqueeOfSettingWithState:MarqueeShutDown_H];
    }
    if (audioPlayer) {
        [audioPlayer stop];
        audioPlayer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = JP_viewBackgroundColor;
    
    weakSelf_declare;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kCFUMMessageClickNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if (!weakSelf.redLabel) {
            if ([JPPushHelper badgeNumber] > 0) {
                weakSelf.redLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 15, 15)];
                weakSelf.redLabel.backgroundColor = [UIColor redColor];
                weakSelf.redLabel.textColor = [UIColor whiteColor];
                weakSelf.redLabel.textAlignment = NSTextAlignmentCenter;
                weakSelf.redLabel.font = [UIFont systemFontOfSize:12];
                weakSelf.redLabel.layer.masksToBounds = YES;
                weakSelf.redLabel.layer.cornerRadius = 7.5;
                weakSelf.redLabel.text = [NSString stringWithFormat:@"%ld", (long)[JPPushHelper badgeNumber]];
                [weakSelf.rightBtn addSubview:_redLabel];
            }
        } else {
            if ([JPPushHelper badgeNumber] > 0) {
                weakSelf.redLabel.text = [NSString stringWithFormat:@"%ld", (long)[JPPushHelper badgeNumber]];
            } else {
                [weakSelf.redLabel removeFromSuperview];
            }
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kCFUMMessageReceiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if (!weakSelf.redLabel) {
            if ([JPPushHelper badgeNumber] > 0) {
                weakSelf.redLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 15, 15)];
                weakSelf.redLabel.backgroundColor = [UIColor redColor];
                weakSelf.redLabel.textColor = [UIColor whiteColor];
                weakSelf.redLabel.textAlignment = NSTextAlignmentCenter;
                weakSelf.redLabel.font = [UIFont systemFontOfSize:12];
                weakSelf.redLabel.layer.masksToBounds = YES;
                weakSelf.redLabel.layer.cornerRadius = 7.5;
                weakSelf.redLabel.text = [NSString stringWithFormat:@"%ld", (long)[JPPushHelper badgeNumber]];
                [weakSelf.rightBtn addSubview:_redLabel];
            }
        } else {
            if ([JPPushHelper badgeNumber] > 0) {
                weakSelf.redLabel.text = [NSString stringWithFormat:@"%ld", (long)[JPPushHelper badgeNumber]];
            } else {
                [weakSelf.redLabel removeFromSuperview];
            }
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"haveReadAction" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if (!weakSelf.redLabel) {
            if ([JPPushHelper badgeNumber] > 0) {
                weakSelf.redLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 15, 15)];
                weakSelf.redLabel.backgroundColor = [UIColor redColor];
                weakSelf.redLabel.textColor = [UIColor whiteColor];
                weakSelf.redLabel.textAlignment = NSTextAlignmentCenter;
                weakSelf.redLabel.font = [UIFont systemFontOfSize:12];
                weakSelf.redLabel.layer.masksToBounds = YES;
                weakSelf.redLabel.layer.cornerRadius = 7.5;
                weakSelf.redLabel.text = [NSString stringWithFormat:@"%ld", (long)[JPPushHelper badgeNumber]];
                [weakSelf.rightBtn addSubview:_redLabel];
            }
        } else {
            if ([JPPushHelper badgeNumber] > 0) {
                weakSelf.redLabel.text = [NSString stringWithFormat:@"%ld", (long)[JPPushHelper badgeNumber]];
            } else {
                [weakSelf.redLabel removeFromSuperview];
            }
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kCFNewNoticeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        JPHomeModel *model = (JPHomeModel *)note.object;
        
        weakSelf.pieView.segmentTitleArray = [NSMutableArray arrayWithArray:self.segmentTitleArray];
        //  环状图
        if ([JPUserEntity sharedUserEntity].applyType == 1) {
            //  K9商户
//            weakSelf.pieView.segmentDataArray = @[model.weixin, model.alipay, model.jieji, model.bank].mutableCopy;
//            weakSelf.pieView.segmentTitleArray = @[@"微信", @"支付宝",@"借记卡", @"贷记卡"].mutableCopy;
//            weakSelf.pieView.segmentColorArray = @[[UIColor colorWithHexString:@"0ddddd"], [UIColor colorWithHexString:@"7a93f5"], [UIColor colorWithHexString:@"f5b87a"], [UIColor colorWithHexString:@"c87af5"],[UIColor colorWithHexString:@"0ddddd"], [UIColor colorWithHexString:@"7a93f5"],[UIColor colorWithHexString:@"0ddddd"]].mutableCopy;
            // 遍历商户支持的支付类型
            NSMutableArray * dataArray = [NSMutableArray array];
            NSMutableArray * colorArray = [NSMutableArray array];
            NSMutableArray * titleArray = [NSMutableArray array];
            for (int i = 0; i < self.segmentTitleArray.count; i++) {
                if ([_segmentTitleArray[i] isEqualToString:@"bank"]) {
                    [dataArray addObject:model.bank == nil ? @"0.00" : model.bank];
                    [titleArray addObject:@"贷记卡"];
                    [colorArray addObject:[UIColor colorWithHexString:@"c87af5"]];
                }
                if ([_segmentTitleArray[i] isEqualToString:@"jieji"]) {
                    [dataArray addObject:model.jieji == nil ? @"0.00" : model.jieji];
                    [titleArray addObject:@"借记卡"];
                    [colorArray addObject:[UIColor colorWithHexString:@"f5b87a"]];
                }
                if ([_segmentTitleArray[i] isEqualToString:@"alipay"]) {
                    if ([JPUserEntity sharedUserEntity].applyType == 1) {
                        [dataArray addObject:model.alipay== nil ? @"0.00" : model.alipay];
                    } else {
                        [dataArray addObject:model.apqrcode == nil ? @"0.00" : model.apqrcode];
                    }
                    
                    [titleArray addObject:@"支付宝"];
                    [colorArray addObject:[UIColor colorWithHexString:@"7a93f5"]];
                }
                if ([_segmentTitleArray[i] isEqualToString:@"weixin"]) {
                    if ([JPUserEntity sharedUserEntity].applyType == 1) {
                        [dataArray addObject:model.weixin == nil ? @"0.00" : model.weixin];
                    } else {
                        [dataArray addObject:model.wxqrcode == nil ? @"0.00" : model.wxqrcode];
                    }
                    [titleArray addObject:@"微信"];
                    [colorArray addObject:[UIColor colorWithHexString:@"0ddddd"]];
                }
                
                if ([_segmentTitleArray[i] isEqualToString:@"qqpay"]) {
                    [dataArray addObject:model.qqpay == nil ? @"0.00" : model.qqpay];
                    [titleArray addObject:@"QQ钱包"];
                    [colorArray addObject:[UIColor colorWithHexString:@"#57E191"]];
                }
                if ([_segmentTitleArray[i] isEqualToString:@"jdpay"]) {
                    [dataArray addObject:model.jdpay == nil ? @"0.00" : model.jdpay];
                    [titleArray addObject:@"京东钱包"];
                    [colorArray addObject:[UIColor colorWithHexString:@"FC6074"]];
                }
                
                if ([_segmentTitleArray[i] isEqualToString:@"unionpay"]) {
                    [dataArray addObject:model.unionpay == nil ? @"0.00" : model.unionpay];
                    [titleArray addObject:@"银联二维码"];
                    [colorArray addObject:[UIColor colorWithHexString:@"FDD55A"]];
                }
                
            }
            weakSelf.pieView.segmentDataArray = dataArray;
            weakSelf.pieView.segmentTitleArray = titleArray;
            weakSelf.pieView.segmentColorArray = colorArray;
        } else {
            //  一码付商户
            weakSelf.pieView.segmentDataArray = @[model.wxqrcode == nil ? @"0.00" : model.wxqrcode, model.apqrcode == nil ? @"0.00" : model.apqrcode].mutableCopy;
            weakSelf.pieView.segmentTitleArray = @[@"微信", @"支付宝"].mutableCopy;
            weakSelf.pieView.segmentColorArray = @[[UIColor colorWithHexString:@"0ddddd"], [UIColor colorWithHexString:@"7a93f5"]].mutableCopy;
        }
   
        
        NSInteger todayTotal = [model.todayTotal doubleValue] * 100;
        weakSelf.pieView.ammountLab.text = [NSString stringWithFormat:@"%.2f", todayTotal / 100.0];
//        [self.pieView.chartView showCustomViewInSuperView:self.pieView];
//        [self.pieView reloadData];

        if (![JP_UserDefults boolForKey:@"roll"]) {
            [JP_UserDefults setBool:YES forKey:@"isRolling"];
            [JP_UserDefults setBool:YES forKey:@"roll"];
            [JP_UserDefults synchronize];
        }
        //  若用户关闭了最新公告显示，则客户端不显示
        if ([JP_UserDefults boolForKey:@"isRolling"]) {
            weakSelf.isRolling = model.title.length > 0;
        }
        
        if (weakSelf.isRolling) {
            [weakSelf.scrollView addSubview:weakSelf.rollingView];
            weakSelf.rollingView.horizontalMarquee.text = [NSString stringWithFormat:@"%@      ", model.title];
            // 开启跑马灯
            [weakSelf.rollingView.horizontalMarquee marqueeOfSettingWithState:MarqueeStart_H];
            weakSelf.rollingView.tapBlock = ^{
                //  点击跑马灯方法
                
                JPLastestNewsDetailViewController *lastestVC = [JPLastestNewsDetailViewController new];
                lastestVC.navigationItem.title = @"最新公告";
                lastestVC.noticeTitle = model.title;
                lastestVC.date = model.createTime;
                lastestVC.content = model.content;
                lastestVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:lastestVC animated:YES];
            };
        } else {
            [weakSelf.rollingView removeFromSuperview];
        }
//        weakSelf.canGetCash = [model.isCash isEqualToString:@"1"];
//        if (weakSelf.canGetCash) {
//            weakSelf.cashView.cashLab.text = [NSString stringWithFormat:@"¥%@", model.cashWithdrawal];
//        }
        
        [weakSelf reloadScrollSubviews];
        [weakSelf.pieView reloadData];
    }];
//    [self createRequest];
    
    [self.view addSubview:self.scrollView];
    [self handleHeadView];
    [self handleSubviews];
    
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf createRequest];
    }];
}

#pragma mark - Action
- (void)leftClick {
    //  二维码
    [MobClick event:@"person_qrcode"];

    JPCodeViewController *codeVC = [[JPCodeViewController alloc] init];
    codeVC.navigationItem.title = @"我的收款码";
    codeVC.hidesBottomBarWhenPushed = YES;

    weakSelf_declare;
    [IBProgressHUD loading];
    [IBHomeRequest getQrcodeWithAccount:[JPUserEntity sharedUserEntity].account merchantId:[JPUserEntity sharedUserEntity].merchantId callback:^(NSString *code, NSString *msg, id resp) {
        NSDictionary *obj = [IBAnalysis analysisWithEncryptString:resp privateKey:[JPUserEntity sharedUserEntity].privateKey];
        if (code.integerValue == 0) {
            [IBProgressHUD dismiss];
            [JP_UserDefults setObject:obj[@"merchantName"] forKey:@"merchantName"];
            codeVC.codeModel = [JPCodeModel yy_modelWithDictionary:obj];
            [weakSelf.navigationController pushViewController:codeVC animated:YES];
        } else {
            [IBProgressHUD showInfoWithStatus:msg];
        }
    }];
}

- (void)rightClick
{
    JPNewsViewController * newsvc = [[JPNewsViewController alloc] init];
    newsvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsvc animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
//    IBAdvertisementModel *model = self.adertisementList[index];
//    JPWebViewController *webVC = [JPWebViewController new];
//    webVC.urlString = model.detailUrl;
//    webVC.naviTitle = model.title;
//    webVC.hidesBottomBarWhenPushed = YES;
    // !!!: 1.2.2 环球黑卡
    IBAdvertisementModel *model = self.adertisementList[index];
    JPWebViewController *webVC = [JPWebViewController new];
    NSString * url = model.detailUrl;
    NSArray * array = [url componentsSeparatedByString:@"imagePath="];
    NSLog(@"%@", array);
    if (array.count >= 2) {
        if ([array[1] hasPrefix:@"https"]) {
            webVC.urlString = array[1];
        } else {
            webVC.urlString = model.detailUrl;
        }
    }
    
    webVC.naviTitle = model.title;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - Layout
- (void)handleSubviews {
    
    weakSelf_declare;
    [self.scrollView addSubview:self.cycleScrollView];
    
    if (self.isRolling) {
        self.pieView.frame = (CGRect){JPRealValue(30), self.cycleScrollView.frame.size.height + JPRealValue(60) + JPRealValue(20), kScreenWidth - JPRealValue(60), JPRealValue(80) + 210};
    } else {
        self.pieView.frame = (CGRect){JPRealValue(30), self.cycleScrollView.frame.size.height + JPRealValue(20), kScreenWidth - JPRealValue(60), JPRealValue(80) + 210};
    }
    [self.scrollView addSubview:self.pieView];
    
//    if (self.canGetCash) {
//        //  可提现金额
//        self.cashView.frame = (CGRect){JPRealValue(30), self.pieView.frame.origin.y + self.pieView.frame.size.height + JPRealValue(20), kScreenWidth - JPRealValue(60), JPRealValue(240)};
//        
//        //  折线图
//        self.lineView.frame = (CGRect){JPRealValue(30), self.cashView.frame.origin.y + self.cashView.frame.size.height + JPRealValue(20), kScreenWidth - JPRealValue(60), 230 + JPRealValue(372)};
//    } else {
        //  折线图
        self.lineView.frame = (CGRect){JPRealValue(30), self.pieView.frame.origin.y + self.pieView.frame.size.height + JPRealValue(20), kScreenWidth - JPRealValue(60), 230 + JPRealValue(260)};
//    }
    self.lineView.dealSearchBlock = ^{
        // !!!: 交易查询
        JPSearchViewController *queryVC = [[JPSearchViewController alloc] init];
        queryVC.hidesBottomBarWhenPushed = YES;
        
        [JPNetworkUtils netWorkState:^(NSInteger netState) {
            switch (netState) {
                case 1:case 2: {
                    [MobClick event:@"home_dealSearch"];
                    [weakSelf.navigationController pushViewController:queryVC animated:YES];
                }
                    break;
                default: {
                    [IBProgressHUD showInfoWithStatus:@"网络异常，请稍后再试"];
                }
                    break;
            }
        }];
    };
    [self.scrollView addSubview:self.lineView];
    
    //  根据lineView内容自适应高度
    CGSize actualSize = [self.lineView sizeThatFits:CGSizeZero];
    CGRect newFrame = self.lineView.frame;
    newFrame.size.height = actualSize.height;
    self.lineView.frame = newFrame;
    //  根据lineView高度计算scrollView的ContentSize
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth, newFrame.origin.y + newFrame.size.height + 10)];
}

- (void)reloadScrollSubviews {
    self.cycleScrollView.frame = (CGRect){0, 0, kScreenWidth, JPRealValue(360)};
    //  有跑马灯
    if (self.isRolling) {
        self.rollingView.frame = (CGRect){0, JPRealValue(360), kScreenWidth, JPRealValue(60)};
        self.pieView.frame = (CGRect){JPRealValue(30), self.cycleScrollView.frame.size.height + JPRealValue(60) + JPRealValue(20), kScreenWidth - JPRealValue(60), JPRealValue(80) + 215};
    } else {
        self.pieView.frame = (CGRect){JPRealValue(30), self.cycleScrollView.frame.size.height + JPRealValue(20), kScreenWidth - JPRealValue(60), JPRealValue(80) + 215};
    }
//    //  可提现
//    if (self.canGetCash) {
//        [self.scrollView addSubview:self.cashView];
//        //  可提现金额
//        self.cashView.frame = (CGRect){JPRealValue(30), self.pieView.frame.origin.y + self.pieView.frame.size.height + JPRealValue(20), kScreenWidth - JPRealValue(60), JPRealValue(240)};
//        //  折线图
//        self.lineView.frame = (CGRect){JPRealValue(30), self.cashView.frame.origin.y + self.cashView.frame.size.height + JPRealValue(20), kScreenWidth - JPRealValue(60), 235 + JPRealValue(372)};
//    } else {
        //  折线图
        self.lineView.frame = (CGRect){JPRealValue(30), self.pieView.frame.origin.y + self.pieView.frame.size.height + JPRealValue(20), kScreenWidth - JPRealValue(60), 235 + JPRealValue(260) - JPRealValue(98)};
//    }
    //  根据lineView内容自适应高度
    CGSize actualSize = [self.lineView sizeThatFits:CGSizeZero];
    CGRect newFrame = self.lineView.frame;
    newFrame.size.height = actualSize.height;
    self.lineView.frame = newFrame;
    //  根据lineView高度计算scrollView的ContentSize
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth, newFrame.origin.y + newFrame.size.height + 10)];
}

#pragma mark - Lazy
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}
- (NSMutableArray *)adImageList {
    if (!_adImageList) {
        _adImageList = @[].mutableCopy;
    }
    return _adImageList;
}
- (NSMutableArray *)adertisementList {
    if (!_adertisementList) {
        _adertisementList = @[].mutableCopy;
    }
    return _adertisementList;
}

- (NSArray *)segmentTitleArray
{
    if (!_segmentTitleArray) {
        _segmentTitleArray = [NSArray array];
    }
    return _segmentTitleArray;
}

#pragma mark - Subviews
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight - 49}];
        _scrollView.contentInset = UIEdgeInsetsMake(-kStatusBarHeight, 0, 0, 0);
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
        _scrollView.delegate = self;
        [_scrollView sizeToFit];
    }
    return _scrollView;
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, JPRealValue(360)) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.autoScrollTimeInterval = 3;
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    }
    return _cycleScrollView;
}

- (JPRollingView *)rollingView {
    if (!_rollingView) {
        _rollingView = [JPRollingView new];
        _rollingView.frame = (CGRect){0, JPRealValue(360), kScreenWidth, JPRealValue(60)};
        weakSelf_declare;
        _rollingView.deleteBlock = ^{
            
            [JP_UserDefults setBool:NO forKey:@"isRolling"];
            [JP_UserDefults synchronize];
            
            //  我不想看跑马灯
            weakSelf.isRolling = YES;
            
            [weakSelf.rollingView removeFromSuperview];
            [weakSelf handleSubviews];
        };
    }
    return _rollingView;
}

- (JPPieView *)pieView {
    if (!_pieView) {
        _pieView = [JPPieView new];
    }
    return _pieView;
}

//- (JPCashView *)cashView {
//    if (!_cashView) {
//        _cashView = [JPCashView new];
//        weakSelf_declare;
//        _cashView.cashDetailBlock = ^{
//            // !!!: 提现明细
//            JPCashDetailViewController *cashDetailVC = [JPCashDetailViewController new];
//            cashDetailVC.navigationItem.title = @"提现记录";
//            cashDetailVC.hidesBottomBarWhenPushed = YES;
//            [weakSelf.navigationController pushViewController:cashDetailVC animated:YES];
//        };
//        _cashView.getCashBlock = ^{
//            // !!!: 立即提现
//            JPCashViewController *cashVC = [JPCashViewController new];
//            cashVC.navigationItem.title = @"立即提现";
//            cashVC.hidesBottomBarWhenPushed = YES;
//            [weakSelf.navigationController pushViewController:cashVC animated:YES];
//        };
//    }
//    return _cashView;
//}

- (JPLineView *)lineView {
    if (!_lineView) {
        _lineView = [JPLineView new];
        _lineView.monthNum = @"0";
    }
    return _lineView;
}

#pragma mark - head
- (void)handleHeadView {
    
    _navImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
//    _navImageView.backgroundColor = JPBaseColor;
    _navImageView.alpha = 0;
    [self.view insertSubview:_navImageView atIndex:1];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"7a93f5"].CGColor, (__bridge id)[UIColor colorWithHexString:@"68b2f2"].CGColor, (__bridge id)[UIColor colorWithHexString:@"51dbf0"].CGColor];
    gradientLayer.locations = @[@0, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = (CGRect){0, 0, kScreenWidth, 64};
    [_navImageView.layer addSublayer:gradientLayer];
    
    
    _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 100, 44)];
    _titleLb.font = [UIFont systemFontOfSize:16.8];
    _titleLb.textAlignment = NSTextAlignmentCenter;
    _titleLb.textColor = [UIColor whiteColor];
    //    _title.backgroundColor = [UIColor greenColor];
    _titleLb.text = @"首页";
    _titleLb.center = CGPointMake(self.view.center.x, 42);
    [_navImageView addSubview:_titleLb];
    
    if ([JPUserEntity sharedUserEntity].applyType == 2) {
        _leftBtn = [[UIButton alloc] init];
        _leftBtn.frame = CGRectMake(10, 20, 40, 40);
        [_leftBtn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
        _backImg = [[UIImageView alloc] init];
        _backImg.frame = CGRectMake(10, 7, 25, 25);
        _backImg.image = [UIImage imageNamed:@"jp_home_code"];
        [_leftBtn addSubview:_backImg];
        _backImgs = [[UIImageView alloc] init];
        _backImgs.frame = CGRectMake(10, 7, 25, 25);
        _backImgs.image = [UIImage imageNamed:@"jp_home_code1"];
        [_leftBtn addSubview:_backImgs];
        _backImgs.alpha = 0;
        [self.view addSubview:_leftBtn];
    }
    _rightBtn = [[UIButton alloc] init];
    _rightBtn.frame = CGRectMake(kScreenWidth - 50, 20, 40, 40);
    [_rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    _backImg2 = [[UIImageView alloc] init];
    _backImg2.frame = CGRectMake(10, 7, 25, 25);
    _backImg2.image = [UIImage imageNamed:@"jp_home_news"];
    [_rightBtn addSubview:_backImg2];
    _backImgs2 = [[UIImageView alloc] init];
    _backImgs2.frame = CGRectMake(10, 7, 25, 25);
    _backImgs2.image = [UIImage imageNamed:@"jp_home_news1"];
    [_rightBtn addSubview:_backImgs2];
    _backImgs2.alpha = 0;
    [self.view addSubview:_rightBtn];
    if ([JPPushHelper badgeNumber] > 0) {
        _redLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 15, 15)];
        _redLabel.backgroundColor = [UIColor redColor];
        _redLabel.textColor = [UIColor whiteColor];
        _redLabel.textAlignment = NSTextAlignmentCenter;
        _redLabel.font = [UIFont systemFontOfSize:12];
        _redLabel.layer.masksToBounds = YES;
        _redLabel.layer.cornerRadius = 7.5;
        _redLabel.text = [NSString stringWithFormat:@"%ld", (long)[JPPushHelper badgeNumber]];
        [_rightBtn addSubview:_redLabel];
    }
}

#pragma mark - 导航栏渐变效果
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 180.0) {
        _navImageView.alpha = scrollView.contentOffset.y / 180.0;
        _titleLb.alpha = scrollView.contentOffset.y / 180.0;
        _backImg.alpha = 1 - scrollView.contentOffset.y / 180.0;
        _backImg.alpha = 1 - scrollView.contentOffset.y / 180.0;
//        _shareImg.alpha = 1 - scrollView.contentOffset.y / 180.0;
        _backImgs.alpha = scrollView.contentOffset.y / 180.0;
        _backImgs2.alpha = scrollView.contentOffset.y / 180.0;
//        _shareImgs.alpha = scrollView.contentOffset.y / 180.0;
    } else if (scrollView.contentOffset.y >= 180.0) {
        _navImageView.alpha = 1.0;
        _titleLb.alpha = 1.0;
        _backImg.alpha = 0;
        _backImg2.alpha = 0;
        
//        _shareImg.alpha = 0;
        _backImgs.alpha = 1;
        _backImgs2.alpha = 1;
//        _shareImgs.alpha = 1;
    }
}

- (BOOL)navigationBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


