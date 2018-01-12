//
//  JPContactViewController.m
//  JiePos
//
//  Created by iBlocker on 2017/8/17.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPContactViewController.h"

static NSString *const mobileCell = @"mobileCell";
static NSString *const weixinCell = @"weixinCell";

@interface JPMobileCell : UITableViewCell

@property (nonatomic, strong) UIButton *headerView;
@property (nonatomic, strong) UIView *currentView;
@property (nonatomic, strong) UIButton *mobileButton;
@property (nonatomic, strong) UILabel *workTime;
@property (nonatomic, copy) NSString * mobileNumber;

@end

@implementation JPMobileCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        [self.contentView addSubview:self.currentView];
        [self.contentView addSubview:self.headerView];
        [self.contentView addSubview:self.mobileButton];
        [self.contentView addSubview:self.workTime];
    }
    return self;
}

#pragma mark - Method
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.currentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(30));
//        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(20));
//        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-30));
//        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, JPRealValue(30), 0, JPRealValue(30)));
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.currentView.mas_top).offset(JPRealValue(44));
        make.centerX.equalTo(weakSelf.currentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(200), JPRealValue(40)));
    }];
    [self.mobileButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.currentView.mas_centerX);
        make.centerY.equalTo(weakSelf.currentView.mas_centerY).offset(JPRealValue(10));
    }];
    [self.workTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.currentView.mas_bottom).offset(JPRealValue(-30));
        make.centerX.equalTo(weakSelf.currentView.mas_centerX);
    }];
}

#pragma mark - Setter
- (void)setMobileNumber:(NSString *)mobileNumber
{
    _mobileNumber = mobileNumber;
    [_mobileButton setAttributedTitle:[self attributrStringWithString:mobileNumber color:JPBaseColor] forState:UIControlStateNormal];
}

#pragma mark - Getter
- (UIView *)currentView {
    if (!_currentView) {
        _currentView = [UIView new];
        _currentView.backgroundColor = [UIColor whiteColor];
        _currentView.layer.cornerRadius = JPRealValue(10);
        _currentView.layer.shadowColor = JPBaseColor.CGColor;
        _currentView.layer.shadowOffset = CGSizeMake(2, 2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _currentView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _currentView.layer.shadowRadius = 2;//阴影半径，默认3
    }
    return _currentView;
}

- (UIButton *)headerView {
    if (!_headerView) {
        _headerView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headerView setImage:[UIImage imageNamed:@"jp_contact_mobile"] forState:UIControlStateNormal];
        [_headerView setTitle:@"联系电话" forState:UIControlStateNormal];
        [_headerView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _headerView.titleEdgeInsets = UIEdgeInsetsMake(0, JPRealValue(10), 0, 0);
        _headerView.titleLabel.font = [UIFont boldSystemFontOfSize:JPRealValue(34)];
    }
    return _headerView;
}

- (UIButton *)mobileButton {
    if (!_mobileButton) {
        _mobileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _mobileButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//        NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"4008-4008-57"];
//        [tncString addAttribute:NSUnderlineStyleAttributeName
//                          value:@(NSUnderlineStyleSingle)
//                          range:(NSRange){0,[tncString length]}];
//        //此时如果设置字体颜色要这样
//        [tncString addAttribute:NSForegroundColorAttributeName value:JPBaseColor range:NSMakeRange(0,[tncString length])];
//        
//        //设置下划线颜色...
//        [tncString addAttribute:NSUnderlineColorAttributeName value:JPBaseColor range:(NSRange){0,[tncString length]}];
//        [tncString addAttribute:NSFontAttributeName value:JP_DefaultsFont range:(NSRange){0,[tncString length]}];
//        [_mobileButton setAttributedTitle:tncString forState:UIControlStateNormal];
        
        [_mobileButton addTarget:self action:@selector(callServiceTelephone:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mobileButton;
}

- (UILabel *)workTime {
    if (!_workTime) {
        _workTime = [UILabel new];
        _workTime.text = @"工作时间：7*24小时";
        _workTime.font = [UIFont systemFontOfSize:JPRealValue(24)];
        _workTime.textAlignment = NSTextAlignmentCenter;
        _workTime.textColor = JP_NoticeText_Color;
    }
    return _workTime;
}

#pragma mark - Action
- (void)callServiceTelephone:(UIButton *)sender {
    sender.enabled = NO;
    
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", _mobileNumber];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:callPhone]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        } else {
            [IBProgressHUD showInfoWithStatus:@"无法拨打电话！"];
        }
    });
    
    sender.enabled = YES;
}

#pragma mark - Methods
- (NSMutableAttributedString *)attributrStringWithString:(NSString *)string color:(UIColor *)color {
    
    NSMutableAttributedString *tncString = [[NSMutableAttributedString alloc] initWithString:string];
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString length]}];
    //此时如果设置字体颜色要这样
    [tncString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,[tncString length])];
    
    //设置下划线颜色...
    [tncString addAttribute:NSUnderlineColorAttributeName value:color range:(NSRange){0,[tncString length]}];
    [tncString addAttribute:NSFontAttributeName value:JP_DefaultsFont range:(NSRange){0,[tncString length]}];
    
    return tncString;
}

