//
//  JPLoginViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPLoginViewController.h"
#import "JPForgetPswViewController.h"
#import "QRCodeScanningVC.h"

#import "JP_LoginNoticeView.h"
#import "IBBaseInfoViewController.h"
#import <SDWebImage/UIImage+GIF.h>
#import "XHToast.h"
#import "JPMerchantRegisterViewController.h"
#import "UIButton+JPEnlargeTouchArea.h"


#define originMargin JPRealValue(502)

@interface JPLoginViewController () <UITextFieldDelegate>

@property (nonatomic, assign) BOOL isRemember;
@property (nonatomic, strong) UITextField * passwordTextField;
@property (nonatomic, strong) UITextField * userNameTextField;
@property (nonatomic, strong) UIButton * secureSwitchButton;

@end

@implementation JPLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"tq_gesturesPassword"] isEqualToString:@""] || [[NSUserDefaults standardUserDefaults] stringForKey:@"tq_gesturesPassword"] == NULL) {
        self.view.hidden = NO;
    }
    //  密码输入框
    UITextField *passField = [self.view viewWithTag:106];
    //  用户名输入框
    UITextField *userField = [self.view viewWithTag:103];
    if (_isRemember && [JP_UserDefults objectForKey:@"passLogin"]) {
        passField.text = [JP_UserDefults objectForKey:@"passLogin"];
    } else {
        passField.text = @"";
    }
    if ([JP_UserDefults objectForKey:@"userLogin"]) {
        userField.text = [JP_UserDefults objectForKey:@"userLogin"];
    } else {
        userField.text = @"";
    }
    //  记住密码时自动登录
    if (_isRemember && [JP_UserDefults objectForKey:@"passLogin"] && [JP_UserDefults objectForKey:@"userLogin"]) {
        if (!_isGesturePush) {
            [self handleLoginRequest:nil];
        }
    } else {
        self.view.hidden = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD setMaximumDismissTimeInterval:1];
    self.view.backgroundColor = JP_viewBackgroundColor;
    
    if (![JP_UserDefults boolForKey:@"defaultRemember"]) {
        _isRemember = [JP_UserDefults boolForKey:@"remember"];
        [JP_UserDefults setBool:YES forKey:@"remember"];
        [JP_UserDefults setBool:YES forKey:@"defaultRemember"];
    }
    _isRemember = [JP_UserDefults boolForKey:@"remember"];
    [self handleUserInterface];
}

- (void)handleUserInterface {
    weakSelf_declare;
    //  背景
    UIImageView *imageView = [self.view viewWithTag:101];
    if (!imageView) {
        imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"jbb_loginBg"];
        imageView.tag = 101;
        [self.view addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.right.equalTo(weakSelf.view);
        }];
    }
    
    //  账号
    JP_LoginNoticeView *userView = [self.view viewWithTag:102];
    if (!userView) {
        userView = [[JP_LoginNoticeView alloc] initWithImage:[UIImage imageNamed:@"jp_logon_user"] title:@"账号"];
        userView.tag = 102;
        [self.view addSubview:userView];
        
        [userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view.mas_centerX);
            make.top.equalTo(imageView.mas_bottom).offset(JPRealValue(30));
        }];
    }
    
    //  用户名输入框
    UITextField *userField = [[UITextField alloc] init];
    userField.placeholder = @"平台用户名/商户号/手机号";
    userField.textAlignment = NSTextAlignmentCenter;
    userField.font = [UIFont systemFontOfSize:JPRealValue(28)];
    userField.tag = 103;
    userField.delegate = self;
    [self.view addSubview:userField];
    _userNameTextField = userField;
    [userField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userView.mas_bottom).offset(JPRealValue(20));
        make.left.equalTo(weakSelf.view.mas_left).offset(JPRealValue(150));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.height.equalTo(@30);
    }];

    UIButton * questionButton = [[UIButton alloc] init];
    [questionButton setBackgroundImage:[UIImage imageNamed:@"jp_login_question"] forState:UIControlStateNormal];
    [questionButton addTarget:self action:@selector(questionButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:questionButton];
    [questionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.width.equalTo(@20);
        make.centerY.equalTo(weakSelf.userNameTextField.mas_centerY);
        make.right.equalTo(weakSelf.userNameTextField).offset(JPRealValue(10));
    }];
    
