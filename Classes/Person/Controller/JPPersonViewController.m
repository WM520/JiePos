//
//  JPPersonViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPPersonViewController.h"
#import "JPCodeViewController.h"
#import "JPNoticeViewController.h"
#import "JPSettingViewController.h"
#import "JPCodeModel.h"
#import "JPMerchantStateViewController.h"
#import "JP_PersonHeaderView.h"
#import "JPContactViewController.h"
#import "JPShareViewController.h"
#import "JPNewsViewController.h"

#define imageName @"imageName"
#define configName @"configName"
static NSString *const headerReuseIdentifier = @"headerReuseIdentifier";

@interface JPPersonViewController ()
<UITableViewDataSource,
UITableViewDelegate,
JPNewsViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray <NSArray *>*dataSource;
@property (nonatomic, strong) UITableView *ctntView;
@property (nonatomic, strong) JPCodeModel *codeModel;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger badgeNumber;
@property (nonatomic, strong) UILabel * unreadLabel;

@end

@implementation JPPersonViewController

#pragma mark - View
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    JPNavigationController *newsNav = self.tabBarController.viewControllers[1];
//    NSString *badge = nil;
//    if ([JPPushHelper badgeNumber] > 0) {
//        badge = [NSString stringWithFormat:@"%ld", (long)[JPPushHelper badgeNumber]];
//    }
//    [newsNav.tabBarItem setBadgeValue:badge];
    if ([JPPushHelper badgeNumber] != _badgeNumber) {
        [self.ctntView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化数据
    [self configData];
    // 添加view
    [self.view addSubview:self.ctntView];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell-%ld-%ld", (long)indexPath.section, (long)indexPath.row]];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NSString stringWithFormat:@"cell-%ld-%ld", (long)indexPath.section, (long)indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = JP_DefaultsFont;
        cell.textLabel.textColor = JP_Content_Color;
    }
    NSDictionary *configDic = self.dataSource[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:configDic[imageName]];
    cell.textLabel.text = configDic[configName];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([cell.textLabel.text isEqualToString:@"消息中心"]) {
        if ([JPPushHelper badgeNumber] > 0) {
            if (!_unreadLabel) {
                UILabel * unreadLabel = [[UILabel alloc] init];
                unreadLabel.backgroundColor = [UIColor redColor];
                unreadLabel.text = [NSString stringWithFormat:@"%ld", [JPPushHelper badgeNumber]];
                unreadLabel.textAlignment = NSTextAlignmentCenter;
                unreadLabel.textColor = [UIColor whiteColor];
                unreadLabel.layer.masksToBounds = YES;
                unreadLabel.layer.cornerRadius = 13;
                [cell.contentView addSubview:unreadLabel];
                [unreadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.contentView);
                    make.right.equalTo(cell.contentView.mas_right).offset(-5);
                    make.height.equalTo(@25);
                    make.width.equalTo(@35);
                }];
                _unreadLabel = unreadLabel;
            } else {
                _unreadLabel.text = [NSString stringWithFormat:@"%ld", [JPPushHelper badgeNumber]];
            }
        } else {
            [_unreadLabel removeFromSuperview];
        }
    }
    return cell;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 防止重复点击
    if (self.selected == false) {
        
        self.selected = true;
        // 在延时方法中将isSelect更改为false
        [self performSelector:@selector(repeatDelay) withObject:nil afterDelay:0.5f];
        // 在下面实现点击cell需要实现的逻辑
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.textLabel.text isEqualToString:@"公告"]) {
            // 公告
            [MobClick event:@"person_notice"];
            JPNoticeViewController * noticeVC = [[JPNoticeViewController alloc] init];
            noticeVC.navigationItem.title = @"公告";
            noticeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:noticeVC animated:YES];
        } else if ([cell.textLabel.text isEqualToString:@"常见问题"]) {
            // 常见问题
            [MobClick event:@"person_questions"];
            JPWebViewController *webVC = [JPWebViewController new];
            webVC.urlString = jp_question_url;
            webVC.naviTitle = @"常见问题";
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
        } else if ([cell.textLabel.text isEqualToString:@"我的收款码"]) {
            // 我的收款码
            [MobClick event:@"person_qrcode"];
            JPCodeViewController *codeVC = [[JPCodeViewController alloc] init];
            codeVC.navigationItem.title = @"我的收款码";
            codeVC.hidesBottomBarWhenPushed = YES;
            weakSelf_declare;
            [IBProgressHUD loading];
            [IBHomeRequest getQrcodeWithAccount:[JPUserEntity sharedUserEntity].account merchantId:[JPUserEntity sharedUserEntity].merchantId callback:^(NSString *code, NSString *msg, id resp) {
                NSDictionary *obj = [IBAnalysis analysisWithEncryptString:resp privateKey:[JPUserEntity sharedUserEntity].privateKey];
                NSLog(@"obj - %@", obj);
                if (code.integerValue == 0) {
                    [IBProgressHUD dismiss];
                    [JP_UserDefults setObject:obj[@"merchantName"] forKey:@"merchantName"];
                    codeVC.codeModel = [JPCodeModel yy_modelWithDictionary:obj];
                    [weakSelf.navigationController pushViewController:codeVC animated:YES];
                } else {
                    [IBProgressHUD showInfoWithStatus:msg];
                }
            }];
        } else if ([cell.textLabel.text isEqualToString:@"商户自助查询"]) {
            // 商户自助查询
            //        JPMerchantsViewController *merchantVC = [[JPMerchantsViewController alloc] init];
            JPMerchantStateViewController *merchantVC = [[JPMerchantStateViewController alloc] init];
            merchantVC.hidesBottomBarWhenPushed = YES;
            [IBProgressHUD loading];
            weakSelf_declare;
            [IBPersonRequest getMerchantStateWithAccount:[JPUserEntity sharedUserEntity].account callback:^(NSString *code, NSString *msg, id resp) {
                
                NSDictionary *obj = [IBAnalysis analysisWithEncryptString:resp privateKey:[JPUserEntity sharedUserEntity].privateKey];
                if (code.integerValue == 0) {
                    [IBProgressHUD dismiss];
                    
                    [MobClick event:@"person_selfHelp"];
                    
                    JPStateQueryModel *queryModel = [JPStateQueryModel yy_modelWithDictionary:obj];
                    NSString *statusCode = queryModel.statusCode;
                    if ([statusCode isEqualToString:@"1"]) {
                        //  审核通过
                        merchantVC.applyProgress = JPApplyProgressThrough;
                    } else if ([statusCode isEqualToString:@"5"]) {
                        //  审核不通过
                        merchantVC.applyProgress = JPApplyProgressNotThrough;
                    } else {
                        //  审核中
                        merchantVC.applyProgress = JPApplyProgressApplying;
                    }
                    merchantVC.merchantsModel = queryModel;
                    [weakSelf.navigationController pushViewController:merchantVC animated:YES];
                } else {
                    [IBProgressHUD showInfoWithStatus:msg];
                }
            }];
        } else if ([cell.textLabel.text isEqualToString:@"设置"]) {
            // 设置
            [MobClick event:@"person_setting"];
            JPSettingViewController *settingVC = [[JPSettingViewController alloc] init];
            settingVC.navigationItem.title = @"设置";
            settingVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:settingVC animated:YES];
        } else if ([cell.textLabel.text isEqualToString:@"联系方式"]) {
            // 联系方式
            JPContactViewController *contactVC = [JPContactViewController new];
            contactVC.hidesBottomBarWhenPushed = YES;
            contactVC.canUseWeixin = [JPTool canOpenWeixin];
            [self.navigationController pushViewController:contactVC animated:YES];
        } else if ([cell.textLabel.text isEqualToString:@"推荐分享"]) {
            // 联系方式
            JPShareViewController * sharetVC = [JPShareViewController new];
            sharetVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sharetVC animated:YES];
        } else if ([cell.textLabel.text isEqualToString:@"消息中心"]) {
            // 联系方式
            JPNewsViewController * newsVC = [JPNewsViewController new];
            newsVC.delegate = self;
            newsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newsVC animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? JPRealValue(430) : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JP_PersonHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerReuseIdentifier];
    return section == 0 ? headerView : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return JPRealValue(20);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    footerView.backgroundColor = JP_viewBackgroundColor;
    return footerView;
}

