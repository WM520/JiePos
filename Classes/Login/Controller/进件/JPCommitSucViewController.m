//
//  JPCommitSucViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/6/20.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPCommitSucViewController.h"

@interface JPCommitSucViewController ()

@end
@implementation JPCommitSucViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBar];
    [self setupSubviews];
}

#pragma mark - setup
- (void)setupNavigationBar {
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"提交信息成功";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setupSubviews {
    weakSelf_declare;
    
    UIImageView *bgView = [self.view viewWithTag:800];
    if (!bgView) {
        bgView = [UIImageView new];
        bgView.image = [UIImage imageNamed:@"jp_login_regSucBg"];
        bgView.tag = 800;
        bgView.userInteractionEnabled = YES;
        [self.view addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view.mas_centerX);
            make.centerY.equalTo(weakSelf.view.mas_centerY);
        }];
    }
    
    UIImageView *logoView = [self.view viewWithTag:801];
    if (!logoView) {
        logoView = [UIImageView new];
        logoView.image = [UIImage imageNamed:@"jp_login_regSuc"];
        logoView.tag = 801;
        [self.view addSubview:logoView];
        
        [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView.mas_centerX);
            make.top.equalTo(bgView.mas_top).offset(JPRealValue(60) + 64);
        }];
    }
    
    UILabel *sucLab = [self.view viewWithTag:802];
    if (!sucLab) {
        sucLab = [UILabel new];
        sucLab.text = @"提交成功！";
        sucLab.font = JP_DefaultsFont;
        sucLab.textColor = JP_Content_Color;
        sucLab.textAlignment = NSTextAlignmentCenter;
        sucLab.tag = 802;
        [self.view addSubview:sucLab];
        
        [sucLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(logoView.mas_centerX);
            make.top.equalTo(logoView.mas_bottom).offset(JPRealValue(40));
        }];
    }
    
    UIImageView *alertView = [self.view viewWithTag:803];
    if (!alertView) {
        alertView = [UIImageView new];
        alertView.image = [UIImage imageNamed:@"jp_login_regSucAlert"];
        alertView.tag = 803;
        alertView.userInteractionEnabled = YES;
        [self.view addSubview:alertView];
        
        [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(sucLab.mas_centerX);
            make.top.equalTo(sucLab.mas_bottom).offset(JPRealValue(134));
        }];
    }
    
    UILabel *passLab = [self.view viewWithTag:804];
    if (!passLab) {
        passLab = [UILabel new];
        passLab.font = JP_DefaultsFont;
        passLab.textColor = JP_NoticeText_Color;
        passLab.tag = 804;
        
        NSString *str = [NSString stringWithFormat:@"初始密码：%@", self.password];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:JP_Content_Color
                        range:NSMakeRange(0, 5)];
        
        passLab.attributedText = attrStr;
        [alertView addSubview:passLab];
        
        [passLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(alertView.mas_centerX);
            make.left.equalTo(alertView.mas_left).offset(JPRealValue(20));
            make.bottom.equalTo(alertView.mas_bottom).offset(JPRealValue(-42));
        }];
    }
    
    UILabel *userLab = [self.view viewWithTag:805];
    if (!userLab) {
        userLab = [UILabel new];
        userLab.font = JP_DefaultsFont;
        userLab.textColor = JP_NoticeText_Color;
        userLab.tag = 805;
        userLab.userInteractionEnabled = YES;
        
        NSString *str = [NSString stringWithFormat:@"登录账号：%@", self.userName];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:JP_Content_Color
                        range:NSMakeRange(0, 5)];
        
        userLab.attributedText = attrStr;
        [alertView addSubview:userLab];
        
        [userLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(alertView.mas_centerX);
            make.left.equalTo(passLab.mas_left);
            make.bottom.equalTo(passLab.mas_top).offset(JPRealValue(-26));
        }];
    }
}

#pragma mark - Action
- (void)rightBarButtonItenAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
