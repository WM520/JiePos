//
//  JPApplyUserInfoCell.m
//  JiePos
//
//  Created by Jason_LJ on 2017/5/25.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPUserInfoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>

// !!!: JPOnlyOneSelectCell
@implementation JPOnlyOneSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.tipView];
        [self.bgView addSubview:self.textLab];
    }
    return self;
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(50));
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-50));
        make.height.equalTo(@(JPRealValue(70)));
    }];
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-20));
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(16), JPRealValue(10)));
    }];
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
        make.right.equalTo(weakSelf.tipView.mas_left).offset(JPRealValue(-20));
        make.height.equalTo(@(JPRealValue(30)));
    }];
}
#pragma mark - Setter
- (void)setIsEditing:(BOOL)isEditing {
    weakSelf_declare;
    if (isEditing) {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.bgView.layer.borderColor = JPBaseColor.CGColor;
            weakSelf.tipView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.bgView.layer.borderColor = JP_LineColor.CGColor;
            self.bgView.backgroundColor = [UIColor whiteColor];
            weakSelf.tipView.transform = CGAffineTransformMakeRotation(0);
        }];
    }
}
#pragma mark - Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.layer.cornerRadius = JPRealValue(10);
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderWidth = 0.5;
        _bgView.layer.borderColor = JP_LineColor.CGColor;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
- (UIImageView *)tipView {
    if (!_tipView) {
        _tipView = [UIImageView new];
        _tipView.image = [UIImage imageNamed:@"jp_login_tip"];
        _tipView.userInteractionEnabled = YES;
    }
    return _tipView;
}
- (UILabel *)textLab {
    if (!_textLab) {
        _textLab = [UILabel new];
        _textLab.font = JP_DefaultsFont;
        _textLab.textColor = JP_NoticeText_Color;
    }
    return _textLab;
}
@end