@end

@interface JPWeixinCell : UITableViewCell

@property (nonatomic, strong) UIButton *headerView;
@property (nonatomic, strong) UIView *currentView;
@property (nonatomic, strong) UILabel *weixinNo;
@property (nonatomic, assign) BOOL canOpen;
@property (nonatomic, strong) UIButton *cutWeixinNoButton;
@property (nonatomic, strong) UIButton *openWeixinButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, copy) NSString * weixinNumber;
@property (nonatomic, copy) NSString * mobileNumber;

@end

@implementation JPWeixinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        [self.contentView addSubview:self.currentView];
        [self.currentView addSubview:self.headerView];
        [self.currentView addSubview:self.weixinNo];
        [self.currentView addSubview:self.cutWeixinNoButton];
        [self.currentView addSubview:self.openWeixinButton];
        [self.currentView addSubview:self.lineView];
        [self.currentView addSubview:self.textView];
    }
    return self;
}

#pragma mark - Method
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.currentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(30));
//        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(20));
//        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-30));
//        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, JPRealValue(30), 0, JPRealValue(30)));
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(44));
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(200), JPRealValue(40)));
    }];
    [self.weixinNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerView.mas_bottom).offset(JPRealValue(34));
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.weixinNo.mas_bottom).offset(JPRealValue(124));
        make.centerX.equalTo(weakSelf.currentView.mas_centerX);
        make.left.equalTo(weakSelf.currentView.mas_left).offset(JPRealValue(30));
        make.height.equalTo(@(JPRealValue(1)));
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lineView.mas_left);
        make.top.equalTo(weakSelf.lineView.mas_bottom).offset(JPRealValue(30));
        make.right.equalTo(weakSelf.lineView.mas_right);
        make.bottom.equalTo(weakSelf.currentView.mas_bottom).offset(JPRealValue(-20));
    }];
}

#pragma mark - Setter
- (void)setCanOpen:(BOOL)canOpen {
    weakSelf_declare;
    if (canOpen) {
        self.openWeixinButton.hidden = NO;
        [self.cutWeixinNoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.currentView.mas_centerX).offset(JPRealValue(-20));
            make.top.equalTo(weakSelf.weixinNo.mas_bottom).offset(JPRealValue(30));
            make.size.mas_equalTo(CGSizeMake(JPRealValue(140), JPRealValue(54)));
        }];
        [self.openWeixinButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.currentView.mas_centerX).offset(JPRealValue(20));
            make.top.equalTo(weakSelf.cutWeixinNoButton.mas_top);
            make.size.mas_equalTo(CGSizeMake(JPRealValue(140), JPRealValue(54)));
        }];
    } else {
        self.openWeixinButton.hidden = YES;
        [self.cutWeixinNoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.currentView.mas_centerX);
            make.top.equalTo(weakSelf.weixinNo.mas_bottom).offset(JPRealValue(30));
            make.size.mas_equalTo(CGSizeMake(JPRealValue(140), JPRealValue(54)));
        }];
    }
}

