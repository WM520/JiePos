//
//  JPCashFinishViewController.h
//  JiePos
//
//  Created by iBlocker on 2017/8/21.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPViewController.h"

typedef NS_ENUM(NSUInteger, JPFinishState) {
    JPFinishStateAppling = 0,
    JPFinishStateSuccess,
    JPFinishStateFailed,
};
@interface JPCashFinishViewController : JPViewController
@property (nonatomic, assign) JPFinishState state;
@end
