//
//  JPManageGesticulationViewController.m
//  JiePos
//
//  Created by wangmiao on 2017/12/22.
//  Copyright © 2017年 WangMiao. All rights reserved.
//

#import "JPManageGesticulationViewController.h"
#import "XBSettingItemModel.h"
#import "XBSettingSectionModel.h"
#import "XBSettingCell.h"
#import "TQViewController1.h"
#import "TQGesturesPasswordManager.h"
#import "JPModificationViewController.h"
static NSString *settingCellReuseIdentifier = @"settingCell";

@interface JPManageGesticulationViewController ()
<UITableViewDelegate,
UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainListView;
@property (strong, nonatomic) NSMutableArray * dataSource;
@property (nonatomic, strong) TQGesturesPasswordManager *passwordManager;
@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, strong) XBSettingItemModel *item1;
@property (nonatomic, strong) XBSettingItemModel *item2;
@property (nonatomic, strong) XBSettingSectionModel *section2;
@end

@implementation JPManageGesticulationViewController

#pragma mark - lifestyle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 初始化数据
    [self configData];
    // 初始化UI
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.passwordManager = [TQGesturesPasswordManager manager];
    NSLog(@"%@", _passwordManager.getEventuallyPassword);
    
    if ([_passwordManager.getEventuallyPassword  isEqual: @""] || _passwordManager.getEventuallyPassword  == NULL) {
        self.isOn = NO;
    } else {
        self.isOn = YES;
    };
}

#pragma mark - init
- (void)configData
{
    self.passwordManager = [TQGesturesPasswordManager manager];
    if ([_passwordManager.getEventuallyPassword  isEqual: @""] || _passwordManager.getEventuallyPassword  == NULL) {
        _isOn = NO;
    } else {
        _isOn = YES;
        XBSettingItemModel *item2 = [[XBSettingItemModel alloc]init];
        item2.funcName = @"修改手势密码";
        item2.img = [UIImage imageNamed:@"jp_person_login_password"];
        item2.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
        _item2 = item2;
        XBSettingSectionModel *section2 = [[XBSettingSectionModel alloc]init];
        section2.sectionHeaderHeight = 18;
        section2.itemArray = @[item2];
        _section2 = section2;
    }
    
    weakSelf_declare;
    XBSettingItemModel *item1 = [[XBSettingItemModel alloc]init];
    item1.funcName = @"手势登录管理";
    if (_isOn) {
        item1.isOn = YES;
    } else {
        item1.isOn = NO;
    }
    item1.img = [UIImage imageNamed:@"jp_person_shoushi_password"];
    item1.accessoryType = XBSettingAccessoryTypeSwitch;
    item1.switchValueChanged = ^(BOOL isOn) {
        if (isOn) {
            TQViewController1 * vc = [[TQViewController1 alloc] init];
            vc.title = @"手势密码设置";
            vc.successblock = ^{
                XBSettingItemModel *item2 = [[XBSettingItemModel alloc]init];
                item2.funcName = @"修改手势密码";
                item2.img = [UIImage imageNamed:@"jp_person_login_password"];
                item2.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
                _item2 = item2;
                XBSettingSectionModel *section2 = [[XBSettingSectionModel alloc] init];
                section2.sectionHeaderHeight = 18;
                section2.itemArray = @[item2];
                _section2 = section2;
                [self.dataSource addObject:_section2];
                [weakSelf.mainListView reloadData];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else {
            [JP_UserDefults removeObjectForKey:@"tq_gesturesPassword"];
            [weakSelf.dataSource removeLastObject];
            _item1.isOn = NO;
            [weakSelf.mainListView reloadData];
        }
    };
    _item1 = item1;
    XBSettingSectionModel *section1 = [[XBSettingSectionModel alloc] init];
    section1.sectionHeaderHeight = 18;
    section1.itemArray = @[item1];

    [self.dataSource addObject:section1];
    if (_section2) {
        [self.dataSource addObject:_section2];
    }
}

- (void)configUI
{
    self.mainListView.dataSource = self;
    self.mainListView.delegate = self;
    self.mainListView.backgroundColor = JP_viewBackgroundColor;
    self.mainListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainListView registerClass:[XBSettingCell class] forCellReuseIdentifier:settingCellReuseIdentifier];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XBSettingSectionModel *sectionModel = self.dataSource[section];
    return sectionModel.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellReuseIdentifier];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    XBSettingSectionModel *sectionModel = self.dataSource[indexPath.section];
    XBSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if (!cell) {
        cell = [[XBSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:settingCellReuseIdentifier];
    }
    cell.item = itemModel;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        JPModificationViewController * vc = [[JPModificationViewController alloc] init];
        vc.title = @"验证原手势密码";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - setters or getters
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setIsOn:(BOOL)isOn
{
    _isOn = isOn;
    _item1.isOn = isOn;
    [self.mainListView reloadData];
}

@end
