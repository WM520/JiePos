//
//  JPDealMoneyView.h
//  JiePos
//
//  Created by iBlocker on 2017/8/14.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPDealMoneyView : UIView
@property (nonatomic, copy) NSString *money;
/**
 首页交易金额展示

 @param frame 尺寸
 @param image 图片
 @param title 标题
 @return JPDealMoneyView
 */
- (instancetype)initWithFrame:(CGRect)frame
                        image:(UIImage *)image
                        title:(NSString *)title;
@end
