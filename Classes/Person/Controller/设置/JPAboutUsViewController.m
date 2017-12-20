//
//  JPAboutUsViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/6/8.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPAboutUsViewController.h"

@interface JPAboutUsViewController ()
@property (nonatomic, strong) UIView *navImageView;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIView *currentView;
@property (nonatomic, strong) UIView *nameView;
/** 左侧线条*/
@property (nonatomic, strong) UIImageView *leftView;
/** 右侧线条*/
@property (nonatomic, strong) UIImageView *rightView;
/** 标题*/
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel     *versionInfoLab;
@property (nonatomic, strong) UIView      *introduceView;
@property (nonatomic, strong) UILabel     *introduceLab;
@end

@implementation JPAboutUsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    [self layoutHomeView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.currentView];
    [self.currentView addSubview:self.introduceLab];
    [self.currentView addSubview:self.nameView];
    [self.nameView addSubview:self.titleLab];
    [self.nameView addSubview:self.leftView];
    [self.nameView addSubview:self.rightView];
    [self.bgView addSubview:self.versionInfoLab];
    [self.bgView addSubview:self.logoView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(weakSelf.view);
    }];
    [self.currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(JPRealValue(30));
        make.right.equalTo(weakSelf.view.mas_right).offset(JPRealValue(-30));
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, JPRealValue(598)));
        make.top.equalTo(weakSelf.bgView.mas_bottom).offset(JPRealValue(-85));
    }];
    [self.introduceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.currentView.mas_left).offset(JPRealValue(60));
        make.right.equalTo(weakSelf.currentView.mas_right).offset(JPRealValue(-60));
        make.bottom.equalTo(weakSelf.currentView.mas_bottom);
        make.height.equalTo(@(JPRealValue(494)));
    }];
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(weakSelf.currentView);
        make.height.equalTo(@(JPRealValue(104)));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.nameView.mas_centerX);
        make.top.and.bottom.equalTo(weakSelf.nameView);
    }];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.titleLab.mas_centerY);
        make.right.equalTo(weakSelf.titleLab.mas_left).offset(JPRealValue(-20));
    }];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.titleLab.mas_centerY);
        make.left.equalTo(weakSelf.titleLab.mas_right).offset(JPRealValue(20));
    }];
    [self.versionInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.currentView.mas_top).offset(JPRealValue(-20));
        make.centerX.equalTo(weakSelf.bgView.mas_centerX);
    }];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.versionInfoLab.mas_top).offset(JPRealValue(-24));
        make.centerX.equalTo(weakSelf.bgView.mas_centerX);
    }];
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
        _bgView.image = [UIImage imageNamed:@"jp_version_bg"];
    }
    return _bgView;
}
- (UIView *)currentView {
    if (!_currentView) {
        _currentView = [UIView new];
        _currentView.backgroundColor = JP_viewBackgroundColor;
        _currentView.layer.cornerRadius = JPRealValue(10);
        _currentView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _currentView.layer.shadowOffset = CGSizeMake(2, 2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _currentView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _currentView.layer.shadowRadius = 2;//阴影半径，默认3
    }
    return _currentView;
}
- (UILabel *)introduceLab {
    if (!_introduceLab) {
        _introduceLab = [UILabel new];
        _introduceLab.numberOfLines = 0;
        _introduceLab.lineBreakMode = NSLineBreakByWordWrapping;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = JPRealValue(10);// 字体的行间距
        paragraphStyle.paragraphSpacing = JPRealValue(5);
        
        NSDictionary *attributes = @{
                                     NSFontAttributeName:JP_DefaultsFont,
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     NSForegroundColorAttributeName:JP_NoticeText_Color
                                     };
        _introduceLab.attributedText = [[NSAttributedString alloc] initWithString:JPJBBIntroduce attributes:attributes];
    }
    return _introduceLab;
}

- (UIView *)nameView {
    if (!_nameView) {
        _nameView = [UIView new];
        _nameView.backgroundColor = [UIColor whiteColor];
        _nameView.layer.cornerRadius = JPRealValue(10);
        _nameView.layer.masksToBounds = YES;
    }
    return _nameView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"杰宝宝";
        _titleLab.textColor = JP_Content_Color;
        _titleLab.font = [UIFont boldSystemFontOfSize:JPRealValue(34)];
    }
    return _titleLab;
}
- (UIImageView *)leftView {
    if (!_leftView) {
        _leftView = [UIImageView new];
        _leftView.image = [UIImage imageNamed:@"jp_version_left"];
    }
    return _leftView;
}
- (UIImageView *)rightView {
    if (!_rightView) {
        _rightView = [UIImageView new];
        _rightView.image = [UIImage imageNamed:@"jp_version_right"];
    }
    return _rightView;
}

- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [UIImageView new];
        _logoView.image = [UIImage imageNamed:@"jp_version_circleLogo"];
    }
    return _logoView;
}

- (UILabel *)versionInfoLab {
    if (!_versionInfoLab) {
        _versionInfoLab = [UILabel new];
        
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *localVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        _versionInfoLab.text = [NSString stringWithFormat:@"当前版本V%@", localVersion];
        
        _versionInfoLab.font = JP_DefaultsFont;
        _versionInfoLab.textColor = [UIColor whiteColor];
        _versionInfoLab.textAlignment = NSTextAlignmentCenter;
    }
    return _versionInfoLab;
}

- (UIView *)introduceView {
    if (!_introduceView) {
        _introduceView = [UIView new];
        _introduceView.backgroundColor = JP_viewBackgroundColor;
    }
    return _introduceView;
}


//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//    [self.view addSubview:self.logoView];
//    [self.view addSubview:self.versionInfoLab];
//    [self.view addSubview:self.introduceView];
//    [self.introduceView addSubview:self.introduceLab];
//    
//    weakSelf_declare;
//    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf.view.mas_centerX);
//        make.top.equalTo(weakSelf.view.mas_top).offset(JPRealValue(50));
//    }];
//    [self.versionInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.logoView.mas_bottom).offset(JPRealValue(10));
//        make.centerX.equalTo(weakSelf.logoView.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake(JPRealValue(300), JPRealValue(30)));
//    }];
//    [self.introduceView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.view.mas_left);
//        make.right.equalTo(weakSelf.view.mas_right);
//        make.top.equalTo(weakSelf.versionInfoLab.mas_bottom).offset(JPRealValue(40));
//        make.height.equalTo(@(JPRealValue(200)));
//    }];
//    [self.introduceLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.introduceView.mas_top).offset(JPRealValue(20));
//        make.left.equalTo(weakSelf.introduceView.mas_left).offset(JPRealValue(30));
//        make.right.equalTo(weakSelf.introduceView.mas_right).offset(JPRealValue(-30));
//        make.bottom.equalTo(weakSelf.introduceView.mas_bottom).offset(JPRealValue(-20));
//    }];
//}

#pragma mark - NavigationBar
- (void)layoutHomeView {
    _navImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _navImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navImageView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - 100, 20, 200, 44)];
    titleLab.text = @"关于杰宝宝";
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
