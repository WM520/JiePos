//
//  IBPopView.h
//  JiePos
//
//  Created by iBlocker on 2017/9/6.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBPopView : UIViewController
@property (nonatomic, copy) void (^ib_clickBlock)(NSInteger index);
@end
