//
//  JPCashViewController.m
//  JiePos
//
//  Created by iBlocker on 2017/8/10.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPCashViewController.h"
#import "CYPasswordView.h"
#import "JPFogetPayPassViewController.h"
#import "JPCashFinishViewController.h"
#import "JPCashModel.h"

@interface JPCashHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *accountLab;
@end
@implementation JPCashHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.accountLab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(JPRealValue(-20));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(30));
    }];
    [self.accountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-30));
        make.top.equalTo(weakSelf.contentView.mas_top).offset(64 + JPRealValue(144));
    }];
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
        _bgView.image = [UIImage imageNamed:@"jp_cash_bg"];
    }
    return _bgView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.text = @"可提现金额";
        _titleLab.font = JP_DefaultsFont;
        _titleLab.textColor = [UIColor whiteColor];
    }
    return _titleLab;
}
- (UILabel *)accountLab {
    if (!_accountLab) {
        _accountLab = [UILabel new];
        _accountLab.font = [UIFont boldSystemFontOfSize:JPRealValue(62)];
        _accountLab.textColor = [UIColor whiteColor];
        _accountLab.textAlignment = NSTextAlignmentCenter;
        _accountLab.text = @"¥4567890.12";
    }
    return _accountLab;
}
@end

typedef void (^jp_cashButtonBlock)();
@interface JPCashFooterView : UITableViewHeaderFooterView
@property (nonatomic, strong) UILabel *noticeLab;
@property (nonatomic, strong) UIButton *cashButton;
@property (nonatomic, strong) UIImageView *leftView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *rightView;
@property (nonatomic, strong) UILabel *ruleLab;
@property (nonatomic, copy) jp_cashButtonBlock cashButtonBlock;
@end
@implementation JPCashFooterView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        [self.contentView addSubview:self.noticeLab];
        [self.contentView addSubview:self.cashButton];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.leftView];
        [self.contentView addSubview:self.rightView];
        [self.contentView addSubview:self.ruleLab];
    }
    return self;
}

#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(30));
        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(20));
    }];
    [self.cashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(130));
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - JPRealValue(150), JPRealValue(80)));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.cashButton.mas_bottom).offset(JPRealValue(94));
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
    }];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.titleLab.mas_left).offset(JPRealValue(-20));
        make.centerY.equalTo(weakSelf.titleLab.mas_centerY);
    }];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab.mas_right).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.titleLab.mas_centerY);
    }];
    [self.ruleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLab.mas_bottom).offset(JPRealValue(60));
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(30));
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-30));
    }];
    
    [self layoutIfNeeded];
}

