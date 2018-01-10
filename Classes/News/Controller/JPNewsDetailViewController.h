//
//  JPNewsDetailViewController.h
//  JiePos
//
//  Created by Jason_LJ on 2017/7/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPViewController.h"
#import "JPNewsModel.h"

@interface JPNewsDetailViewController : JPViewController

@property (nonatomic, strong) JPNewsModel *newsModel;
@property (nonatomic, strong) NSString *businessName;

@end
