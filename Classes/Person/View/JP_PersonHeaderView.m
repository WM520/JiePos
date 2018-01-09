//
//  JP_PersonHeaderView.m
//  JiePos
//
//  Created by Jason_LJ on 2017/7/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JP_PersonHeaderView.h"

@interface JP_PersonHeaderView ()

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIView *currentView;
@property (nonatomic, strong) UIImageView *portraitView;
@property (nonatomic, strong) UILabel *merchatLab;
@property (nonatomic, strong) UIImageView *tagView;
@property (nonatomic, strong) UILabel *userLab;
@property (nonatomic, strong) UILabel *merchantNoLab;

@end

@implementation JP_PersonHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.currentView];
        [self.currentView addSubview:self.portraitView];
        [self.currentView addSubview:self.merchatLab];
        [self.currentView addSubview:self.tagView];
        [self.currentView addSubview:self.userLab];
        [self.currentView addSubview:self.merchantNoLab];
        
        if (![JPUserEntity sharedUserEntity].merchantNo) {
            self.tagView.hidden = YES;
        } else {
            self.tagView.hidden = NO;
        }
        
        NSString *merchatName = [JPUserEntity sharedUserEntity].merchantName;
        if (!merchatName) {
            merchatName = [JPUserEntity sharedUserEntity].account;
        }
        self.merchatLab.text = merchatName;
        self.userLab.text = [NSString stringWithFormat:@"账号：%@", [JPUserEntity sharedUserEntity].account];
        if ([JPUserEntity sharedUserEntity].merchantNo) {
            self.merchantNoLab.text = [NSString stringWithFormat:@"商户号：%@", [JPUserEntity sharedUserEntity].merchantNo];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(weakSelf.contentView);
        make.height.equalTo(@(JPRealValue(320)));
    }];
    [self.currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(60));
        make.centerY.equalTo(weakSelf.bgView.mas_bottom);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-60));
        make.height.equalTo(@(JPRealValue(160)));
    }];
    [self.portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.currentView.mas_centerY);
        make.left.equalTo(weakSelf.currentView.mas_left).offset(JPRealValue(60));
    }];
    [self.merchatLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.portraitView.mas_right).offset(JPRealValue(20));
        make.top.equalTo(weakSelf.portraitView.mas_top);
        make.right.lessThanOrEqualTo(weakSelf.currentView.mas_right).offset(-(JPRealValue(20) + JPRealValue(14) + JPRealValue(24)));
    }];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.merchatLab.mas_right).offset(JPRealValue(14));
        make.centerY.equalTo(weakSelf.merchatLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(24), JPRealValue(30)));
    }];
    [self.userLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.merchatLab.mas_left);
        if ([JPUserEntity sharedUserEntity].merchantNo) {
            make.centerY.equalTo(weakSelf.portraitView.mas_centerY).offset(JPRealValue(5));
        } else {
            make.bottom.equalTo(weakSelf.portraitView.mas_bottom);
        }
    }];
    [self.merchantNoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.merchatLab.mas_left);
        make.bottom.equalTo(weakSelf.portraitView.mas_bottom);
    }];
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
        _bgView.image = [UIImage imageNamed:@"jp_person_bg"];
    }
    return _bgView;
}

- (UIView *)currentView {
    if (!_currentView) {
        _currentView = [UIView new];
        _currentView.layer.cornerRadius = JPRealValue(10);
//        _currentView.layer.masksToBounds = YES;
        _currentView.layer.shadowColor = JPBaseColor.CGColor;
        _currentView.layer.shadowOffset = CGSizeMake(2, 2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _currentView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _currentView.layer.shadowRadius = 2;//阴影半径，默认3
        _currentView.backgroundColor = [UIColor whiteColor];
    }
    return _currentView;
}

- (UIImageView *)portraitView {
    if (!_portraitView) {
        _portraitView = [UIImageView new];
        _portraitView.image = [UIImage imageNamed:@"jp_person_portrait"];
    }
    return _portraitView;
}

- (UILabel *)merchatLab {
    if (!_merchatLab) {
        _merchatLab = [UILabel new];
        _merchatLab.font = JP_DefaultsFont;
        _merchatLab.textColor = JP_Content_Color;
    }
    return _merchatLab;
}

- (UIImageView *)tagView {
    if (!_tagView) {
        _tagView = [UIImageView new];
        _tagView.image = [UIImage imageNamed:@"jp_person_throughTag"];
    }
    return _tagView;
}

- (UILabel *)userLab {
    if (!_userLab) {
        _userLab = [UILabel new];
        _userLab.font = [UIFont systemFontOfSize:JPRealValue(24)];
        _userLab.textColor = JP_NoticeText_Color;
    }
    return _userLab;
}

- (UILabel *)merchantNoLab {
    if (!_merchantNoLab) {
        _merchantNoLab = [UILabel new];
        _merchantNoLab.font = [UIFont systemFontOfSize:JPRealValue(24)];
        _merchantNoLab.textColor = JP_NoticeText_Color;
    }
    return _merchantNoLab;
}

@end