#pragma mark - lazy
- (UILabel *)noticeLab {
    if (!_noticeLab) {
        _noticeLab = [UILabel new];
        _noticeLab.font = [UIFont systemFontOfSize:JPRealValue(20)];
        _noticeLab.textColor = JP_NoticeRedColor;
        _noticeLab.text = @"注：可提现时间8:00-19:00；起提金额0.00元";
    }
    return _noticeLab;
}
- (UIButton *)cashButton {
    if (!_cashButton) {
        _cashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cashButton setTitle:@"立即提现" forState:UIControlStateNormal];
        [_cashButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cashButton.titleLabel.font = JP_DefaultsFont;
        _cashButton.layer.cornerRadius = JPRealValue(10);
        _cashButton.layer.masksToBounds = YES;
        [_cashButton setBackgroundImage:[UIImage imageNamed:@"jp_button_normal"] forState:UIControlStateNormal];
        [_cashButton setBackgroundImage:[UIImage imageNamed:@"jp_button_highlighted"] forState:UIControlStateHighlighted];
        [_cashButton addTarget:self action:@selector(cashButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cashButton;
}

- (UIImageView *)leftView {
    if (!_leftView) {
        _leftView = [UIImageView new];
        _leftView.image = [UIImage imageNamed:@"jp_cash_left"];
    }
    return _leftView;
}
- (UIImageView *)rightView {
    if (!_rightView) {
        _rightView = [UIImageView new];
        _rightView.image = [UIImage imageNamed:@"jp_cash_right"];
    }
    return _rightView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.text = @"业务规则说明";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = JP_DefaultsFont;
        _titleLab.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _titleLab;
}

- (UILabel *)ruleLab {
    if (!_ruleLab) {
        _ruleLab = [UILabel new];
        _ruleLab.numberOfLines = 0;
        _ruleLab.lineBreakMode = NSLineBreakByWordWrapping;
        _ruleLab.font = [UIFont systemFontOfSize:JPRealValue(20)];
        _ruleLab.textColor = JP_NoticeText_Color;
    }
    return _ruleLab;
}

#pragma mark - Action
- (void)cashButtonClick:(UIButton *)sender {
    if (self.cashButtonBlock) {
        self.cashButtonBlock();
    }
}
@end

#define kRequestTime 3.0f
#define kDelay 0.3f

@interface JPCashViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIButton *cashButton;
@property (nonatomic, strong) CYPasswordView *passwordView;
@property (nonatomic, strong) UITableView *ctntView;
@property (nonatomic, strong) UIView *navImageView;
@property (nonatomic, strong) JPCashModel *cashModel;
@end


@implementation JPCashViewController

- (void)request {
    weakSelf_declare;
    [IBHomeRequest canGetCashWithAccount:[JPUserEntity sharedUserEntity].account
                              merchantNo:[JPUserEntity sharedUserEntity].merchantNo
                                callback:^(NSString *code, NSString *msg, id resp) {
                                    
        id obj = [IBAnalysis analysisWithEncryptString:resp privateKey:[JPUserEntity sharedUserEntity].privateKey];
        JPLog(@"%@", resp);
        if (code.integerValue == 0) {
            weakSelf.cashModel = [JPCashModel yy_modelWithDictionary:obj];
            [weakSelf.ctntView reloadData];
        } else {
            [IBProgressHUD showInfoWithStatus:msg];
        }
        [weakSelf.ctntView.mj_header endRefreshing];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = JP_viewBackgroundColor;
    /** 注册取消按钮点击的通知 */
    [CYNotificationCenter addObserver:self selector:@selector(cancel) name:CYPasswordViewCancleButtonClickNotification object:nil];
    [CYNotificationCenter addObserver:self selector:@selector(forgetPWD) name:CYPasswordViewForgetPWDButtonClickNotification object:nil];
    
    [self.view addSubview:self.ctntView];
    [self layoutHomeView];
    [self request];
    
    weakSelf_declare;
    self.ctntView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf request];
    }];
}

#pragma mark - tableViewDataSource
static NSString *const headerReuseIdentifier = @"headerReuseIdentifier";
static NSString *const footerReuseIdentifier = @"footerReuseIdentifier";
static NSString *const cellReuseIdentifier = @"cellReuseIdentifier";

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellReuseIdentifier];
        cell.contentView.backgroundColor = JP_viewBackgroundColor;
        cell.textLabel.textColor = JP_Content_Color;
        cell.detailTextLabel.textColor = JP_Content_Color;
        cell.textLabel.font = JP_DefaultsFont;
        cell.detailTextLabel.font = JP_DefaultsFont;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"实际到账金额";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元", self.cashModel.realCashWithdrawal];
    } else {
        cell.textLabel.text = @"提现费用";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元", self.cashModel.cashFee];
    }
    return cell;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return JPRealValue(384);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return JPRealValue(700);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JPCashHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerReuseIdentifier];
    headerView.accountLab.text = [NSString stringWithFormat:@"¥%@", self.cashModel.cashWithdrawal];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    JPCashFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerReuseIdentifier];
    footerView.noticeLab.text = [NSString stringWithFormat:@"注：可提现时间%@；起提金额%@元", self.cashModel.cashWithdrawalTime, self.cashModel.enabledCashAmount];
    footerView.ruleLab.text = [self ruleWithPeriodOfTime:self.cashModel.cashWithdrawalTime];
    footerView.cashButton.enabled = [self.cashModel.isCash boolValue];
    weakSelf_declare;
    footerView.cashButtonBlock = ^{
        //  立即提现
        [weakSelf cashButtonClick];
    };
    return footerView;
}

#pragma mark - Action
- (void)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemClicked:(UIButton *)sender {
    //  记录
    JPCashDetailViewController *cashDetailVC = [JPCashDetailViewController new];
    cashDetailVC.navigationItem.title = @"提现记录";
    cashDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cashDetailVC animated:YES];
}

