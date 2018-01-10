//
//  IBMenuView.m
//  JPDatePicker
//
//  Created by iBlocker on 2017/8/16.
//  Copyright © 2017年 iBlocker. All rights reserved.
//

#import "IBMenuView.h"
#import <Masonry/Masonry.h>

@interface IBLinkButton : UIButton {
    UIColor *lineColor;
}

- (void)setLineColor:(UIColor*)color;

@end

@implementation IBLinkButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setLineColor:(UIColor *)color {
    lineColor = [color copy];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGRect textRect = self.titleLabel.frame;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGFloat descender = self.titleLabel.font.descender;
    if([lineColor isKindOfClass:[UIColor class]]) {
        CGContextSetStrokeColorWithColor(contextRef, lineColor.CGColor);
    }
    
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender + 1 + 10);
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender + 1 + 10);
    
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathStroke);
}

@end

@interface IBMenuView ()

@property (nonatomic, strong) UILabel *wordLab;
@property (nonatomic, strong) IBLinkButton *leftButton;
@property (nonatomic, strong) IBLinkButton *rightButton;
@property (nonatomic, assign) NSInteger lastTag;

@end

@implementation IBMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isLeft = YES;
        self.lastTag = 10000;
        [self addSubview:self.wordLab];
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    __weak typeof(self) weakSelf = self;
    [self.wordLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(15);
        make.top.and.bottom.equalTo(weakSelf);
        make.right.equalTo(weakSelf.wordLab.mas_left).offset(-20);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-15);
        make.top.and.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf.wordLab.mas_right).offset(20);
    }];
}

#pragma mark - Setter
- (void)setLeftDate:(NSString *)leftDate {
    if (leftDate) {
        [self.leftButton setTitle:leftDate forState:UIControlStateNormal];
    }
    _leftDate = leftDate;
}
- (void)setRightDate:(NSString *)rightDate {
    if (rightDate) {
        [self.rightButton setTitle:rightDate forState:UIControlStateNormal];
    }
    _rightDate = rightDate;
}

#pragma mark - Getter
- (UILabel *)wordLab {
    if (!_wordLab) {
        _wordLab = [UILabel new];
        _wordLab.text = @"至";
        _wordLab.textColor = JP_NoticeText_Color;
        _wordLab.font = JP_DefaultsFont;
    }
    return _wordLab;
}

- (IBLinkButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [IBLinkButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setTitle:[NSDate stringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        [_leftButton setTitleColor:JPBaseColor forState:UIControlStateNormal];
        [_leftButton setLineColor:JPBaseColor];
        _leftButton.titleLabel.font = JP_DefaultsFont;
        _leftButton.tag = 10000;
        [_leftButton addTarget:self action:@selector(linkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (IBLinkButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [IBLinkButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitle:[NSDate stringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        [_rightButton setTitleColor:JP_Dark_Color forState:UIControlStateNormal];
        [_rightButton setLineColor:JP_LineColor];
        _rightButton.titleLabel.font = JP_DefaultsFont;
        _rightButton.tag = 10010;
        [_rightButton addTarget:self action:@selector(linkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

#pragma mark - Action
- (void)linkButtonClick:(IBLinkButton *)sender {
    if (sender.tag == self.lastTag) {
        
    } else {
        [sender setTitleColor:JPBaseColor forState:UIControlStateNormal];
        [sender setLineColor:JPBaseColor];
        
        IBLinkButton *lastButton = (IBLinkButton *)[self viewWithTag:self.lastTag];
        [lastButton setTitleColor:JP_Dark_Color forState:UIControlStateNormal];
        [lastButton setLineColor:JP_LineColor];
        
        self.isLeft = sender.tag == 10000;
        if (self.selectBlock) {
            self.selectBlock(sender.tag == 10000);
        }
    }
    self.lastTag = sender.tag;
}

@end
