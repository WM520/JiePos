//
//  JPDealStateView.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/18.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPDealStateView.h"

@interface JPDealStateView ()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *circleView;
/** 交易金额*/
@property (nonatomic, strong) UILabel *ammountLab;
@property (nonatomic, strong) UIView *lineView;
/** 交易类型*/
@property (nonatomic, strong) UILabel *typeLab;
@end

@implementation JPDealStateView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.circleView];
        [self.circleView addSubview:self.lineView];
        [self.circleView addSubview:self.ammountLab];
        [self.circleView addSubview:self.typeLab];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(weakSelf.contentView);
    }];
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.centerY.equalTo(weakSelf.bgView.mas_bottom);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.circleView.mas_centerX);
        make.centerY.equalTo(weakSelf.circleView.mas_centerY);
        make.size.mas_equalTo((CGSize){50, 1});
    }];
    [self.ammountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.circleView.mas_left).offset(JPRealValue(20));
        make.right.equalTo(weakSelf.circleView.mas_right).offset(JPRealValue(-20));
        make.bottom.equalTo(weakSelf.lineView.mas_top).offset(JPRealValue(-20));
    }];
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.ammountLab.mas_left);
        make.right.equalTo(weakSelf.ammountLab.mas_right);
        make.top.equalTo(weakSelf.lineView.mas_bottom).offset(JPRealValue(20));
    }];
    [self layoutIfNeeded];
}
- (void)setType:(JP_DealType)type {
    if (self.ammount.length > 4) {
        self.ammountLab.font = [UIFont systemFontOfSize:JPRealValue(40)];
    } else {
        self.ammountLab.font = [UIFont systemFontOfSize:JPRealValue(50)];
    }
    if (type == JP_DealTypeCollection) {
        self.ammountLab.text = [NSString stringWithFormat:@"+%@", self.ammount];
        self.typeLab.text = @"收款金额(元)";
    } else {
        self.ammountLab.text = [NSString stringWithFormat:@"-%@", self.ammount];
        self.typeLab.text = @"退款金额(元)";
    }
}
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
        _bgView.image = [UIImage imageNamed:@"jp_news_deatailBg"];
    }
    return _bgView;
}
- (UIImageView *)circleView {
    if (!_circleView) {
        _circleView = [UIImageView new];
        _circleView.image = [UIImage imageNamed:@"jp_news_ammoubtBg"];
    }
    return _circleView;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"466ed2"];
    }
    return _lineView;
}
- (UILabel *)ammountLab {
    if (!_ammountLab) {
        _ammountLab = [UILabel new];
        _ammountLab.font = [UIFont systemFontOfSize:JPRealValue(50)];
        _ammountLab.textColor = [UIColor colorWithHexString:@"466ed2"];
        _ammountLab.textAlignment = NSTextAlignmentCenter;
    }
    return _ammountLab;
}
- (UILabel *)typeLab {
    if (!_typeLab) {
        _typeLab = [UILabel new];
        _typeLab.font = [UIFont systemFontOfSize:JPRealValue(26)];
        _typeLab.textColor = [UIColor colorWithHexString:@"84a0e7"];
        _typeLab.textAlignment = NSTextAlignmentCenter;
    }
    return _typeLab;
}
@end

