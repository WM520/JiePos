//
//  TQViewController1.m
//  TQGestureLockViewDemo_Example
//
//  Created by TQTeam on 2017/11/3.
//  Copyright © 2017年 TQTeam. All rights reserved.
//

#import "TQViewController1.h"
#import "TQGestureLockView.h"
#import "TQGestureLockPreview.h"
#import "TQGesturesPasswordManager.h"
#import "TQGestureLockHintLabel.h"
#import "TQGestureLockToast.h"
#import "JPTabBarController.h"
#import "LXAlertView.h"

@interface TQViewController1 () <TQGestureLockViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *rightButtonItem;
@property (nonatomic, strong) TQGestureLockView *lockView;
@property (nonatomic, strong) TQGestureLockPreview *preview;
@property (nonatomic, strong) TQGestureLockHintLabel *hintLabel;
@property (nonatomic, strong) TQGesturesPasswordManager *passwordManager;
@property (nonatomic, strong) UIButton * repeatSettings;
@end

@implementation TQViewController1

- (UIBarButtonItem *)rightButtonItem
{
    if (!_rightButtonItem) {
        _rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClicked)];
    }
    return _rightButtonItem;
}

- (void)setNavRightButtonItem {
    if (!self.repeatSettings) {
        weakSelf_declare;
        _repeatSettings = [[UIButton alloc] init];
        [_repeatSettings setTitle:@"重新设置" forState:UIControlStateNormal];
        [_repeatSettings setTitleColor:RGB(122, 147, 245) forState:UIControlStateNormal];
        [_repeatSettings addTarget:self action:@selector(repeatSetting) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_repeatSettings];
        [_repeatSettings mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view);
            make.right.equalTo(weakSelf.view);
            make.height.equalTo(@30);
            make.bottom.equalTo(weakSelf.view).offset(JPRealValue(-50));
        }];
    }
}

- (void)repeatSetting
{
    _hintLabel.textColor = [UIColor grayColor];
    _hintLabel.text = @"绘制解锁图案";
    [_preview redraw];
    self.passwordManager.firstPassword = nil;
}

- (void)rightBarItemClicked {
    weakSelf_declare;
    LXAlertView * alert = [[LXAlertView alloc] initWithTitle:@"友情提醒" message:@"您可以在我的-设置-手势密码设置中启用手势密码，点击我知道了跳转至首页" cancelBtnTitle:nil otherBtnTitle:@"我知道了" clickIndexBlock:^(NSInteger clickIndex) {
        JPTabBarController * tabVc = [[JPTabBarController alloc] init];
        [weakSelf presentViewController:tabVc animated:YES completion:nil];
    }];
    [alert showLXAlertView];
}

- (void)onBackItemClicked:(id)sender
{
//    [super onBackItemClicked:sender];
    if (self.isModification) {
        NSArray * controllers = self.navigationController.childViewControllers;
        [self.navigationController popToViewController:controllers[2] animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self commonInitialization];
    
    [self subviewsInitialization];
}

- (void)commonInitialization
{
    self.passwordManager = [TQGesturesPasswordManager manager];
    if (_isFirstLogin) {
        self.title = @"请设置解锁图案";
        self.navigationItem.rightBarButtonItem = self.rightButtonItem;
    }
}

- (void)subviewsInitialization
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGFloat top1Height = 150;
    // 适配首次登录的显示问题
    if (_isFirstLogin) {
        top1Height = 150 - 64;
    }
    
    CGFloat spacing = TQSizeFitW(40);
    CGFloat diameter = (screenSize.width - spacing * 4) / 3;
    CGFloat bottom1 = JPRealValue(55);
    CGFloat width1 = kScreenWidth;
    CGFloat top1 = kScreenHeight - width1 - bottom1 - top1Height;
    CGRect rect1 = CGRectMake(0, top1, width1, width1);
    
    CGFloat width2 = screenSize.width, height2 = 30;
    CGFloat top2 = top1 + spacing - height2 - 15;
    CGRect rect2 = CGRectMake(0, top2, width2, height2);
    
    CGFloat width3 = 55;
    CGFloat left3 = screenSize.width / 2 - width3 / 2;
    CGFloat top3 = top2 - width3 - 5;
    CGRect rect3 = CGRectMake(left3, top3, width3, width3);
    
    TQGestureLockDrawManager *drawManager = [TQGestureLockDrawManager defaultManager];
    drawManager.circleDiameter = diameter;
    drawManager.edgeSpacingInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    drawManager.bridgingLineWidth = 0.5;
    drawManager.hollowCircleBorderWidth = 0.5;
    
    _lockView = [[TQGestureLockView alloc] initWithFrame:rect1 drawManager:drawManager];
    _lockView.delegate = self;
    [self.view addSubview:_lockView];
    
    _hintLabel = [[TQGestureLockHintLabel alloc] initWithFrame:rect2];
    [_hintLabel setNormalText:@"绘制解锁图案"];
    [self.view addSubview:_hintLabel];
    
    _preview = [[TQGestureLockPreview alloc] initWithFrame:CGRectIntegral(rect3)];
    [self.view addSubview:_preview];
    [_preview redraw];
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
    if (self.passwordManager.hasFirstPassword == NO) {
       
        [gestureLockView setNeedsDisplayGestureLockErrorState:NO];
        
        self.passwordManager.firstPassword = securityCodeSting;
       
        [_preview redrawWithVerifySecurityCodeString:securityCodeSting];
        
        [_hintLabel setNormalText:@"请再次绘制解锁图案"];
        
    } else {
        
        if ([self.passwordManager.firstPassword isEqualToString:securityCodeSting]) {
            
            [gestureLockView setNeedsDisplayGestureLockErrorState:NO];
          
            [_hintLabel clearText];
            
            [self.passwordManager saveEventuallyPassword:securityCodeSting];
            if (self.successblock) {
                self.successblock();
            }
            gestureLockView.userInteractionEnabled = NO;
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                // 第一次登录时候提醒设置手势密码
                if (_isFirstLogin) {
                    [IBProgressHUD showSuccessWithStatus:@"设置成功"];
                    JPTabBarController * tabVc = [[JPTabBarController alloc] init];
                    [self presentViewController:tabVc animated:YES completion:nil];
                } else {
                    // 是否是修改手势密码
                    if (_isModification) {
                        [IBProgressHUD showSuccessWithStatus:@"修改成功"];
                        NSArray * controllers = self.navigationController.viewControllers;
                        [self.navigationController popToViewController:controllers[2] animated:YES];
                    } else {
                        [IBProgressHUD showSuccessWithStatus:@"设置成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            }); } else {
                [gestureLockView setNeedsDisplayGestureLockErrorState:YES];
                
                [_hintLabel setWarningText:@"与上一次绘制不一致，请重新绘制" shakeAnimated:YES];
                
                [self setNavRightButtonItem];
            }
    }
}



@end
