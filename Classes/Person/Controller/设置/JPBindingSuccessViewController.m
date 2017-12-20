//
//  JPBindingSuccessViewController.m
//  JiePos
//
//  Created by wangmiao on 2017/12/19.
//  Copyright © 2017年 WangMiao. All rights reserved.
//

#import "JPBindingSuccessViewController.h"


@interface JPBindingSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *resultImage;

@end

@implementation JPBindingSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"绑定成功";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    NSArray * controllers = self.navigationController.viewControllers;
    [self.navigationController popToViewController:controllers[1] animated:YES];
}


@end