// !!!: JPOnlyTwoSelectCell
@implementation JPOnlyTwoSelectCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        
        [self.contentView addSubview:self.leftButton];
        [self.contentView addSubview:self.rightButton];
        [self.leftButton addSubview:self.tipView1];
        [self.rightButton addSubview:self.tipView2];
        [self.leftButton addSubview:self.textLab1];
        [self.rightButton addSubview:self.textLab2];
    }
    return self;
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    CGFloat width = (kScreenWidth - JPRealValue(120)) / 2.0;
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-50));
        make.size.mas_equalTo(CGSizeMake(width, JPRealValue(70)));
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(50));
        make.right.equalTo(weakSelf.rightButton.mas_left).offset(JPRealValue(-20));
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.height.equalTo(@(JPRealValue(70)));
    }];
    
    [self.tipView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.leftButton.mas_right).offset(JPRealValue(-20));
        make.centerY.equalTo(weakSelf.leftButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(16), JPRealValue(10)));
    }];
    [self.tipView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.rightButton.mas_right).offset(JPRealValue(-20));
        make.centerY.equalTo(weakSelf.rightButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(16), JPRealValue(10)));
    }];
    [self.textLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.leftButton.mas_centerY);
        make.left.equalTo(weakSelf.leftButton.mas_left).offset(JPRealValue(20));
        make.right.equalTo(weakSelf.tipView1.mas_left).offset(JPRealValue(-20));
        make.height.equalTo(@(JPRealValue(30)));
    }];
    [self.textLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.rightButton.mas_centerY);
        make.left.equalTo(weakSelf.rightButton.mas_left).offset(JPRealValue(20));
        make.right.equalTo(weakSelf.tipView2.mas_left).offset(JPRealValue(-20));
        make.height.equalTo(@(JPRealValue(30)));
    }];
}
#pragma mark - Getter
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.tag = 10086;
        _leftButton.layer.cornerRadius = JPRealValue(10);
        _leftButton.layer.masksToBounds = YES;
        _leftButton.layer.borderWidth = 0.5;
        _leftButton.layer.borderColor = JP_LineColor.CGColor;
        _leftButton.backgroundColor = [UIColor whiteColor];
        [_leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.tag = 10010;
        _rightButton.layer.cornerRadius = JPRealValue(10);
        _rightButton.layer.masksToBounds = YES;
        _rightButton.layer.borderWidth = 0.5;
        _rightButton.layer.borderColor = JP_LineColor.CGColor;
        _rightButton.backgroundColor = [UIColor whiteColor];
        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
- (UIImageView *)tipView1 {
    if (!_tipView1) {
        _tipView1 = [UIImageView new];
        _tipView1.image = [UIImage imageNamed:@"jp_login_tip"];
        _tipView1.userInteractionEnabled = YES;
    }
    return _tipView1;
}
- (UIImageView *)tipView2 {
    if (!_tipView2) {
        _tipView2 = [UIImageView new];
        _tipView2.image = [UIImage imageNamed:@"jp_login_tip"];
        _tipView2.userInteractionEnabled = YES;
    }
    return _tipView2;
}
- (UILabel *)textLab1 {
    if (!_textLab1) {
        _textLab1 = [UILabel new];
        _textLab1.font = JP_DefaultsFont;
        _textLab1.textColor = JP_NoticeText_Color;
    }
    return _textLab1;
}
- (UILabel *)textLab2 {
    if (!_textLab2) {
        _textLab2 = [UILabel new];
        _textLab2.font = JP_DefaultsFont;
        _textLab2.textColor = JP_NoticeText_Color;
    }
    return _textLab2;
}

#pragma mark - Action
- (void)leftButtonClick:(UIButton *)sender {
    if (self.jpOnlyTwoSelect_leftBlock) {
        self.jpOnlyTwoSelect_leftBlock(sender, self.textLab1);
    }
}
- (void)rightButtonClick:(UIButton *)sender {
    if (self.jpOnlyTwoSelect_rightBlock) {
        self.jpOnlyTwoSelect_rightBlock(sender, self.textLab2);
    }
}
@end

// !!!: JPOneSelectCell
@implementation JPOneSelectCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.titleLab];
        [self.bgView addSubview:self.tipView];
        [self.bgView addSubview:self.textLab];
    }
    return self;
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(50));
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-50));
        make.height.equalTo(@(JPRealValue(70)));
    }];
    
    CGRect rect = [self.title boundingRectWithSize:CGSizeMake(MAXFLOAT, JPRealValue(30)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:JP_DefaultsFont} context:nil];
    float width = rect.size.width + JPRealValue(24);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.height.equalTo(@(JPRealValue(30)));
    }];
    
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-20));
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(16), JPRealValue(10)));
    }];
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.left.equalTo(weakSelf.titleLab.mas_right).offset(JPRealValue(20));
        make.right.equalTo(weakSelf.tipView.mas_left).offset(JPRealValue(-20));
        make.height.equalTo(@(JPRealValue(30)));
    }];
}

#pragma mark - Setter
- (void)setTitle:(NSString *)title {
    
    self.titleLab.text = title;
    _title = title;
}

- (void)setIsEditing:(BOOL)isEditing {
    weakSelf_declare;
    if (isEditing) {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.bgView.layer.borderColor = JPBaseColor.CGColor;
            weakSelf.tipView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.bgView.layer.borderColor = JP_LineColor.CGColor;
            self.bgView.backgroundColor = [UIColor whiteColor];
            weakSelf.tipView.transform = CGAffineTransformMakeRotation(0);
        }];
    }
}

#pragma mark - Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.layer.cornerRadius = JPRealValue(10);
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderWidth = 0.5;
        _bgView.layer.borderColor = JP_LineColor.CGColor;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
- (JPRequestLabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[JPRequestLabel alloc] initWithFrame:CGRectZero];
        _titleLab.font = JP_DefaultsFont;
        _titleLab.textColor = JP_Content_Color;
    }
    return _titleLab;
}
- (UIImageView *)tipView {
    if (!_tipView) {
        _tipView = [UIImageView new];
        _tipView.image = [UIImage imageNamed:@"jp_login_tip"];
        _tipView.userInteractionEnabled = YES;
    }
    return _tipView;
}
- (UILabel *)textLab {
    if (!_textLab) {
        _textLab = [UILabel new];
        _textLab.text = @"选择省/市/区/县";
        _textLab.font = JP_DefaultsFont;
        _textLab.textColor = JP_NoticeText_Color;
    }
    return _textLab;
}
@end

