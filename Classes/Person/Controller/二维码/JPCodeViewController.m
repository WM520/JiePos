//
//  JPCodeViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/18.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPCodeViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface JPCodeViewController ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *codeBgView;
@property (nonatomic, strong) UILabel *merchantsNameLab;
@property (nonatomic, strong) UIImageView *qrcodeView;
@property (nonatomic, strong) UILabel *supportLab;
@property (nonatomic, strong) UIImageView *aliView;
@property (nonatomic, strong) UIImageView *wechatView;
@property (nonatomic, strong) UIImageView *nodataView;
@property (nonatomic, strong) UIView *navImageView;
@end
@implementation JPCodeViewController

#pragma mark - lifestyle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    // 导航栏背景颜色
//    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
//    // 导航栏标题字体颜色
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    // 导航栏左右按钮字体颜色
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"7a93f5"].CGColor, (__bridge id)[UIColor colorWithHexString:@"68b2f2"].CGColor, (__bridge id)[UIColor colorWithHexString:@"51dbf0"].CGColor];
    gradientLayer.locations = @[@0, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    gradientLayer.frame = (CGRect){0, -kStatusBarHeight, kScreenWidth, kScreenHeight + kStatusBarHeight};
    [self.view.layer addSublayer:gradientLayer];
    
    [self layoutHomeView];
    [self handleUserInterface];
//    [self qrcodeViewWithUrlString:self.codeModel.url];
}
#pragma mark - Method
- (void)handleUserInterface {
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.logoView];
    [self.bgView addSubview:self.titleLab];
    [self.bgView addSubview:self.codeBgView];
    [self.bgView addSubview:self.merchantsNameLab];
    [self.bgView addSubview:self.qrcodeView];
    [self.bgView addSubview:self.supportLab];
    [self.bgView addSubview:self.aliView];
    [self.bgView addSubview:self.wechatView];
    [self.bgView addSubview:self.nodataView];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(-kStatusBarHeight, JPRealValue(30), JPRealValue(100), JPRealValue(30)));
        make.top.equalTo(weakSelf.view.mas_top).offset(JPRealValue(40) + 64);
        make.left.equalTo(weakSelf.view.mas_left).offset(JPRealValue(30));
        make.right.equalTo(weakSelf.view.mas_right).offset(JPRealValue(-30));
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(JPRealValue(-100));
    }];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.bgView.mas_top).offset(JPRealValue(45));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.logoView.mas_right).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.logoView.mas_centerY);
    }];
    [self.codeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgView.mas_top).offset(JPRealValue(90));
        make.left.and.right.equalTo(weakSelf.bgView);
        make.bottom.equalTo(weakSelf.bgView.mas_bottom).offset(JPRealValue(-286));
    }];
    [self.merchantsNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.codeBgView.mas_top);
        make.left.equalTo(weakSelf.logoView.mas_left);
        make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-20));
        make.height.equalTo(@(JPRealValue(130)));
    }];
    
    CGFloat width = kScreenWidth - JPRealValue(260);
    [self.qrcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.codeBgView.mas_centerX);
        make.top.equalTo(weakSelf.merchantsNameLab.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(width, width));
    }];
    [self.supportLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.codeBgView.mas_bottom).offset(JPRealValue(50));
        make.centerX.equalTo(weakSelf.codeBgView.mas_centerX);
    }];
    [self.aliView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.supportLab.mas_bottom).offset(JPRealValue(50));
        make.centerX.equalTo(weakSelf.codeBgView.mas_centerX).offset(JPRealValue(-102));
    }];
    [self.wechatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.aliView.mas_top);
        make.centerX.equalTo(weakSelf.codeBgView.mas_centerX).offset(JPRealValue(102));
    }];
    [self.nodataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(weakSelf.qrcodeView);
    }];
}
#pragma mark - Lazy
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = JP_viewBackgroundColor;
        _bgView.layer.cornerRadius = JPRealValue(10);
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}
- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [UIImageView new];
        _logoView.image = [UIImage imageNamed:@"jp_code_jbbLogo"];
    }
    return _logoView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.text = @"杰宝宝收款码";
        _titleLab.font = [UIFont systemFontOfSize:JPRealValue(30)];
        _titleLab.textColor = JP_Content_Color;
    }
    return _titleLab;
}
- (UIView *)codeBgView {
    if (!_codeBgView) {
        _codeBgView = [UIView new];
        _codeBgView.backgroundColor = [UIColor whiteColor];
    }
    return _codeBgView;
}
- (UILabel *)merchantsNameLab {
    if (!_merchantsNameLab) {
        _merchantsNameLab = [UILabel new];
        _merchantsNameLab.text = self.codeModel.merchantName;
        _merchantsNameLab.textColor = [UIColor colorWithHexString:@"608dff"];
        _merchantsNameLab.font = [UIFont systemFontOfSize:JPRealValue(40)];
        _merchantsNameLab.textAlignment = NSTextAlignmentCenter;
    }
    return _merchantsNameLab;
}
- (UIImageView *)qrcodeView {
    if (!_qrcodeView) {
        _qrcodeView = [UIImageView new];
    }
    return _qrcodeView;
}
- (UILabel *)supportLab {
    if (!_supportLab) {
        _supportLab = [UILabel new];
        _supportLab.text = @"使用支付宝微信扫一扫付款";
        _supportLab.font = [UIFont systemFontOfSize:JPRealValue(30)];
        _supportLab.textAlignment = NSTextAlignmentCenter;
        _supportLab.textColor = JP_Content_Color;
    }
    return _supportLab;
}
- (UIImageView *)aliView {
    if (!_aliView) {
        _aliView = [UIImageView new];
        _aliView.image = [UIImage imageNamed:@"ali"];
    }
    return _aliView;
}
- (UIImageView *)wechatView {
    if (!_wechatView) {
        _wechatView = [UIImageView new];
        _wechatView.image = [UIImage imageNamed:@"wechat"];
    }
    return _wechatView;
}
- (UIImageView *)nodataView {
    if (!_nodataView) {
        _nodataView = [UIImageView new];
        _nodataView.image = [UIImage imageNamed:@"jp_result_noPaymentCode"];
    }
    return _nodataView;
}
#pragma mark - Action
- (void)rightItemClicked:(UIBarButtonItem *)sender {
    
    [MobClick event:@"qrcode_save"];
    
    UIImage *image = [self makeImageWithView:self.bgView];
    [[JPAlbumManager sharedManager] saveImage:image toAlbum:@"杰宝宝收款码" completionHandler:^(UIImage *image, NSError *error) {
        if (!error) {
            [IBProgressHUD showSuccessWithStatus:@"保存成功！"];
        } else {
            [IBProgressHUD showInfoWithStatus:@"保存失败！"];
        }
    }];
}
//  二维码生成
- (void)qrcodeViewWithUrlString:(NSString *)urlString {
    self.nodataView.hidden = [urlString isURLString];
    
    //二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //恢复滤镜的默认属性
    [filter setDefaults];
    
    //将字符串转换成NSData
    NSData *data = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    //通过KVO设置滤镜inputmessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    //获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    //将CIImage转换成UIImage,并放大显示
    self.qrcodeView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:100.0*[UIScreen mainScreen].scale];
    
    //如果还想加上阴影，就在ImageView的Layer上使用下面代码添加阴影
    //    self.qrcodeView.layer.shadowOffset = CGSizeMake(0, 0.5);//设置阴影的偏移量
    //    self.qrcodeView.layer.shadowRadius = 1;//设置阴影的半径
    //    self.qrcodeView.layer.shadowColor = [UIColor blackColor].CGColor;//设置阴影的颜色为黑色
    //    self.qrcodeView.layer.shadowOpacity = 0.3;
}
//改变二维码大小
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}
#pragma mark - NavigationBar
- (void)layoutHomeView {
    _navImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _navImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navImageView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - 100, 20, 200, 44)];
    titleLab.text = @"我的收款码";
    titleLab.font = [UIFont systemFontOfSize:JPRealValue(34)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor whiteColor];
    [_navImageView addSubview:titleLab];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(10, 25, JPRealValue(60), JPRealValue(60));
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(JPRealValue(15), JPRealValue(15), JPRealValue(15), JPRealValue(15));
    [leftButton setImage:[[UIImage imageNamed:@"jp_goBack1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_navImageView addSubview:leftButton];
    
    if ([self.codeModel.url isURLString]) {
        
        [self qrcodeViewWithUrlString:self.codeModel.url];
        self.nodataView.hidden = YES;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(kScreenWidth - JPRealValue(120), 26, JPRealValue(90), JPRealValue(60));
        rightButton.titleLabel.font = [UIFont systemFontOfSize:JPRealValue(28)];
        [rightButton setTitle:@"保存" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_navImageView addSubview:rightButton];
        
    } else {
        self.nodataView.hidden = NO;
    }
}
//  把View写成图片
- (UIImage *)makeImageWithView:(UIView *)view {
    
    //    CGRect rect = view.frame;
    //    JPLog(@"%@", NSStringFromCGRect(rect));
    //
    //    CGSize size = view.frame.size;
    //    JPLog(@"%@", NSStringFromCGSize(size));
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    
    CGSize size = (CGSize){kScreenWidth - JPRealValue(60), kScreenHeight - JPRealValue(140)};
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Action
- (void)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (BOOL)navigationBarHidden {
//    return YES;
//}

@end

