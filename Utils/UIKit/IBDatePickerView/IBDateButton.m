//
//  IBDateButton.m
//  JPDatePickerDemo
//
//  Created by iBlocker on 2017/8/15.
//  Copyright © 2017年 iBlocker. All rights reserved.
//

#import "IBDateButton.h"
static NSInteger count = 0;

@implementation IBDateButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = self.frame.size.height / 2.0f;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
        self.layer.borderWidth = 0.5;
        
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setImage:[UIImage imageNamed:@"jp_cash_change"] forState:UIControlStateNormal];
        if (count % 2 == 0) {
            [self setTitle:@"按日查询" forState:UIControlStateNormal];
            [self setTitleColor:JP_Dark_Color forState:UIControlStateNormal];
            self.isDay = YES;
        } else {
            [self setTitle:@"按月查询" forState:UIControlStateNormal];
            [self setTitleColor:JP_Dark_Color forState:UIControlStateNormal];
            self.isDay = NO;
        }
        
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, -10);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
        
        [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)buttonClick:(UIButton *)sender {
    count ++;
    if (count % 2 == 0) {
        [self setTitle:@"按日查询" forState:UIControlStateNormal];
        [self setTitleColor:JP_Dark_Color forState:UIControlStateNormal];
        self.isDay = YES;
    } else {
        [self setTitle:@"按月查询" forState:UIControlStateNormal];
        [self setTitleColor:JP_Dark_Color forState:UIControlStateNormal];
        self.isDay = NO;
    }
    if (self.dateBlock) {
        self.dateBlock(self.isDay);
    }
}

@end
