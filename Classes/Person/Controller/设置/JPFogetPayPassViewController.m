//
//  JPFogetPayPassViewController.m
//  JiePos
//
//  Created by iBlocker on 2017/8/17.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPFogetPayPassViewController.h"
#import "UITextField+Helper.h"

@interface JPFogetPayPassViewController () <UITextFieldDelegate>

@end

@implementation JPFogetPayPassViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"忘记提现密码";
    [self handleUserInterface];
}

#pragma mark - Method
- (void)handleUserInterface {
    weakSelf_declare;
    //  用户名
    UILabel *userLab = [self.view viewWithTag:100];
    if (!userLab) {
        userLab = [UILabel new];
        userLab.text = @"用户名";
        userLab.textColor = JP_NoticeText_Color;
        userLab.font = JP_DefaultsFont;
        userLab.tag = 100;
        [self.view addSubview:userLab];
        
        [userLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view.mas_left).offset(JPRealValue(30));
            make.top.equalTo(weakSelf.view.mas_top).offset(JPRealValue(60));
            make.size.mas_equalTo(CGSizeMake(JPRealValue(100), JPRealValue(30)));
        }];
    }
    
    //  用户名输入框
    UITextField *userField = [self.view viewWithTag:101];
    if (!userField) {
        userField = [UITextField new];
        userField.clearButtonMode = UITextFieldViewModeWhileEditing;
        userField.tag = 101;
        userField.placeholder = @"请输入用户名";
        //        [userField setValue:JP_NoticeText_Color forKeyPath:@"_placeholderLabel.textColor"];
        [userField setValue:JP_DefaultsFont forKeyPath:@"_placeholderLabel.font"];
        [self.view addSubview:userField];
        
        [userField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(userLab.mas_centerY);
            make.left.equalTo(userLab.mas_right).offset(JPRealValue(26));
            make.right.equalTo(weakSelf.view.mas_right).offset(JPRealValue(-30));
            make.height.equalTo(@30);
        }];
    }
    
    //  用户名分割线
    UILabel *userLine = [self.view viewWithTag:102];
    if (!userLine) {
        userLine = [UILabel new];
        userLine.backgroundColor = JP_LineColor;
        userLine.tag = 102;
        [self.view addSubview:userLine];
        
        [userLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userLab.mas_left);
            make.right.equalTo(userField.mas_right);
            make.top.equalTo(userField.mas_bottom).offset(JPRealValue(10));
            make.height.equalTo(@0.5);
        }];
    }
    
    //  手机号
    UILabel *phoneLab = [self.view viewWithTag:103];
    if (!phoneLab) {
        phoneLab = [UILabel new];
        phoneLab.text = @"手机号";
        phoneLab.textColor = JP_NoticeText_Color;
        phoneLab.font = JP_DefaultsFont;
        phoneLab.tag = 103;
        [self.view addSubview:phoneLab];
        
        [phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userLab.mas_left);
            make.top.equalTo(userLine.mas_bottom).offset(JPRealValue(50));
            make.size.mas_equalTo(CGSizeMake(JPRealValue(100), JPRealValue(30)));
        }];
    }
    
    //  手机号输入框
    UITextField *phoneField = [self.view viewWithTag:104];
    if (!phoneField) {
        phoneField = [UITextField new];
        phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
        phoneField.tag = 104;
        phoneField.placeholder = @"请输入手机号";
        phoneField.delegate = self;
        phoneField.keyboardType = UIKeyboardTypeNumberPad;
        //        [phoneField setValue:JP_NoticeText_Color forKeyPath:@"_placeholderLabel.textColor"];
        [phoneField setValue:JP_DefaultsFont forKeyPath:@"_placeholderLabel.font"];
        [self.view addSubview:phoneField];
        
        [phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(phoneLab.mas_centerY);
            make.left.equalTo(phoneLab.mas_right).offset(JPRealValue(26));
            make.right.equalTo(weakSelf.view.mas_right).offset(JPRealValue(-30));
            make.height.equalTo(@30);
        }];
    }
    
    //  手机号分割线
    UILabel *phoneLine = [self.view viewWithTag:105];
    if (!phoneLine) {
        phoneLine = [UILabel new];
        phoneLine.backgroundColor = JP_LineColor;
        phoneLine.tag = 105;
        [self.view addSubview:phoneLine];
        
        [phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(phoneLab.mas_left);
            make.right.equalTo(phoneField.mas_right);
            make.top.equalTo(phoneField.mas_bottom).offset(JPRealValue(10));
            make.height.equalTo(@0.5);
        }];
    }
    
    //  验证码
    UILabel *codeLab = [self.view viewWithTag:106];
    if (!codeLab) {
        codeLab = [UILabel new];
        codeLab.text = @"验证码";
        codeLab.textColor = JP_NoticeText_Color;
        codeLab.font = [UIFont systemFontOfSize:JPRealValue(30)];
        codeLab.tag = 106;
        [self.view addSubview:codeLab];
        
        [codeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userLab.mas_left);
            make.top.equalTo(phoneLine.mas_bottom).offset(JPRealValue(50));
            make.size.mas_equalTo(CGSizeMake(JPRealValue(100), JPRealValue(30)));
        }];
    }
    
    //  验证码获取
    UIButton *codeButton = [self.view viewWithTag:107];
    if (!codeButton) {
        codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        codeButton.titleLabel.font = JP_DefaultsFont;
        //        codeButton.backgroundColor = JPBaseColor;
        [codeButton setBackgroundImage:[UIImage imageNamed:@"jp_button_normal"] forState:UIControlStateNormal];
        codeButton.tag = 107;
        codeButton.layer.cornerRadius = JPRealValue(10);
        codeButton.layer.masksToBounds = YES;
        [codeButton addTarget:self action:@selector(handleGetCode:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:codeButton];
        
        [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(phoneLine.mas_bottom).offset(JPRealValue(30));
            make.right.equalTo(weakSelf.view.mas_right).offset(JPRealValue(-30));
            make.size.mas_equalTo(CGSizeMake(JPRealValue(200), JPRealValue(60)));
        }];
    }
    
    //  验证码输入框
    UITextField *codeField = [self.view viewWithTag:108];
    if (!codeField) {
        codeField = [UITextField new];
        codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        codeField.tag = 108;
        codeField.placeholder = @"短信验证码";
        codeField.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview:codeField];
        
        [codeField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(codeLab.mas_centerY);
            make.left.equalTo(codeLab.mas_right).offset(JPRealValue(26));
            make.right.equalTo(codeButton.mas_left).offset(JPRealValue(-26));
            make.height.equalTo(@30);
        }];
    }
    
    //  验证码分割线
    UILabel *codeLine = [self.view viewWithTag:109];
    if (!codeLine) {
        codeLine = [UILabel new];
        codeLine.backgroundColor = JP_LineColor;
        codeLine.tag = 109;
        [self.view addSubview:codeLine];
        
        [codeLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(codeLab.mas_left);
            make.right.equalTo(phoneField.mas_right);
            make.top.equalTo(codeField.mas_bottom).offset(JPRealValue(10));
            make.height.equalTo(@0.5);
        }];
    }
    
    //  下一步
    UIButton *nextButton = [self.view viewWithTag:110];
    if (!nextButton) {
        nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextButton setTitle:@"重置密码" forState:UIControlStateNormal];
        //        nextButton.backgroundColor = JPBaseColor;
        [nextButton setBackgroundImage:[UIImage imageNamed:@"jp_button_normal"] forState:UIControlStateNormal];
        [nextButton setBackgroundImage:[UIImage imageNamed:@"jp_button_highlighted"] forState:UIControlStateHighlighted];
        nextButton.layer.cornerRadius = JPRealValue(10);
        nextButton.layer.masksToBounds = YES;
        nextButton.tag = 110;
        [nextButton addTarget:self action:@selector(handleNext) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:nextButton];
        
        [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(codeLine.mas_bottom).offset(JPRealValue(60));
            make.centerX.equalTo(weakSelf.view.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth - JPRealValue(60), JPRealValue(80)));
        }];
    }
}

