//
//  JPModifyPayPassViewController.m
//  JiePos
//
//  Created by iBlocker on 2017/8/17.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPModifyPayPassViewController.h"
#import "IBPayPassView.h"
#import "JPFogetPayPassViewController.h"

typedef NS_ENUM(NSUInteger, JPPassStep) {
    JPPassStepOne = 0,
    JPPassStepTwo,
    JPPassStepThree,
};

typedef void (^jp_passForgetBlock)();
@interface JPPassHeaderView : UIView
@property (nonatomic, assign) JPPassStep step;
@property (nonatomic, strong) UILabel *infoLab;
@property (nonatomic, strong) UIButton *forgetButton;
@property (nonatomic, copy) jp_passForgetBlock block;
@end
@implementation JPPassHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.forgetButton];
        [self addSubview:self.infoLab];
    }
    return self;
}

- (void)setStep:(JPPassStep)step {
    if (step == JPPassStepOne) {
        [self.forgetButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
        self.forgetButton.frame = CGRectMake(self.frame.size.width - JPRealValue(180), 0, JPRealValue(180), self.frame.size.height);
        self.infoLab.text = @"输入原提现密码进行验证";
        self.infoLab.textAlignment = NSTextAlignmentLeft;
        self.infoLab.frame = CGRectMake(0, 0, self.frame.size.width - JPRealValue(200), self.frame.size.height);
    } else if (step == JPPassStepTwo) {
        [self.forgetButton setTitle:@"" forState:UIControlStateNormal];
        self.infoLab.text = @"请输入新的提现密码";
        self.infoLab.textAlignment = NSTextAlignmentCenter;
        self.infoLab.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    } else {
        [self.forgetButton setTitle:@"" forState:UIControlStateNormal];
        self.infoLab.text = @"请再次输入新的提现密码";
        self.infoLab.textAlignment = NSTextAlignmentCenter;
        self.infoLab.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    _step = step;
}

- (UILabel *)infoLab {
    if (!_infoLab) {
        _infoLab = [UILabel new];
        _infoLab.font = [UIFont boldSystemFontOfSize:JPRealValue(30)];
        _infoLab.textColor = JP_Content_Color;
    }
    return _infoLab;
}

- (UIButton *)forgetButton {
    if (!_forgetButton) {
        _forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetButton setTitleColor:JPBaseColor forState:UIControlStateNormal];
        _forgetButton.titleLabel.font = JP_DefaultsFont;
        _forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_forgetButton addTarget:self action:@selector(forgetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetButton;
}

- (void)forgetButtonClick:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
}

@end


@interface JPModifyPayPassViewController () <IBPayPassViewDelegate>
@property (nonatomic, strong) JPPassHeaderView *headerView;
@property (nonatomic, strong) IBPayPassView *payView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation JPModifyPayPassViewController

#pragma mark - lifestyle
- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.navigationItem.title = @"提现密码修改";
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.payView];
    weakSelf_declare;
    self.headerView.block = ^{
        JPFogetPayPassViewController *forgetVC = [JPFogetPayPassViewController new];
        [weakSelf.navigationController pushViewController:forgetVC animated:YES];
    };
}

#pragma mark - IBPayPassViewDelegate
/** 监听输入的变化 */
- (void)passwordDidChange:(IBPayPassView *)password {
    JPLog(@"监听输入的变化%@", password.saveStore);
}

/** 监听开始输入 */
- (void)passwordBeginInput:(IBPayPassView *)password {
    JPLog(@"监听开始输入%@", password.saveStore);
}

/** 监听输入完成时 */
- (void)passwordCompleteInput:(IBPayPassView *)password {
    JPLog(@"监听输入完成时%@", password.saveStore);
    
    weakSelf_declare;
    if (self.headerView.step == JPPassStepOne) {
        //  保存原密码
        [JP_UserDefults setObject:password.saveStore forKey:oldPayPass];
        [JP_UserDefults synchronize];
        
        [IBProgressHUD loadingWithStatus:@"验证中..."];
        
        [IBLoginRequest checkPayPswWithAccount:[JPUserEntity sharedUserEntity].account oldPwd:password.saveStore callback:^(NSString *code, NSString *msg, id resp) {
            if (code.integerValue == 0) {
                //  原密码输入正确
                [IBProgressHUD dismiss];
                [password deleteAll];
                
                weakSelf.headerView.step = JPPassStepTwo;
            } else {
                //  原密码输入错误
                [IBProgressHUD showInfoWithStatus:msg];
                [password deleteAll];
                
                //  若原密码输入错误，需要将保存的密码删除
                [JP_UserDefults removeObjectForKey:oldPayPass];
                [JP_UserDefults synchronize];
            }
        }];
    } else if (self.headerView.step == JPPassStepTwo) {
        if ([password.saveStore isEqualToString:[JP_UserDefults objectForKey:oldPayPass]]) {
            [IBProgressHUD showInfoWithStatus:@"新密码和原密码一致，请重新输入！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [password deleteAll];
            });
        } else {
            [JP_UserDefults setObject:password.saveStore forKey:newPayPass];
            [JP_UserDefults synchronize];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [password deleteAll];
                weakSelf.headerView.step = JPPassStepThree;
            });
        }
    } else if (self.headerView.step == JPPassStepThree) {
        
        if ([password.saveStore isEqualToString:[JP_UserDefults objectForKey:newPayPass]]) {
            [IBLoginRequest modifyPswWithAccount:[JPUserEntity sharedUserEntity].account oldPwd:[JP_UserDefults objectForKey:oldPayPass] newPwd:password.saveStore isCashPass:true callback:^(NSString *code, NSString *msg, id resp) {
                if (code.integerValue == 0) {
                    [IBProgressHUD showSuccessWithStatus:@"修改支付密码成功！"];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [IBProgressHUD showSuccessWithStatus:msg];
                    [password deleteAll];
                    [JP_UserDefults removeObjectForKey:oldPayPass];
                    [JP_UserDefults removeObjectForKey:newPayPass];
                    [JP_UserDefults synchronize];
                    weakSelf.headerView.step = JPPassStepOne;
                }
            }];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [IBProgressHUD showInfoWithStatus:@"两次密码输入不一致，请重新输入!"];
                [password deleteAll];
                [JP_UserDefults removeObjectForKey:newPayPass];
                [JP_UserDefults synchronize];
                weakSelf.headerView.step = JPPassStepTwo;
            });
        }
    }
}

#pragma mark - Getter
- (JPPassHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[JPPassHeaderView alloc] initWithFrame:CGRectMake(JPRealValue(30), JPRealValue(40), kScreenWidth - JPRealValue(60), JPRealValue(40))];
        _headerView.step = JPPassStepOne;
    }
    return _headerView;
}

- (IBPayPassView *)payView {
    if (!_payView) {
        _payView = [[IBPayPassView alloc] initWithFrame:CGRectMake(JPRealValue(60), JPRealValue(100), kScreenWidth - JPRealValue(120), JPRealValue(100))];
        _payView.backgroundColor = [UIColor whiteColor];
        _payView.digitsNumber = 6;
        _payView.squareSize = (kScreenWidth - JPRealValue(120)) / 6;
        _payView.pointRadius = JPRealValue(10);
        _payView.rectColor = JP_LineColor;
        _payView.layer.borderWidth = 1;
        _payView.layer.borderColor = JP_LineColor.CGColor;
        _payView.delegate = self;
    }
    return _payView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

@end
