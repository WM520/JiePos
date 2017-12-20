//
//  JPDemoViewController.m
//  JiePos
//
//  Created by iBlocker on 2017/8/23.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPDemoViewController.h"

@interface JPDemoViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, weak) UITableView *ctntView;

/** 商户类别*/
@property (nonatomic, strong) UITableViewCell *merchantCategoryCell;
/** 营业执照*/
@property (nonatomic, strong) UITableViewCell *licenceCell;
/** 商户名称*/
@property (nonatomic, strong) UITableViewCell *merchantNameCell;
/** 商户简称*/
@property (nonatomic, strong) UITableViewCell *merchantShortNameCell;
/** 注册地址*/
@property (nonatomic, strong) UITableViewCell *registerAddressCell;
/** 详细地址*/
@property (nonatomic, strong) UITableViewCell *detailAddressCell;
/** 行业类型*/
@property (nonatomic, strong) UITableViewCell *industryTypeCell;
/** 行业编号*/
@property (nonatomic, strong) UITableViewCell *industryNoCell;
/** 法人姓名*/
@property (nonatomic, strong) UITableViewCell *legalPersonNameCell;
/** 用户名*/
@property (nonatomic, strong) UITableViewCell *usernameCell;
/** 身份证号码*/
@property (nonatomic, strong) UITableViewCell *accountIdcardCell;
/** 备注信息*/
@property (nonatomic, strong) UITableViewCell *remarkCell;







@property (nonatomic, strong) UITableViewCell *areaCell;
@property (nonatomic, strong) UITableViewCell *shopCell;
@property (nonatomic, strong) UITableViewCell *timeCell;
@property (nonatomic, strong) UITableViewCell *goldTypeCell;
@property (nonatomic, weak) UITextView *areaTextView;
@property (nonatomic, weak) UITextView *shopTextView;
@property (nonatomic, weak) UITextView *timeTextView;
@property (nonatomic, weak) UITextView *goldTypeTextView;
@property (nonatomic, weak) UILabel *invoiceLabel;
@property (nonatomic, weak) UISwitch *invoiceSwitch;

@property (nonatomic, strong) NSArray<NSArray<UITableViewCell *> *> *cells;

// data
@property (nonatomic, strong) NSDictionary *shops;
@property (nonatomic, assign) NSInteger shopIndex;
@property (nonatomic, assign) NSInteger goldTypeIndex;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *fee;

- (void)doneItemClicked:(UIBarButtonItem *)sender;
- (void)cancelItemClicked:(UIBarButtonItem *)sender;
- (void)nextPayFeeButtonClicked:(UIButton *)sender;
- (void)invoiceSwitchChange:(UISwitch *)sender;
@end

//static NSString *const remarkCellReuseIdentifier = @"remarkCellReuseIdentifier";

@implementation JPDemoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"提出黄金";
        self.shopIndex = NSNotFound;
        self.goldTypeIndex = NSNotFound;
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:UIApplication.sharedApplication.delegate.window.bounds];
    view.backgroundColor = JPRGBColor(245, 245, 245, 1);
    self.view = view;
    // 列表
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 44;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
//    tableView.allowsKeyboardDismissOnTap = YES;
    tableView.tableFooterView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 100)];
//        view.backgroundColor = GPColorRGB(245, 245, 245);
        UIImageView *tipImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 20, 20)];
        tipImg.image = [UIImage imageNamed:@"sellGoldTip"];
        tipImg.contentMode = UIViewContentModeCenter;
        [view addSubview:tipImg];