- (void)cashButtonClick {
    weakSelf_declare;
    
    self.passwordView = [[CYPasswordView alloc] init];
    self.passwordView.title = @"输入提现密码";
    self.passwordView.loadingText = @"提交中...";
    [self.passwordView showInView:self.view.window];
    
    self.passwordView.finish = ^(NSString *password) {
        [weakSelf.passwordView hideKeyboard];
        [weakSelf.passwordView startLoading];
        
        [IBHomeRequest getCashWithAccount:[JPUserEntity sharedUserEntity].account merchantNo:[JPUserEntity sharedUserEntity].merchantNo cashWithdrawal:weakSelf.cashModel.cashWithdrawal beginTime:weakSelf.cashModel.beginTime endTime:weakSelf.cashModel.endTime loan:weakSelf.cashModel.loan withdraw:weakSelf.cashModel.withdraw cashFlow:weakSelf.cashModel.cashFlow withdrawPwd:password callback:^(NSString *code, NSString *msg, id resp) {
            
            JPCashFinishViewController *finishVC = [JPCashFinishViewController new];
            id obj = [IBAnalysis analysisWithEncryptString:resp privateKey:[JPUserEntity sharedUserEntity].privateKey];
            if (code.integerValue == 0) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dic = (NSDictionary *)obj;
                    NSArray *keys = dic.allKeys;
                    if ([keys containsObject:@"isSuccess"]) {
                        BOOL isSuccess = [dic[@"isSuccess"] boolValue];
                        if (isSuccess) {
                            [IBProgressHUD showInfoWithStatus:msg];
                            [weakSelf.passwordView requestComplete:YES message:@"提现成功"];
                            [weakSelf.passwordView stopLoading];
                            finishVC.state = JPFinishStateSuccess;
//                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                [weakSelf.passwordView hide];
//                            });
                        } else {
                            [IBProgressHUD showInfoWithStatus:msg];
                            [weakSelf.passwordView requestComplete:NO message:@"提现失败"];
                            [weakSelf.passwordView stopLoading];
                            finishVC.state = JPFinishStateAppling;
                            [IBProgressHUD loadingWithStatus:msg];
                        }
                        [weakSelf.navigationController pushViewController:finishVC animated:YES];
                    }
                }
            } else if (code.integerValue == 9) {
                //  提现密码错误
                [IBProgressHUD showInfoWithStatus:msg];
            } else {
                [IBProgressHUD showInfoWithStatus:msg];
                [weakSelf.passwordView requestComplete:NO message:@"提现失败"];
                [weakSelf.passwordView stopLoading];
                finishVC.state = JPFinishStateAppling;
                [IBProgressHUD loadingWithStatus:msg];
                [weakSelf.navigationController pushViewController:finishVC animated:YES];
            }
            [weakSelf.passwordView stopLoading];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.passwordView hide];
            });
        }];
    };
}

- (void)cancel {
    CYLog(@"关闭密码框");
    [IBProgressHUD showInfoWithStatus:@"提现失败"];
}

- (void)forgetPWD {
    CYLog(@"忘记密码");
    [self.passwordView hide];
    JPFogetPayPassViewController *forgetVC = [JPFogetPayPassViewController new];
    forgetVC.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:forgetVC animated:YES];
}

#pragma mark - Header
- (void)layoutHomeView {
    _navImageView = [[UIView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, 64}];
    _navImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navImageView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:(CGRect){kScreenWidth / 2.0 - 100, 20, 200, 44}];
    titleLab.text = @"立即提现";
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
    rightButton.frame = CGRectMake(kScreenWidth - JPRealValue(120), 26, JPRealValue(90), JPRealValue(60));
    rightButton.titleLabel.font = [UIFont systemFontOfSize:JPRealValue(28)];
    [rightButton setTitle:@"记录" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_navImageView addSubview:rightButton];
}

#pragma mark - Lazy
- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight} style:UITableViewStyleGrouped];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        _ctntView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ctntView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        _ctntView.backgroundColor = JP_viewBackgroundColor;
        _ctntView.estimatedSectionHeaderHeight = 0;
        _ctntView.estimatedSectionFooterHeight = 0;
        
        [_ctntView registerClass:[JPCashHeaderView class] forHeaderFooterViewReuseIdentifier:headerReuseIdentifier];
        [_ctntView registerClass:[JPCashFooterView class] forHeaderFooterViewReuseIdentifier:footerReuseIdentifier];
    }
    return _ctntView;
}

- (NSString *)ruleWithPeriodOfTime:(NSString *)time {
    //  8:00-19:30
    return [NSString stringWithFormat:@"1、“立即提现”为您提供当日提款服务，您当日的收单交易款项可在当日到账。\n2、每日立即提现服务受理时间段为%@，请在此时间范围内申请提款。\n3、立即提现会产生手续费，将从您的可提现金额中自动扣除，详情请咨询相关服务机构。\n4、使用此服务，您的申请提取金额预计将在2小时内到达您的结算账户。\n5、使用此服务前，请确认您的可提现金额、手续费、实际入账金额，以免有误。", time];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
