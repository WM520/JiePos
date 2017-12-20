//
//  JPDealFlowCell.m
//  JiePos
//
//  Created by Jason_LJ on 2017/7/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPDealFlowCell.h"

@implementation JPDealFlowHeadButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _open = NO;
        //  处理UI
        [self handleUserInterface];
    }
    return self;
}

- (void)setOpen:(BOOL)open {
    _open = open;
    //设定点击旋转动画效果
    [UIView beginAnimations:nil context:nil];
    self.indicatorView.transform = CGAffineTransformMakeRotation(self.isOpen ? M_PI : 0);
    [UIView commitAnimations];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(JPRealValue(30));
        make.top.and.bottom.equalTo(weakSelf);
        make.right.equalTo(weakSelf.mas_right).offset(JPRealValue(-30));
    }];
    [self.dealTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).offset(JPRealValue(20));
        make.top.and.bottom.equalTo(weakSelf.bgView);
        make.width.equalTo(@((kScreenWidth - JPRealValue(100)) / 3.0));
    }];
    
    [self.businessName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(weakSelf.bgView);
        make.left.equalTo(weakSelf.dealTime.mas_right);
        make.width.equalTo(@((kScreenWidth - JPRealValue(100)) / 3.0));
    }];
    
    [self.dealMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(weakSelf.bgView);
        make.left.equalTo(weakSelf.businessName.mas_right);
        make.width.equalTo(@((kScreenWidth - JPRealValue(100)) / 3.0 - 35));
    }];
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.dealMoney.mas_right).offset(JPRealValue(20));
        make.centerY.equalTo(weakSelf.dealMoney.mas_centerY);
    }];
}
#pragma mark - Method
- (void)handleUserInterface {
    
    if (!self.bgView) {
        self.bgView = [UIView new];
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.layer.cornerRadius = JPRealValue(10);
        self.bgView.layer.masksToBounds = YES;
        self.bgView.userInteractionEnabled = YES;
        [self addSubview:self.bgView];
    }
    
    if (!self.dealTime) {
        self.dealTime = [UILabel new];
        self.dealTime.text = @"04-17 14:00";
        self.dealTime.textColor = JP_Content_Color;
        self.dealTime.font = [UIFont systemFontOfSize:14];
        self.dealTime.userInteractionEnabled = YES;
        [self.bgView addSubview:self.dealTime];
    }
    
    if (!self.businessName) {
        self.businessName = [UILabel new];
        self.businessName.text = @"杰博实产品创新部";
        self.businessName.textAlignment = NSTextAlignmentCenter;
        self.businessName.textColor = JP_Content_Color;
        self.businessName.font = [UIFont systemFontOfSize:14];
        self.businessName.numberOfLines = 0;
        self.businessName.lineBreakMode = NSLineBreakByWordWrapping;
        self.businessName.userInteractionEnabled = YES;
        [self.bgView addSubview:self.businessName];
    }
    
    if (!self.dealMoney) {
        self.dealMoney = [UILabel new];
        self.dealMoney.text = @"666.00";
        self.dealMoney.textAlignment = NSTextAlignmentRight;
        self.dealMoney.textColor = JP_Content_Color;
        self.dealMoney.font = [UIFont systemFontOfSize:14];
        self.dealMoney.userInteractionEnabled = YES;
        [self.bgView addSubview:self.dealMoney];
    }
    
    if (!self.indicatorView) {
        self.indicatorView = [UIImageView new];
        self.indicatorView.image = [UIImage imageNamed:@"jp_home_close"];
        self.indicatorView.userInteractionEnabled = YES;
        [self.bgView addSubview:self.indicatorView];
    }
}
- (void)setDealFlowModel:(JPDealFlowModel *)dealFlowModel {
    
    NSDate *dealDate = [NSDate dateFromString:dealFlowModel.recCrtTs withFormat:@"yyyyMMddHHmmss"];
    self.dealTime.text = [NSString stringWithFormat:@"%@", [NSDate stringFromDate:dealDate withFormat:@"MM-dd HH:mm"]];
    
    self.businessName.text = dealFlowModel.merchantShortName;
    if (dealFlowModel.merchantShortName.length <= 0) {
        self.businessName.text = self.shortName;
    }
    self.dealMoney.text = [NSString stringWithFormat:@"%.2lf", [dealFlowModel.transAt doubleValue]];
    
    if (self.colorType == JPDealTextColorTypeFailed && [dealFlowModel.transIn isEqualToString:@"-1"]) {
        self.dealTime.textColor = JP_NoticeRedColor;
        self.businessName.textColor = JP_NoticeRedColor;
        self.dealMoney.textColor = JP_NoticeRedColor;
    } else {
        self.dealTime.textColor = JP_Content_Color;
        self.businessName.textColor = JP_Content_Color;
        self.dealMoney.textColor = JP_Content_Color;
    }
}
@end