//        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(tipImg.right + 10, 0, view.width - tipImg.width - 40, 90)];
//        tipsLabel.textColor = GPColorRGB(51, 51, 51);
//        tipsLabel.font = [UIFont systemFontOfSize:12];
//        tipsLabel.numberOfLines = 5;
//        [view addSubview:tipsLabel];
//        self.tipsLabel = tipsLabel;
        // 返回
        view;
    });
    [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    self.ctntView = tableView;
    
    // 联系信息
    UITableViewCell *titleOneCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    titleOneCell.selectionStyle = UITableViewCellSelectionStyleNone;
    titleOneCell.textLabel.text = @"联系信息";
    titleOneCell.textLabel.font = [UIFont systemFontOfSize:16];
//    titleOneCell.textLabel.textColor = GPColorRGB(59, 59, 59);
    titleOneCell.imageView.image = [UIImage imageNamed:@"mine_withdraw_contact"];
    titleOneCell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    // 联系人
    UITableViewCell *contactCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
    contactCell.selectionStyle = UITableViewCellSelectionStyleNone;
    contactCell.textLabel.text = @"联系人";
    contactCell.textLabel.font = [UIFont systemFontOfSize:16];
//    contactCell.textLabel.textColor = GPColorRGB(59, 59, 59);
    contactCell.textLabel.textAlignment = NSTextAlignmentLeft;
//    contactCell.detailTextLabel.text = User.current.realName ?: @"--";
    contactCell.detailTextLabel.font = [UIFont systemFontOfSize:16];
//    contactCell.detailTextLabel.textColor = GPColorRGB(59, 59, 59);
    // 联系电话
    UITableViewCell *phoneCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
    phoneCell.selectionStyle = UITableViewCellSelectionStyleNone;
    phoneCell.textLabel.text = @"联系电话";
    phoneCell.textLabel.font = [UIFont systemFontOfSize:16];
//    phoneCell.textLabel.textColor = GPColorRGB(59, 59, 59);
    phoneCell.textLabel.textAlignment = NSTextAlignmentLeft;
//    phoneCell.detailTextLabel.text = User.current.userName ?: @"--";
    phoneCell.detailTextLabel.font = [UIFont systemFontOfSize:16];
//    phoneCell.detailTextLabel.textColor = GPColorRGB(59, 59, 59);
    // 预约信息
    UITableViewCell *titleTwoCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    titleTwoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    titleTwoCell.textLabel.text = @"预约信息";
    titleTwoCell.textLabel.font = [UIFont systemFontOfSize:16];
//    titleTwoCell.textLabel.textColor = GPColorRGB(59, 59, 59);
    titleTwoCell.imageView.image = [UIImage imageNamed:@"mine_withdraw_appointment"];
    titleTwoCell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    // 选择地区
    UITableViewCell *areaCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
    areaCell.selectionStyle = UITableViewCellSelectionStyleDefault;
    areaCell.textLabel.text = @"选择地区";
    areaCell.textLabel.font = [UIFont systemFontOfSize:16];
//    areaCell.textLabel.textColor = GPColorRGB(59, 59, 59);
    areaCell.textLabel.textAlignment = NSTextAlignmentLeft;
    areaCell.detailTextLabel.text = @"选择您要预约的地区";
    areaCell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    areaCell.detailTextLabel.textColor = UIColor.lightGrayColor;
    areaCell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shop_time"]];
    self.areaCell = areaCell;
    // 地区选择器
    UITextView *areaTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    areaTextView.delegate = self;
    areaTextView.userInteractionEnabled = NO;
    areaTextView.inputAccessoryView = ({
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
        toolbar.items = @[
                          ({
                              UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelItemClicked:)];
                              [item setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.grayColor} forState:UIControlStateNormal];
                              item;
                          }),
                          [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                          ({
                              UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneItemClicked:)];
//                              [item setTitleTextAttributes:@{NSForegroundColorAttributeName:GPColorRGB(213, 161, 88)} forState:UIControlStateNormal];
                              item;
                          })
                          ];
        toolbar;
    });
    [areaCell addSubview:areaTextView];
    self.areaTextView = areaTextView;
    // 选择门店
    UITableViewCell *shopCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
    shopCell.selectionStyle = UITableViewCellSelectionStyleDefault;
    shopCell.textLabel.text = @"选择门店";
    shopCell.textLabel.font = [UIFont systemFontOfSize:16];
//    shopCell.textLabel.textColor = GPColorRGB(59, 59, 59);
    shopCell.textLabel.textAlignment = NSTextAlignmentLeft;
    shopCell.detailTextLabel.text = @"选择您要预约的门店";
    shopCell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    shopCell.detailTextLabel.textColor = UIColor.lightGrayColor;
    shopCell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shop_time"]];
    self.shopCell = shopCell;
    // 门店选择器
    UITextView *shopTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    shopTextView.delegate = self;
    shopTextView.userInteractionEnabled = NO;
    shopTextView.inputAccessoryView = ({
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
        toolbar.items = @[
                          ({
                              UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelItemClicked:)];
                              [item setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.grayColor} forState:UIControlStateNormal];
                              item;
                          }),
                          [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                          ({
                              UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneItemClicked:)];
//                              [item setTitleTextAttributes:@{NSForegroundColorAttributeName:GPColorRGB(213, 161, 88)} forState:UIControlStateNormal];
                              item;
                          })
                          ];
        toolbar;
    });
    [shopCell addSubview:shopTextView];
    self.shopTextView = shopTextView;
    // 预约时间
    UITableViewCell *timeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
    timeCell.selectionStyle = UITableViewCellSelectionStyleDefault;
    timeCell.textLabel.text = @"预约时间";
    timeCell.textLabel.font = [UIFont systemFontOfSize:16];