// !!!: JPTwoSelectCell
@implementation JPTwoSelectCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        
        [self.contentView addSubview:self.leftButton];
        [self.contentView addSubview:self.rightButton];
        [self.leftButton addSubview:self.titleLab];
        [self.leftButton addSubview:self.tipView1];
        [self.rightButton addSubview:self.tipView2];
        [self.leftButton addSubview:self.textLab1];
        [self.rightButton addSubview:self.textLab2];
    }
    return self;
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-50));
        make.size.mas_equalTo(CGSizeMake(JPRealValue(250), JPRealValue(70)));
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(50));
        make.right.equalTo(weakSelf.rightButton.mas_left).offset(JPRealValue(-20));
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.height.equalTo(@(JPRealValue(70)));
    }];
    
    CGRect rect = [self.title boundingRectWithSize:CGSizeMake(MAXFLOAT, JPRealValue(30)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:JP_DefaultsFont} context:nil];
    float width = rect.size.width + JPRealValue(24);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.left.equalTo(weakSelf.leftButton.mas_left).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.leftButton.mas_centerY);
        make.height.equalTo(@(JPRealValue(30)));
    }];
    
    [self.tipView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.leftButton.mas_right).offset(JPRealValue(-20));
        make.centerY.equalTo(weakSelf.leftButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(16), JPRealValue(10)));
    }];
    [self.tipView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.rightButton.mas_right).offset(JPRealValue(-20));
        make.centerY.equalTo(weakSelf.rightButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(16), JPRealValue(10)));
    }];
    [self.textLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.leftButton.mas_centerY);
        make.left.equalTo(weakSelf.titleLab.mas_right).offset(JPRealValue(20));
        make.right.equalTo(weakSelf.tipView1.mas_left).offset(JPRealValue(-20));
        make.height.equalTo(@(JPRealValue(30)));
    }];
    [self.textLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.rightButton.mas_centerY);
        make.left.equalTo(weakSelf.rightButton.mas_left).offset(JPRealValue(20));
        make.right.equalTo(weakSelf.tipView2.mas_left).offset(JPRealValue(-20));
        make.height.equalTo(@(JPRealValue(30)));
    }];
}

#pragma mark - Setter
- (void)setTitle:(NSString *)title {
    
    self.titleLab.text = title;
    _title = title;
}

#pragma mark - Getter
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.tag = 10086;
        _leftButton.layer.cornerRadius = JPRealValue(10);
        _leftButton.layer.masksToBounds = YES;
        _leftButton.layer.borderWidth = 0.5;
        _leftButton.layer.borderColor = JP_LineColor.CGColor;
        _leftButton.backgroundColor = [UIColor whiteColor];
        [_leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.tag = 10010;
        _rightButton.layer.cornerRadius = JPRealValue(10);
        _rightButton.layer.masksToBounds = YES;
        _rightButton.layer.borderWidth = 0.5;
        _rightButton.layer.borderColor = JP_LineColor.CGColor;
        _rightButton.backgroundColor = [UIColor whiteColor];
        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
- (JPRequestLabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[JPRequestLabel alloc] initWithFrame:CGRectZero];
        _titleLab.font = JP_DefaultsFont;
        _titleLab.textColor = JP_Content_Color;
    }
    return _titleLab;
}
- (UIImageView *)tipView1 {
    if (!_tipView1) {
        _tipView1 = [UIImageView new];
        _tipView1.image = [UIImage imageNamed:@"jp_login_tip"];
        _tipView1.userInteractionEnabled = YES;
    }
    return _tipView1;
}
- (UIImageView *)tipView2 {
    if (!_tipView2) {
        _tipView2 = [UIImageView new];
        _tipView2.image = [UIImage imageNamed:@"jp_login_tip"];
        _tipView2.userInteractionEnabled = YES;
    }
    return _tipView2;
}
- (UILabel *)textLab1 {
    if (!_textLab1) {
        _textLab1 = [UILabel new];
        _textLab1.font = JP_DefaultsFont;
        _textLab1.textColor = JP_NoticeText_Color;
    }
    return _textLab1;
}
- (UILabel *)textLab2 {
    if (!_textLab2) {
        _textLab2 = [UILabel new];
        _textLab2.font = JP_DefaultsFont;
        _textLab2.textColor = JP_NoticeText_Color;
    }
    return _textLab2;
}

