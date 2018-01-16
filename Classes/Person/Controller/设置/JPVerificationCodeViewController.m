//
//  JPVerificationCodeViewController.m
//  JiePos
//
//  Created by wangmiao on 2017/12/19.
//  Copyright © 2017年 WangMiao. All rights reserved.
//

#import "JPVerificationCodeViewController.h"
#import "JPBindingSuccessViewController.h"

@interface JPVerificationCodeViewController ()
<UITextFieldDelegate>
{
    NSInteger _index;
}
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstNumberField;
@property (weak, nonatomic) IBOutlet UITextField *secondNumberFiled;
@property (weak, nonatomic) IBOutlet UITextField *threeNumberField;
@property (weak, nonatomic) IBOutlet UITextField *fourNumberField;
@property (weak, nonatomic) IBOutlet UITextField *fiveNumberField;
@property (weak, nonatomic) IBOutlet UITextField *sixNumberField;
@property (copy, nonatomic) NSArray *textFieldArr;
@property (strong, nonatomic) UITextField *currentTextField;
@property (copy, nonatomic) NSString * codeID;
@property (nonatomic, strong)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (nonatomic , assign)NSInteger time;
@end

@implementation JPVerificationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"更换手机号";
    [self configData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IBPersonRequest sendSmsPhoneCode:self.numberPhone account:[JPUserEntity sharedUserEntity].account callback:^(NSString *code, NSString *msg, id resp) {
        if (code.integerValue == 0) {
            [IBProgressHUD showInfoWithStatus:@"验证码发送成功"];
        } else {
            [IBProgressHUD showInfoWithStatus:@"验证码发送失败"];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configData
{
    _numberLabel.text = [NSString stringWithFormat:@"+86  %@", self.numberPhone];
    self.time = 60;
    _textFieldArr = @[self.firstNumberField, self.secondNumberFiled, self.threeNumberField, self.fourNumberField, self.fiveNumberField, self.sixNumberField];
    self.firstNumberField.delegate = self;
    self.secondNumberFiled.delegate = self;
    self.threeNumberField.delegate = self;
    self.fourNumberField.delegate = self;
    self.fiveNumberField.delegate = self;
    self.sixNumberField.delegate = self;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _index = textField.tag - 101;
    textField.text = @"";
    self.currentTextField = textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if (string.length > 0 && _index == 0) {
        _firstNumberField.text = string;
        _index = [self forinArr:1];
        return NO;
    }else if(string.length > 0 && _index == 1){
        _secondNumberFiled.text = string;
        _index = [self forinArr:2];
        return NO;
    }else if(string.length > 0 && _index == 2){
        _threeNumberField.text = string;
        _index = [self forinArr:3];
        return NO;
    }else if(string.length > 0 && _index == 3){
        _fourNumberField.text = string;
        _index = [self forinArr:4];
        return NO;
    }else if(string.length > 0 && _index == 4){
        _fiveNumberField.text = string;
        _index = [self forinArr:5];
        return NO;
    }else if(string.length > 0 && _index == 5){
        _sixNumberField.text = string;
        _index = [self forinArr:5];
//        [textField endEditing:YES];
        return NO;
    }else if(string.length > 0 && _index == 6){
        
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 101) {
        [self.secondNumberFiled becomeFirstResponder];
    } else if (textField.tag == 102) {
        [self.threeNumberField becomeFirstResponder];
    } else if (textField.tag == 103) {
        [self.fourNumberField becomeFirstResponder];
    } else if (textField.tag == 104) {
        [self.fiveNumberField becomeFirstResponder];
    } else if (textField.tag == 105) {
        [self.sixNumberField becomeFirstResponder];
    } else if (textField.tag == 106) {
        [self.view endEditing:YES];
    }
    return YES;
}

/**
 *  遍历处理
 */
- (NSInteger)forinArr:(NSInteger )j{
    NSInteger k = 0;
    BOOL isChang = NO;
    for (NSInteger i = j; i < _textFieldArr.count; i++) {
        if([_textFieldArr[i] text].length == 0)
        {
            k = i;
            [_textFieldArr[i] becomeFirstResponder];
            NSLog(@"%lu",k);
            isChang = YES;
            break;
        };
    }
    if (!isChang) {
        for (NSInteger i = 0; i < _textFieldArr.count; i++) {
            if([_textFieldArr[i] text].length == 0)
            {
                k = i;
                [_textFieldArr[i] becomeFirstResponder];
                NSLog(@"%lu",[_textFieldArr[i] text].length);
                isChang = YES;
                break;
            };
        }
    }
    NSLog(@"%ld",(long)k);
    if (!isChang) {
        [self.view endEditing:YES];
        _codeID = @"";
        for (int i = 0; i < _textFieldArr.count; i++) {
            UITextField *textField = _textFieldArr[i];
            _codeID = [_codeID stringByAppendingString:textField.text];
        }
        NSLog(@"%@", _codeID);
        NSLog(@"%@", self.numberPhone);
        NSLog(@"%@", [JPUserEntity sharedUserEntity].userId);
        NSLog(@"%@", [JPUserEntity sharedUserEntity].account);
        [IBPersonRequest checkIsOKPhoneCode:_codeID appPhone:self.numberPhone userId:[JPUserEntity sharedUserEntity].userId account:[JPUserEntity sharedUserEntity].account callback:^(NSString *code, NSString *msg, id resp) {
//            id obj = [IBAnalysis analysisWithEncryptString:resp privateKey:[JPUserEntity sharedUserEntity].privateKey];
            if ([code isEqualToString:@"0"]) {
                JPBindingSuccessViewController * bindingSuccessVC = [[JPBindingSuccessViewController alloc] init];
                [self.navigationController pushViewController:bindingSuccessVC animated:YES];
            } else {
                [IBProgressHUD showInfoWithStatus:msg];
            }
        }];
        return 6;
    }else
        return k;
}

- (IBAction)receiveAction:(id)sender {
    
    for (int i = 0; i < _textFieldArr.count; i++) {
        UITextField * textField = _textFieldArr[i];
        textField.text = @"";
    }
    _getCodeButton.userInteractionEnabled = NO;
    self.timer.fireDate = [NSDate distantPast];
    [IBPersonRequest sendSmsPhoneCode:self.numberPhone account:[JPUserEntity sharedUserEntity].account callback:^(NSString *code, NSString *msg, id resp) {
        if (code.integerValue == 0) {
            [IBProgressHUD showInfoWithStatus:@"验证码发送成功"];
        } else {
            [IBProgressHUD showInfoWithStatus:@"验证码发送失败"];
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