//    timeCell.textLabel.textColor = GPColorRGB(59, 59, 59);
    timeCell.textLabel.textAlignment = NSTextAlignmentLeft;
    timeCell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shop_time"]];
    timeCell.detailTextLabel.text = ({
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
        [dateFormatter stringFromDate:[NSDate.date dateByAddingTimeInterval:24*60*60*10+60]];
    });
//    timeCell.detailTextLabel.textColor = GPColorRGB(59, 59, 59);
    timeCell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    self.timeCell = timeCell;
    // 时间选择器
    UITextView *timeTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    timeTextView.delegate = self;
    timeTextView.userInteractionEnabled = NO;
    timeTextView.inputView = ({
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.minimumDate = [NSDate.date dateByAddingTimeInterval:24*60*60*10+60];
        datePicker.date = datePicker.minimumDate;
        datePicker;
    });
    timeTextView.inputAccessoryView = ({
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
//        toolbar.barTintColor = GPColorRGB(240, 240, 240);
        toolbar.translucent = NO;
        toolbar.items = @[
                          ({
                              UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelItemClicked:)];
                              [item setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.grayColor} forState:UIControlStateNormal];
                              item;
                          }),
                          [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                          ({
                              UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneItemClicked:)];
//                              [item setTitleTextAttributes:@{NSForegroundColorAttributeName:GPColorRGB(213, 161, 88)} forState:UIControlStateNormal];
                              item;
                          })
                          ];
        toolbar;
    });
    [timeCell.contentView addSubview:timeTextView];
    self.timeTextView = timeTextView;
    // 黄金信息
    UITableViewCell *titleThreeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    titleThreeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    titleThreeCell.textLabel.text = @"黄金信息";
    titleThreeCell.textLabel.font = [UIFont systemFontOfSize:16];
//    titleThreeCell.textLabel.textColor = GPColorRGB(59, 59, 59);
    titleThreeCell.imageView.image = [UIImage imageNamed:@"mine_withdraw_goldmessage"];
    titleThreeCell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    // 黄金类型
    UITableViewCell *goldTypeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
    goldTypeCell.selectionStyle = UITableViewCellSelectionStyleDefault;
    goldTypeCell.textLabel.text = @"黄金类型";
    goldTypeCell.textLabel.font = [UIFont systemFontOfSize:16];
//    goldTypeCell.textLabel.textColor = GPColorRGB(59, 59, 59);
    goldTypeCell.textLabel.textAlignment = NSTextAlignmentLeft;
    goldTypeCell.detailTextLabel.text = @"选择您要预约的黄金类型";
    goldTypeCell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    goldTypeCell.detailTextLabel.textColor = UIColor.lightGrayColor;
    goldTypeCell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shop_time"]];
    self.goldTypeCell = goldTypeCell;
    // 黄金类型选择器
    UITextView *goldTypeTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    goldTypeTextView.delegate = self;
    goldTypeTextView.userInteractionEnabled = NO;
    goldTypeTextView.inputAccessoryView = ({
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
        toolbar.items = @[
                          ({
                              UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelItemClicked:)];
                              [item setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.grayColor} forState:UIControlStateNormal];
                              item;
                          }),
                          [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                          ({
                              UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneItemClicked:)];
//                              [item setTitleTextAttributes:@{NSForegroundColorAttributeName:GPColorRGB(213, 161, 88)} forState:UIControlStateNormal];
                              item;
                          })
                          ];
        toolbar;
    });
    [goldTypeCell addSubview:goldTypeTextView];
    self.goldTypeTextView = goldTypeTextView;
    // 黄金克数
    UITableViewCell *goldGramsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
    goldGramsCell.textLabel.text = @"黄金克数";
    goldGramsCell.textLabel.font = [UIFont systemFontOfSize:16];
