//
//  IBPayPassView.h
//  JiePos
//
//  Created by iBlocker on 2017/8/17.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IBPayPassView;
@protocol IBPayPassViewDelegate <NSObject>
@optional
/** 监听输入的变化 */
- (void)passwordDidChange:(IBPayPassView *)password;
/** 监听开始输入 */
- (void)passwordBeginInput:(IBPayPassView *)password;
/** 监听输入完成时 */
- (void)passwordCompleteInput:(IBPayPassView *)password;
@end

@interface IBPayPassView : UIView
/** 密码的位数*/
@property (assign, nonatomic) IBInspectable NSUInteger digitsNumber;
/** 正方形大小*/
@property (assign, nonatomic) IBInspectable CGFloat squareSize;
/** 黑点半径*/
@property (assign, nonatomic) IBInspectable CGFloat pointRadius;
/** 黑点的颜色*/
@property (strong, nonatomic) IBInspectable UIColor * pointColor;
/** 边框的颜色*/
@property (strong, nonatomic) IBInspectable UIColor * rectColor;
/** 保存密码的字符串*/
@property (strong, nonatomic) NSMutableString * saveStore;
/** 代理*/
@property (weak, nonatomic) id<IBPayPassViewDelegate> delegate;
//  清空输入框
- (void)deleteAll;
@end
