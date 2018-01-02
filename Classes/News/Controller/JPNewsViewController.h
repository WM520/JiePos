//
//  JPNewsViewController.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPViewController.h"
@protocol JPNewsViewControllerDelegate

- (void)reload;

@end

//  消息
@interface JPNewsViewController : JPViewController

@property (nonatomic, weak) id<JPNewsViewControllerDelegate> delegate;

@end
