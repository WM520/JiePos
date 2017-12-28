//
//  IBBaseInfoViewController.h
//  JiePos
//
//  Created by iBlocker on 2017/9/4.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPViewController.h"
//  商户入驻申请（基本信息）
@interface IBBaseInfoViewController : JPViewController
@property (nonatomic, strong) NSString *qrcodeid;
// 无码入驻时手机号
@property (nonatomic, copy) NSString * phoneNumber;
@end
