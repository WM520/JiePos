//
//  JPCashFinishViewController.m
//  JiePos
//
//  Created by iBlocker on 2017/8/21.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPCashFinishViewController.h"

@interface JPCashFinishViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) IBWaterWaveView *waterView;
@property (nonatomic, strong) UIView *navImageView;
/** Logo*/
@property (nonatomic, strong) UIImageView *logoView;
/** 审核状态*/
@property (nonatomic, strong) UILabel *statusLab;
@property (nonatomic, strong) UITableView *ctntView;
@property (nonatomic, strong) UIButton *telButton;
@end

@implementation JPCashFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:self.scrollView];
    [self layoutHomeView];
    [self.scrollView addSubview:self.waterView];
    [self.scrollView addSubview:self.logoView];
    [self.scrollView addSubview:self.statusLab];
    [self.scrollView addSubview:self.ctntView];
    [self.scrollView addSubview:self.telButton];
}

#pragma mark - NavigationBar
- (void)layoutHomeView {
    if (!_navImageView) {
        _navImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        _navImageView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_navImageView];
    }
    
    UILabel *titleLab = [_navImageView viewWithTag:101];
    if (!titleLab) {
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - 100, 20, 200, 44)];
        titleLab.text = @"提现结果";
        titleLab.font = [UIFont systemFontOfSize:JPRealValue(34)];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = [UIColor whiteColor];
        titleLab.tag = 101;
        [_navImageView addSubview:titleLab];
    }
    
    UIButton *leftButton = [_navImageView viewWithTag:102];
    if (!leftButton) {
        leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(10, 25, JPRealValue(60), JPRealValue(60));
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(JPRealValue(15), JPRealValue(15), JPRealValue(15), JPRealValue(15));
        [leftButton setImage:[[UIImage imageNamed:@"jp_goBack1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        leftButton.tag = 102;
        [leftButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_navImageView addSubview:leftButton];
    }
    
    UIButton *rightButton = [_navImageView viewWithTag:103];
    if (!rightButton) {
        rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.tag = 103;
        rightButton.frame = CGRectMake(kScreenWidth - JPRealValue(120), 26, JPRealValue(90), JPRealValue(60));
        rightButton.titleLabel.font = [UIFont systemFontOfSize:JPRealValue(28)];
        [rightButton setTitle:@"完成" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_navImageView addSubview:rightButton];
    }
}
#pragma mark - Action
- (void)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemClicked:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.contentView.backgroundColor = JP_viewBackgroundColor;
        cell.textLabel.font = JP_DefaultsFont;
        cell.textLabel.textColor = JP_NoticeText_Color;
        cell.detailTextLabel.font = JP_DefaultsFont;
        cell.detailTextLabel.textColor = JP_Content_Color;
    }
    switch (indexPath.row) {
        case 0: {
            //  提现金额
            cell.textLabel.text = @"提现金额";
            cell.detailTextLabel.text = @"10000元";
        }
            break;
        case 1: {
            //  到账金额
            cell.textLabel.text = @"到账金额";
            cell.detailTextLabel.text = @"9997元";
        }
            break;
        case 2: {
            //  申请时间
            cell.textLabel.text = @"申请时间";
            cell.detailTextLabel.text = @"2017-08-21 16:13:45";
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - Setter
- (void)setState:(JPFinishState)state {
    switch (state) {
        case JPFinishStateAppling: {
            //  提现审核中
            self.waterView.startColor = [UIColor colorWithHexString:@"7a93f5" alpha:0.7];
            self.waterView.endColor = [UIColor colorWithHexString:@"51dbf0" alpha:0.7];
        }
            break;
        case JPFinishStateSuccess: {
            //  提现成功
            self.waterView.startColor = [UIColor colorWithHexString:@"7a93f5" alpha:0.7];
            self.waterView.endColor = [UIColor colorWithHexString:@"51dbf0" alpha:0.7];
        }
            break;
        case JPFinishStateFailed: {
            //  提现失败
            self.waterView.startColor = [UIColor colorWithHexString:@"fbd49d" alpha:0.7];
            self.waterView.endColor = [UIColor colorWithHexString:@"ff785c" alpha:0.7];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
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
        _waterView = [[IBWaterWaveView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, JPRealValue(456)}];
        _waterView.startColor = [UIColor colorWithHexString:@"7a93f5" alpha:0.7];
        _waterView.endColor = [UIColor colorWithHexString:@"51dbf0" alpha:0.7];
    }
    return _waterView;
}

- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:(CGRect){0, JPRealValue(456), kScreenWidth, 44 * 3} style:UITableViewStyleGrouped];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        _ctntView.scrollEnabled = NO;
        _ctntView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _ctntView.estimatedSectionHeaderHeight = 0;
        _ctntView.estimatedSectionFooterHeight = 0;
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
        _statusLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - JPRealValue(200), JPRealValue(174) + 64, JPRealValue(400), JPRealValue(30))];
        _statusLab.text = @"提现申请审核中！";
        _statusLab.textColor = [UIColor whiteColor];
        _statusLab.textAlignment = NSTextAlignmentCenter;
        _statusLab.font = [UIFont boldSystemFontOfSize:JPRealValue(30)];
    }
    return _statusLab;
}

- (UIButton *)telButton {
    if (!_telButton) {
        _telButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _telButton.frame = CGRectMake(kScreenWidth / 2.0 - JPRealValue(150), kScreenHeight - JPRealValue(92), JPRealValue(300), JPRealValue(40));
        [_telButton setTitle:@"联系客服" forState:UIControlStateNormal];
        [_telButton setTitleColor:JP_NoticeRedColor forState:UIControlStateNormal];
        [_telButton setImage:[UIImage imageNamed:@"jp_home_serviceTel"] forState:UIControlStateNormal];
        _telButton.titleLabel.font = JP_DefaultsFont;
        _telButton.titleEdgeInsets = UIEdgeInsetsMake(0, JPRealValue(-25), 0, JPRealValue(25));
        _telButton.imageEdgeInsets = UIEdgeInsetsMake(0, JPRealValue(130), 0, JPRealValue(-130));
        [_telButton addTarget:self action:@selector(telButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _telButton;
}

- (BOOL)navigationBarHidden {
    return YES;
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
