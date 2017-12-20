//
//  UIColor+JPFormHex.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (JPFormHex)
///颜色转换 十六进制的颜色转换为UIColor
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
//  颜色转化为RGB值
+ (NSArray *)getRGBWithColor:(UIColor *)color;
@end