#pragma mark - Action
- (void)leftButtonClick:(UIButton *)sender {
    if (self.jpTwoSelect_leftBlock) {
        self.jpTwoSelect_leftBlock(sender, self.textLab1);
    }
}
- (void)rightButtonClick:(UIButton *)sender {
    if (self.jpTwoSelect_rightBlock) {
        self.jpTwoSelect_rightBlock(sender, self.textLab2);
    }
}
@end

// !!!: JPInputCell
@implementation JPInputCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.titleLab];
        [self.bgView addSubview:self.inputField];
    }
    return self;
}

#pragma mark - Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.layer.cornerRadius = JPRealValue(10);
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderWidth = 0.5;
        _bgView.layer.borderColor = JP_LineColor.CGColor;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (JPRequestLabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[JPRequestLabel alloc] initWithFrame:CGRectZero];
        _titleLab.font = JP_DefaultsFont;
        _titleLab.textColor = JP_Content_Color;
    }
    return _titleLab;
}

- (UITextField *)inputField {
    if (!_inputField) {
        if (!_inputField) {
            _inputField = [UITextField new];
            _inputField.font = JP_DefaultsFont;
            _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _inputField.textColor = JP_Content_Color;
            [_inputField setValue:JP_NoticeText_Color forKeyPath:@"_placeholderLabel.textColor"];
            [_inputField setValue:JP_DefaultsFont forKeyPath:@"_placeholderLabel.font"];
            
            //监听开始编辑状态
            [_inputField addTarget:self action:@selector(startEditing) forControlEvents:UIControlEventEditingDidBegin];// 可在自定义selector处
            //监听编辑完成的状态
            [_inputField addTarget:self action:@selector(endEditing) forControlEvents:UIControlEventEditingDidEnd];// 可在自定义selector处
        }
    }
    return _inputField;
}

#pragma mark - Setter
- (void)setTitle:(NSString *)title {
    
    self.titleLab.text = title;
    _title = title;
}

#pragma mark - Methods
- (void)startEditing {
    self.bgView.layer.borderColor = JPBaseColor.CGColor;
}

- (void)endEditing {
    self.bgView.layer.borderColor = JP_LineColor.CGColor;
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(50));
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-50));
        make.height.equalTo(@(JPRealValue(70)));
    }];

    CGRect rect = [self.title boundingRectWithSize:CGSizeMake(MAXFLOAT, JPRealValue(30)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:JP_DefaultsFont} context:nil];
    float width = rect.size.width + JPRealValue(24);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.size.mas_equalTo((CGSize){width, JPRealValue(30)});
    }];
    
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab.mas_right).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-20));
        make.height.equalTo(weakSelf.bgView.mas_height);
    }];
}

@end

// !!!: JPOnlyInputCell
@implementation JPOnlyInputCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.inputField];
    }
    return self;
}
#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(50));
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-50));
        make.height.equalTo(@(JPRealValue(70)));
    }];
    
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-20));
        make.height.equalTo(weakSelf.bgView.mas_height);
    }];
}

#pragma mark - Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.layer.cornerRadius = JPRealValue(10);
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderWidth = 0.5;
        _bgView.layer.borderColor = JP_LineColor.CGColor;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
- (UITextField *)inputField {
    if (!_inputField) {
        _inputField = [UITextField new];
        _inputField.font = JP_DefaultsFont;
        _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputField.textColor = JP_Content_Color;
        [_inputField setValue:JP_NoticeText_Color forKeyPath:@"_placeholderLabel.textColor"];
        [_inputField setValue:JP_DefaultsFont forKeyPath:@"_placeholderLabel.font"];
        
        //监听开始编辑状态
        [_inputField addTarget:self action:@selector(startEditing) forControlEvents:UIControlEventEditingDidBegin];// 可在自定义selector处
        //监听编辑完成的状态
        [_inputField addTarget:self action:@selector(endEditing) forControlEvents:UIControlEventEditingDidEnd];// 可在自定义selector处
    }
    return _inputField;
}

