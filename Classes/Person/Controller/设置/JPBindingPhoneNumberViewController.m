//
//  JPBindingPhoneNumberViewController.m
//  JiePos
//
//  Created by wangmiao on 2017/12/19.
//  Copyright © 2017年 WangMiao. All rights reserved.
//

#import "JPBindingPhoneNumberViewController.h"
#import "JPVerificationCodeViewController.h"

@interface JPBindingPhoneNumberViewController ()
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation JPBindingPhoneNumberViewController

#pragma mark - lifestyle
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
    if ([JP_UserDefults objectForKey:@"appPhone"]) {
        self.title = @"更换手机号";
        [self.nextButton setTitle:@"更换手机号" forState:UIControlStateNormal];
    } else {
        self.title = @"绑定手机号";
        [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    }
    self.numberTextField.delegate = self;
    self.nextButton.enabled = NO;
}

#pragma mark - Action
- (IBAction)nextTap:(id)sender {
    
    [IBPersonRequest checkIsOnlyPhone:self.numberTextField.text account:[JPUserEntity sharedUserEntity].account callback:^(NSString *code, NSString *msg, id resp) {
        if (code.integerValue == 0) {
            JPVerificationCodeViewController * codeVC = [[JPVerificationCodeViewController alloc] init];
            codeVC.numberPhone = self.numberTextField.text;
            [self.navigationController pushViewController:codeVC animated:YES];
        } else {
            [IBProgressHUD showErrorWithStatus:msg];
        }
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _numberTextField) {
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length >= 11) {
            self.nextButton.enabled = YES;
        } else {
            self.nextButton.enabled = NO;
        }
        if (toBeString.length > 11 && range.length!=1){
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    return YES;
}

@end
