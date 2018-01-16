//
//  JPNewsViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPNewsViewController.h"
#import "JPNewsHeaderView.h"
#import "JPNewsCell.h"
#import "IBPopView.h"
#import "JPNewsDetailViewController.h"
static NSString *const headerReuseIdentifier = @"headerReuseIdentifier";
static NSString *const cellReuseIdentifier = @"cellReuseIdentifier";

@interface JPNewsViewController ()
<UITableViewDataSource,
UITableViewDelegate,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate,
UIPopoverPresentationControllerDelegate> {
    IBPopView   *_popVC;
}
@property (nonatomic, strong) UITableView *ctntView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, getter=isLoading) BOOL loading;

@end

@implementation JPNewsViewController

#pragma mark - lifestyle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    JPNavigationController *newsNav = self.tabBarController.viewControllers[1];
    //    NSString *badge = nil;
    //    if ([JPPushHelper badgeNumber] > 0) {
    //        badge = [NSString stringWithFormat:@"%ld", (long)[JPPushHelper badgeNumber]];
    //    }
    //    [newsNav.tabBarItem setBadgeValue:badge];
    
    [self.ctntView.mj_header beginRefreshing];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCFUMMessageClickNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"jp_news_allread"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"7a93f5"].CGColor, (__bridge id)[UIColor colorWithHexString:@"68b2f2"].CGColor, (__bridge id)[UIColor colorWithHexString:@"51dbf0"].CGColor];
    gradientLayer.locations = @[@0, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    gradientLayer.frame = (CGRect){0, 0, kScreenWidth, kScreenHeight - 49};
    [self.view.layer addSublayer:gradientLayer];
    
    [self.view addSubview:self.ctntView];
    
    self.ctntView.emptyDataSetSource = self;
    self.ctntView.emptyDataSetDelegate = self;
    
    weakSelf_declare;
    self.ctntView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.dataSource removeAllObjects];
        [weakSelf getDataFromDataBase];
    }];
    self.ctntView.mj_header.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kCFUMMessageClickNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.ctntView.mj_header beginRefreshing];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCFUMMessageClickNotification object:nil];
}

#pragma mark - 获取DataBase数据
- (void)getDataFromDataBase {
    
    NSMutableArray *dataArray = @[].mutableCopy;
    
    NSMutableArray *data = [JPPushHelper dataSource];
    for (NSDictionary *dic in data) {
        JPNewsModel *newsModel = [JPNewsModel yy_modelWithDictionary:dic];
        [dataArray insertObject:newsModel atIndex:0];
    }
    
    NSArray *sortArray = [dataArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        JPNewsModel *pModel1 = obj1;
        JPNewsModel *pModel2 = obj2;
        
        NSDate *date1 = [NSDate dateFromString:pModel1.transactionTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date2 = [NSDate dateFromString:pModel2.transactionTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
            
        if ([date1 compare:date2] == NSOrderedDescending) {
            //不使用intValue比较无效
            return NSOrderedAscending;//降序
        } else if ([date1 compare:date2] == NSOrderedAscending) {
            return NSOrderedDescending;//升序
        } else {
            return NSOrderedSame;//相等
        }
    }];
    
    if (sortArray.count > 0) {
        //  !!!:    对plist获取到的数组按时间再次分组 分配给tableView数据源
        NSMutableArray *timeArr = @[].mutableCopy;
        [sortArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            JPNewsModel *model = obj;
            NSDate *modelDate = [NSDate dateFromString:model.transactionTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *modelTimeString = [NSDate stringFromDate:modelDate withFormat:@"yyyy-MM-dd HH"];
            [timeArr addObject:modelTimeString];
        }];
        //使用asset把timeArr的日期去重
        NSSet *set = [NSSet setWithArray:timeArr];
        NSArray *userArray = [set allObjects];
        NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];//yes升序排列，no,降序排列
        //按日期降序排列的日期数组
        NSArray *myary = [userArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]];
        //此时得到的myary就是按照时间降序排列拍好的数组
        //遍历myary把_titleArray按照myary里的时间分成几个组每个组都是空的数组
        [myary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableArray *arr = @[].mutableCopy;
            [self.dataSource addObject:arr];
            
        }];
        //遍历_dataArray取其中每个数据的日期看看与myary里的那个日期匹配就把这个数据装到_titleArray 对应的组中
        [sortArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            JPNewsModel *model = obj;
            NSDate *modelDate = [NSDate dateFromString:model.transactionTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *modelTimeString = [NSDate stringFromDate:modelDate withFormat:@"yyyy-MM-dd HH"];
            for (NSString *str in myary) {
                if([str isEqualToString:modelTimeString]) {
                    NSMutableArray *arr = [self.dataSource objectAtIndex:[myary indexOfObject:str]];
                    [arr addObject:model];
                }
            }
        }];
    }
    self.ctntView.mj_header.hidden = dataArray.count <= 0;
    [self.ctntView reloadData];
    [self.ctntView.mj_header endRefreshing];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JPNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.newsModel = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark - tableVieDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [MobClick event:@"news_detailed"];
    JPNewsDetailViewController *dealDetailVC = [[JPNewsDetailViewController alloc] init];