//    if ([JP_UserDefults objectForKey:@"userLogin"]) {
//        userField.text = [JP_UserDefults objectForKey:@"userLogin"];
//    } else {
//        userField.text = @"";
//    }
    
    UIView *userLine = [self.view viewWithTag:104];
    if (!userLine) {
        userLine = [UIView new];
        userLine.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
        userLine.tag = 104;
        [self.view addSubview:userLine];
        
        [userLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(userField.mas_bottom);
            make.left.and.right.equalTo(userField);
            make.height.equalTo(@0.5);
        }];
    }
    
    //  密码
    JP_LoginNoticeView *passView = [self.view viewWithTag:105];
    if (!passView) {
        passView = [[JP_LoginNoticeView alloc] initWithImage:[UIImage imageNamed:@"jp_logon_pass"] title:@"密码"];
        passView.tag = 105;
        [self.view addSubview:passView];
        
        [passView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view.mas_centerX);
            make.top.equalTo(userLine.mas_bottom).offset(JPRealValue(40));
        }];
    }
    
    //  密码输入框
    UITextField *passField = [[UITextField alloc] init];
    passField.placeholder = @"请输入您的密码";
    passField.textAlignment = NSTextAlignmentCenter;
    passField.font = [UIFont systemFontOfSize:JPRealValue(28)];
    passField.secureTextEntry = YES;
    passField.tag = 106;
    passField.delegate = self;
    [self.view addSubview:passField];
    _passwordTextField = passField;
    
    [passField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passView.mas_bottom).offset(JPRealValue(20));
        make.left.equalTo(weakSelf.view.mas_left).offset(JPRealValue(150));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.height.equalTo(@30);
    }];
    
    UIButton * secureSwitchButton = [[UIButton alloc] init];
    secureSwitchButton.selected = NO;
    [secureSwitchButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:20];
    [secureSwitchButton setBackgroundImage:[UIImage imageNamed:@"jp_login_zhengyan"] forState:UIControlStateSelected];
    [secureSwitchButton setBackgroundImage:[UIImage imageNamed:@"jp_login_biyan"] forState:UIControlStateNormal];
    [secureSwitchButton addTarget:self action:@selector(secureSwitchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:secureSwitchButton];
    _secureSwitchButton = secureSwitchButton;
    [secureSwitchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@11);
        make.width.equalTo(@22);
        make.centerY.equalTo(weakSelf.passwordTextField.mas_centerY);
        make.right.equalTo(weakSelf.passwordTextField).offset(JPRealValue(10));
    }];
    
