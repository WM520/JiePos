//
//  JPSettingViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/18.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPSettingViewController.h"
#import "JPAlertPswViewController.h"
#import "JPModifyPayPassViewController.h"
#import "JPNotiSettingViewController.h"
#import "JPAboutUsViewController.h"
#import "XBSettingItemModel.h"
#import "XBSettingSectionModel.h"
#import "XBSettingCell.h"
#import "JPBindingPhoneNumberViewController.h"
#import "JPManageGesticulationViewController.h"

static NSString *settingCellReuseIdentifier = @"settingCell";

@interface JPSettingViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *ctntView;
@property (nonatomic, strong) NSArray <NSArray *>* configArray;
@property (nonatomic, strong) NSMutableArray * dataSource;
@end

@implementation JPSettingViewController

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化数据源
    [self configData];
    // 初始化UI
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods
// 初始化UI
- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.ctntView];
}
// 初始化数据源
- (void)configData
{
    XBSettingItemModel *item1 = [[XBSettingItemModel alloc]init];
    item1.funcName = @"手机号";
    item1.executeCode = ^{
        JPBindingPhoneNumberViewController * bingingVC = [[JPBindingPhoneNumberViewController alloc] init];
        [self.navigationController pushViewController:bingingVC animated:YES];
    };
    item1.img = [UIImage imageNamed:@"jp_person_phone"];
    item1.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item1.detailText = @"13888888888";
    
    XBSettingSectionModel *section1 = [[XBSettingSectionModel alloc]init];
    section1.sectionHeaderHeight = 18;
    section1.itemArray = @[item1];
    
    XBSettingItemModel *item2 = [[XBSettingItemModel alloc]init];
    item2.funcName = @"登录密码修改";
    item2.img = [UIImage imageNamed:@"jp_person_set_psw"];
    item2.executeCode = ^{
        //  登录密码修改
        [MobClick event:@"setting_modifyPass"];
        //  登录密码修改
        JPAlertPswViewController *alertPswVC = [[JPAlertPswViewController alloc] init];
        alertPswVC.navigationItem.title = @"登录密码修改";
        [self.navigationController pushViewController:alertPswVC animated:YES];
    };
    item2.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingItemModel *item3 = [[XBSettingItemModel alloc]init];
    item3.funcName = @"手势登录管理";
    item3.img = [UIImage imageNamed:@"jp_person_shoushi_password"];
    item3.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item3.executeCode = ^() {
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://10010"]];
        JPManageGesticulationViewController * vc = [[JPManageGesticulationViewController alloc] init];
        vc.title = @"手势密码设置";
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    XBSettingItemModel *item4 = [[XBSettingItemModel alloc]init];
    item4.funcName = @"交易记录通知设置";
    item4.img = [UIImage imageNamed:@"jp_person_news"];
    item4.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item4.executeCode = ^{
        //  交易消息通知设置
        [MobClick event:@"setting_notiSetting"];
        //  交易消息通知设置
        JPNotiSettingViewController *notiSettingVC = [[JPNotiSettingViewController alloc] init];
        notiSettingVC.navigationItem.title = @"交易消息通知设置";
        [self.navigationController pushViewController:notiSettingVC animated:YES];
    };
    
    XBSettingSectionModel *section2 = [[XBSettingSectionModel alloc]init];
    section2.sectionHeaderHeight = 18;
    section2.itemArray = @[item2, item3, item4];
    
    XBSettingItemModel *item5 = [[XBSettingItemModel alloc]init];
    item5.funcName = @"关于杰宝宝";
    item5.img = [UIImage imageNamed:@"jp_person_set_aboutUs"];
    item5.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item5.executeCode = ^{
        //  关于杰宝宝
        [MobClick event:@"setting_aboutUs"];
        //  关于我们
        JPAboutUsViewController *aboutUsVC = [[JPAboutUsViewController alloc] init];
        aboutUsVC.navigationItem.title = @"关于杰宝宝";
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    };
    
    XBSettingSectionModel *section3 = [[XBSettingSectionModel alloc]init];
    section3.sectionHeaderHeight = 18;
    section3.itemArray = @[item5];
    
    self.dataSource = [NSMutableArray array];
    [self.dataSource addObject:section1];
    [self.dataSource addObject:section2];
    [self.dataSource addObject:section3];
}

#pragma mark - tableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    XBSettingSectionModel *sectionModel = self.dataSource[section];
    return sectionModel.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XBSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellReuseIdentifier];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.height = JPRealValue(80);
    XBSettingSectionModel *sectionModel = self.dataSource[indexPath.section];
    XBSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if (!cell) {
        cell = [[XBSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:settingCellReuseIdentifier];
    }
    cell.item = itemModel;
    return cell;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if ([cell.textLabel.text isEqualToString:@"登录密码修改"]) {
//
//    } else if ([cell.textLabel.text isEqualToString:@"提现密码修改"]) {
//        //  提现密码修改
//
//        JPModifyPayPassViewController *modifyVC = [JPModifyPayPassViewController new];
//        [self.navigationController pushViewController:modifyVC animated:YES];
//    } else if ([cell.textLabel.text isEqualToString:@"交易消息通知设置"]) {
//
//    } else if ([cell.textLabel.text isEqualToString:@"关于杰宝宝"]) {
//
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XBSettingSectionModel *sectionModel = self.dataSource[indexPath.section];
    XBSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if (itemModel.executeCode) {
        itemModel.executeCode();
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JPRealValue(80);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 2 ? 100 : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    footerView.backgroundColor = JP_viewBackgroundColor;
    
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.titleLabel.font = JP_DefaultsFont;
    [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutButton setTitleColor:JP_Content_Color forState:UIControlStateNormal];
    logoutButton.layer.cornerRadius = JPRealValue(10);
    logoutButton.layer.masksToBounds = YES;
    logoutButton.layer.borderColor = JP_LineColor.CGColor;
    logoutButton.layer.borderWidth = 1;
    [logoutButton setBackgroundColor:JP_viewBackgroundColor];
    [logoutButton addTarget:self action:@selector(logoutClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:logoutButton];
    
    [logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top).offset(JPRealValue(50));
        make.left.equalTo(footerView.mas_left).offset(JPRealValue(50));
        make.right.equalTo(footerView.mas_right).offset(JPRealValue(-50));
        make.height.equalTo(@(JPRealValue(90)));
    }];
    
    return section == 2 ? footerView : nil;
}

#pragma mark - action
- (void)logoutClick:(UIButton *)sender {
    weakSelf_declare;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"退出登录将删除本地推送消息记录，是否退出？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //  确认退出
        JPLog(@"退出登录按钮点击了");
        
        [MobClick event:@"setting_logout"];
        
        if ([JPUserEntity sharedUserEntity].isLogin) {
            
            if ([JPUserEntity sharedUserEntity].merchantNo) {
                NSMutableDictionary *params = @{}.mutableCopy;
                [params setObject:[JPUserEntity sharedUserEntity].merchantNo forKey:@"alias"];
                if ([JP_UserDefults objectForKey:@"deviceToken"]) {
                    [params setObject:[JP_UserDefults objectForKey:@"deviceToken"] forKey:@"deviceTokens"];
                }
                
                //  appType 1：安卓飞燕，2：安卓杰宝宝，3：iOS杰宝宝，4：iOS飞燕
                [params setObject:@"3" forKey:@"appType"];
                
                //获取当前版本号
                NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
                NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
                [params setObject:currentAppVersion forKey:@"versionNo"];
                
                [JPNetworking postUrl:jp_UMessage_logout_url params:params progress:nil callback:^(id resp) {
                    JPLog(@"resp - %@", resp);
                 }];
            }
            
            [UMessage removeAlias:[JPUserEntity sharedUserEntity].merchantNo type:JP_UMessageAliasType response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                if(responseObject) {
                    JPLog(@"解绑成功！");
                } else {
                    JPLog(@"解绑失败！ - %@", error.localizedDescription);
                }
                [[JPPushManager sharedManager] makeIsBindAlias:NO];
            }];
            
            [[JPUserEntity sharedUserEntity] setIsLogin:NO account:@"" merchantNo:nil merchantId:0 merchantName:@"" applyType:0 privateKey:@"" publicKey:@""];
                        
//            [JP_UserDefults removeObjectForKey:@"userLogin"];
            [JP_UserDefults removeObjectForKey:@"passLogin"];
//            [JP_UserDefults removeObjectForKey:@"deviceToken"];
            
            //  首页跑马灯
            [JP_UserDefults removeObjectForKey:@"isRolling"];
            [JP_UserDefults removeObjectForKey:@"roll"];
            [JP_UserDefults synchronize];
            
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}



- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        _ctntView.backgroundColor = JP_viewBackgroundColor;
        _ctntView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        _ctntView.separatorColor = JP_LineColor;
        _ctntView.estimatedSectionHeaderHeight = JPRealValue(12);
        _ctntView.estimatedRowHeight = JPRealValue(80);
        [_ctntView registerClass:[XBSettingCell class] forCellReuseIdentifier:settingCellReuseIdentifier];
    }
    return _ctntView;
}

@end
