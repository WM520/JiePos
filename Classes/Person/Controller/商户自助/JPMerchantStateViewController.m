//
//  JPCashFinishViewController.m
//  JiePos
//
//  Created by iBlocker on 2017/8/21.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPMerchantStateViewController.h"
#import "JPMerchantsSHViewController.h"

@interface JPMerchantsFooterView : UITableViewHeaderFooterView
@property (nonatomic, assign) JPApplyProgress progress;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, copy) void (^jp_merchantsClickBlock)();
@end
@implementation JPMerchantsFooterView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        [self.contentView addSubview:self.nextButton];
    }
    return self;
}
- (void)setProgress:(JPApplyProgress)progress {
    switch (progress) {
        case JPApplyProgressNotThrough:
        {
            [self.nextButton setTitle:@"重新修改" forState:UIControlStateNormal];
            [self.nextButton setTitleColor:JP_NoticeRedColor forState:UIControlStateNormal];
        }
            break;
        case JPApplyProgressThrough:
        {
            [self.nextButton setTitle:@"查看详情" forState:UIControlStateNormal];
            [self.nextButton setTitleColor:JP_Content_Color forState:UIControlStateNormal];
        }
            break;
        case JPApplyProgressApplying:
        {
            [self.nextButton setTitle:@"查看详情" forState:UIControlStateNormal];
            [self.nextButton setTitleColor:JP_Content_Color forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(60));
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.size.mas_equalTo((CGSize){JPRealValue(620), JPRealValue(90)});
    }];
}
- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.titleLabel.font = JP_DefaultsFont;
        _nextButton.layer.cornerRadius = JPRealValue(10);
        _nextButton.layer.masksToBounds = YES;
        _nextButton.layer.borderColor = JP_LayerColor.CGColor;
        _nextButton.layer.borderWidth = 1;
        [_nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}
- (void)nextButtonClick:(UIButton *)sender {
    if (self.jp_merchantsClickBlock) {
        self.jp_merchantsClickBlock();
    }
}
@end

@interface JPMerchantsCell : UITableViewCell
/** 浅红色背景视图*/
@property (nonatomic, strong) UIView *bgView;
/** 白色背景*/
@property (nonatomic, strong) UIView *whiteView;
/** 左侧线条*/
@property (nonatomic, strong) UIImageView *leftView;
/** 右侧线条*/
@property (nonatomic, strong) UIImageView *rightView;
/** 标题*/
@property (nonatomic, strong) UILabel *titleLab;
/** 具体原因*/
@property (nonatomic, strong) UILabel *reasonLab;
@end
@implementation JPMerchantsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.whiteView];
        [self.whiteView addSubview:self.titleLab];
        [self.whiteView addSubview:self.leftView];
        [self.whiteView addSubview:self.rightView];
        [self.bgView addSubview:self.reasonLab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(30));
        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(20));
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-30));
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(JPRealValue(-20));
    }];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(weakSelf.bgView);
        make.height.equalTo(@(JPRealValue(106)));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgView.mas_centerX);
        make.top.and.bottom.equalTo(weakSelf.whiteView);
    }];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.titleLab.mas_centerY);
        make.right.equalTo(weakSelf.titleLab.mas_left).offset(JPRealValue(-20));
    }];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.titleLab.mas_centerY);
        make.left.equalTo(weakSelf.titleLab.mas_right).offset(JPRealValue(20));
    }];
    [self.reasonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(60));
        make.top.equalTo(weakSelf.whiteView.mas_bottom).offset(JPRealValue(30));
        make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-60));
        make.bottom.equalTo(weakSelf.bgView.mas_bottom).offset(JPRealValue(-30));
    }];
}
#pragma mark - Lazy
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor colorWithHexString:@"fffafa"];;
        //        _bgView.layer.shadowColor = [UIColor blackColor].CGColor;
        //        _bgView.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        //        _bgView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
        //        _bgView.layer.shadowRadius = 4;//阴影半径，默认3
        _bgView.layer.cornerRadius = JPRealValue(10);
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
        _bgView.layer.borderWidth = 0.5;
    }
    return _bgView;
}
- (UIView *)whiteView {
    if (!_whiteView) {
        _whiteView = [UIView new];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"审核不通过原因";
        _titleLab.textColor = JP_NoticeRedColor;
        _titleLab.font = [UIFont boldSystemFontOfSize:JPRealValue(30)];
    }
    return _titleLab;
}
- (UIImageView *)leftView {
    if (!_leftView) {
        _leftView = [UIImageView new];
        _leftView.image = [UIImage imageNamed:@"jp_merchants_left"];
    }
    return _leftView;
}
- (UIImageView *)rightView {
    if (!_rightView) {
        _rightView = [UIImageView new];
        _rightView.image = [UIImage imageNamed:@"jp_merchants_right"];
    }
    return _rightView;
}
- (UILabel *)reasonLab {
    if (!_reasonLab) {
        _reasonLab = [UILabel new];
        _reasonLab.font = JP_DefaultsFont;
        _reasonLab.textColor = JP_NoticeRedColor;
        _reasonLab.numberOfLines = 0;
        _reasonLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _reasonLab;
}
@end

@interface JPMerchantStateViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) IBWaterWaveView *waterView;
@property (nonatomic, strong) UIView *navImageView;
/** Logo*/
@property (nonatomic, strong) UIImageView *logoView;
/** 审核状态*/
@property (nonatomic, strong) UILabel *statusLab;
@property (nonatomic, strong) UITableView *ctntView;
@end

