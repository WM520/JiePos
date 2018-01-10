//
//  JPLaunchIntroView.m
//  JiePos
//
//  Created by Jason_LJ on 2017/7/14.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPLaunchIntroView.h"

static NSString * const kAppVersion = @"appVersion";
@interface JPLaunchIntroView () <UIScrollViewDelegate> {
    UIScrollView  * launchScrollView;
    UIPageControl * page;
}
@end
@implementation JPLaunchIntroView
NSArray * images;
CGRect enterBtnFrame;
static JPLaunchIntroView * launch = nil;

#pragma mark - 创建对象-->>带button
+ (instancetype)sharedWithImages:(NSArray *)imageNames buttonFrame:(CGRect)frame {
    images = imageNames;
    enterBtnFrame = frame;
    launch = [[JPLaunchIntroView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    launch.backgroundColor = [UIColor whiteColor];
    return launch;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if ([self isFirstLauch]) {
            UIWindow * window = [UIApplication sharedApplication].windows.lastObject;
            [window addSubview:self];
            [self addImages];
        } else {
            [self removeFromSuperview];
        }
    }
    return self;
}
#pragma mark - 判断是不是首次登录或者版本更新
- (BOOL)isFirstLauch {
    
    //获取当前版本号
    NSDictionary * infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString * currentAppVersion = infoDic[@"CFBundleShortVersionString"];
    //获取上次启动应用保存的appVersion
    NSString * version = [JP_UserDefults objectForKey:kAppVersion];
    //版本升级或首次登录
    if (version == nil || ![version isEqualToString:currentAppVersion]) {
        
        [UMessage removeAlias:[JPUserEntity sharedUserEntity].merchantNo type:JP_UMessageAliasType response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            if(responseObject) {
                JPLog(@"解绑成功！");
            } else {
                JPLog(@"解绑失败！ - %@", error.localizedDescription);
            }
            [[JPPushManager sharedManager] makeIsBindAlias:NO];
        }];

        [[JPUserEntity sharedUserEntity] setIsLogin:NO account:@"" merchantNo:nil merchantId:0 merchantName:@"" applyType:0 privateKey:@"" publicKey:@"" userId:@""];
                
        [JP_UserDefults removeObjectForKey:@"userLogin"];
        [JP_UserDefults removeObjectForKey:@"passLogin"];
        [JP_UserDefults setObject:currentAppVersion forKey:kAppVersion];
        [JP_UserDefults synchronize];
        return YES;
    } else {
        return NO;
    }
}
#pragma mark - 添加引导页图片
- (void)addImages {
    [self createScrollView];
}
#pragma mark - 创建滚动视图
- (void)createScrollView {
    if (!launchScrollView) {
        launchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        launchScrollView.showsHorizontalScrollIndicator = NO;
        launchScrollView.bounces = NO;
        launchScrollView.pagingEnabled = YES;
        launchScrollView.delegate = self;
        launchScrollView.contentSize = CGSizeMake(kScreenWidth * images.count, kScreenHeight);
        [self addSubview:launchScrollView];
    }
    
    if (!page) {
        page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenHeight - 60, kScreenWidth, 30)];
        page.numberOfPages = images.count;
        page.backgroundColor = [UIColor clearColor];
        page.currentPage = 0;
        page.defersCurrentPageDisplay = YES;
        //  通过KVC的方式修改pageControl的图片
        [page setValue:[UIImage imageNamed:@"jp_page_selected"] forKeyPath:@"_currentPageImage"];
        [page setValue:[UIImage imageNamed:@"jp_page_normal"] forKeyPath:@"_pageImage"];
        [self addSubview:page];
    }
    
    for (int i = 0; i < images.count; i ++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        imageView.image = [UIImage imageNamed:images[i]];
        [launchScrollView addSubview:imageView];
        if (i == images.count - 1) {
            //判断要不要添加button
            UIButton * enterButton = [[UIButton alloc] initWithFrame:CGRectMake(enterBtnFrame.origin.x, enterBtnFrame.origin.y, enterBtnFrame.size.width, enterBtnFrame.size.height)];
            enterButton.backgroundColor = [UIColor whiteColor];
            [enterButton setTitle:@"立即体验" forState:UIControlStateNormal];
            enterButton.titleLabel.font = JP_DefaultsFont;
            [enterButton setTitleColor:JP_Content_Color forState:UIControlStateNormal];
            [enterButton setImage:[UIImage imageNamed:@"guide_indicator"] forState:UIControlStateNormal];
            enterButton.imageEdgeInsets = UIEdgeInsetsMake(0, JPRealValue(160), 0, JPRealValue(-20));
            enterButton.titleEdgeInsets = UIEdgeInsetsMake(0, JPRealValue(-20), 0, JPRealValue(20));
            
            enterButton.layer.cornerRadius = enterBtnFrame.size.height / 2.0;
            enterButton.layer.masksToBounds = YES;
            enterButton.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
            enterButton.layer.borderWidth = 1;
            
            [enterButton addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:enterButton];
            imageView.userInteractionEnabled = YES;
        }
    }
}

#pragma mark - 进入按钮
- (void)enterBtnClick {
    [self hideGuidView];
}

#pragma mark - 隐藏引导页
- (void)hideGuidView {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    }];
}

#pragma mark - scrollView Delegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    //  滑到最后一页隐藏pageControl
    if (scrollView.contentOffset.x / kScreenWidth > images.count - 2) {
        page.hidden = YES;
    } else {
        page.hidden = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //  设置当前的pageControl
    page.currentPage = scrollView.contentOffset.x / kScreenWidth;
    //  滑到最后一页隐藏pageControl
    if (page.currentPage == images.count - 1) {
        page.hidden = YES;
    } else {
        page.hidden = NO;
    }
}

@end