//    if (_isRemember && [JP_UserDefults objectForKey:@"passLogin"]) {
//        passField.text = [JP_UserDefults objectForKey:@"passLogin"];
//    } else {
//        passField.text = @"";
//    }
    
    UIView *passLine = [self.view viewWithTag:107];
    if (!passLine) {
        passLine = [UIView new];
        passLine.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
        passLine.tag = 107;
        [self.view addSubview:passLine];
        
        [passLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(passField.mas_bottom);
            make.left.and.right.equalTo(passField);
            make.height.equalTo(@0.5);
        }];
    }

    //  登录按钮
    UIButton *loginButton = [self.view viewWithTag:108];
    if (!loginButton) {
        loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [loginButton setBackgroundImage:[UIImage imageNamed:@"jp_button_normal"] forState:UIControlStateNormal];
        [loginButton setBackgroundImage:[UIImage imageNamed:@"jp_button_highlighted"] forState:UIControlStateHighlighted];
        loginButton.layer.cornerRadius = JPRealValue(10);
        loginButton.layer.masksToBounds = YES;
        [loginButton addTarget:self action:@selector(handleLoginRequest:) forControlEvents:UIControlEventTouchUpInside];
        loginButton.tag = 108;
        [self.view addSubview:loginButton];
        
        [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(passLine.mas_bottom).offset(JPRealValue(74));
            make.left.equalTo(weakSelf.view.mas_left).offset(JPRealValue(60));
            make.right.equalTo(weakSelf.view.mas_right).offset(JPRealValue(-60));
            make.height.equalTo(@(JPRealValue(90)));
        }];
    }
    
    //  商户入驻
    UIButton *registerButton = [self.view viewWithTag:109];
    if (!registerButton) {
        registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [registerButton setTitle:@"商户入驻" forState:UIControlStateNormal];
        [registerButton setTitleColor:JPBaseColor forState:UIControlStateNormal];
        registerButton.layer.cornerRadius = JPRealValue(10);
        registerButton.layer.masksToBounds = YES;
        registerButton.layer.borderColor = JPBaseColor.CGColor;
        registerButton.layer.borderWidth = 1;
        [registerButton addTarget:self action:@selector(handleRegister:) forControlEvents:UIControlEventTouchUpInside];
        registerButton.tag = 109;
        [self.view addSubview:registerButton];
        
        [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(loginButton.mas_bottom).offset(JPRealValue(26));
            make.left.equalTo(loginButton.mas_left);
            make.right.equalTo(loginButton.mas_right);
            make.height.equalTo(@(JPRealValue(90)));
        }];
    }
    //  记住密码按钮
    UIButton *rememberButton = [self.view viewWithTag:110];
    if (!rememberButton) {
        rememberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rememberButton setTitle:@"记住密码" forState:UIControlStateNormal];
        [rememberButton setTitleColor:JPBaseColor forState:UIControlStateNormal];
        [rememberButton setImage:[UIImage imageNamed:@"jp_login_remember"] forState:UIControlStateNormal];
        if (_isRemember) {
            [rememberButton setImage:[UIImage imageNamed:@"jp_login_remember_selected"] forState:UIControlStateNormal];
        } else {
            [rememberButton setImage:[UIImage imageNamed:@"jp_login_remember"] forState:UIControlStateNormal];
        }
        rememberButton.titleLabel.font = [UIFont systemFontOfSize:JPRealValue(24)];
        [rememberButton addTarget:self action:@selector(handleRememberPass:) forControlEvents:UIControlEventTouchUpInside];
        rememberButton.tag = 110;
        [self.view addSubview:rememberButton];
        
        [rememberButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(registerButton.mas_left);
            make.top.equalTo(registerButton.mas_bottom).offset(JPRealValue(20));
            make.height.equalTo(@(JPRealValue(60)));
        }];
    }
    //  忘记密码按钮
    UIButton *forgetButton = [self.view viewWithTag:111];
    if (!forgetButton) {
        forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [forgetButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [forgetButton setTitleColor:JPBaseColor forState:UIControlStateNormal];
        forgetButton.titleLabel.font = [UIFont systemFontOfSize:JPRealValue(24)];
        forgetButton.tag = 111;
        [forgetButton addTarget:self action:@selector(handleForgetPass) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:forgetButton];
        
        [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(registerButton.mas_right);
            make.top.equalTo(registerButton.mas_bottom).offset(JPRealValue(20));
            make.height.equalTo(@(JPRealValue(60)));
        }];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - action
//  商户入驻
- (void)handleRegister:(UIButton *)sender {
    
//    IBBaseInfoViewController *baseInfoVC = [IBBaseInfoViewController new];
//    baseInfoVC.qrcodeid = @"739ea4cac8aa4266a9041aa53cb5ab2b";
//    [self.navigationController pushViewController:baseInfoVC animated:YES];
//    return;
    JPMerchantRegisterViewController * registerVC = [[JPMerchantRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
//    if ([JPUserInfoHelper dataSource].count > 0) {
//        [JPUserInfoHelper clearData];
//    }
//
//    //  跳到二维码扫描界面
//    // 1、 获取摄像设备
//    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    if (device) {
//        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//        if (status == AVAuthorizationStatusNotDetermined) {
//            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//                if (granted) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [MobClick event:@"login_register"];
//                        QRCodeScanningVC *vc = [[QRCodeScanningVC alloc] init];
//                        [self.navigationController pushViewController:vc animated:YES];
//                    });
//                    JPLog(@"用户第一次同意了访问相机权限");
//
//                } else {
//
//                    // 用户第一次拒绝了访问相机权限
//                    JPLog(@"用户第一次拒绝了访问相机权限");
//                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您已关闭相机使用权限，请前往 -> [设置 - 杰宝宝] 打开开关" preferredStyle:(UIAlertControllerStyleAlert)];
//                    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
//                    [alertC addAction:alertA];
//                    [self presentViewController:alertC animated:YES completion:nil];
//                }
//            }];
//        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
//            [MobClick event:@"login_register"];
//            QRCodeScanningVC *vc = [[QRCodeScanningVC alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
//            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您已关闭相机使用权限，请前往 -> [设置 - 隐私 - 相机 - 杰宝宝] 打开开关" preferredStyle:(UIAlertControllerStyleAlert)];
//            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
//            [alertC addAction:alertA];
//            [self presentViewController:alertC animated:YES completion:nil];
//
//        } else if (status == AVAuthorizationStatusRestricted) {
//            JPLog(@"因为系统原因, 无法访问相册");
//        }
//    } else {
//        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
//        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
//
//        [alertC addAction:alertA];
//        [self presentViewController:alertC animated:YES completion:nil];
//    }
}
//  登录
- (void)handleLoginRequest:(UIButton *)sender {
    
    weakSelf_declare;
    //  监控网络状态变化
    [JPNetworkUtils netWorkState:^(NSInteger netState) {
        switch (netState) {
            case 1:
            case 2: {
                [weakSelf login];
            }
                break;
            default: {
                JPLog(@"没网");
            }
                break;
        }
    }];
//    [self login];
}

//  记住密码
- (void)handleRememberPass:(UIButton *)rememberBtn {
    
    [MobClick event:@"login_rememberPsw"];
    
    _isRemember = !_isRemember;
    if (_isRemember) {
        JPLog(@"记住密码");
        [rememberBtn setImage:[UIImage imageNamed:@"jp_login_remember_selected"] forState:UIControlStateNormal];
    } else {
        JPLog(@"不记住密码");
        [rememberBtn setImage:[UIImage imageNamed:@"jp_login_remember"] forState:UIControlStateNormal];
    }
    [JP_UserDefults setBool:_isRemember forKey:@"remember"];
    [JP_UserDefults synchronize];
}

//  忘记密码
- (void)handleForgetPass {
    
    [MobClick event:@"login_forgetPsw"];
    
    JPForgetPswViewController *forgetVC = [[JPForgetPswViewController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (void)login {

    if (_userNameTextField.text.length <= 0) {
        [IBProgressHUD showInfoWithStatus:@"请输入您的账号！"];
        return;
    }
    if (_passwordTextField.text.length <= 0) {
        [IBProgressHUD showInfoWithStatus:@"请输入您的密码！"];
        return;
    }
    
    [MobClick event:@"login_click"];
    
    [IBProgressHUD loadingWithStatus:@"登录中，请稍后..."];
    
    weakSelf_declare;
    [IBLoginRequest loginWithAccount:_userNameTextField.text
                            loginPwd:_passwordTextField.text
                            callback:^(NSString *code, NSString *msg, id resp) {
                                
        JPLog(@"%@ - %@ - %@", code, msg, resp);
        if ([resp isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)resp;
            NSArray *keys = dic.allKeys;
            
            if (code.integerValue == 0) {
                //  登录成功
                [IBProgressHUD dismiss];
                
                if ([JP_UserDefults objectForKey:@"userLogin"]) {
                    if (![[JP_UserDefults objectForKey:@"userLogin"] isEqualToString:_userNameTextField.text]) {
                        //  若本次登录账号与上次不一致，清除本地推送消息
                        [JPPushHelper clearData];
                    }
                }
                //  登录成功 先把用户名存到本地
                [JP_UserDefults setObject:_userNameTextField.text forKey:@"userLogin"];
                if ([keys containsObject:@"appPhone"]) {
                    [JP_UserDefults setObject:[resp objectForKey:@"appPhone"] forKey:@"appPhone"];
                }
                
                NSString *merchantNo = nil;
                
                if ([keys containsObject:@"merchantNo"]) {
                    merchantNo = dic[@"merchantNo"];
                    if (![merchantNo isEqual:[NSNull null]]) {
                        [JP_UserDefults setObject:merchantNo forKey:@"merchantNo"];
                        
                        //  绑定友盟推送alias
                        [UMessage addAlias:merchantNo
                                      type:JP_UMessageAliasType
                                  response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                            if(responseObject) {
                                JPLog(@"绑定成功！");
                                [[JPPushManager sharedManager] makeIsBindAlias:YES];
                            } else {
                                JPLog(@"绑定失败！ - %@", error.localizedDescription);
                                [[JPPushManager sharedManager] makeIsBindAlias:NO];
                            }
                        }];
                        
                        //  友盟Alias上传服务器
                        NSMutableDictionary *parameters = @{}.mutableCopy;
                        [parameters setObject:merchantNo forKey:@"alias"];
                        [parameters setObject:JP_UMessageAliasType forKey:@"aliasType"];
                        //  appType 1：安卓飞燕，2：安卓杰宝宝，3：iOS杰宝宝，4：iOS飞燕
                        [parameters setObject:@"3" forKey:@"appType"];
                        
                        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
                        NSString *localVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
                        //  当前版本号
                        [parameters setObject:localVersion forKey:@"versionNo"];
                        if ([JP_UserDefults objectForKey:@"deviceToken"]) {
                            [parameters setObject:[JP_UserDefults objectForKey:@"deviceToken"] forKey:@"deviceTokens"];
                        }
                        
                        [JPNetworking postUrl:jp_UMessageAlias_url
                                       params:parameters
                                     progress:nil
                                     callback:^(id respon) {
                            JPLog(@"------%@", respon);
                            JPLog(@"deviceToken - %@", [JP_UserDefults objectForKey:@"deviceToken"]);
                            if ([respon isKindOfClass:[NSString class]]) {
                                return;
                            }
                            if ([respon isKindOfClass:[NSDictionary class]]) {
                                BOOL suc = [respon[@"responseCode"] isEqualToString:@"0"];
                                [[JPPushManager sharedManager] makeIsBindService:suc];
                            }
                        }];
                    } else {
                        //  新进件用户可登录 但是不能交易
                        merchantNo = nil;
                    }
                }
                
                NSString *userName = [keys containsObject:@"username"] ? dic[@"username"] : _userNameTextField.text;
                
                [[JPUserEntity sharedUserEntity] setIsLogin:YES account:userName merchantNo:merchantNo merchantId:[dic[@"merchantId"] integerValue] merchantName:dic[@"merchantName"] applyType:[dic[@"applyType"] integerValue] privateKey:dic[@"privateKey"] publicKey:dic[@"publicKey"] userId:dic[@"userId"]];
                                
                if (_isRemember) {
                    [JP_UserDefults setObject:_passwordTextField.text forKey:@"passLogin"];
                    [JP_UserDefults synchronize];
                }
                
                //  跳转tabBarController首页
                JPTabBarController *tabBarController = [[JPTabBarController alloc] init];
//                [weakSelf.view.window setRootViewController:tabBarController];
                [weakSelf presentViewController:tabBarController animated:YES completion:nil];
            }
            return;
        }
        [IBProgressHUD showInfoWithStatus:msg];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textField只允许输入字母和数字
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
        if(textField == _userNameTextField) {
        [MobClick event:@"login_user"];
    } else if (textField == _passwordTextField) {
        [MobClick event:@"login_pass"];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField) {
        //lengthOfString的值始终为1
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            unichar character = [string characterAtIndex:loopIndex];
            // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57 && character < 65) return NO; //
            if (character > 90 && character < 97) return NO;
            if (character > 122) return NO;
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 20) {
            return NO;//限制长度
        }
        return YES;
    }
    return YES;
}

- (BOOL)navigationBarHidden {
    return YES;
}

#pragma mark - Methods
- (void)secureSwitchAction
{
    _secureSwitchButton.selected = !_secureSwitchButton.selected;
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
    NSString* text = self.passwordTextField.text;
    self.passwordTextField.text = @" ";
    self.passwordTextField.text = text;
}

- (void)questionButtonAction
{
     [XHToast showBottomWithText:@"1.已经绑定了手机号的商户可以使用手机号登录杰宝宝APP \n 2、没有账号点击商户入驻直接注册成为商户" bottomOffset:40 duration:2.0];
    NSLog(@"111");
}

@end
