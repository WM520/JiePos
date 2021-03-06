//
//  JPGesturePasswordViewController.m
//  JiePos
//
//  Created by wangmiao on 2017/12/22.
//  Copyright © 2017年 WangMiao. All rights reserved.
//

//
//  JPModificationViewController.m
//  JiePos
//
//  Created by wangmiao on 2017/12/22.
//  Copyright © 2017年 WangMiao. All rights reserved.
//

#import "JPGesturePasswordViewController.h"
#import "TQGestureLockView.h"
#import "TQGestureLockPreview.h"
#import "TQGesturesPasswordManager.h"
#import "TQGestureLockHintLabel.h"
#import "TQGestureLockToast.h"
#import "LXAlertView.h"

@interface JPGesturePasswordViewController () <TQGestureLockViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *rightButtonItem;
@property (nonatomic, strong) TQGestureLockView *lockView;
@property (nonatomic, strong) TQGestureLockPreview *preview;
@property (nonatomic, strong) TQGestureLockHintLabel *hintLabel;
@property (nonatomic, strong) TQGesturesPasswordManager *passwordManager;
@property (nonatomic, strong) UIButton * repeatSettings;
@property (nonatomic, assign) NSInteger count;
@end

@implementation JPGesturePasswordViewController

- (UIBarButtonItem *)rightButtonItem
{
    if (!_rightButtonItem) {
        _rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClicked)];
    }
    return _rightButtonItem;
}

- (void)setNavRightButtonItem {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _count = 5;
    [self commonInitialization];
    
    [self subviewsInitialization];
}

- (void)commonInitialization
{
    self.passwordManager = [TQGesturesPasswordManager manager];
}

- (void)subviewsInitialization
{
    weakSelf_declare;
    
    CGFloat interval = 30;
    
    if (kScreenWidth == 375) {
        interval = 30;
    } else if (kScreenWidth == 414) {
        interval = 40;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * imageview = [[UIImageView alloc] init];
    imageview.image = [UIImage imageNamed:@"jbb_loginBg"];
    [self.view addSubview:imageview];
    
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(weakSelf.view);
    }];
    
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGFloat spacing = TQSizeFitW(40);
    CGFloat diameter = (screenSize.width - spacing * 4) / 3;
    CGFloat bottom1 = JPRealValue(55);
    CGFloat width1 = kScreenWidth;
    CGFloat top1 = kScreenHeight - width1 - bottom1 - interval;
    CGRect rect1 = CGRectMake(0, top1, width1, width1);
    
    UILabel * userNameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, top1 - interval, kScreenWidth, 30)];
    userNameLable.textColor = RGB(122, 147, 245);
    userNameLable.textAlignment = NSTextAlignmentCenter;
    userNameLable.font = [UIFont systemFontOfSize:18 weight:300];
    userNameLable.text = [JP_UserDefults objectForKey:@"userLogin"];
    [self.view addSubview:userNameLable];

    
    CGFloat width2 = screenSize.width, height2 = 30;
    CGFloat top2 = top1 + spacing - height2 - 15;
    CGRect rect2 = CGRectMake(0, top2, width2, height2);
    
//    CGFloat width3 = 70;
//    CGFloat left3 = screenSize.width / 2 - width3 / 2;
//    CGFloat top3 = top2 - width3 - 5;
//    CGRect rect3 = CGRectMake(left3, top3, width3, width3);
    
    TQGestureLockDrawManager *drawManager = [TQGestureLockDrawManager defaultManager];
    drawManager.circleDiameter = diameter;
    drawManager.edgeSpacingInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    drawManager.bridgingLineWidth = 0.5;
    drawManager.hollowCircleBorderWidth = 0.5;
    
    _lockView = [[TQGestureLockView alloc] initWithFrame:rect1 drawManager:drawManager];
    _lockView.delegate = self;
    [self.view addSubview:_lockView];
    
    
    
    _hintLabel = [[TQGestureLockHintLabel alloc] initWithFrame:rect2];
    [_hintLabel setNormalText:@"请输入手势密码"];
    [self.view addSubview:_hintLabel];
    
    UIButton * loginWithCode = [[UIButton alloc] init];
    [loginWithCode setTitle:@"使用账号登录" forState: UIControlStateNormal];
    [loginWithCode setTitleColor:RGB(122, 147, 245) forState:UIControlStateNormal];
    [loginWithCode addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginWithCode];
    
    [loginWithCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.height.equalTo(@30);
    }];
    
}

#pragma mark - TQGestureLockViewDelegate

- (void)gestureLockView:(TQGestureLockView *)gestureLockView lessErrorSecurityCodeSting:(NSString *)securityCodeSting
{
    [gestureLockView setNeedsDisplayGestureLockErrorState:YES];
    
    if (self.passwordManager.hasFirstPassword) {
        [_hintLabel setWarningText:@"与上一次绘制不一致，请重新绘制" shakeAnimated:YES];
        [self setNavRightButtonItem];
    } else {
        [_hintLabel setWarningText:@"至少连接4个点，请重新输入"
                     shakeAnimated:YES];
    }
}

- (void)gestureLockView:(TQGestureLockView *)gestureLockView finalRightSecurityCodeSting:(NSString *)securityCodeSting
{
    weakSelf_declare;
    NSString * oldCodeString = [self.passwordManager getEventuallyPassword];
    if ([oldCodeString isEqualToString:securityCodeSting]) { // 手势验证成功，直接登录
        [gestureLockView setNeedsDisplayGestureLockErrorState:NO];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [JPNetworkUtils netWorkState:^(NSInteger netState) {
                switch (netState) {
                    case 1: case 2:{
                        JPLoginViewController * vc = [JPLoginViewController new];
                        JPNavigationController *loginNav = [[JPNavigationController alloc] initWithRootViewController:vc];
                        vc.view.hidden = YES;
                        [weakSelf presentViewController:loginNav animated:YES completion:nil];
                    }
                        
                        break;
                        
                    default:{
                        [weakSelf.preview redraw];
                    }
                        break;
                }
            }];
            
        });
    } else { // 手势验证失败5次，清除保存的密码，用户重新登录
        [gestureLockView setNeedsDisplayGestureLockErrorState:YES];
        self.count--;
        [_hintLabel setWarningText:[NSString stringWithFormat:@"密码错误，您还可以输入%ld次", self.count] shakeAnimated:YES];
        if (_count <= 0) {
  
            LXAlertView * alert = [[LXAlertView alloc] initWithTitle:@"提醒" message:@"你已经连续5次输错手势密码，手势登录失效，请使用登录密码重新登录，点击确认跳转到账号密码登录页面" cancelBtnTitle:nil otherBtnTitle:@"我知道了" clickIndexBlock:^(NSInteger clickIndex) {
                if (clickIndex == 0) {
                    [JP_UserDefults removeObjectForKey:@"passLogin"];
                    [JP_UserDefults removeObjectForKey:@"tq_gesturesPassword"];
                    JPNavigationController *loginNav = [[JPNavigationController alloc] initWithRootViewController:[JPLoginViewController new]];
                    [weakSelf presentViewController:loginNav animated:YES completion:nil];
                }
            }];
            [alert showLXAlertView];
        }
    }
}

#pragma mark - Methods
// 账号密码登录
- (void)login
{
    [JP_UserDefults removeObjectForKey:@"passLogin"];
    JPLoginViewController * vc = [JPLoginViewController new];
    JPNavigationController *loginNav = [[JPNavigationController alloc] initWithRootViewController:vc];
    vc.isGesturePush = YES;
    [self presentViewController:loginNav animated:YES completion:nil];
}

@end


