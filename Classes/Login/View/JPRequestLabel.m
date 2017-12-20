//
//  JPRequestLabel.m
//  JiePos
//
//  Created by Jason_LJ on 2017/5/22.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPRequestLabel.h"

#define starWidth  JPRealValue(24)

@interface JPRequestLabel ()
@property (nonatomic, strong) UILabel *starLabel;
@end
@implementation JPRequestLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.starLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf.mas_top);
        make.size.mas_equalTo(CGSizeMake(starWidth, starWidth));
    }];
}

- (UILabel *)starLabel {
    if (!_starLabel) {
        _starLabel = [UILabel new];
        _starLabel.text = @"*";
        _starLabel.font = [UIFont systemFontOfSize:starWidth];
        _starLabel.textColor = [UIColor redColor];
    }
    return _starLabel;
}

@end