#pragma mark - Getter
- (UIView *)currentView {
    if (!_currentView) {
        _currentView = [UIView new];
        _currentView.backgroundColor = [UIColor whiteColor];
        _currentView.layer.cornerRadius = JPRealValue(10);
        _currentView.layer.shadowColor = JPBaseColor.CGColor;
        _currentView.layer.shadowOffset = CGSizeMake(2, 2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _currentView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _currentView.layer.shadowRadius = 2;//阴影半径，默认3
    }
    return _currentView;
}

- (UIButton *)headerView {
    if (!_headerView) {
        _headerView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headerView setImage:[UIImage imageNamed:@"jp_contact_weixin"] forState:UIControlStateNormal];
        [_headerView setTitle:@"客服微信" forState:UIControlStateNormal];
        [_headerView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _headerView.titleEdgeInsets = UIEdgeInsetsMake(0, JPRealValue(10), 0, 0);
        _headerView.titleLabel.font = [UIFont boldSystemFontOfSize:JPRealValue(34)];
    }
    return _headerView;
}

- (UILabel *)weixinNo {
    if (!_weixinNo) {
        _weixinNo = [UILabel new];
//        _weixinNo.text = @"15850548165";
        _weixinNo.font = JP_DefaultsFont;
        _weixinNo.textColor = JP_NoticeText_Color;
        _weixinNo.textAlignment = NSTextAlignmentCenter;
    }
    return _weixinNo;
}

- (UIButton *)cutWeixinNoButton {
    if (!_cutWeixinNoButton) {
        _cutWeixinNoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cutWeixinNoButton setTitle:@"复制微信" forState:UIControlStateNormal];
        [_cutWeixinNoButton setTitleColor:[UIColor colorWithHexString:@"3dce7c"] forState:UIControlStateNormal];
        _cutWeixinNoButton.layer.cornerRadius = JPRealValue(5);
        _cutWeixinNoButton.layer.masksToBounds = YES;
        _cutWeixinNoButton.layer.borderColor = [UIColor colorWithHexString:@"3dce7c"].CGColor;
        _cutWeixinNoButton.layer.borderWidth = 1.0f;
        _cutWeixinNoButton.titleLabel.font = JP_DefaultsFont;
        [_cutWeixinNoButton addTarget:self action:@selector(cutWeixinNoClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cutWeixinNoButton;
}

- (UIButton *)openWeixinButton {
    if (!_openWeixinButton) {
        _openWeixinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openWeixinButton setTitle:@"打开微信" forState:UIControlStateNormal];
        [_openWeixinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _openWeixinButton.backgroundColor = [UIColor colorWithHexString:@"3dce7c"];
        _openWeixinButton.layer.cornerRadius = JPRealValue(5);
        _openWeixinButton.layer.masksToBounds = YES;
        _openWeixinButton.titleLabel.font = JP_DefaultsFont;
        [_openWeixinButton addTarget:self action:@selector(openWeixinClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openWeixinButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = JP_LineColor;
    }
    return _lineView;
}

- (YYTextView *)textView {
    if (!_textView) {
        _textView = [YYTextView new];
        _textView.userInteractionEnabled = NO;
        _textView.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.editable = NO;
        
//        //创建最主要的attribute文本
//        NSMutableAttributedString *contentText = [NSMutableAttributedString new];
//
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineSpacing = JPRealValue(16);// 字体的行间距
//        paragraphStyle.paragraphSpacing = JPRealValue(5);
//
//        [contentText appendAttributedString:[[NSAttributedString alloc] initWithString:@"1、复制微信号：15850548165\n2、打开微信，点击右上角“+”【添加好友】\n3、在搜索框中，粘贴微信号，与微信客服沟通" attributes:@{NSForegroundColorAttributeName : JP_NoticeText_Color, NSFontAttributeName : [UIFont systemFontOfSize:JPRealValue(24)], NSParagraphStyleAttributeName : paragraphStyle}]];
//
//        _textView.attributedText = contentText;
    }
    return _textView;
}

#pragma mark - Action
- (void)cutWeixinNoClick:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _weixinNumber;
    [IBProgressHUD showSuccessWithStatus:@"已复制微信号到剪贴板"];
}

- (void)openWeixinClick:(UIButton *)sender {
    [JPTool openWeixin];
}

- (void)setWeixinNumber:(NSString *)weixinNumber
{
    _weixinNumber = weixinNumber;
    _weixinNo.text = weixinNumber;
    NSMutableAttributedString *contentText = [NSMutableAttributedString new];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = JPRealValue(16);// 字体的行间距
    paragraphStyle.paragraphSpacing = JPRealValue(5);
    [contentText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"1、复制微信号：%@\n2、打开微信，点击右上角“+”【添加好友】\n3、在搜索框中，粘贴微信号，与微信客服沟通", weixinNumber] attributes:@{NSForegroundColorAttributeName : JP_NoticeText_Color, NSFontAttributeName : [UIFont systemFontOfSize:JPRealValue(24)], NSParagraphStyleAttributeName : paragraphStyle}]];
    _textView.attributedText = contentText;
}

@end

@interface JPContactViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *ctntView;
@property (nonatomic, strong) JPMobileCell *cell1;
@property (nonatomic, strong) JPWeixinCell *cell2;

@end

@implementation JPContactViewController

#pragma mark - lifestyle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"联系方式";
    [self.view addSubview:self.ctntView];
    weakSelf_declare;
    [IBPersonRequest getCustomerServiceNumberAccount:[JPUserEntity sharedUserEntity].account merchantId:[JPUserEntity sharedUserEntity].merchantId callback:^(NSString *code, NSString *msg, id resp) {
        if ([code isEqualToString:@"0"]) {
            NSDictionary *obj = [IBAnalysis analysisWithEncryptString:resp privateKey:[JPUserEntity sharedUserEntity].privateKey];
            NSLog(@"%@", obj);
            weakSelf.cell2.weixinNumber = [obj objectForKey:@"serviceWX"];
            weakSelf.cell1.mobileNumber = [obj objectForKey:@"servicePhone"];
        } else {
            [IBProgressHUD showErrorWithStatus:msg];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JPMobileCell *cell = [tableView dequeueReusableCellWithIdentifier:mobileCell forIndexPath:indexPath];
        _cell1 = cell;
        return cell;
    } else {
        JPWeixinCell *cell = [tableView dequeueReusableCellWithIdentifier:weixinCell forIndexPath:indexPath];
        _cell2 = cell;
        cell.canOpen = [JPTool canOpenWeixin];
        return cell;
    }
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? JPRealValue(230) : JPRealValue(476);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return JPRealValue(20);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - Getter
- (UITableView *)ctntView {
    if (!_ctntView) {
        _ctntView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
        _ctntView.dataSource = self;
        _ctntView.delegate = self;
        _ctntView.backgroundColor = JP_viewBackgroundColor;
        _ctntView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ctntView.estimatedSectionHeaderHeight = 0;
        _ctntView.estimatedSectionFooterHeight = 0;
        
        [_ctntView registerClass:NSClassFromString(@"JPMobileCell") forCellReuseIdentifier:mobileCell];
        [_ctntView registerClass:NSClassFromString(@"JPWeixinCell") forCellReuseIdentifier:weixinCell];
    }
    return _ctntView;
}

@end