static NSString *const merchantsFooterViewReuseIdentifier = @"merchantsFooterView";
static NSString *const merchantsCellReuseIdentifier = @"merchantsCell";

@implementation JPMerchantStateViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.scrollView];
    [self layoutHomeView];
    [self.scrollView addSubview:self.waterView];
    [self.scrollView addSubview:self.logoView];
    [self.scrollView addSubview:self.statusLab];
    [self.scrollView addSubview:self.ctntView];
}

#pragma mark - NavigationBar
- (void)layoutHomeView {
    _navImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _navImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navImageView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - 100, 20, 200, 44)];
    titleLab.text = @"商户自助";
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

- (void)telButtonClick:(UIButton *)sender {
    sender.enabled = NO;
    
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", @"4008400857"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:callPhone]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        } else {
            [IBProgressHUD showInfoWithStatus:@"无法拨打电话！"];
        }
    });
    
    sender.enabled = YES;
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.applyProgress == JPApplyProgressNotThrough ? 3 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2) {
        JPMerchantsCell *cell = [tableView dequeueReusableCellWithIdentifier:merchantsCellReuseIdentifier forIndexPath:indexPath];
        NSString *content = self.merchantsModel.unpassCause;
        if (content.length <= 0) {
            content = @"暂无原因";
        }
        cell.reasonLab.text = content;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.contentView.backgroundColor = JP_viewBackgroundColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = JP_DefaultsFont;
            cell.textLabel.textColor = JP_NoticeText_Color;
            cell.detailTextLabel.font = JP_DefaultsFont;
            cell.detailTextLabel.textColor = JP_Content_Color;
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"商户名称";
            cell.detailTextLabel.text = self.merchantsModel.merchantName;
            cell.imageView.image = [UIImage imageNamed:@"jp_merchants_name"];
        } else {
            cell.textLabel.text = @"法人名称";
            cell.detailTextLabel.text = self.merchantsModel.legalPerson;
            cell.imageView.image = [UIImage imageNamed:@"jp_merchants_legal"];
        }
        return cell;
    }
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *content = self.merchantsModel.unpassCause;
    if (content.length <= 0) {
        content = @"暂无原因";
    }
    CGRect rect = [NSString getHeightOfText:content width:(kScreenWidth - JPRealValue(180)) font:JP_DefaultsFont];
    return (self.applyProgress == JPApplyProgressNotThrough && indexPath.row == 2) ? JPRealValue(212) + rect.size.height : 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return JPRealValue(200);
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    JPMerchantsFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:merchantsFooterViewReuseIdentifier];
    footerView.progress = self.applyProgress;
    
    weakSelf_declare;
    footerView.jp_merchantsClickBlock = ^{
        
        [MobClick event:@"selfHelp_detail"];
        
        JPMerchantsSHViewController *merchantsVC = [[JPMerchantsSHViewController alloc] init];
        merchantsVC.applyProgress = weakSelf.applyProgress;
        merchantsVC.reviewStatus = weakSelf.merchantsModel.reviewStatus;
        [weakSelf.navigationController pushViewController:merchantsVC animated:YES];
    };
    return footerView;
}

