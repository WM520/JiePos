//
//  JPMerchantStateViewController.h
//  JiePos
//
//  Created by iBlocker on 2017/8/21.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPViewController.h"

@interface JPMerchantStateViewController : JPViewController
/** 申请进度*/
@property (nonatomic, assign) JPApplyProgress applyProgress;
@property (nonatomic, strong) JPStateQueryModel *merchantsModel;
@end