#pragma mark - Methods
- (void)startEditing {
    self.bgView.layer.borderColor = JPBaseColor.CGColor;
}

- (void)endEditing {
    self.bgView.layer.borderColor = JP_LineColor.CGColor;
}

@end

// !!!: JPCateSelectCell
@implementation JPCateSelectCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.titleLab];
        [self.bgView addSubview:self.leftButton];
        [self.bgView addSubview:self.rightButton];
    }
    return self;
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(50));
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-50));
        make.height.equalTo(@(JPRealValue(70)));
    }];
    
    CGRect rect = [self.title boundingRectWithSize:CGSizeMake(MAXFLOAT, JPRealValue(30)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:JP_DefaultsFont} context:nil];
    float width = rect.size.width + JPRealValue(24);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.height.equalTo(@(JPRealValue(30)));
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab.mas_right).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.titleLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(140), JPRealValue(50)));
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftButton.mas_right).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.titleLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(JPRealValue(140), JPRealValue(50)));
    }];
}

#pragma mark - Setter
- (void)setTitle:(NSString *)title {
    
    self.titleLab.text = title;
    _title = title;
}

- (void)setLeftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle {
    [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
    [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
}

#pragma mark - Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
    }
    return _bgView;
}
- (JPRequestLabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[JPRequestLabel alloc] initWithFrame:CGRectZero];
        _titleLab.font = JP_DefaultsFont;
        _titleLab.textColor = JP_Content_Color;
    }
    return _titleLab;
}
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [JPSelectButton buttonWithType:UIButtonTypeCustom];
        _leftButton.selected = YES;
        _leftButton.tag = 666;
        [_leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [JPSelectButton buttonWithType:UIButtonTypeCustom];
        _rightButton.selected = NO;
        _rightButton.tag = 888;
        [_rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

#pragma mark - Action
- (void)buttonClick:(JPSelectButton *)sender {
    if (self.jp_cateSelectBlock) {
        self.jp_cateSelectBlock(sender.tag);
    }
}
@end

//  !!!: - JPCredentialsCell
@interface JPCredentialsCell ()
/** 过渡色*/
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
/** 渐变色视图提示标签*/
@property (nonatomic, strong) UILabel *promotLab;
/** 删除按钮*/
@property (nonatomic, strong) UIButton *deleteButton;
/** 右上角角标*/
@property (nonatomic, strong) UIImageView *triangleView;
@end
@implementation JPCredentialsCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.addView];
        [self.contentView addSubview:self.imgNameLab];
        [self.contentView addSubview:self.promotLab];
        [self.contentView addSubview:self.triangleView];
        [self.contentView addSubview:self.deleteButton];
        
        [self.contentView bringSubviewToFront:self.triangleView];
        [self.contentView bringSubviewToFront:self.deleteButton];
        [self.contentView bringSubviewToFront:self.promotLab];
        [self.promotLab.layer addSublayer:self.gradientLayer];
    }
    return self;
}

