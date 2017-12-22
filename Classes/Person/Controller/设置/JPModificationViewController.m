//
//  JPModificationViewController.m
//  JiePos
//
//  Created by wangmiao on 2017/12/22.
//  Copyright © 2017年 WangMiao. All rights reserved.
//

#import "JPModificationViewController.h"
#import "TQGestureLockView.h"
#import "TQGestureLockPreview.h"
#import "TQGesturesPasswordManager.h"
#import "TQGestureLockHintLabel.h"
#import "TQGestureLockToast.h"
#import "TQViewController1.h"

@interface JPModificationViewController () <TQGestureLockViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *rightButtonItem;
@property (nonatomic, strong) TQGestureLockView *lockView;
@property (nonatomic, strong) TQGestureLockPreview *preview;
@property (nonatomic, strong) TQGestureLockHintLabel *hintLabel;
@property (nonatomic, strong) TQGesturesPasswordManager *passwordManager;
@property (nonatomic, strong) UIButton * repeatSettings;
@property (nonatomic, assign) NSInteger count;
@end

@implementation JPModificationViewController

- (UIBarButtonItem *)rightButtonItem
{
    if (!_rightButtonItem) {
        _rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClicked)];
    }
    return _rightButtonItem;
}

- (void)setNavRightButtonItem {
    if (!self.repeatSettings) {
        weakSelf_declare;
        _repeatSettings = [[UIButton alloc] init];
        [_repeatSettings setTitle:@"重新设置" forState:UIControlStateNormal];
        [_repeatSettings setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_repeatSettings addTarget:self action:@selector(rightBarItemClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_repeatSettings];
        [_repeatSettings mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view);
            make.right.equalTo(weakSelf.view);
            make.height.equalTo(@30);
            make.bottom.equalTo(weakSelf.view).offset(JPRealValue(-50));
        }];
    }
}

- (void)rightBarItemClicked {
    _hintLabel.textColor = [UIColor grayColor];
    _hintLabel.text = @"绘制解锁图案";
    [_preview redraw];
    self.passwordManager.firstPassword = nil;
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGFloat spacing = TQSizeFitW(40);
    CGFloat diameter = (screenSize.width - spacing * 4) / 3;
    CGFloat bottom1 = JPRealValue(55);
    CGFloat width1 = kScreenWidth;
    CGFloat top1 = kScreenHeight - width1 - bottom1 - 150;
    CGRect rect1 = CGRectMake(0, top1, width1, width1);
    
    CGFloat width2 = screenSize.width, height2 = 30;
    CGFloat top2 = top1 + spacing - height2 - 15;
    CGRect rect2 = CGRectMake(0, top2, width2, height2);
    
    CGFloat width3 = 70;
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
    
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:rect3];
    imageview.image = [UIImage imageNamed:@"js_person_logo"];
    [self.view addSubview:imageview];
    
    _hintLabel = [[TQGestureLockHintLabel alloc] initWithFrame:rect2];
    [_hintLabel setNormalText:@"绘制原密码解锁图案"];
    [self.view addSubview:_hintLabel];
    
//    _preview = [[TQGestureLockPreview alloc] initWithFrame:CGRectIntegral(rect3)];
//    [self.view addSubview:_preview];
//    [_preview redraw];
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
    if ([oldCodeString isEqualToString:securityCodeSting]) {
            gestureLockView.userInteractionEnabled = NO;
//            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:TQGesturesPasswordStorageKey];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                TQViewController1 * vc = [[TQViewController1 alloc] init];
                vc.isModification = YES;
                vc.title = @"手势密码设置";
                [weakSelf.navigationController pushViewController:vc animated:YES];
            });
            
    } else {
        [gestureLockView setNeedsDisplayGestureLockErrorState:YES];
        self.count--;
        [_hintLabel setWarningText:[NSString stringWithFormat:@"密码错误，您还可以输入%ld次", self.count] shakeAnimated:YES];
    }
}

@end