//    goldGramsCell.textLabel.textColor = GPColorRGB(59, 59, 59);
    goldGramsCell.textLabel.textAlignment = NSTextAlignmentLeft;
//    goldGramsCell.detailTextLabel.text = self.currentDrawGrams;
    goldGramsCell.detailTextLabel.font = [UIFont systemFontOfSize:16];
//    goldGramsCell.detailTextLabel.textColor = GPColorRGB(59, 59, 59);
    goldGramsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 发票
    UITableViewCell *titleFourCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    titleFourCell.selectionStyle = UITableViewCellSelectionStyleNone;
    titleFourCell.textLabel.text = @"发票信息";
    titleFourCell.textLabel.font = [UIFont systemFontOfSize:16];
//    titleFourCell.textLabel.textColor = GPColorRGB(59, 59, 59);
    titleFourCell.imageView.image = [UIImage imageNamed:@"mine_withdraw_invoice"];
    titleFourCell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    // 是否需要发票
    UITableViewCell *invoiceCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    invoiceCell.selectionStyle = UITableViewCellSelectionStyleNone;
    invoiceCell.textLabel.text = @"是否需要发票";
    invoiceCell.textLabel.font = [UIFont systemFontOfSize:16];
//    invoiceCell.textLabel.textColor = GPColorRGB(59, 59, 59);
    UILabel *invoiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 100, 44)];
    invoiceLabel.text = @"不需要发票";
//    invoiceLabel.textColor = GPColorRGB(59, 59, 59);
    invoiceLabel.font = [UIFont systemFontOfSize:16];
    [invoiceCell.contentView addSubview:invoiceLabel];
    self.invoiceLabel = invoiceLabel;
    // 开关
    UISwitch *invoiceSwitch = [[UISwitch alloc] init];
    [invoiceSwitch setOn:NO animated:YES];
    [invoiceSwitch addTarget:self action:@selector(invoiceSwitchChange:)forControlEvents:UIControlEventValueChanged];
    invoiceCell.accessoryView = invoiceSwitch;
    self.invoiceSwitch = invoiceSwitch;
    // 单元格数组
    self.cells = @[@[titleOneCell,contactCell,phoneCell],@[titleTwoCell,areaCell,shopCell,timeCell],@[titleThreeCell,goldTypeCell,goldGramsCell],@[titleFourCell,invoiceCell]];
    // 下一步(支付手续费)
//    UIButton *nextPayFeeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    nextPayFeeButton.frame = CGRectMake(0, self.view.bottom - 50, self.view.width, 50);
//    [nextPayFeeButton setTitle:@"下一步(支付手续费)" forState:UIControlStateNormal];
//    [nextPayFeeButton setTitleColor:GPColorRGB(59, 59, 59) forState:UIControlStateNormal];
//    [nextPayFeeButton setTitleColor:UIColor.whiteColor forState:UIControlStateDisabled];
////    [nextPayFeeButton setBackgroundImage:[UIImage imageWithColor:GPColorRGB(255, 214, 0)] forState:UIControlStateNormal];
////    [nextPayFeeButton setBackgroundImage:[UIImage imageWithColor:GPColorRGB(187, 187, 187)] forState:UIControlStateDisabled];
//    [nextPayFeeButton addTarget:self action:@selector(nextPayFeeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    nextPayFeeButton.enabled = NO;
//    [self.view addSubview:nextPayFeeButton];
//    self.nextPayFeeButton = nextPayFeeButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
//    GPWeakSelf
//    [WithdrawGoldAPI fetchAreaAndShopWithCompletion:^(NSArray * _Nonnull provinces, NSDictionary * _Nonnull cities, NSDictionary * _Nonnull counties, NSDictionary * _Nonnull shops) {
//        GPStrongSelfElseReturn
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        GPStringPicker *stringPicker = [[GPStringPicker alloc] initWithFrame:CGRectMake(0, 0, GP_SCREEN_WIDTH, 216) items:provinces];
//        [stringPicker addItems:cities];
//        [stringPicker addItems:counties];
//        self.areaTextView.inputView = stringPicker;
//        NSString *county = stringPicker.selectedValues.lastObject;
//        self.shopTextView.inputView = [[GPStringPicker alloc] initWithFrame:CGRectMake(0, 0, GP_SCREEN_WIDTH, 216) items:[shops[county] valueForKey:@"shopName"]];
//        self.shops = shops;
//    } failure:^(NSError * _Nonnull error) {
//        GPStrongSelfElseReturn
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [MBProgressHUD showError:error.localizedDescription];
//    }];
//
//    [WithdrawGoldAPI fetchGoldTypeAndTipsWithCompletion:^(NSArray * _Nonnull goldType, NSString * _Nonnull tips) {
//        GPStrongSelfElseReturn
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        self.goldTypeTextView.inputView = [[GPStringPicker alloc] initWithFrame:CGRectMake(0, 0, GP_SCREEN_WIDTH, 216) items:goldType];
//        self.tipsLabel.text = [NSString stringWithFormat:@"%@",tips];
//    } failure:^(NSError * _Nonnull error) {
//        GPStrongSelfElseReturn
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [MBProgressHUD showError:error.localizedDescription];
//    }];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Notification

