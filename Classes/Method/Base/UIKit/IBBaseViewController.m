//
//  IBBaseViewController.m
//  JiePos
//
//  Created by iBlocker on 2017/9/21.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "IBBaseViewController.h"

void *KVOContext;
@interface IBBaseViewController ()
- (void)adjustScrollViewInsets;
@end

@implementation IBBaseViewController

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    //    [MobClick beginLogPageView:NSStringFromClass(self.class)];
    
    //    [DebugToolManager share].currVC = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    [MobClick endLogPageView:NSStringFromClass(self.class)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if ([self.parentViewController isKindOfClass:UINavigationController.class]) {
        self.navigationBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64);
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.navigationBar setNeedsDisplay];
    [self.navigationBar setNeedsLayout];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    if (![parent isKindOfClass:[UINavigationController class]]) {
        return;
    }
    self.navigationController.navigationBarHidden = YES;
    self.navigationBar.items = @[self.navigationItem];
    if (self.navigationController.viewControllers.firstObject != self) {
        self.hidesBottomBarWhenPushed = YES;
        if (self.navigationItem.leftBarButtonItems.count == 0) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
        }
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == KVOContext) {
        if (!CGRectEqualToRect([change[NSKeyValueChangeOldKey] CGRectValue], [change[NSKeyValueChangeNewKey] CGRectValue])) {
            [self adjustScrollViewInsets];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    NSLog(@"-[%@ %s]", self.class, sel_getName(_cmd));
    [self.navigationBar removeObserver:self forKeyPath:@"frame"];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        return self.navigationController.viewControllers.firstObject != self;
    }
    return YES;
}

#pragma mark - 抽象方法
- (void)beginRefreshing:(id)sender {}
- (void)beginLoadingMore:(id)sender {}

#pragma mark - 私有方法
- (void)adjustScrollViewInsets {
    __block UIScrollView *scrollView = nil;
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:UIScrollView.class]) {
            scrollView = (UIScrollView *)obj;
            if (CGRectIntersectsRect(obj.frame, self.navigationBar.frame)) {
                scrollView.contentInsetTop = (!self.automaticallyAdjustsScrollViewInsets || self.navigationBar.hidden) ? 0 : CGRectIntersection(scrollView.frame, self.navigationBar.frame).size.height;
                scrollView.contentOffsetY = -scrollView.contentInsetTop;
            } else {
                scrollView.contentInsetTop = 0;
                scrollView.contentOffsetY = 0;
            }
        }
    }];
}

- (UINavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[UINavigationBar alloc] init];
        _navigationBar.topItem.title = self.title;
        _navigationBar.tintColor = UIColor.whiteColor;
        _navigationBar.barTintColor = [UIColor greenColor];//GPColorRGB(59, 59, 59);
        _navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: [UIFont systemFontOfSize:17]};
        _navigationBar.translucent = NO; // 关闭默认透明度效果
        [_navigationBar addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:KVOContext];
    }
    return _navigationBar;
}

@end

@implementation JPNavigationBar

- (void)layoutSubviews {
    [super layoutSubviews];
    if (@available(iOS 11.0, *)) {
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                obj.height = self.height;
            } else if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")]) {
                if (CGRectIntersectsRect([self convertRect:obj.frame toView:self.window], UIApplication.sharedApplication.statusBarFrame)) {
                    obj.top = CGRectGetMaxY(UIApplication.sharedApplication.statusBarFrame);
                    obj.height = self.height - CGRectGetMaxY(UIApplication.sharedApplication.statusBarFrame);
                } else {
                    obj.centerY = self.middleY;
                    [self setTitleVerticalPositionAdjustment:2 forBarMetrics:UIBarMetricsDefault];
                }
            }
        }];
    }
}

@end