@implementation JPDealFlowExtentionCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = JP_viewBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self handleUserIdentifier];
    }
    return self;
}
#pragma mark - Method
- (void)handleUserIdentifier {
    if (!self.currentView) {
        self.currentView = [UIView new];
        self.currentView.backgroundColor = [UIColor whiteColor];
        self.currentView.layer.cornerRadius = JPRealValue(10);
        self.currentView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.currentView];
    }
    
    {
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(JPRealValue(35), 0)];
        [path addLineToPoint:CGPointMake(kScreenWidth - JPRealValue(40), 0)];
        
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        [pathLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:5], nil]]; // 设置线为虚线
        pathLayer.lineWidth = 0.5;
        pathLayer.strokeColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
        pathLayer.path = path.CGPath;
        [self.contentView.layer addSublayer:pathLayer];
    }
    
    if (!self.businessID) {
        self.businessID = [YYLabel new];
        self.businessID.font = [UIFont fontWithName:@"HelveticaNeueLTCom-Th" size:JPRealValue(24)];
        self.businessID.lineBreakMode = NSLineBreakByCharWrapping;
        [self.currentView addSubview:self.businessID];
    }
    
    if (!self.serverBusiness) {
        self.serverBusiness = [YYLabel new];
        self.serverBusiness.font = [UIFont fontWithName:@"HelveticaNeueLTCom-Th" size:JPRealValue(24)];
        self.serverBusiness.lineBreakMode = NSLineBreakByCharWrapping;
        [self.currentView addSubview:self.serverBusiness];
    }
    
    if (!self.terminalNo) {
        self.terminalNo = [YYLabel new];
        self.terminalNo.font = [UIFont fontWithName:@"HelveticaNeueLTCom-Th" size:JPRealValue(24)];
        self.terminalNo.lineBreakMode = NSLineBreakByCharWrapping;
        [self.currentView addSubview:self.terminalNo];
    }
    
    if (!self.dealType) {
        self.dealType = [YYLabel new];
        self.dealType.font = [UIFont fontWithName:@"HelveticaNeueLTCom-Th" size:JPRealValue(24)];
        self.dealType.lineBreakMode = NSLineBreakByCharWrapping;
        [self.currentView addSubview:self.dealType];
    }
    
    if (!self.dealState) {
        self.dealState = [YYLabel new];
        self.dealState.font = [UIFont fontWithName:@"HelveticaNeueLTCom-Th" size:JPRealValue(24)];
        self.dealState.lineBreakMode = NSLineBreakByCharWrapping;
        [self.currentView addSubview:self.dealState];
    }
    
    if (!self.payWay) {
        self.payWay = [YYLabel new];
        self.payWay.font = [UIFont fontWithName:@"HelveticaNeueLTCom-Th" size:JPRealValue(24)];
        self.payWay.lineBreakMode = NSLineBreakByCharWrapping;
        [self.currentView addSubview:self.payWay];
    }
    
    if (!self.payCardNo) {
        self.payCardNo = [YYLabel new];
        self.payCardNo.font = [UIFont fontWithName:@"HelveticaNeueLTCom-Th" size:JPRealValue(24)];
        self.payCardNo.lineBreakMode = NSLineBreakByCharWrapping;
        [self.currentView addSubview:self.payCardNo];
    }
    
    if (!self.poundage) {
        self.poundage = [YYLabel new];
        self.poundage.font = [UIFont fontWithName:@"HelveticaNeueLTCom-Th" size:JPRealValue(24)];
        self.poundage.lineBreakMode = NSLineBreakByCharWrapping;
        [self.currentView addSubview:self.poundage];
    }
    
    if (!self.actualMoney) {
        self.actualMoney = [YYLabel new];
        self.actualMoney.font = [UIFont fontWithName:@"HelveticaNeueLTCom-Th" size:JPRealValue(24)];
        self.actualMoney.lineBreakMode = NSLineBreakByCharWrapping;
        [self.currentView addSubview:self.actualMoney];
    }
    
    if (!self.signingMoney) {
        self.signingMoney = [YYLabel new];
        self.signingMoney.font = [UIFont fontWithName:@"HelveticaNeueLTCom-Th" size:JPRealValue(24)];
        self.signingMoney.lineBreakMode = NSLineBreakByCharWrapping;
        [self.currentView addSubview:self.signingMoney];
    }
    
    if (!self.platfromNo) {
        self.platfromNo = [YYLabel new];
        self.platfromNo.font = [UIFont fontWithName:@"HelveticaNeueLTCom-Th" size:JPRealValue(24)];
        self.platfromNo.lineBreakMode = NSLineBreakByCharWrapping;
        [self.currentView addSubview:self.platfromNo];
    }
    
    if (!self.returnCode) {
        self.returnCode = [YYLabel new];
        self.returnCode.font = [UIFont fontWithName:@"HelveticaNeueLTCom-Th" size:JPRealValue(24)];
        self.returnCode.lineBreakMode = NSLineBreakByCharWrapping;
        [self.currentView addSubview:self.returnCode];
    }
    
    if ([JPUserEntity sharedUserEntity].applyType == 1) {
        if (!self.parameter1) {
            self.parameter1 = [YYLabel new];
            self.parameter1.font = [UIFont fontWithName:@"HelveticaNeueLTCom-Th" size:JPRealValue(24)];
            self.parameter1.lineBreakMode = NSLineBreakByCharWrapping;
            [self.currentView addSubview:self.parameter1];
        }
        
        if (!self.parameter2) {
            self.parameter2 = [YYLabel new];
            self.parameter2.font = [UIFont fontWithName:@"HelveticaNeueLTCom-Th" size:JPRealValue(24)];
            self.parameter2.lineBreakMode = NSLineBreakByCharWrapping;
            [self.currentView addSubview:self.parameter2];
        }
    }
}

