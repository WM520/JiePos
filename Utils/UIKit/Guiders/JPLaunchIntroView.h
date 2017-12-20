//
//  JPLaunchIntroView.h
//  JiePos
//
//  Created by Jason_LJ on 2017/7/14.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

//  引导页
@interface JPLaunchIntroView : UIView
/**
 *  带按钮的引导页
 *
 *  @param imageNames      背景图片数组
 *  @param frame           按钮的frame
 *
 *  @return LaunchIntroductionView对象
 */
+ (instancetype)sharedWithImages:(NSArray *)imageNames buttonFrame:(CGRect)frame;
@end