#pragma mark - Setter
- (void)setImgUrl:(NSString *)imgUrl {
    
    if (imgUrl.length <= 0) {
        self.bgView.image = [UIImage imageNamed:@"jp_login_registerCertificationBg"];
        self.hasImage = NO;
        self.valueHasChange = YES;
    } else {
        [self.bgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        self.hasImage = YES;
        self.valueHasChange = NO;
    }
}

- (void)setImage:(UIImage *)image {
    
    if (!image) {
        self.bgView.image = [UIImage imageNamed:@"jp_login_registerCertificationBg"];
        self.hasImage = NO;
        self.valueHasChange = NO;
    } else {
        self.bgView.image = image;
        self.hasImage = YES;
        self.valueHasChange = YES;
    }
}

- (void)setPlaceholderName:(NSString *)placeholderName {
    self.imgNameLab.text = placeholderName;
    self.promotLab.text = placeholderName;
}

- (void)setCanEditing:(BOOL)canEditing {
    
    self.deleteButton.hidden = !canEditing;
    
    _canEditing = canEditing;
}

- (void)setHasImage:(BOOL)hasImage {
    
    self.addView.hidden = hasImage;
    self.imgNameLab.hidden = hasImage;
    self.promotLab.hidden = !hasImage;
    self.deleteButton.hidden = !self.canEditing ? YES : hasImage ? NO : YES;
    
    _hasImage = hasImage;
}

- (void)setIsNeed:(BOOL)isNeed {
    self.triangleView.hidden = !isNeed;
    _isNeed = isNeed;
}


#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    float margin = JPRealValue(180) / 3.0;
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(40));
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-40));
        make.left.and.bottom.equalTo(weakSelf.contentView);
    }];
    [self.addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgView.mas_centerX);
        make.centerY.equalTo(weakSelf.bgView.mas_top).offset(margin);
    }];
    [self.imgNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgView.mas_centerX);
        make.centerY.equalTo(weakSelf.bgView.mas_top).offset(margin * 2);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, JPRealValue(24)));
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-40));
        make.centerY.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(40));
        make.size.mas_equalTo(CGSizeMake(JPRealValue(80), JPRealValue(80)));
    }];
    [self.triangleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right);
        make.top.equalTo(weakSelf.bgView.mas_top);
    }];
    [self.promotLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-40));
        make.height.equalTo(@20);
    }];
    self.gradientLayer.frame = CGRectMake(0, 0, self.promotLab.frame.size.width, self.promotLab.frame.size.height);
}

#pragma mark - Getter
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
        UIImage *image = [UIImage imageNamed:@"jp_login_registerCertificationBg"];
        _bgView.image = image;
    }
    return _bgView;
}
- (UIImageView *)addView {
    if (!_addView) {
        _addView = [UIImageView new];
        _addView.image = [UIImage imageNamed:@"jp_login_copy"];
    }
    return _addView;
}
- (UILabel *)imgNameLab {
    if (!_imgNameLab) {
        _imgNameLab = [UILabel new];
        _imgNameLab.font = [UIFont systemFontOfSize:JPRealValue(24)];
        _imgNameLab.textAlignment = NSTextAlignmentCenter;
        _imgNameLab.textColor = JP_Content_Color;
    }
    return _imgNameLab;
}
- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[UIColor colorWithHexString:@"777777"].CGColor];
        _gradientLayer.locations = @[@0, @1.0];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1.0);
    }
    return _gradientLayer;
}
- (UILabel *)promotLab {
    if (!_promotLab) {
        _promotLab = [UILabel new];
        _promotLab.font = [UIFont systemFontOfSize:JPRealValue(24)];
        _promotLab.textAlignment = NSTextAlignmentCenter;
        _promotLab.textColor = [UIColor whiteColor];
    }
    return _promotLab;
}
- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"jp_person_deleteImage"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(handleDeleteImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}
- (UIImageView *)triangleView {
    if (!_triangleView) {
        _triangleView = [UIImageView new];
        _triangleView.image = [UIImage imageNamed:@"jp_login_request"];
    }
    return _triangleView;
}

#pragma mark - Action
- (void)handleDeleteImage:(UIButton *)sender {
    if (self.credentialsDeleteImageBlock) {
        [self setImgUrl:@""];
        self.valueHasChange = YES;
        self.credentialsDeleteImageBlock(self);
    }
}

@end

//  !!!: - JPRemarkCell
@interface JPRemarkCell () <UITextViewDelegate> {
    NSString *_remarkString;
}
/** 备注信息输入框*/
@property (nonatomic, strong) UITextView *txtView;
/** 备注*/
@property (nonatomic, strong) UILabel *remarkLab;
/** 文本计数*/
@property (nonatomic, strong) UILabel *numLab;
@end
@implementation JPRemarkCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.txtView];
        [self.txtView addSubview:self.remarkLab];
        [self.bgView addSubview:self.numLab];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:self.txtView];
    }
    return self;
}

/**
 *  设置输入超过三行（高度78）自动滚入不可见区域
 *
 *  @param notification <#notification description#>
 */
