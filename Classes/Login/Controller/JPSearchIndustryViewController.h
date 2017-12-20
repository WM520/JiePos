//
//  JPSearchIndustryViewController.h
//  JiePos
//
//  Created by Jason_LJ on 2017/6/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPViewController.h"
//  搜索子行业
@interface JPSearchIndustryViewController : JPViewController
//@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray    *dataSource;
@property (nonatomic, copy) void (^jp_returnSearchValue)(NSString *name);
@end
