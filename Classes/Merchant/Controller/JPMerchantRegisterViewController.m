//
//  JPMerchantRegisterViewController.m
//  JiePos
//
//  Created by wangmiao on 2017/12/1.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPMerchantRegisterViewController.h"
#import "JPCustomButton.h"
#import "QRCodeScanningVC.h"
#import "JPPhoneRegisterViewController.h"

@interface JPMerchantRegisterViewController ()
<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView * navImageView;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIView * alphaView;
@property (nonatomic, strong) UIButton * leftBtn;
@end

@implementation JPMerchantRegisterViewController

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
    weakSelf_declare;;
    self.view.backgroundColor = JP_viewBackgroundColor;
    _navImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    _navImageView.image = [UIImage imageNamed:@"jp_news_deatailBg"];
    _navImageView.alpha = 1;
    [self.view insertSubview:_navImageView atIndex:1];
    _leftBtn = [[UIButton alloc] init];
    _leftBtn.frame = CGRectMake(10, 25, JPRealValue(60), JPRealValue(60));
    _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(JPRealValue(15), JPRealValue(15), JPRealValue(15), JPRealValue(15));
    [_leftBtn setImage:[[UIImage imageNamed:@"jp_goBack1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftBtn];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - 100, 20, 200, 44)];
    titleLab.text = @"商户入驻";
    titleLab.font = [UIFont systemFontOfSize:JPRealValue(34)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLab];
    
//    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(20, 120, kScreenWidth - 40, JPRealValue(400))];
    UIView * contentView = [[UIView alloc] init];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.top.equalTo(weakSelf.view.mas_top).offset(100);
        make.height.equalTo(@450);
    }];
    
    UIImageView * backBigImage = [[UIImageView alloc] init];
    backBigImage.image = [UIImage imageNamed:@"jp_merchant_bg"];
    [contentView addSubview:backBigImage];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"一码付商户";
    titleLabel.textColor = RGB(122, 147, 245);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:25 weight:400];
    
    [contentView addSubview:titleLabel];
    
    UILabel * desLabel = [[UILabel alloc] init];
    desLabel.text = @"请选择入驻类型";
    desLabel.textColor = RGB(85, 85, 85);
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.font = [UIFont systemFontOfSize:18 weight:300];
    [contentView addSubview:desLabel];
    
    JPCustomButton * haveRegistrationCode = [[JPCustomButton alloc] initWithIconView:@"jp_merchant_zhucema" textString:@"有注册收款码" indicatorView:@"jp_merchant_jiantou"];
    haveRegistrationCode.actionBlock = ^{
        if ([JPUserInfoHelper dataSource].count > 0) {
            [JPUserInfoHelper clearData];
        }
        
        //  跳到二维码扫描界面
        // 1、 获取摄像设备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (device) {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (status == AVAuthorizationStatusNotDetermined) {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MobClick event:@"login_register"];
                            QRCodeScanningVC *vc = [[QRCodeScanningVC alloc] init];
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        });
                        JPLog(@"用户第一次同意了访问相机权限");
                        
                    } else {
                        
                        // 用户第一次拒绝了访问相机权限
                        JPLog(@"用户第一次拒绝了访问相机权限");
                        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您已关闭相机使用权限，请前往 -> [设置 - 杰宝宝] 打开开关" preferredStyle:(UIAlertControllerStyleAlert)];
                        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
                        [alertC addAction:alertA];
                        [weakSelf presentViewController:alertC animated:YES completion:nil];
                    }
                }];
            } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
                [MobClick event:@"login_register"];
                QRCodeScanningVC *vc = [[QRCodeScanningVC alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您已关闭相机使用权限，请前往 -> [设置 - 隐私 - 相机 - 杰宝宝] 打开开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
                [alertC addAction:alertA];
                [weakSelf presentViewController:alertC animated:YES completion:nil];
                
            } else if (status == AVAuthorizationStatusRestricted) {
                JPLog(@"因为系统原因, 无法访问相册");
            }
        } else {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
            
            [alertC addAction:alertA];
            [weakSelf presentViewController:alertC animated:YES completion:nil];
        }
    };
    [contentView addSubview:haveRegistrationCode];
    
    JPCustomButton * noHaveRegistrationCode = [[JPCustomButton alloc] initWithIconView:@"jp_merchant_wuzhucema" textString:@"无注册收款码 " indicatorView:@"jp_merchant_jiantou"];
    noHaveRegistrationCode.actionBlock = ^{
        JPPhoneRegisterViewController * vc = [[JPPhoneRegisterViewController alloc] init];
        vc.title = @"商户入驻";
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [contentView addSubview:noHaveRegistrationCode];
    
    [backBigImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).offset(50);
        make.centerX.equalTo(contentView);
        make.width.equalTo(@200);
        make.height.equalTo(@50);
    }];
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(0);
        make.centerX.equalTo(contentView);
        make.width.equalTo(@200);
        make.height.equalTo(@40);
    }];
    
    [haveRegistrationCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLabel.mas_bottom).offset(40);
        make.centerX.equalTo(contentView);
        make.left.equalTo(contentView.mas_left).offset(40);
        make.right.equalTo(contentView.mas_right).offset(-40);
        make.height.equalTo(@60);
    }];
    
    [noHaveRegistrationCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(haveRegistrationCode.mas_bottom).offset(40);
        make.centerX.equalTo(contentView);
        make.left.equalTo(contentView.mas_left).offset(40);
        make.right.equalTo(contentView.mas_right).offset(-40);
        make.height.equalTo(@60);
    }];
    
    [haveRegistrationCode setNeedsDisplay];
    [noHaveRegistrationCode setNeedsDisplay];
    
}

//设置图片透明度

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image

{
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    
    
    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    
    
    CGContextSetAlpha(ctx, alpha);
    
    
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    UIGraphicsEndImageContext();
    
    
    
    return newImage;
    
}

- (BOOL)navigationBarHidden
{
    return YES;
}

- (void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight - 49}];
        _scrollView.contentInset = UIEdgeInsetsMake(-kStatusBarHeight, 0, 0, 0);
        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
        _scrollView.delegate = self;
        [_scrollView sizeToFit];
    }
    return _scrollView;
}

@end
