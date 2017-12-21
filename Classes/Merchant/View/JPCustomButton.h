//
//  JPCustomButton.h
//  JiePos
//
//  Created by wangmiao on 2017/12/21.
//  Copyright © 2017年 WangMiao. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ActionBlock)();
@interface JPCustomButton : UIView
- (instancetype)initWithIconView:(NSString *)iconView
                      textString:(NSString *)textString
                   indicatorView:(NSString *)indicatorView;

@property (nonatomic, copy) ActionBlock actionBlock;
@end