- (void)setDealModel:(JPDealFlowModel *)dealModel {
    
    UIColor *orignColor = nil;
    UIColor *finalColor = nil;
    if (self.colorType == JPDealTextColorTypeFailed && [dealModel.transIn isEqualToString:@"-1"]) {
        orignColor = JP_NoticeRedColor;
        finalColor = JP_NoticeRedColor;
    } else {
        orignColor = JP_NoticeText_Color;
        finalColor = JP_Content_Color;
    }
    
    if ([JPUserEntity sharedUserEntity].applyType == 1) {
        //  K9
        self.businessID.attributedText = [self getAttributeStringWithKeyStr:@"商户号：" valueStr:dealModel.mchntCd originColor:orignColor finalColor:finalColor];
        self.serverBusiness.attributedText = [self getAttributeStringWithKeyStr:@"服务商：" valueStr:dealModel.instName originColor:orignColor finalColor:finalColor];
        self.terminalNo.attributedText = [self getAttributeStringWithKeyStr:@"终端号：" valueStr:dealModel.termId originColor:orignColor finalColor:finalColor];
        self.dealType.attributedText = [self getAttributeStringWithKeyStr:@"卡号：" valueStr:dealModel.priAcctNo originColor:orignColor finalColor:finalColor];
        self.dealState.attributedText = [self getAttributeStringWithKeyStr:@"交易类型：" valueStr:dealModel.opeName originColor:orignColor finalColor:finalColor];
        self.payWay.attributedText = [self getAttributeStringWithKeyStr:@"支付方式：" valueStr:dealModel.payName originColor:orignColor finalColor:finalColor];
        self.payCardNo.attributedText = [self getAttributeStringWithKeyStr:@"交易状态：" valueStr:dealModel.transName originColor:orignColor finalColor:finalColor];
        self.poundage.attributedText = [self getAttributeStringWithKeyStr:@"手续费(元)：" valueStr:dealModel.merFee originColor:orignColor finalColor:finalColor];
        self.actualMoney.attributedText = [self getAttributeStringWithKeyStr:@"应付金额(元)：" valueStr:dealModel.originalMoney originColor:orignColor finalColor:finalColor];
        self.signingMoney.attributedText = [self getAttributeStringWithKeyStr:@"优惠金额(元)：" valueStr:dealModel.favorableMoney originColor:orignColor finalColor:finalColor];
        self.platfromNo.attributedText = [self getAttributeStringWithKeyStr:@"实到金额(元)：" valueStr:dealModel.realmoney originColor:orignColor finalColor:finalColor];
        self.returnCode.attributedText = [self getAttributeStringWithKeyStr:@"签约费率(%)：" valueStr:dealModel.rate originColor:orignColor finalColor:finalColor];
        self.parameter1.attributedText = [self getAttributeStringWithKeyStr:@"平台流水账号：" valueStr:dealModel.sysTraNo originColor:orignColor finalColor:finalColor];
        self.parameter2.attributedText = [self getAttributeStringWithKeyStr:@"返回码：" valueStr:dealModel.respCd originColor:orignColor finalColor:finalColor];
    } else {
        //  一码付
        self.businessID.attributedText = [self getAttributeStringWithKeyStr:@"商户号：" valueStr:dealModel.mchntCd originColor:orignColor finalColor:finalColor];
        self.serverBusiness.attributedText = [self getAttributeStringWithKeyStr:@"服务商：" valueStr:dealModel.instName originColor:orignColor finalColor:finalColor];
        self.terminalNo.attributedText = [self getAttributeStringWithKeyStr:@"交易类型：" valueStr:dealModel.opeName originColor:orignColor finalColor:finalColor];
        self.dealType.attributedText = [self getAttributeStringWithKeyStr:@"支付方式：" valueStr:dealModel.payName originColor:orignColor finalColor:finalColor];
        self.dealState.attributedText = [self getAttributeStringWithKeyStr:@"交易状态：" valueStr:dealModel.transName originColor:orignColor finalColor:finalColor];
        self.payWay.attributedText = [self getAttributeStringWithKeyStr:@"手续费(元)：" valueStr:dealModel.merFee originColor:orignColor finalColor:finalColor];
        self.payCardNo.attributedText = [self getAttributeStringWithKeyStr:@"应付金额(元)：" valueStr:dealModel.originalMoney originColor:orignColor finalColor:finalColor];
        self.poundage.attributedText = [self getAttributeStringWithKeyStr:@"优惠金额(元)：" valueStr:dealModel.favorableMoney originColor:orignColor finalColor:finalColor];
        self.actualMoney.attributedText = [self getAttributeStringWithKeyStr:@"实到金额(元)：" valueStr:dealModel.realmoney originColor:orignColor finalColor:finalColor];
        self.signingMoney.attributedText = [self getAttributeStringWithKeyStr:@"签约费率(%)：" valueStr:dealModel.rate originColor:orignColor finalColor:finalColor];
        self.platfromNo.attributedText = [self getAttributeStringWithKeyStr:@"平台流水账号：" valueStr:dealModel.sysTraNo originColor:orignColor finalColor:finalColor];
        self.returnCode.attributedText = [self getAttributeStringWithKeyStr:@"返回码：" valueStr:dealModel.respCd originColor:orignColor finalColor:finalColor];
    }
//    self.businessID.attributedText = [self getAttributeStringWithKeyStr:@"商户号：" valueStr:dealModel.mchntCd];
//    self.serverBusiness.attributedText = [self getAttributeStringWithKeyStr:@"服务商：" valueStr:dealModel.instName];
//    self.terminalNo.attributedText = [self getAttributeStringWithKeyStr:@"终端号：" valueStr:dealModel.termId];
//    
//    self.dealType.attributedText = [self getAttributeStringWithKeyStr:@"交易类型：" valueStr:dealModel.opeName];
//    self.dealState.attributedText = [self getAttributeStringWithKeyStr:@"交易状态：" valueStr:dealModel.transName];
//    self.payWay.attributedText = [self getAttributeStringWithKeyStr:@"支付方式：" valueStr:dealModel.payName];
//    self.payCardNo.attributedText = [self getAttributeStringWithKeyStr:@"支付卡号：" valueStr:dealModel.priAcctNo];
//    self.poundage.attributedText = [self getAttributeStringWithKeyStr:@"手续费（元）：" valueStr:dealModel.merFee];
//    
//    self.actualMoney.attributedText = [self getAttributeStringWithKeyStr:@"实到金额（元）：" valueStr:dealModel.realmoney];
//    self.signingMoney.attributedText = [self getAttributeStringWithKeyStr:@"签约费率：" valueStr:dealModel.rate];
//    self.platfromNo.attributedText = [self getAttributeStringWithKeyStr:@"平台流水账号：" valueStr:dealModel.sysTraNo];
//    self.returnCode.attributedText = [self getAttributeStringWithKeyStr:@"返回码：" valueStr:dealModel.respCd];
}
#pragma mark - NSMutableAttributedString
- (NSMutableAttributedString *)getAttributeStringWithKeyStr:(NSString *)keyStr valueStr:(NSString *)valueStr originColor:(UIColor *)originColor finalColor:(UIColor *)finalColor {
    NSMutableAttributedString *combiStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", keyStr, valueStr]];
    if (keyStr.length > 0) {
        NSRange range1 = [[combiStr string] rangeOfString:keyStr options:NSCaseInsensitiveSearch];
        //文字颜色
        [combiStr yy_setColor:originColor range:range1];
    }
    if (valueStr.length > 0) {
        NSRange range2 = [[combiStr string] rangeOfString:valueStr options:NSCaseInsensitiveSearch];
        //文字颜色
        [combiStr yy_setColor:finalColor range:range2];
    }
    return combiStr;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(JPRealValue(30));
        make.top.and.bottom.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(JPRealValue(-30));
    }];
    [self.businessID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.currentView.mas_left);
        make.top.equalTo(weakSelf.currentView.mas_top).offset(JPRealValue(20));
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(70)) / 2.0, JPRealValue(24)));
    }];
    
    [self.serverBusiness mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.businessID.mas_right);
        make.centerY.equalTo(weakSelf.businessID.mas_centerY);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(70)) / 2.0, JPRealValue(24)));
    }];
    
    [self.terminalNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.businessID.mas_left);
        make.top.equalTo(weakSelf.businessID.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(70)) / 2.0, JPRealValue(24)));
    }];
    
    [self.dealType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.terminalNo.mas_top);
        make.left.equalTo(weakSelf.terminalNo.mas_right);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(70)) / 2.0, JPRealValue(24)));
    }];
    
    [self.dealState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.businessID.mas_left);
        make.top.equalTo(weakSelf.terminalNo.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(70)) / 2.0, JPRealValue(24)));
    }];
    
    [self.payWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.dealState.mas_top);
        make.left.equalTo(weakSelf.dealState.mas_right);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(70)) / 2.0, JPRealValue(24)));
    }];
    
    [self.payCardNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.businessID.mas_left);
        make.top.equalTo(weakSelf.dealState.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(70)) / 2.0, JPRealValue(24)));
    }];
    
    [self.poundage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.payCardNo.mas_top);
        make.left.equalTo(weakSelf.payCardNo.mas_right);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(70)) / 2.0, JPRealValue(24)));
    }];
    
    [self.actualMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.businessID.mas_left);
        make.top.equalTo(weakSelf.payCardNo.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(70)) / 2.0, JPRealValue(24)));
    }];
    
    [self.signingMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.actualMoney.mas_top);
        make.left.equalTo(weakSelf.actualMoney.mas_right);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(70)) / 2.0, JPRealValue(24)));
    }];
    
    [self.platfromNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.businessID.mas_left);
        make.top.equalTo(weakSelf.actualMoney.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(70)) / 2.0, JPRealValue(24)));
    }];
    
    [self.returnCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.platfromNo.mas_top);
        make.left.equalTo(weakSelf.platfromNo.mas_right);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(70)) / 2.0, JPRealValue(24)));
    }];
    
    if ([JPUserEntity sharedUserEntity].applyType == 1) {
        [self.parameter1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.businessID.mas_left);
            make.top.equalTo(weakSelf.platfromNo.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(70)) / 2.0, JPRealValue(24)));
        }];
        
        [self.parameter2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.parameter1.mas_top);
            make.left.equalTo(weakSelf.parameter1.mas_right);
            make.size.mas_equalTo(CGSizeMake((kScreenWidth - JPRealValue(70)) / 2.0, JPRealValue(24)));
        }];
    }
}
@end

