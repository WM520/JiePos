//
//  JPDealMoneyView.m
//  JiePos
//
//  Created by iBlocker on 2017/8/14.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPDealMoneyView.h"

@interface JPDealMoneyView ()
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *moneyLab;
@end
@implementation JPDealMoneyView
- (instancetype)initWithFrame:(CGRect)frame
                        image:(UIImage *)image
                        title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JP_viewBackgroundColor;
        
        [self addSubview:self.logoView];
        [self addSubview:self.titleLab];
        [self addSubview:self.moneyLab];
        
        self.logoView.image = image;
        self.titleLab.text = title;
    }
    return self;
}

- (void)setMoney:(NSString *)money {
    NSString *numStr = [NSString stringWithFormat:@"%@元", money];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:numStr];
    
    NSRange range = NSMakeRange([numStr length] - 1, 1);
    [attributeString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:JPRealValue(30)]} range:range];
    self.moneyLab.attributedText = attributeString;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(44), JPRealValue(44)));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.logoView.mas_right).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(270), JPRealValue(30)));
    }];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab.mas_right);
        make.right.equalTo(weakSelf.mas_right).offset(JPRealValue(-20));
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    [self layoutIfNeeded];
}
- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [UIImageView new];
    }
    return _logoView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = JP_DefaultsFont;
        _titleLab.textColor = JP_Content_Color;
    }
    return _titleLab;
}
- (UILabel *)moneyLab {
    if (!_moneyLab) {
        _moneyLab = [UILabel new];
        _moneyLab.textColor = JP_Content_Color;
        _moneyLab.textAlignment = NSTextAlignmentRight;
        _moneyLab.font = [UIFont boldSystemFontOfSize:JPRealValue(44)];
        _moneyLab.adjustsFontSizeToFitWidth = YES;
    }
    return _moneyLab;
}
@end