#pragma mark - Setter
- (void)setMerchantsModel:(JPStateQueryModel *)merchantsModel {
    
    switch (self.applyProgress) {
        case JPApplyProgressApplying: {
            //  审核中
            self.waterView.startColor = [UIColor colorWithHexString:@"90cfed" alpha:0.7];
            self.waterView.endColor = [UIColor colorWithHexString:@"21e2aa" alpha:0.7];
            self.logoView.image = [UIImage imageNamed:@"jp_merchants_applying"];
        }
            break;
        case JPApplyProgressThrough: {
            //  审核通过
            self.waterView.startColor = [UIColor colorWithHexString:@"7a93f5" alpha:0.7];
            self.waterView.endColor = [UIColor colorWithHexString:@"51dbf0" alpha:0.7];
            self.logoView.image = [UIImage imageNamed:@"jp_merchants_through"];
        }
            break;
        case JPApplyProgressNotThrough: {
            //  审核失败
            self.waterView.startColor = [UIColor colorWithHexString:@"fbd49d" alpha:0.7];
            self.waterView.endColor = [UIColor colorWithHexString:@"ff785c" alpha:0.7];
            self.logoView.image = [UIImage imageNamed:@"jp_merchants_notThrough"];
        }
            break;
        default:
            break;
    }
    self.statusLab.text = merchantsModel.reviewStatus;
    
//    //  根据lineView内容自适应高度
//    CGSize actualSize = [self.ctntView sizeThatFits:CGSizeZero];
//    CGRect newFrame = self.ctntView.frame;
//    newFrame.size.height = actualSize.height;
//    self.ctntView.frame = newFrame;
//    //  根据lineView高度计算scrollView的ContentSize
//    [self.scrollView setContentSize:CGSizeMake(kScreenWidth, newFrame.origin.y + newFrame.size.height + 10)];
    
    _merchantsModel = merchantsModel;
}

- (void)setApplyProgress:(JPApplyProgress)applyProgress {
    _applyProgress = applyProgress;
}

#pragma mark - Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.contentInset = UIEdgeInsetsMake(-kStatusBarHeight, 0, 0, 0);
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
        _scrollView.backgroundColor = JP_viewBackgroundColor;
        //        _scrollView.delegate = self;
        [_scrollView sizeToFit];
    }
    return _scrollView;
}

- (IBWaterWaveView *)waterView {
    if (!_waterView) {
        CGFloat waveHeight = is_iPhone_X ? JPRealValue(456) + 44 : JPRealValue(456);
        _waterView = [[IBWaterWaveView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, waveHeight}];
    }
    return _waterView;
}

- (UITableView *)ctntView {
    if (!_ctntView) {
//        CGFloat waveHeight = is_iPhone_X ? JPRealValue(456) + 44 : JPRealValue(456);
        _ctntView = [[UITableView alloc] initWithFrame:(CGRect){0, JPRealValue(456), kScreenWidth, JPRealValue(700)} style:UITableViewStyleGrouped];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        _ctntView.scrollEnabled = NO;
        _ctntView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ctntView.backgroundColor = JP_viewBackgroundColor;
        
        _ctntView.estimatedSectionHeaderHeight = 0;
        _ctntView.estimatedSectionFooterHeight = 0;
        
        [_ctntView registerClass:[JPMerchantsCell class] forCellReuseIdentifier:merchantsCellReuseIdentifier];
        [_ctntView registerClass:[JPMerchantsFooterView class] forHeaderFooterViewReuseIdentifier:merchantsFooterViewReuseIdentifier];
    }
    return _ctntView;
}

- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - JPRealValue(62), JPRealValue(30) + 64, JPRealValue(124), JPRealValue(124))];
        _logoView.image = [UIImage imageNamed:@"jp_merchants_applying"];
    }
    return _logoView;
}

- (UILabel *)statusLab {
    if (!_statusLab) {
        _statusLab = [[UILabel alloc] initWithFrame:CGRectMake(JPRealValue(30), JPRealValue(174) + 64, kScreenWidth - JPRealValue(60), JPRealValue(30))];
        _statusLab.textColor = [UIColor whiteColor];
        _statusLab.textAlignment = NSTextAlignmentCenter;
        _statusLab.font = [UIFont boldSystemFontOfSize:JPRealValue(30)];
    }
    return _statusLab;
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