//- (void)textViewTextDidChange:(NSNotification *)notification {
//    
//    //不输入换行
//    if ([self.txtView.text hasSuffix:@"\n"]) {
//        NSMutableString * textViewStr = [NSMutableString stringWithString:self.txtView.text];
//        [textViewStr deleteCharactersInRange:NSMakeRange(textViewStr.length - 1, 1)];
//        self.txtView.text = textViewStr;
//    }
//    if (self.txtView.text.length >= 51) {
//        self.txtView.text = self.remarkString;
//        
//        //切记：千万不可使用下面的语句否则，当字数到50字符后，无法弹出键盘重新编辑。
//        //      self.txtView.editable = NO;
//        return;
//    } else {
//        self.numLab.textColor = JP_NoticeText_Color;
//    }
//    //不以空格开头
//    if ([self.txtView.text hasPrefix:@" "]) {
//        NSMutableString * textViewStr = [NSMutableString stringWithString:self.txtView.text ];
//        [textViewStr deleteCharactersInRange:NSMakeRange(0, 1)];
//        self.txtView.text = textViewStr;
//    }
//    //不以三个空格结尾
//    if ([self.txtView.text hasSuffix:@"   "]) {
//        NSMutableString * textViewStr = [NSMutableString stringWithString:self.txtView.text];
//        [textViewStr deleteCharactersInRange:NSMakeRange(textViewStr.length - 2, 1)];
//        self.txtView.text = textViewStr;
//    }
//    self.numLab.text = [NSString stringWithFormat:@"%ld/50", (long)(self.txtView.text.length)];
//    if ( [self.numLab.text isEqualToString:@"50/50"]) {
//        self.numLab.textColor = JP_NoticeRedColor;
//    } else {
//        self.numLab.textColor = JP_NoticeText_Color;
//    }
//    self.remarkString = self.txtView.text;
//    
////    if([self.txtView.text hasPrefix:@" "]){
////        self.txtView.text = [self.txtView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
////    }
////    JPLog(@"|%@ - %ld", self.txtView.text, (unsigned long)self.txtView.text.length);
////    if (self.txtView.text.length > 50) {
////        self.txtView.text = [self.txtView.text substringToIndex:50];
////    }
////    self.numLab.text = [NSString stringWithFormat:@"%lu/50", 50 - self.txtView.text.length];
////    self.remarkString = self.txtView.text;
////    return;
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(JPRealValue(15));
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(50));
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-50));
    }];
    [self.txtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
        make.top.equalTo(weakSelf.bgView.mas_top).offset(JPRealValue(20));
        make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-20));
        make.height.equalTo(@(JPRealValue(160)));
    }];
    [self.remarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.txtView.mas_top).offset(JPRealValue(10));
        make.left.equalTo(weakSelf.txtView.mas_left).offset (JPRealValue(10));
        make.size.mas_equalTo(CGSizeMake(JPRealValue(100), JPRealValue(50)));
    }];
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.txtView.mas_right);
        make.top.equalTo(weakSelf.txtView.mas_bottom);
        make.height.equalTo(@(JPRealValue(20)));
    }];
}

- (void)setRemarkString:(NSString *)remarkString {
    
    self.txtView.text = remarkString;
    self.numLab.text = [NSString stringWithFormat:@"%lu/50", 50 - remarkString.length];
    _remarkString = remarkString;
}