- (void)keyboardWillShow:(NSNotification *)notification
{
//    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
//    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGRect cellFrame = CGRectOffset(selectedCell.frame, 0, self.navigationBar.height);
//    if (CGRectIntersectsRect(keyboardFrame, cellFrame)) {
//        CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//        UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationCurve:curve];
//        [UIView setAnimationDuration:duration];
//        self.tableView.contentOffsetY = CGRectGetMaxY(cellFrame) - CGRectGetMinY(keyboardFrame);
//        self.tableView.contentInsetTop = -self.tableView.contentOffsetY;
//        self.tableView.contentInsetBottom = -self.tableView.contentInsetTop;
//        [UIView commitAnimations];
//    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.ctntView deselectRowAtIndexPath:self.ctntView.indexPathForSelectedRow animated:YES];
    });
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:duration];
//    self.tableView.contentOffsetY = -64;
//    self.tableView.contentInsetTop = 64;
//    self.tableView.contentInsetBottom = 0;
    [UIView commitAnimations];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cells[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cells[indexPath.section][indexPath.row];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if (selectedCell == self.areaCell) {
        [self.areaTextView becomeFirstResponder];
    }
    if (selectedCell == self.shopCell) {
        [self.shopTextView becomeFirstResponder];
    }
    if (selectedCell == self.timeCell) {
        [self.timeTextView becomeFirstResponder];
    }
    if (selectedCell == self.goldTypeCell) {
        [self.goldTypeTextView becomeFirstResponder];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

#pragma mark - UITextViewDelegte

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    UIPickerView *pickerView = (UIPickerView *)textView.inputView;
    if ([pickerView isKindOfClass:UIPickerView.class]) {
        [pickerView reloadAllComponents];
    }
    return YES;
}


#pragma mark - Target actions

- (void)nextPayFeeButtonClicked:(UIButton *)sender
{
//    GPWeakSelf
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [WithdrawGoldAPI withdrawOrderWithShopId:self.shopId goldType:self.goldTypeCell.detailTextLabel.text reserveTime:self.timeCell.detailTextLabel.text gram20:self.grams20 gram50:self.grams50 gram100:self.grams100 gram200:self.grams200 gram500:self.grams500 gram1000:self.grams1000 needBill:self.invoiceSwitch.isOn ? @"1" : @"0" completion:^(NSString * _Nonnull orderNo, NSString * _Nonnull fee) {
//        GPStrongSelfElseReturn
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        self.orderNo = orderNo;
//        self.fee = fee;
//        // 开始支付操作
//        [self startPayOperation:orderNo payFee:fee];
//    } failure:^(NSError * _Nonnull error) {
//        GPStrongSelfElseReturn
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [MBProgressHUD showError:error.localizedDescription toView:self.view];
//    }];
}

- (void)startPayOperation:(NSString *)orderNo payFee:(NSString *)payFee
{
//    if (User.current.hasBankCard) { // 是否有银行卡
//        if (User.current.hasTradingPassword) { // 是否设置了交易密码
//            PaymentEntranceViewController *viewController = [[PaymentEntranceViewController alloc] initWithOrderNo:orderNo amount:payFee allowsWalletPay:YES];
//            viewController.delegate = self;
//            GPActionSheetNavigationController *navigationController = [[GPActionSheetNavigationController alloc] initWithRootViewController:viewController];
//            [self presentViewController:navigationController animated:YES completion:nil];
//        } else {
//            PaymentSetPasswordViewController *viewController = [[PaymentSetPasswordViewController alloc] init];
//            viewController.delegate = self;
//            GPActionSheetNavigationController *navigationController = [[GPActionSheetNavigationController alloc] initWithRootViewController:viewController];
//            [self presentViewController:navigationController animated:YES completion:nil];
//        }
//    } else {
//        AddBankCardViewController *addBankCard = [[AddBankCardViewController alloc] init];
//        addBankCard.titleType = @"充值";
//        addBankCard.paymentAmount = [NSString stringWithFormat:@"%@",payFee];
//        addBankCard.orderNumber = [NSString stringWithFormat:@"%@",orderNo];
//        [self.navigationController pushViewController:addBankCard animated:YES];
//    }
}

- (void)doneItemClicked:(UIBarButtonItem *)sender
{
//    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
//    if (selectedCell == self.areaCell) {
//        self.shopCell.selectionStyle = UITableViewCellSelectionStyleDefault;
////        GPStringPicker *stringPicker = (GPStringPicker *)self.areaTextView.inputView;
////        NSString *string = [stringPicker.selectedValues componentsJoinedByString:@" "];
//        if (![string isEqualToString:self.areaCell.detailTextLabel.text]) {
//            self.shopCell.detailTextLabel.text = @"选择您要预约的门店";
//            self.shopCell.detailTextLabel.textColor = UIColor.lightGrayColor;
//            self.shopIndex = NSNotFound;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                GPStringPicker *shopPicker = (GPStringPicker *)self.shopTextView.inputView;
//                [shopPicker setItems:[self.shops[stringPicker.selectedValues.lastObject] valueForKey:@"shopName"] forComponent:0];
//            });
//        }
//        self.areaCell.detailTextLabel.text = string;
//        self.areaCell.detailTextLabel.textColor = GPColorRGB(74, 74, 74);
//        [self.areaTextView resignFirstResponder];
//    } else if (selectedCell == self.shopCell) {
//        GPStringPicker *stringPicker = (GPStringPicker *)self.shopTextView.inputView;
//        self.shopIndex = stringPicker.selectedIndexes.firstObject.integerValue;
//        self.shopCell.detailTextLabel.text = stringPicker.selectedValues.firstObject;
//        self.shopCell.detailTextLabel.textColor = GPColorRGB(74, 74, 74);
//        NSDictionary *shop = self.shops[[self.areaCell.detailTextLabel.text componentsSeparatedByString:@" "].lastObject][self.shopIndex];
//        self.shopId = [NSString stringWithFormat:@"%@",shop[@"shopId"]];
//        [self.shopTextView resignFirstResponder];
//    } else if (selectedCell == self.goldTypeCell) {
//        GPStringPicker *stringPicker = (GPStringPicker *)self.goldTypeTextView.inputView;
//        NSString *string = [stringPicker.selectedValues componentsJoinedByString:@" "];
//        self.goldTypeCell.detailTextLabel.text = string;
//        self.goldTypeCell.detailTextLabel.textColor = GPColorRGB(74, 74, 74);
//        if ([string isEqualToString:self.goldTypeCell.detailTextLabel.text]) {
//            self.goldTypeIndex = !NSNotFound;
//        }
//        [self.goldTypeTextView resignFirstResponder];
//    } else {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
//        UIDatePicker *picker = (UIDatePicker *)self.timeTextView.inputView;
//        self.timeCell.detailTextLabel.text =  [dateFormatter stringFromDate:picker.date];
//        [self.timeTextView resignFirstResponder];
//    }
}

- (void)cancelItemClicked:(UIBarButtonItem *)sender
{
    [self.ctntView endEditing:YES];
}

- (void)invoiceSwitchChange:(UISwitch *)sender
{
    self.invoiceLabel.text = sender.on ? @"需要发票" : @"不需要发票";
}

#pragma mark - 私有方法

- (void)setShopIndex:(NSInteger)shopIndex
{
    _shopIndex = shopIndex;
//    self.nextPayFeeButton.enabled = shopIndex != NSNotFound;
}

- (void)setGoldTypeIndex:(NSInteger)goldTypeIndex
{
    _goldTypeIndex = goldTypeIndex;
//    self.nextPayFeeButton.enabled = goldTypeIndex != NSNotFound;
}

@end
