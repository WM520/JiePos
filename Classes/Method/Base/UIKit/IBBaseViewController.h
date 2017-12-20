//
//  IBBaseViewController.h
//  JiePos
//
//  Created by iBlocker on 2017/9/21.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface IBBaseViewController : UIViewController <UIGestureRecognizerDelegate>
/**
 导航条
 */
@property (strong, nonatomic) UINavigationBar *navigationBar;

/**
 触发刷新的方法
 
 @param sender 进行刷新的header
 */
- (void)beginRefreshing:(nullable id)sender;

/**
 触发加载更多的方法
 
 @param sender 进行刷加载的footer
 */
- (void)beginLoadingMore:(nullable id)sender;


/**
 生命周期方法，覆盖需加super
 */
- (void)viewDidLoad NS_REQUIRES_SUPER;
- (void)viewWillAppear:(BOOL)animated NS_REQUIRES_SUPER;
- (void)viewWillDisappear:(BOOL)animated NS_REQUIRES_SUPER;
- (void)viewDidAppear:(BOOL)animated NS_REQUIRES_SUPER;
- (void)viewDidDisappear:(BOOL)animated NS_REQUIRES_SUPER;
- (void)viewWillLayoutSubviews NS_REQUIRES_SUPER;
- (void)viewDidLayoutSubviews NS_REQUIRES_SUPER;
- (void)willMoveToParentViewController:(nullable UIViewController *)parent NS_REQUIRES_SUPER;
- (void)didMoveToParentViewController:(nullable UIViewController *)parent NS_REQUIRES_SUPER;
@end

@interface JPNavigationBar : UINavigationBar

@end

NS_ASSUME_NONNULL_END
