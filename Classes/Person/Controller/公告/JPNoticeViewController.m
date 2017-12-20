//
//  JPNoticeViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/7/18.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPNoticeViewController.h"
#import "JPInfoModel.h"
#import "JPLastestNewsDetailViewController.h"

@interface JPNoticeCell : UITableViewCell
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UILabel *showDetailLab;
@property (nonatomic, strong) UIImageView *indicatorView;
@property (nonatomic, strong) JPInfoModel *infoModel;
@end

@implementation JPNoticeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.logoView];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.showDetailLab];
        [self.contentView addSubview:self.indicatorView];
        [self.contentView addSubview:self.contentLab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(20));
        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(25));
        make.size.mas_equalTo(CGSizeMake(JPRealValue(44), JPRealValue(44)));
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-30));
        make.centerY.equalTo(weakSelf.logoView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(150), JPRealValue(26)));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.logoView.mas_right).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.logoView.mas_centerY);
        make.right.equalTo(weakSelf.timeLab.mas_left).offset(JPRealValue(-20));
        make.height.equalTo(@(JPRealValue(34)));
    }];
    [self.showDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab.mas_left);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(150), JPRealValue(58)));
    }];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.showDetailLab.mas_centerY);
        make.right.equalTo(weakSelf.timeLab.mas_right);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(12), JPRealValue(22)));
    }];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab.mas_left);
        make.top.equalTo(weakSelf.titleLab.mas_bottom).offset(JPRealValue(32));
        make.right.equalTo(weakSelf.timeLab.mas_right);
        make.bottom.equalTo(weakSelf.showDetailLab.mas_top);
    }];
}

- (void)setInfoModel:(JPInfoModel *)infoModel {
    self.titleLab.text = infoModel.title;
    
    NSString *timeStr = infoModel.createTimeSt;
    NSString *time = [NSDate stringFromDate:[NSDate dateFromString:timeStr withFormat:@"yyyy-MM-dd"] withFormat:@"yyyy/MM/dd"];
    self.timeLab.text = time;

    self.contentLab.text = infoModel.content;
}

- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [UIImageView new];
        _logoView.image = [UIImage imageNamed:@"jp_notice_logo"];
    }
    return _logoView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.text = @"服务商系统升级";
        _titleLab.font = [UIFont boldSystemFontOfSize:JPRealValue(34)];
        _titleLab.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _titleLab;
}
- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.text = @"2017/05/26";
        _timeLab.font = [UIFont systemFontOfSize:JPRealValue(26)];
        _timeLab.textColor = JP_NoticeText_Color;
        _timeLab.textAlignment = NSTextAlignmentRight;
    }
    return _timeLab;
}
- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.numberOfLines = 8;
        _contentLab.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLab.font = JP_DefaultsFont;
        _contentLab.textColor = JP_Content_Color;
    }
    return _contentLab;
}
- (UILabel *)showDetailLab {
    if (!_showDetailLab) {
        _showDetailLab = [UILabel new];
        _showDetailLab.text = @"查看详情";
        _showDetailLab.font = [UIFont systemFontOfSize:JPRealValue(26)];
        _showDetailLab.textColor = JPBaseColor;
    }
    return _showDetailLab;
}
- (UIImageView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [UIImageView new];
        _indicatorView.image = [UIImage imageNamed:@"jp_person_noticeIndicator"];
    }
    return _indicatorView;
}
@end

@interface JPNoticeViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *ctntView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, getter=isLoading) BOOL loading;
@property (nonatomic, strong) JPNoticeCell *tempCell;
@end

static NSString *noticeCell = @"noticeCell";

@implementation JPNoticeViewController

- (void)setLoading:(BOOL)loading {
    if (self.isLoading == loading) {
        return;
    }
    
    _loading = loading;
    
    [self.ctntView reloadEmptyDataSet];
}

