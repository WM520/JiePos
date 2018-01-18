//
//  JPPhoneRegisterViewController.m
//  JiePos
//
//  Created by wangmiao on 2017/12/21.
//  Copyright © 2017年 WangMiao. All rights reserved.
//

#import "JPPhoneRegisterViewController.h"
#import "IBBaseInfoViewController.h"

@interface JPPhoneRegisterViewController ()
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic , assign)NSInteger time;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *sendMsgButton;
@property (weak, nonatomic) IBOutlet UIButton *nextstepButton;

@end

@implementation JPPhoneRegisterViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.phoneTextField.delegate = self;
    self.codeTextFiled.delegate = self;
    self.sendMsgButton.enabled = NO;
    self.nextstepButton.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods
- (IBAction)getMessageCode:(id)sender {
    [JPNetTools1_0_2 checkIsOnlyPhone:self.phoneTextField.text callback:^(NSString *code, NSString *msg, id resp) {
        if ([code isEqualToString:@"00"]) {
            _getCodeButton.userInteractionEnabled = NO;
            self.timer.fireDate = [NSDate distantPast];
            [JPNetTools1_0_2 sendSmsPhoneCode:self.phoneTextField.text callback:^(NSString *code, NSString *msg, id resp) {
//                id obj = [IBAnalysis analysisWithEncryptString:resp privateKey:[JPUserEntity sharedUserEntity].privateKey];
                if ([code isEqualToString:@"00"]) {
                    [IBProgressHUD showSuccessWithStatus:@"验证码发送成功"];
                } else {
                    [IBProgressHUD showSuccessWithStatus:@"验证码发送失败"];
                }
            }];
        } else {
            [IBProgressHUD showErrorWithStatus:msg];
        }
    }];
}
- (IBAction)nextTap:(id)sender {
    [JPNetTools1_0_2 checkCodeIsOK:self.phoneTextField.text code:self.codeTextFiled.text callback:^(NSString *code, NSString *msg, id resp) {
        if ([code  isEqual: @"00"]) {
            IBBaseInfoViewController *baseInfoVC = [IBBaseInfoViewController new];
            baseInfoVC.qrcodeid = @"";
            baseInfoVC.phoneNumber = self.phoneTextField.text;
            [self.navigationController pushViewController:baseInfoVC animated:YES];
        } else {
            [IBProgressHUD showErrorWithStatus:msg];
        }
    }];
}

- (void)timeUp
{
    _time = _time - 1;
    [_getCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)_time] forState:UIControlStateNormal];
    if (_time <= 0) {
        //结束计时
        _timer.fireDate = [NSDate distantFuture];
        _getCodeButton.userInteractionEnabled = YES;
        [_getCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        self.time = 60;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _phoneTextField) {
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length >= 11) {
            self.sendMsgButton.enabled = YES;
            if (self.codeTextFiled.text.length == 6) {
                self.nextstepButton.enabled = YES;
            }
        } else {
            self.sendMsgButton.enabled = NO;
            self.nextstepButton.enabled = NO;
        }
        if (toBeString.length > 11 && range.length!=1){
            textField.text = [toBeString substringToIndex:11];
            [textField resignFirstResponder];
            return NO;
        }
    } else if (textField == _codeTextFiled) {
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length >= 6 && self.sendMsgButton.enabled == YES) {
            self.nextstepButton.enabled = YES;
        } else {
            self.nextstepButton.enabled = NO;
        }
        if (toBeString.length > 6 && range.length!=1){
            textField.text = [toBeString substringToIndex:6];
            [textField resignFirstResponder];
            return NO;
        }
    }
    return YES;
}

#pragma mark - Getter&&Setter
- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeUp) userInfo:nil repeats:YES];
        _time = 60;
    }
    return _timer;
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

@end