@implementation JPDealFlowHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //  处理UI
        [self handleUserInterface];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    weakSelf_declare;
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(JPRealValue(30));
        make.right.equalTo(weakSelf.mas_right).offset(JPRealValue(-30));
        make.height.equalTo(@(JPRealValue(90)));
        make.bottom.equalTo(weakSelf.mas_bottom).offset(JPRealValue(-20));
    }];
    [self layoutIfNeeded];
    
    CGFloat width = self.headView.frame.size.width;
    [self.dealTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.bottom.equalTo(weakSelf.headView);
        make.width.equalTo(@(width / 3.0));
    }];
    
    [self.businessName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(weakSelf.headView);
        make.left.equalTo(weakSelf.dealTime.mas_right);
        make.width.equalTo(@(width / 3.0));
    }];
    
    [self.dealMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.and.bottom.equalTo(weakSelf.headView);
        make.width.equalTo(@(width / 3.0));
    }];
}
#pragma mark - Method
- (void)handleUserInterface {
    
    self.backgroundColor = JP_viewBackgroundColor;
    [self.layer addSublayer:self.gradientLayer];
    self.gradientLayer.frame = (CGRect){0, 0, kScreenWidth, JPRealValue(173)};
    [self addSubview:self.headView];
    
    if (!self.dealTime) {
        self.dealTime = [UILabel new];
        self.dealTime.text = @"    交易时间";
        self.dealTime.textColor = JPBaseColor;
        self.dealTime.font = JP_DefaultsFont;
        [self.headView addSubview:self.dealTime];
    }
    if (!self.businessName) {
        self.businessName = [UILabel new];
        self.businessName.text = @"商户名称";
        self.businessName.textAlignment = NSTextAlignmentCenter;
        self.businessName.textColor = JPBaseColor;
        self.businessName.font = JP_DefaultsFont;
        [self.headView addSubview:self.businessName];
    }
    if (!self.dealMoney) {
        self.dealMoney = [UILabel new];
        self.dealMoney.text = @"交易金额（元）   ";
        self.dealMoney.textAlignment = NSTextAlignmentRight;
        self.dealMoney.textColor = JPBaseColor;
        self.dealMoney.font = JP_DefaultsFont;
        [self.headView addSubview:self.dealMoney];
    }
}
- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"7a93f5"].CGColor, (__bridge id)[UIColor colorWithHexString:@"68b2f2"].CGColor, (__bridge id)[UIColor colorWithHexString:@"51dbf0"].CGColor];
        _gradientLayer.locations = @[@0, @0.5, @1.0];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1.0, 0);
    }
    return _gradientLayer;
}
- (UIView *)headView {
    if (!_headView) {
        _headView = [UIView new];
        ;_headView.backgroundColor = [UIColor whiteColor];
        _headView.layer.cornerRadius = JPRealValue(10);
//        _headView.layer.masksToBounds = YES;
        _headView.layer.shadowColor = JPBaseColor.CGColor;
        _headView.layer.shadowOffset = CGSizeMake(2, 2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _headView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _headView.layer.shadowRadius = 2;//阴影半径，默认3
    }
    return _headView;
}
@end
