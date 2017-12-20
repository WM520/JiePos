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
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

@end

@implementation JPBindingPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"更换手机号";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextTap:(id)sender {
    JPVerificationCodeViewController * codeVC = [[JPVerificationCodeViewController alloc] init];
    [self.navigationController pushViewController:codeVC animated:YES];
}


@end
