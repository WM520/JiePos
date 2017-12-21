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
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic , assign)NSInteger time;
@end

@implementation JPPhoneRegisterViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

- (IBAction)getMessageCode:(id)sender {
    _getCodeButton.userInteractionEnabled = NO;
    self.timer.fireDate = [NSDate distantPast];
}
- (IBAction)nextTap:(id)sender {
    IBBaseInfoViewController *baseInfoVC = [IBBaseInfoViewController new];
    baseInfoVC.qrcodeid = @"739ea4cac8aa4266a9041aa53cb5ab2b";
    [self.navigationController pushViewController:baseInfoVC animated:YES];
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
