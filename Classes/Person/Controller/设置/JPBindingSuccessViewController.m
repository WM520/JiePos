//
//  JPBindingSuccessViewController.m
//  JiePos
//
//  Created by wangmiao on 2017/12/19.
//  Copyright © 2017年 WangMiao. All rights reserved.
//

#import "JPBindingSuccessViewController.h"
#import "JPLoginViewController.h"


@interface JPBindingSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *resultImage;
@property (nonatomic, strong) UIBarButtonItem *rightButtonItem;
@end

@implementation JPBindingSuccessViewController

#pragma mark - lifestyle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"绑定成功";
    _rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClicked)];
    self.navigationItem.rightBarButtonItem = self.rightButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Action
- (void)rightBarItemClicked {
    NSArray * controllers = self.navigationController.viewControllers;
    [self.navigationController popToViewController:controllers[1] animated:YES];
}
// 跳转登录页
- (IBAction)backAction:(id)sender {
//    NSArray * controllers = self.navigationController.viewControllers;
//    [self.navigationController popToViewController:controllers[1] animated:YES];
    JPLoginViewController * login = [[JPLoginViewController alloc] init];
    [self presentViewController:login animated:YES completion:nil];
}

@end
