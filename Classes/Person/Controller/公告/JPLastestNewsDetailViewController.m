//
//  JPLastestNewsDetailViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/18.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPLastestNewsDetailViewController.h"
#import "JPInfoModel.h"
#import <YYText/NSAttributedString+YYText.h>

@interface JPLastestNewsDetailViewController ()

@end

@implementation JPLastestNewsDetailViewController

#pragma mark - lifestyle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.noticeTitle && self.date && self.content) {
        [self handleLastNewsWithTitle:self.noticeTitle date:self.date content:self.content];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleLastNewsWithTitle:(NSString *)title date:(NSString *)date content:(NSString *)content {
    
    YYTextView *txtView = [[YYTextView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight - 64}];
    txtView.contentInset = UIEdgeInsetsMake(JPRealValue(20), JPRealValue(30), JPRealValue(20), JPRealValue(-30));
    txtView.userInteractionEnabled = YES;
    txtView.textVerticalAlignment = YYTextVerticalAlignmentTop;
//    txtView.showsVerticalScrollIndicator = NO;
    txtView.editable = NO;
    
    //创建最主要的attribute文本
    NSMutableAttributedString *contentText = [NSMutableAttributedString new];
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = JPRealValue(16);// 字体的行间距
    paragraphStyle.paragraphSpacing = JPRealValue(5);
    
    [contentText appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : JP_Content_Color, NSFontAttributeName : [UIFont boldSystemFontOfSize:JPRealValue(36)], NSParagraphStyleAttributeName : paragraphStyle}]];
    
    if (date.length >= 10) {
        date = [date substringToIndex:10];
    }
    NSString *dateString = [NSDate stringFromDate:[NSDate dateFromString:date withFormat:@"yyyy-MM-dd"] withFormat:@"yyyy年M月d日"];
    [contentText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", dateString] attributes:@{NSForegroundColorAttributeName : JP_NoticeText_Color, NSFontAttributeName : [UIFont systemFontOfSize:JPRealValue(28)], NSParagraphStyleAttributeName : paragraphStyle}]];
    [contentText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", content] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"666666"], NSFontAttributeName : JP_DefaultsFont, NSParagraphStyleAttributeName : paragraphStyle}]];
    
    txtView.attributedText = contentText;
    [self.view addSubview:txtView];
}

@end
