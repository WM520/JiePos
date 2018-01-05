//
//  JPShareViewController.m
//  JiePos
//
//  Created by wangmiao on 2017/12/18.
//  Copyright © 2017年 WangMiao. All rights reserved.
//

#import "JPShareViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "ActionSheetView.h"

@interface JPShareViewController ()
{
    BOOL _isShare;
}
@property (nonatomic, strong) UIImageView * backgroundImageView;

@end

@implementation JPShareViewController

#pragma mark - liftstyle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init
- (void)configUI
{
    weakSelf_declare;
    self.title = @"推荐分享";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"jp_news_allread"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    _backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView.image = [UIImage imageNamed:@"shareBG"];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_backgroundImageView];
    
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - Methods
- (void)rightClick:(UIBarButtonItem *)rightItem
{
    NSArray *titlearr = @[@"微信朋友圈", @"微信好友",@"QQ好友", @"QQ空间"];
    NSArray *imageArr = @[@"wechatquan", @"wechat", @"link",@"kongjian"];
    ActionSheetView *actionsheet = [[ActionSheetView alloc] initWithShareHeadOprationWith:titlearr andImageArry:imageArr andProTitle:@"测试" and:ShowTypeIsShareStyle];
    [actionsheet setBtnClick:^(NSInteger btnTag) {
        NSArray *imageArray = @[[UIImage imageNamed:@"shareBG"]];
        if (btnTag == 0) {
            
            if (imageArray) {
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                //通用参数设置
                [parameters SSDKSetupShareParamsByText:@"杰宝宝"
                                                images:imageArray
                                                   url:[NSURL URLWithString:@"http://wx.jiepos.com/jpay-spmp/jbbDownload.html"]
                                                 title:@"杰宝宝App"
                                                  type:SSDKContentTypeImage];
                [self shareWithParameters:parameters platformType:SSDKPlatformSubTypeWechatTimeline];
            }
        } else if (btnTag == 1) {
            if (imageArray) {
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                //通用参数设置
                [parameters SSDKSetupShareParamsByText:@"杰宝宝"
                                                images:imageArray
                                                   url:[NSURL URLWithString:@"http://wx.jiepos.com/jpay-spmp/jbbDownload.html"]
                                                 title:@"杰宝宝App"
                                                  type:SSDKContentTypeImage];
                [self shareWithParameters:parameters platformType:SSDKPlatformSubTypeWechatSession];
            }
        } else if (btnTag == 2) {
            if (imageArray) {
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                //通用参数设置
                [parameters SSDKSetupShareParamsByText:@"杰宝宝"
                                                images:imageArray
                                                   url:[NSURL URLWithString:@"http://wx.jiepos.com/jpay-spmp/jbbDownload.html"]
                                                 title:@"杰宝宝App"
                                                  type:SSDKContentTypeImage];
                [self shareWithParameters:parameters platformType:SSDKPlatformSubTypeQQFriend];
            }
        } else if (btnTag == 3) {
            if (imageArray) {
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                //通用参数设置
                [parameters SSDKSetupShareParamsByText:@"杰宝宝"
                                                images:imageArray
                                                   url:[NSURL URLWithString:@"http://wx.jiepos.com/jpay-spmp/jbbDownload.html"]
                                                 title:@"杰宝宝App"
                                                  type:SSDKContentTypeImage];
                [self shareWithParameters:parameters platformType:SSDKPlatformSubTypeQZone];
            }
        }
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:actionsheet];
}

- (void)shareWithParameters:(NSMutableDictionary *)parameters platformType:(SSDKPlatformType) platformType
{
    if (_isShare) {
        return;
    }
    _isShare = YES;
    if(parameters.count == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"请先设置分享参数"
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    [ShareSDK share:platformType
         parameters:parameters
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         if(state == SSDKResponseStateBeginUPLoad){
             return ;
         }
         NSString *titel = @"";
         NSString *typeStr = @"";
         UIColor *typeColor = [UIColor grayColor];
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 NSLog(@"分享成功");
                 _isShare = NO;
                 titel = @"分享成功";
                 typeStr = @"成功";
                 typeColor = [UIColor blueColor];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 _isShare = NO;
                 NSLog(@"error :%@",error);
                 titel = @"分享失败";
                 typeStr = [NSString stringWithFormat:@"%@",error];
                 typeColor = [UIColor redColor];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 _isShare = NO;
                 titel = @"分享已取消";
                 typeStr = @"取消";
                 break;
             }
             default:
                 break;
         }
        
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titel
                                                             message:typeStr
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
         [alertView show];
     }];
}

@end
