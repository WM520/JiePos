//
//  IBTextView.m
//  JiePos
//
//  Created by iBlocker on 2017/9/5.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "IBTextView.h"

@interface IBTextView () <UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) UILabel *residueLabel;// 输入文本时剩余字数
@end
@implementation IBTextView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!self.textView) {
            self.textView = [ [UITextView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth - JPRealValue(100), JPRealValue(240))];
            self.textView.delegate = self;
            self.textView.layer.borderWidth = 0.5;//边宽
            self.textView.layer.cornerRadius = JPRealValue(10);//设置圆角
            self.textView.layer.borderColor = JP_LineColor.CGColor;
            self.textView.font = JP_DefaultsFont;
            [self addSubview :self.textView];
        }
        if (!_placeHolderLabel) {
            self.placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, -15, 290, 60)];
            self.placeHolderLabel.numberOfLines = 0;
            self.placeHolderLabel.text = @"备注";
            self.placeHolderLabel.font = JP_DefaultsFont;
            self.placeHolderLabel.textColor = JP_NoticeText_Color;
            [self.textView addSubview:self.placeHolderLabel];
        }
        if (!self.residueLabel) {
            self.residueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - JPRealValue(100) - 60 - 5, JPRealValue(200), 60, JPRealValue(20))];
            self.residueLabel.textAlignment = NSTextAlignmentRight;
            self.residueLabel.font = [UIFont systemFontOfSize:JPRealValue(18)];
            self.residueLabel.text = [NSString stringWithFormat:@"%@",@"50/50"];
            self.residueLabel.textColor = JP_NoticeText_Color;
            [self.textView addSubview:self.residueLabel];
        }
    }
    return self;
}

- (void)setIb_text:(NSString *)ib_text {
    self.textView.text = ib_text;
}

- (NSString *)ib_text {
    return self.textView.text;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if([textView.text length] == 0) {
        self.placeHolderLabel.text = @"备注";
    } else {
        self.placeHolderLabel.text = @"";//这里给空
    }
    //计算剩余字数   不需要的也可不写
    int existTextNum = (int)[textView.text length];
    if (existTextNum > 50) {
        textView.text = [textView.text substringToIndex:50];
    }
    int remainTextNum = 50 - (int)[textView.text length];
    self.residueLabel.text = [NSString stringWithFormat:@"%d/50", remainTextNum];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return YES;
    } else {
        return range.location < 50;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.textView.layer.borderColor = JPBaseColor.CGColor;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    self.textView.layer.borderColor = JP_LineColor.CGColor;
}
@end