#pragma mark - 断网
- (void)outsideNetworkWithStartRow:(NSInteger)startRow {
    weakSelf_declare;
    //  监控网络状态变化
    [JPNetworkUtils netWorkState:^(NSInteger netState) {
        switch (netState) {
            case 1:
            case 2:
            {
                [weakSelf getInfoWithStartRow:startRow];
            }
                break;
            default: {
                JPLog(@"没网");
                [weakSelf.ctntView.mj_header endRefreshing];
            }
                break;
        }
    }];
}
#pragma mark - request
- (void)getInfoWithStartRow:(NSInteger)startRow {
    
    weakSelf_declare;
    [IBPersonRequest getNoticeListWithAccount:[JPUserEntity sharedUserEntity].account startRow:startRow callback:^(NSString *code, NSString *msg, id resp) {
        NSDictionary *obj = [IBAnalysis analysisWithEncryptString:resp privateKey:[JPUserEntity sharedUserEntity].privateKey];
        JPLog(@"%@", obj);
        if (code.integerValue == 0) {
            
            NSDictionary *response = (NSDictionary *)obj;
            NSArray *infoList = response[@"informationList"];
            if (infoList.count > 0) {
                for (NSDictionary *dic in infoList) {
                    JPInfoModel *model = [JPInfoModel yy_modelWithDictionary:dic];
                    [weakSelf.dataSource addObject:model];
                }
            }
            self.ctntView.mj_header.hidden = infoList.count <= 0;
            weakSelf.ctntView.mj_footer.hidden = infoList.count != 10;
            if (infoList.count == 10) {
                [weakSelf.ctntView.mj_footer resetNoMoreData];
            } else {
                [weakSelf.ctntView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [IBProgressHUD showInfoWithStatus:msg];
        }
        [weakSelf.ctntView reloadData];
        [weakSelf.ctntView.mj_header endRefreshing];
        [weakSelf.ctntView.mj_footer endRefreshing];
    }];
}

#pragma mark - View
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.ctntView];
    
    self.ctntView.emptyDataSetSource = self;
    self.ctntView.emptyDataSetDelegate = self;
    
    weakSelf_declare;
    //  下拉刷新
    self.ctntView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNo = 0;
        [weakSelf.dataSource removeAllObjects];
        [weakSelf outsideNetworkWithStartRow:weakSelf.pageNo];
    }];
    self.ctntView.mj_header.hidden = YES;
    
    //  上拉加载
    self.ctntView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageNo ++;
        [weakSelf outsideNetworkWithStartRow:weakSelf.pageNo * 10];
    }];
    self.ctntView.mj_footer.hidden = YES;
    
    [self.ctntView.mj_header beginRefreshing];
    
    self.tempCell = [[JPNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noticeCell];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JPNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:noticeCell forIndexPath:indexPath];
    cell.infoModel = self.dataSource[indexPath.section];
    return cell;
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JPInfoModel *model = self.dataSource[indexPath.section];
    CGRect rect = [NSString getHeightOfText:model.content width:(kScreenWidth - JPRealValue(114)) font:JP_DefaultsFont];
    CGFloat cellHeight = rect.size.height;
    if (cellHeight > JPRealValue(280)) {
        cellHeight = JPRealValue(280);
    }
    return cellHeight + JPRealValue(165);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [MobClick event:@"notice_detail"];
    
    JPLastestNewsDetailViewController *detailVC = [[JPLastestNewsDetailViewController alloc] init];
    detailVC.navigationItem.title = @"公告详情";
    JPInfoModel *model = self.dataSource[indexPath.section];
    detailVC.noticeTitle = model.title;
    detailVC.date = model.createTimeSt;
    detailVC.content = model.content;
    [self.navigationController pushViewController:detailVC animated:YES];
}

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

#pragma mark - Lazy
- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        _ctntView.rowHeight = JPRealValue(242);
        _ctntView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ctntView.backgroundColor = JP_viewBackgroundColor;
        _ctntView.estimatedRowHeight = 300;
        _ctntView.estimatedSectionHeaderHeight = 0;
        _ctntView.estimatedSectionFooterHeight = 0;
        
        [_ctntView registerClass:[JPNoticeCell class] forCellReuseIdentifier:noticeCell];
    }
    return _ctntView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

#pragma mark - DZNEmptyDataSetSource
#pragma mark 空白页显示图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.isLoading) {
        // 圆形加载图片
        return [UIImage imageNamed:@"loading_imgBlue_78x78"];
    } else {
        // 默认静态图片
        return [UIImage imageNamed:@"jp_result_noNotice"];
    }
}

#pragma mark 图片旋转动画
- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
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
    [self getInfoWithStartRow:0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 关闭动画，reloadEmptyDataSet
        self.loading = NO;
    });
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -64;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"正在加载，请稍后...";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return self.loading ? [[NSAttributedString alloc] initWithString:text attributes:attributes] : nil;
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