//    dealDetailVC.hidesBottomBarWhenPushed = YES;
    dealDetailVC.newsModel = self.dataSource[indexPath.section][indexPath.row];
//    [self.navigationController pushViewController:dealDetailVC animated:YES];
    weakSelf_declare;
    [self presentViewController:dealDetailVC animated:YES completion:^{
        JPNewsModel *model = weakSelf.dataSource[indexPath.section][indexPath.row];
        JPLog(@"%@ - %@ - %@", model.tenantsNumber, model.orderNumber, model.transactionTime);
        [JPPushHelper modifyUnreadWithNewsModel:model];
        [weakSelf.delegate reload];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JPNewsHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerReuseIdentifier];
    JPNewsModel *newsModel = self.dataSource[section][0];
    headerView.timeString = newsModel.transactionTime;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return JPRealValue(70);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - DZNEmptyDataSetSource
#pragma mark 空白页显示图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.isLoading) {
        // 圆形加载图片
        return [UIImage imageNamed:@"loading_imgBlue_78x78"];
    } else {
        // 默认静态图片
        return [UIImage imageNamed:@"jp_result_noNews"];
    }
}

#pragma mark 图片旋转动画
- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    return animation;
    
}

#pragma mark - DZNEmptyDataSetDelegate
#pragma mark 是否开启动画
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return self.isLoading;
}

#pragma mark 空白页面被点击时刷新页面
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    // 空白页面被点击时开启动画，reloadEmptyDataSet
    self.loading = YES;
    [self.ctntView.mj_header beginRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 关闭动画，reloadEmptyDataSet
        self.loading = NO;
    });
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -64-49;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"正在加载，请稍后...";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:JP_DefaultsFont,
                                 NSForegroundColorAttributeName:[UIColor whiteColor],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    return self.loading ? [[NSAttributedString alloc] initWithString:text attributes:attributes] : nil;
}

#pragma mark - Action
- (void)rightClick:(UIBarButtonItem *)rightItem {
    _popVC = [IBPopView new];
    
    _popVC.modalPresentationStyle = UIModalPresentationPopover;
    //设置依附的按钮
    _popVC.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    //可以指示小箭头颜色
    _popVC.popoverPresentationController.backgroundColor = [UIColor whiteColor];
    //content尺寸
    _popVC.preferredContentSize = CGSizeMake(400, 400);
    //pop方向
    _popVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    //delegate
    _popVC.popoverPresentationController.delegate = self;
    [self presentViewController:_popVC animated:YES completion:nil];
    
    weakSelf_declare;
    _popVC.ib_clickBlock = ^(NSInteger index) {
        JPLog(@"我点击了%ld", (long)index);
        if (index == 0) {
            if ([JPPushHelper badgeNumber] > 0) {
                [JPPushHelper modifyAllUnread];
                
                NSString *badge = nil;
                if ([JPPushHelper badgeNumber] > 0) {
                    badge = [NSString stringWithFormat:@"%ld", (long)[JPPushHelper badgeNumber]];
                }
                weakSelf.tabBarItem.badgeValue = badge;
                [weakSelf.ctntView.mj_header beginRefreshing];
                [weakSelf.delegate reload];
                
            } else {
                [IBProgressHUD showInfoWithStatus:@"暂无未读消息"];
            }
        }
    };
}

- (void)setLoading:(BOOL)loading {
    if (self.isLoading == loading) {
        return;
    }
    _loading = loading;
    [self.ctntView reloadEmptyDataSet];
}
//代理方法 ,点击即可dismiss掉每次init产生的PopViewController
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

#pragma mark - lazy
- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44) style:UITableViewStyleGrouped];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        _ctntView.rowHeight = JPRealValue(630);
        _ctntView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ctntView.backgroundColor = [UIColor clearColor];
        _ctntView.estimatedSectionHeaderHeight = 0;
        _ctntView.estimatedSectionFooterHeight = 0;
        
        [_ctntView registerClass:[JPNewsHeaderView class] forHeaderFooterViewReuseIdentifier:headerReuseIdentifier];
        [_ctntView registerClass:[JPNewsCell class] forCellReuseIdentifier:cellReuseIdentifier];
    }
    return _ctntView;
}
//  数据源
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

@end
