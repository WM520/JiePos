//
//  JPMerchantRegisterViewController.m
//  JiePos
//
//  Created by wangmiao on 2017/12/1.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPMerchantRegisterViewController.h"

@interface JPMerchantRegisterViewController ()
<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView * navImageView;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIView * alphaView;
@property (nonatomic, strong) UIButton * leftBtn;
@end

@implementation JPMerchantRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 初始化UI
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init
- (void)configUI
{
    weakSelf_declare;;
    self.view.backgroundColor = JP_viewBackgroundColor;
    _navImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, JPRealValue(300))];
    _navImageView.image = [UIImage imageNamed:@"jp_news_deatailBg"];
    _navImageView.alpha = 1;
    [self.view insertSubview:_navImageView atIndex:1];
    _leftBtn = [[UIButton alloc] init];
    _leftBtn.frame = CGRectMake(10, 25, JPRealValue(60), JPRealValue(60));
    _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(JPRealValue(15), JPRealValue(15), JPRealValue(15), JPRealValue(15));
    [_leftBtn setImage:[[UIImage imageNamed:@"jp_goBack1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftBtn];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - 100, 20, 200, 44)];
    titleLab.text = @"商户入驻";
    titleLab.font = [UIFont systemFontOfSize:JPRealValue(34)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLab];
    
//    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(20, 120, kScreenWidth - 40, JPRealValue(400))];
    UIView * contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor redColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(JPRealValue(50));
        make.right.equalTo(weakSelf.view.mas_right).offset(JPRealValue(-50));
        make.top.equalTo(weakSelf.view.mas_top).offset(JPRealValue(200));
        make.height.equalTo(@(JPRealValue(400)));
    }];
    
    UIImageView * backBigImage = [[UIImageView alloc] init];
    backBigImage.image = [UIImage imageNamed:@"jp_news_deatailBg"];
    [contentView addSubview:backBigImage];
    
    [backBigImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left);
        make.right.equalTo(contentView.mas_right);
        make.top.equalTo(contentView.mas_top);
        make.bottom.equalTo(contentView.mas_bottom);
    }];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"一码付商户";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    [contentView addSubview:titleLabel];
    
    UILabel * desLabel = [[UILabel alloc] init];
    desLabel.text = @"请选择入驻类型";
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.font = [UIFont systemFontOfSize:20];
    [contentView addSubview:desLabel];
    
    
}

- (BOOL)navigationBarHidden
{
    return YES;
}

- (void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight - 49}];
        _scrollView.contentInset = UIEdgeInsetsMake(-kStatusBarHeight, 0, 0, 0);
        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
        _scrollView.delegate = self;
        [_scrollView sizeToFit];
    }
    return _scrollView;
}

@end
