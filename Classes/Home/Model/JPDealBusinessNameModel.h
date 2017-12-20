//
//  JPDealBusinessNameModel.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/19.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPDealBusinessNameModel : NSObject
/** 账户*/
@property (nonatomic, copy) NSString *account;
/** 支行名称*/
@property (nonatomic, copy) NSString *accountBankBranchName;
/** 银行名称编码*/
@property (nonatomic, copy) NSString *accountBankNameId;
/** 开户城市编码*/
@property (nonatomic, copy) NSString *accountCityCode;
/** 身份证号码*/
@property (nonatomic, copy) NSString *accountIdcard;
/** 开户名称*/
@property (nonatomic, copy) NSString *accountName;
/** 开户省编码*/
@property (nonatomic, copy) NSString *accountProvinceCode;
/** 账户类型*/
@property (nonatomic, copy) NSString *accountType;
/** 支行编码*/
@property (nonatomic, copy) NSString *alliedBankCode;
/** 申请时间*/
@property (nonatomic, copy) NSString *applyTime;
/** 商户类型：1 K9商户    2 一码付商户 */
@property (nonatomic, assign) NSInteger applyType;
/** 商户地址*/
@property (nonatomic, copy) NSString *businessAddress;
/** 城市编码*/
@property (nonatomic, copy) NSString *businessCityCode;
/** 区县编码*/
@property (nonatomic, copy) NSString *businessDistrictCode;
/** 商户营业执照*/
@property (nonatomic, copy) NSString *businessLicense;
/** 商户省编码*/
@property (nonatomic, copy) NSString *businessProvinceCode;
/** 商户Zip编码*/
@property (nonatomic, copy) NSString *businessZipCode;
/** contact*/
@property (nonatomic, copy) NSString *contact;
/** 预留手机号*/
@property (nonatomic, copy) NSString *contactMobilePhone;
/** contractNumber*/
@property (nonatomic, copy) NSString *contractNumber;
/** 行业编号*/
@property (nonatomic, copy) NSString *industryNo;
/** 行业类型*/
@property (nonatomic, copy) NSString *industryType;
/** instId*/
@property (nonatomic, copy) NSString *instId;
/** 法人证件*/
@property (nonatomic, copy) NSString *legalPersonCertificate;
/** 法人证件类型ID*/
@property (nonatomic, copy) NSString *legalPersonCertificateTypeId;
/** 法人姓名*/
@property (nonatomic, copy) NSString *legalPersonName;
/** mcc*/
@property (nonatomic, copy) NSString *mcc;
/** 商户类别*/
@property (nonatomic, copy) NSString *merchantCategory;
/** 商户ID*/
@property (nonatomic, assign) NSInteger merchantId;
/** 商户名称*/
@property (nonatomic, copy) NSString *merchantName;
/** 商户号*/
@property (nonatomic, copy) NSString *merchantNo;
/** 商户简称*/
@property (nonatomic, copy) NSString *merchantShortName;
/** 商户状态*/
@property (nonatomic, copy) NSString *merchantStatus;
/** 商户类型*/
@property (nonatomic, assign) NSInteger merchantType;
/** 组织编码*/
@property (nonatomic, copy) NSString *organizationCode;
/** 注册地址*/
@property (nonatomic, copy) NSString *registerAddress;
/** 注册城市编码*/
@property (nonatomic, copy) NSString *registerCityCode;
/** 注册区县编码*/
@property (nonatomic, copy) NSString *registerDistrictCode;
/** 注册省编码*/
@property (nonatomic, copy) NSString *registerProvinceCode;
/** 注册Zip编码*/
@property (nonatomic, copy) NSString *registerZipCode;
/** registeredCapital*/
@property (nonatomic, copy) NSString *registeredCapital;
/** 预留手机号*/
@property (nonatomic, copy) NSString *reservedPhone;
/** 结算周期*/
@property (nonatomic, copy) NSString *settlementPeriod;
/** 税务登记*/
@property (nonatomic, copy) NSString *taxRegistration;
/** 用户名*/
@property (nonatomic, copy) NSString *username;
@end