#pragma mark - action
- (void)handleGetCode:(UIButton *)codeButton {
    UITextField *userField = [self.view viewWithTag:101];
    UITextField *phoneField = [self.view viewWithTag:104];
    
    NSString *phone = [phoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (userField.text.length <= 0) {
        [IBProgressHUD showInfoWithStatus:@"请输入用户名！"];
        return;
    }
    if (phone.length <= 0) {
        [IBProgressHUD showErrorWithStatus:@"请输入手机号！"];
        return;
    }
    if (![phone isPhone]) {
        [IBProgressHUD showErrorWithStatus:@"请输入正确的手机号！"];
        return;
    }
    //  获取验证码
    [IBLoginRequest getCodeWithAccount:userField.text phone:phone isCashPass:true callback:^(NSString *code, NSString *msg, id resp) {
        if (code.integerValue == 0) {
            [IBProgressHUD showSuccessWithStatus:@"发送成功！"];
            [self startTime:codeButton];
        } else {
            [IBProgressHUD showErrorWithStatus:msg];
        }
    }];
}

- (void)handleNext {
    
    [MobClick event:@"forget_resetPsw"];
    
    //  下一步
    UITextField *userField = [self.view viewWithTag:101];
    UITextField *phoneField = [self.view viewWithTag:104];
    UITextField *codeField = [self.view viewWithTag:108];
    
    NSString *phone = [phoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (userField.text.length <= 0) {
        [IBProgressHUD showInfoWithStatus:@"请输入用户名！"];
        return;
    }
    if (phone.length <= 0) {
        [IBProgressHUD showErrorWithStatus:@"请输入手机号！"];
        return;
    }
    if (![phone isPhone]) {
        [IBProgressHUD showErrorWithStatus:@"请输入正确的手机号！"];
        return;
    }
    if (codeField.text.length <= 0) {
        [IBProgressHUD showErrorWithStatus:@"请输入验证码！"];
        return;
    }
    
    weakSelf_declare;
    [IBLoginRequest resetPswWithAccount:userField.text code:codeField.text phone:phone isCashPass:true callback:^(NSString *code, NSString *msg, id resp) {
        if (code.integerValue == 0) {
            //  已发送密码至该号码，注意查收（重置成功）
            [IBProgressHUD showSuccessWithStatus:@"重置成功，密码将以短信的形式发送到您的手机上，请注意保管！"];
            [weakSelf performSelector:@selector(resetSuccess) withObject:nil afterDelay:3];
        } else {
            [IBProgressHUD showErrorWithStatus:msg];
        }
    }];
}

- (void)resetSuccess {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    UITextField *phoneField = [self.view viewWithTag:104];
    if (phoneField == textField) {
        return [UITextField phoneNumberFormatTextField:phoneField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

#pragma mark - 获取验证码实现倒计时60秒，60秒后按钮变成原来的样子
- (void)startTime:(UIButton *)codeButton {
    __block NSInteger timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if ( timeout <= 0 )
        { //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                [codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [codeButton setBackgroundImage:[UIImage imageNamed:@"jp_button_normal"] forState:UIControlStateNormal];
                codeButton.userInteractionEnabled = YES;
            });
        } else {
            NSInteger seconds = timeout % 61;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //JPLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [codeButton setTitle:[NSString stringWithFormat:@"重新获取(%lds)",(long)seconds] forState:UIControlStateNormal];
                [codeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [codeButton setBackgroundImage:[UIImage imageNamed:@"jp_button_disabled"] forState:UIControlStateNormal];
                [UIView commitAnimations];
                codeButton.userInteractionEnabled = NO;
            });
            timeout --;
        }
    });
    dispatch_resume(_timer);
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