- (NSString *)remarkString {
    if (self.txtView.text.length > 0) {
        _remarkString = [self.txtView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return _remarkString;
}

- (void)setCanEdit:(BOOL)canEdit {
    self.txtView.userInteractionEnabled = canEdit;
    _canEdit = canEdit;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.layer.cornerRadius = JPRealValue(10);
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderWidth = 0.5;
        _bgView.layer.borderColor = JP_LineColor.CGColor;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UITextView *)txtView {
    if (!_txtView) {
        _txtView = [UITextView new];
        _txtView.scrollEnabled = NO;
        //  初始化给个空格的占位字符，否则光标会出现在textView最左边
        _txtView.text = @" ";
        _txtView.delegate = self;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 3;    //行间距
        paragraphStyle.firstLineHeadIndent = JPRealValue(100);    /**首行缩进宽度*/
        paragraphStyle.alignment = NSTextAlignmentJustified;
        NSDictionary *attributes = @{
                                     NSFontAttributeName:JP_DefaultsFont,
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     NSForegroundColorAttributeName:
                                         JP_Content_Color
                                     };
        _txtView.attributedText = [[NSAttributedString alloc] initWithString:_txtView.text attributes:attributes];
    }
    return _txtView;
}

- (UILabel *)remarkLab {
    if (!_remarkLab) {
        _remarkLab = [UILabel new];
        _remarkLab.text = @"备注";
        _remarkLab.font = JP_DefaultsFont;
        _remarkLab.textColor = JP_Content_Color;
        [self.bgView addSubview:_remarkLab];
    }
    return _remarkLab;
}

- (UILabel *)numLab {
    if (!_numLab) {
        _numLab = [UILabel new];
        _numLab.text = @"0/50";
        _numLab.font = [UIFont systemFontOfSize:JPRealValue(18)];
        _numLab.textColor = JP_NoticeText_Color;
        _numLab.textAlignment = NSTextAlignmentRight;
    }
    return _numLab;
}

- (void)textViewDidChange:(UITextView *)textView {

    //计算剩余字数   不需要的也可不写
    
    NSString *nsTextCotent = textView.text;
    int existTextNum = (int)[nsTextCotent length];
    int remainTextNum = 50 - existTextNum;
    self.numLab.text = [NSString stringWithFormat:@"%d/50",remainTextNum];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return YES;
    } else {
        if (range.location >= 50) {
            return  NO;
        } else {
            return YES;
        }
    }
}


//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 30;    //行间距
//    paragraphStyle.maximumLineHeight = 60;   /**最大行高*/
//    paragraphStyle.firstLineHeadIndent = 100.f;    /**首行缩进宽度*/
//    paragraphStyle.alignment = NSTextAlignmentJustified;
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
//                                 NSParagraphStyleAttributeName:paragraphStyle
//                                 };
//    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
//}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end


// !!!: JPTxtViewCell
@implementation JPTxtViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = JP_viewBackgroundColor;
        
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.titleLab];
        [self.bgView addSubview:self.txtView];
    }
    return self;
}

#pragma mark - Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.layer.cornerRadius = JPRealValue(10);
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderWidth = 0.5;
        _bgView.layer.borderColor = JP_LineColor.CGColor;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (JPRequestLabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[JPRequestLabel alloc] initWithFrame:CGRectZero];
        _titleLab.font = JP_DefaultsFont;
        _titleLab.textColor = JP_Content_Color;
    }
    return _titleLab;
}

- (IQTextView *)txtView {
    if (!_txtView) {
        _txtView = [IQTextView new];
        _txtView.font = JP_DefaultsFont;
        _txtView.textColor = JP_Content_Color;
//        _txtView.placeholderTextColor = JP_NoticeText_Color;
//        _txtView.placeholderFont = JP_DefaultsFont;
    }
    return _txtView;
}

#pragma mark - Setter
- (void)setTitle:(NSString *)title {
    
    self.titleLab.text = title;
    _title = title;
}

#pragma mark - Methods
- (void)startEditing {
    self.bgView.layer.borderColor = JPBaseColor.CGColor;
}

- (void)endEditing {
    self.bgView.layer.borderColor = JP_LineColor.CGColor;
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(JPRealValue(15), JPRealValue(50), JPRealValue(15), JPRealValue(50)));
    }];
    
    CGRect rect = [self.title boundingRectWithSize:CGSizeMake(MAXFLOAT, JPRealValue(30)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:JP_DefaultsFont} context:nil];
    float width = rect.size.width + JPRealValue(24);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.size.mas_equalTo((CGSize){width, JPRealValue(30)});
    }];
    
    [self.txtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab.mas_right).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
        make.right.equalTo(weakSelf.bgView.mas_right).offset(JPRealValue(-20));
        make.height.equalTo(weakSelf.bgView.mas_height);
    }];
}

@end

