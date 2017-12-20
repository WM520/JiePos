//
//  JPSearchDealCell.m
//  JiePos
//
//  Created by Jason_LJ on 2017/7/12.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPSearchDealCell.h"

@interface JPSearchHeaderView ()
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *merchantNameLab;
@property (nonatomic, strong) UIButton *merchantNameButton;
@end
@implementation JPSearchHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView.layer addSublayer:self.gradientLayer];
        self.gradientLayer.frame = (CGRect){0, 0, kScreenWidth, JPRealValue(216)};
        
        [self.contentView addSubview:self.headView];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.merchantNameLab];
        [self.contentView addSubview:self.merchantNameButton];
    }
    return self;
}
- (void)setMerchantName:(NSString *)merchantName {
    self.merchantNameLab.text = merchantName;
    _merchantName = merchantName;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(30));
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-30));
        make.height.equalTo(@(JPRealValue(160)));
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(JPRealValue(-20));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headView.mas_left).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.headView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(150), JPRealValue(30)));
    }];
    [self.merchantNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab.mas_right).offset(JPRealValue(50));
        make.centerY.equalTo(weakSelf.titleLab.mas_centerY);
        make.right.equalTo(weakSelf.headView.mas_right).offset(JPRealValue(-60));
    }];
    [self.merchantNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab.mas_right).offset(JPRealValue(30));
        make.right.equalTo(weakSelf.headView.mas_right).offset(JPRealValue(-20));
        make.centerY.equalTo(weakSelf.titleLab.mas_centerY);
        make.height.equalTo(@(JPRealValue(60)));
    }];
}
- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"7a93f5"].CGColor, (__bridge id)[UIColor colorWithHexString:@"68b2f2"].CGColor, (__bridge id)[UIColor colorWithHexString:@"51dbf0"].CGColor];
        _gradientLayer.locations = @[@0, @0.5, @1.0];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1.0, 0);
    }
    return _gradientLayer;
}
- (UIView *)headView {
    if (!_headView) {
        _headView = [UIView new];
        ;_headView.backgroundColor = [UIColor whiteColor];
        _headView.layer.cornerRadius = JPRealValue(10);
//        _headView.layer.masksToBounds = YES;
        _headView.layer.shadowColor = JPBaseColor.CGColor;
        _headView.layer.shadowOffset = CGSizeMake(2, 2);
        _headView.layer.shadowOpacity = 0.5;
        _headView.layer.shadowRadius = 2;
    }
    return _headView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.text = @"商户名称";
        _titleLab.textColor = JP_Content_Color;
        _titleLab.font = JP_DefaultsFont;
    }
    return _titleLab;
}
- (UILabel *)merchantNameLab {
    if (!_merchantNameLab) {
        _merchantNameLab = [UILabel new];
        _merchantNameLab.font = JP_DefaultsFont;
        _merchantNameLab.textColor = JP_NoticeText_Color;
    }
    return _merchantNameLab;
}
- (UIButton *)merchantNameButton {
    if (!_merchantNameButton) {
        _merchantNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _merchantNameButton.layer.cornerRadius = JPRealValue(10);
        _merchantNameButton.layer.masksToBounds = YES;
        _merchantNameButton.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
        _merchantNameButton.layer.borderWidth = 0.5;
        _merchantNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_merchantNameButton setTitle:@"  " forState:UIControlStateNormal];
        [_merchantNameButton setImage:[UIImage imageNamed:@"jp_searchDownIndicator"] forState:UIControlStateNormal];
        [_merchantNameButton addTarget:self action:@selector(handleMerchantNameSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _merchantNameButton;
}
- (void)handleMerchantNameSelected:(UIButton *)sender {
    if (self.jp_searchMerchantBlock) {
        self.jp_searchMerchantBlock(self.merchantNameLab);
    }
}
@end

@interface JPSearchDealCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *oneTitleLab;
@property (nonatomic, strong) UILabel *oneValueLab;
@property (nonatomic, strong) UIImageView *oneIndicator;
@property (nonatomic, strong) UILabel *twoTitleLab;
@property (nonatomic, strong) UILabel *twoValueLab;
@property (nonatomic, strong) UIImageView *twoIndicator;
@property (nonatomic, strong) UIButton *oneButton;
@property (nonatomic, strong) UIButton *twoButton;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation JPSearchDealCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.oneTitleLab];
        [self.contentView addSubview:self.oneValueLab];
        [self.contentView addSubview:self.oneIndicator];
        [self.contentView addSubview:self.twoTitleLab];
        [self.contentView addSubview:self.twoValueLab];
        [self.contentView addSubview:self.twoIndicator];
        [self.contentView addSubview:self.oneButton];
        [self.contentView addSubview:self.twoButton];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}
