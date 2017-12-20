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
@property (weak, nonatomic) IBOutlet UITextField *firstNumberField;
@property (weak, nonatomic) IBOutlet UITextField *secondNumberFiled;
@property (weak, nonatomic) IBOutlet UITextField *threeNumberField;
@property (weak, nonatomic) IBOutlet UITextField *fourNumberField;
@property (weak, nonatomic) IBOutlet UITextField *fiveNumberField;
@property (weak, nonatomic) IBOutlet UITextField *sixNumberField;

@end

@implementation JPVerificationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"更换手机号";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)receiveAction:(id)sender {
    JPBindingSuccessViewController * bindingSuccessVC = [[JPBindingSuccessViewController alloc] init];
    [self.navigationController pushViewController:bindingSuccessVC animated:YES];
}


@end
