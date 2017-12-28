//
//  QRCodeScanningVC.m
//  SGQRCodeExample
//
//  Created by apple on 17/3/21.
//  Copyright © 2017年 JP_lee. All rights reserved.
//

#import "QRCodeScanningVC.h"
#import "IBBaseInfoViewController.h"

@interface QRCodeScanningVC ()

@end

@implementation QRCodeScanningVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 注册观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SGQRCodeInformationFromeAibum:) name:SGQRCodeInformationFromeAibum object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SGQRCodeInformationFromeScanning:) name:SGQRCodeInformationFromeScanning object:nil];
}

/** 从相册获取到图片的扫描 */
- (void)SGQRCodeInformationFromeAibum:(NSNotification *)noti {
    NSString *string = noti.object;

    if (![string containsString:@"jiepos"] || ![string isURLString]) {
        [SVProgressHUD showInfoWithStatus:@"无效的二维码！"];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSArray *arr = [string componentsSeparatedByString:@"="];
        NSString *qrcodeid = [arr lastObject];
        
        [SVProgressHUD showWithStatus:@"扫描结果识别中..."];
        weakSelf_declare;
        [IBPersonRequest scanQRCodeWithCodeID:qrcodeid callback:^(NSString *code, NSString *msg, id resp) {
            if (code.integerValue == 0) {
                [SVProgressHUD dismiss];
                if ([resp isKindOfClass:[NSDictionary class]]) {
                    JPQRCodeModel *model = [JPQRCodeModel yy_modelWithDictionary:resp];
                    if (model.isUsed) {
                        //  已使用
                        [SVProgressHUD showInfoWithStatus:model.reviewStatus];
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    } else {
                        //  未使用 空码
                        IBBaseInfoViewController *baseInfoVC = [IBBaseInfoViewController new];
                        baseInfoVC.qrcodeid = qrcodeid;
                        [weakSelf.navigationController pushViewController:baseInfoVC animated:YES];
                    }
                }
            } else {
                [SVProgressHUD showInfoWithStatus:msg];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
        
    }
}
/** 扫码获取到图片的扫描 */
- (void)SGQRCodeInformationFromeScanning:(NSNotification *)noti {
    NSString *string = noti.object;
    
    if (![string containsString:@"jiepos"] || ![string isURLString]) {
        [SVProgressHUD showInfoWithStatus:@"无效的二维码！"];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSArray *arr = [string componentsSeparatedByString:@"="];
        NSString *qrcodeid = [arr lastObject];
        
        [SVProgressHUD showWithStatus:@"扫描结果识别中..."];
        weakSelf_declare;
        [IBPersonRequest scanQRCodeWithCodeID:qrcodeid callback:^(NSString *code, NSString *msg, id resp) {
            if (code.integerValue == 0) {
                [SVProgressHUD dismiss];
                if ([resp isKindOfClass:[NSDictionary class]]) {
                    JPQRCodeModel *model = [JPQRCodeModel yy_modelWithDictionary:resp];
                    if (model.isUsed) {
                        //  已使用
                        [SVProgressHUD showInfoWithStatus:model.reviewStatus];
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    } else {
                        //  未使用 空码
                        IBBaseInfoViewController *baseInfoVC = [IBBaseInfoViewController new];
                        baseInfoVC.qrcodeid = qrcodeid;
                        baseInfoVC.phoneNumber = @"";
                        [weakSelf.navigationController pushViewController:baseInfoVC animated:YES];
                    }
                }
            } else {
                [SVProgressHUD showInfoWithStatus:msg];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (void)dealloc {
    JPLog(@"QRCodeScanningVC - dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