- (void)setOneTitle:(NSString *)oneTitle {
    self.oneTitleLab.text = oneTitle;
    _oneTitle = oneTitle;
}
- (void)setOneValue:(NSString *)oneValue {
    self.oneValueLab.text = oneValue;
    _oneValue = oneValue;
}
- (void)setTwoTitle:(NSString *)twoTitle {
    self.twoTitleLab.text = twoTitle;
    _twoTitle = twoTitle;
}
- (void)setTwoValue:(NSString *)twoValue {
    self.twoValueLab.text = twoValue;
    _twoValue = twoValue;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(30));
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-30));
    }];
    [self.oneTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
        make.top.equalTo(weakSelf.bgView.mas_top).offset(JPRealValue(36));
    }];
    [self.oneIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.oneTitleLab.mas_centerY);
        make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-20));
    }];
    [self.oneValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.oneIndicator.mas_left).offset(JPRealValue(-30));
        make.centerY.equalTo(weakSelf.oneIndicator.mas_centerY);
    }];
    [self.twoTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
        make.bottom.equalTo(weakSelf.bgView.mas_bottom).offset(JPRealValue(-36));
    }];
    [self.twoIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.twoTitleLab.mas_centerY);
        make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-20));
    }];
    [self.twoValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.twoIndicator.mas_left).offset(JPRealValue(-30));
        make.centerY.equalTo(weakSelf.twoIndicator.mas_centerY);
    }];
    [self.oneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(weakSelf.bgView);
        make.bottom.equalTo(weakSelf.bgView.mas_centerY);
    }];
    [self.twoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.equalTo(weakSelf.bgView);
        make.top.equalTo(weakSelf.bgView.mas_centerY);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(30));
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.right.equalTo(weakSelf.bgView.mas_right);
        make.height.equalTo(@0.5);
    }];
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = JPRealValue(10);
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}
- (UILabel *)oneTitleLab {
    if (!_oneTitleLab) {
        _oneTitleLab = [UILabel new];
        _oneTitleLab.font = JP_DefaultsFont;
        _oneTitleLab.textColor = JP_Content_Color;
    }
    return _oneTitleLab;
}
- (UILabel *)oneValueLab {
    if (!_oneValueLab) {
        _oneValueLab = [UILabel new];
        _oneValueLab.font = JP_DefaultsFont;
        _oneValueLab.textColor = JP_NoticeText_Color;
    }
    return _oneValueLab;
}
- (UIImageView *)oneIndicator {
    if (!_oneIndicator) {
        _oneIndicator = [UIImageView new];
        _oneIndicator.image = [UIImage imageNamed:@"jp_searchRightIndicator"];
    }
    return _oneIndicator;
}
- (UILabel *)twoTitleLab {
    if (!_twoTitleLab) {
        _twoTitleLab = [UILabel new];
        _twoTitleLab.font = JP_DefaultsFont;
        _twoTitleLab.textColor = JP_Content_Color;
    }
    return _twoTitleLab;
}
- (UILabel *)twoValueLab {
    if (!_twoValueLab) {
        _twoValueLab = [UILabel new];
        _twoValueLab.font = JP_DefaultsFont;
        _twoValueLab.textColor = JP_NoticeText_Color;
    }
    return _twoValueLab;
}
- (UIImageView *)twoIndicator {
    if (!_twoIndicator) {
        _twoIndicator = [UIImageView new];
        _twoIndicator.image = [UIImage imageNamed:@"jp_searchRightIndicator"];
    }
    return _twoIndicator;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    }
    return _lineView;
}
- (UIButton *)oneButton {
    if (!_oneButton) {
        _oneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oneButton addTarget:self action:@selector(oneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _oneButton;
}
- (UIButton *)twoButton {
    if (!_twoButton) {
        _twoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_twoButton addTarget:self action:@selector(twoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _twoButton;
}
- (void)oneButtonClick:(UIButton *)sender {
    if (self.jp_oneRowClick) {
        self.jp_oneRowClick(self);
    }
}
- (void)twoButtonClick:(UIButton *)sender {
    if (self.jp_twoRowClick) {
        self.jp_twoRowClick(self);
    }
}
@end

@interface JPSearchFooterView ()

@end

@implementation JPSearchFooterView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.searchDealButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.searchDealButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(60));
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(600), JPRealValue(90)));
    }];
}

- (UIButton *)searchDealButton {
    if (!_searchDealButton) {
        _searchDealButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchDealButton setTitle:@"交易流水查询" forState:UIControlStateNormal];
        [_searchDealButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _searchDealButton.titleLabel.font = JP_DefaultsFont;
        _searchDealButton.layer.cornerRadius = JPRealValue(10);
        _searchDealButton.layer.masksToBounds = YES;
        [_searchDealButton setBackgroundImage:[UIImage imageNamed:@"jp_button_normal"] forState:UIControlStateNormal];
        [_searchDealButton setBackgroundImage:[UIImage imageNamed:@"jp_button_highlighted"] forState:UIControlStateHighlighted];
        [_searchDealButton addTarget:self action:@selector(searchDealClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchDealButton;
}

- (void)searchDealClick:(UIButton *)sender {
    if (self.jp_searchDealBlock) {
        self.jp_searchDealBlock();
    }
}
@end