#pragma mark - Method
- (void)configData {
    self.badgeNumber = [JPPushHelper badgeNumber];
    NSMutableArray *configs1 = @[].mutableCopy;
    [configs1 addObject:@{ imageName : @"jp_person_notice", configName : @"公告" }];
    [configs1 addObject:@{ imageName : @"jp_person_news", configName : @"消息中心" }];
    NSMutableArray *configs2 = @[].mutableCopy;
    [configs2 addObject:@{ imageName : @"jp_person_question", configName : @"常见问题" }];
    [configs2 addObject:@{ imageName : @"jp_person_serviceTel", configName : @"联系方式" }];
    if ([JPUserEntity sharedUserEntity].applyType == 2) {
        [self.dataSource addObject:@[@{ imageName : @"jp_person_codePay", configName : @"我的收款码" }]];
        [self.dataSource addObject:@[@{ imageName : @"jp_person_helper", configName : @"商户自助查询" }]];
    }
    [self.dataSource addObject:@[@{ imageName : @"jp_person_share", configName : @"推荐分享" }]];
    [self.dataSource addObject:configs1];
    [self.dataSource addObject:configs2];
    [self.dataSource addObject:@[@{ imageName : @"jp_person_setting", configName : @"设置" }]];
}

#pragma mark - JPNewsViewControllerDelegate
// 点击消息的回调
- (void)reload
{
    [self.ctntView reloadData];
}

#pragma mark - Lazy
- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight - 49} style:UITableViewStyleGrouped];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        _ctntView.contentInset = (UIEdgeInsets){-kStatusBarHeight, 0, 0, 0};
        _ctntView.backgroundColor = JP_viewBackgroundColor;
//        _ctntView.separatorColor = JP_LineColor;
        _ctntView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ctntView.estimatedSectionFooterHeight = 0;
        
        [_ctntView registerClass:[JP_PersonHeaderView class] forHeaderFooterViewReuseIdentifier:headerReuseIdentifier];
    }
    return _ctntView;
}

- (NSMutableArray <NSArray *>*)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

- (BOOL)navigationBarHidden {
    return YES;
}

- (void)repeatDelay {
    self.selected = false;
}

@end


