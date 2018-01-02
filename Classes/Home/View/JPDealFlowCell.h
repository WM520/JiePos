//
//  JPDealFlowCell.h
//  JiePos
//
//  Created by Jason_LJ on 2017/7/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPDealFlowModel.h"

@interface JPDealFlowHeadButton : UIButton
@property (nonatomic, assign) JPDealTextColorType colorType;
@property (nonatomic, strong) UIView *bgView;
/** 交易时间*/
@property (nonatomic, strong) UILabel *dealTime;
/** 商户名称*/
@property (nonatomic, strong) UILabel *businessName;
/** 交易金额*/
@property (nonatomic, strong) UILabel *dealMoney;
/** 指示符*/
@property (nonatomic, strong) UIImageView *indicatorView;
@property (nonatomic, strong) JPDealFlowModel *dealFlowModel;
@property (nonatomic, strong) NSString *shortName;
@property (assign, nonatomic, getter = isOpen) BOOL open;
@end

@interface JPDealFlowExtentionCell : UITableViewCell
@property (nonatomic, assign) JPDealTextColorType colorType;
@property (nonatomic, strong) UIView *currentView;
@property (nonatomic, strong) YYLabel *businessID;
@property (nonatomic, strong) YYLabel *serverBusiness;
@property (nonatomic, strong) YYLabel *terminalNo;
@property (nonatomic, strong) YYLabel *dealType;
@property (nonatomic, strong) YYLabel *dealState;
@property (nonatomic, strong) YYLabel *payWay;
@property (nonatomic, strong) YYLabel *payCardNo;
@property (nonatomic, strong) YYLabel *poundage;
@property (nonatomic, strong) YYLabel *actualMoney;
@property (nonatomic, strong) YYLabel *signingMoney;
@property (nonatomic, strong) YYLabel *platfromNo;
@property (nonatomic, strong) YYLabel *returnCode;
@property (nonatomic, strong) YYLabel *parameter1;
@property (nonatomic, strong) YYLabel *parameter2;
@property (nonatomic, strong) YYLabel *note;
@property (nonatomic, strong) JPDealFlowModel *dealModel;
@end


@interface JPDealFlowHeaderView : UIView
/** 交易时间*/
@property (nonatomic, strong) UILabel *dealTime;
/** 商户名称*/
@property (nonatomic, strong) UILabel *businessName;
/** 交易金额*/
@property (nonatomic, strong) UILabel *dealMoney;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end
