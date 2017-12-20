//
//  JP_LoginNoticeView.m
//  JiePos
//
//  Created by Jason_LJ on 2017/7/12.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JP_LoginNoticeView.h"

@interface JP_LoginNoticeView ()
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *titleLab;
@end
@implementation JP_LoginNoticeView
- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title {
    self = [super init];
    if (self) {
        [self addSubview:self.logoView];
        [self addSubview:self.titleLab];
        
        self.logoView.image = image;
        self.titleLab.text = title;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.bottom.equalTo(weakSelf);
//        make.width.equalTo(@(JPRealValue(23)));
        make.size.mas_equalTo(CGSizeMake(JPRealValue(23), JPRealValue(29)));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.and.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf.logoView.mas_right).offset(JPRealValue(20));
    }];
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
        _titleLab.font = [UIFont boldSystemFontOfSize:JPRealValue(30)];
        _titleLab.textColor = [UIColor colorWithHexString:@"7a93f5"];
    }
    return _titleLab;
}
@end
