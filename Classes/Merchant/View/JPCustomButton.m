//
//  JPCustomButton.m
//  JiePos
//
//  Created by wangmiao on 2017/12/21.
//  Copyright © 2017年 WangMiao. All rights reserved.
//

#import "JPCustomButton.h"

@interface JPCustomButton()

@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * textLabel;
@property (nonatomic, strong) UIImageView * indicatorView;
@property (nonatomic, strong) UIImageView * clearImageView;

@end

@implementation JPCustomButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithIconView:(NSString *)iconView
                      textString:(NSString *)textString
                   indicatorView:(NSString *)indicatorView
{
    self = [super init];
    if (self) {
        self.backgroundColor = RGB(248, 249, 254);
        self.layer.cornerRadius = 30;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor colorWithHexString:@"#7A93F5"] CGColor];
        _iconView = [[UIImageView alloc] init];
        _iconView.image = [UIImage imageNamed:iconView];
        [self addSubview:_iconView];
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = textString;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:20];
        _textLabel.textColor = RGB(51, 51, 51);
        [self addSubview:_textLabel];
        _indicatorView = [[UIImageView alloc] init];
        _indicatorView.contentMode = UIViewContentModeCenter;
        _indicatorView.image = [UIImage imageNamed:indicatorView];
        [self addSubview:_indicatorView];
        
        _clearImageView = [[UIImageView alloc] init];
        _clearImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigMap:)];
    
        [_clearImageView addGestureRecognizer:recognizer];
        [self addSubview:_clearImageView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    _iconView = [[UIImageView alloc] init];
    [self addSubview:_iconView];
    _textLabel = [[UILabel alloc] init];
    _textLabel.text = @"无注册收款码";
    _textLabel.textColor = RGB(51, 51, 51);
    [self addSubview:_textLabel];
    _indicatorView = [[UIImageView alloc] init];
    [self addSubview:_indicatorView];
}

- (void)setNeedsDisplay
{
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(30);
        make.centerY.equalTo(self);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
    }];
    
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-40);
        make.centerY.equalTo(self);
        make.width.equalTo(@14);
        make.height.equalTo(@28);
    }];
    
    [_clearImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)bigMap:(UITapGestureRecognizer*)gestureRecognizer
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}


@end
