//
//  IBPersonRequest.h
//  JiePos
//
//  Created by iBlocker on 2017/8/29.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "IBNetworking.h"

@interface IBPersonRequest : IBNetworking

/**
 二维码扫描结果

 @param codeID 二维码唯一标识
 @param callback 回调
 */
+ (void)scanQRCodeWithCodeID:(NSString *)codeID
                    callback:(JPNetCallback)callback;

/**
 获取注册省市区

 @param account 账号
 @param parent 父级编码 查询省份列表时，可不传入或者传入1
 @param level 区域级别  查询省份列表时，可不传入或者传入1，市-2，区县-3
 @param qrcodeId 二维码内容
 @param callback 回调
 */
+ (void)registerAddressWithAccount:(NSString *)account
                            parent:(NSString *)parent
                             level:(NSString *)level
                          qrcodeId:(NSString *)qrcodeId
                          callback:(JPNetCallback)callback;

/**
 开户省市

 @param account 账户
 @param parent 父级编码
 @param level 区域级别
 @param callback 回调
 */
+ (void)openCityWithAccount:(NSString *)account
                     parent:(NSString *)parent
                      level:(NSString *)level
                   callback:(JPNetCallback)callback;

/**
 行业类型获取

 @param account 账号
 @param name 行业类型名称 为空时，查询大类列表；反之查询小类列表
 @param callback 回调
 */
+ (void)industryWithAccount:(NSString *)account
                       name:(NSString *)name
                   callback:(JPNetCallback)callback;

/**
 获取银行名称

 @param account     账户
 @param province    开户行所在省份编码   查询总银行列表时可不填
 @param city        开户行所在城市编码   查询总银行列表时可不填
 @param bankName    开户行总行名称      查询总银行列表时可不填
 @param callback    回调
 */
+ (void)bankNameWithAccount:(NSString *)account
                   province:(NSString *)province
                       city:(NSString *)city
                   bankName:(NSString *)bankName
                   callback:(JPNetCallback)callback;

/**
 校验商户名称和用户名存在
 
 @param account 账号
 @param merchantId 商户标识
 @param isUserName 判断是不是用户名
 @param content 校验熟属性的值
 @param qrCodeId 二维码
 @param callback 回调
 */
+ (void)checkUserInfoAccount:(NSString *)account
                  merchantId:(NSInteger)merchantId
                  isUserName:(BOOL)isUserName
                     content:(NSString *)content
                    qrCodeId:(NSString *)qrCodeId
                    callback:(JPNetCallback)callback;

/**
 获取证件资料列表信息

 @param account 账户
 @param type 商户类别   不传入或者传入0，获取企业类需要上传的证件；1-个体有执照；2-个体无执照
 @param callback 回调
 */
+ (void)getCertificateWithAccount:(NSString *)account
                             type:(NSString *)type
                         callback:(JPNetCallback)callback;

/**
 查询商户自助进件状态

 @param account 账户
 @param callback 回调
 */
+ (void)getMerchantStateWithAccount:(NSString *)account
                           callback:(JPNetCallback)callback;

/**
 商户自助

 @param account 商户
 @param callback 回调
 */
+ (void)getMerchantInfoWithAccount:(NSString *)account
                          callback:(JPNetCallback)callback;

/**
 公告列表
 
 @param account 账号
 @param startRow 起始行数   Integer
 @param callback 回调
 */
+ (void)getNoticeListWithAccount:(NSString *)account
                        startRow:(NSInteger)startRow
                        callback:(JPNetCallback)callback;

/**
 公告详情
 
 @param account 账号
 @param noticeID 公告唯一标识
 @param callback 回调
 */
+ (void)getNoticeDetailWithAccount:(NSString *)account
                          noticeID:(NSString *)noticeID
                          callback:(JPNetCallback)callback;

/** 图片上传*/
+ (void)uploadImageWithAccount:(NSString *)account image:(UIImage *)image isUpdate:(BOOL)isUpdate checkContent:(NSString *)checkContent tagStr:(NSString *)tagStr progress:(ZJNetProgress)progress callback:(JPNetCallback)callback;

/**
 商户进件资料提交
 
 @param merchantCategory        商户类别    1-企业类；2-个体
 @param certificateImgType      证件照类别   根据商户类别的值来动态赋值，0-企业类；1-个体有照，2无
 @param merchantName            商户名称
 @param merchantShortName       商户简称
 @param registerProvinceCode    注册省份    传code
 @param registerCityCode        注册地市    传code
 @param registerDistrictCode    注册区县    传code
 @param registerAddress         注册详细地址
 @param industryType            行业类型-大类     直接传名称
 @param mcc                     行业类型-小类     小类编码
 @param industryNo              行业类型描述-小类
 @param legalPersonName         法人姓名
 @param username                用户名
 @param accountIdcard           身份证号
 @param accountType             账户类型    1-对公，2-对私
 @param accountProvinceCode     开户地省份   传code
 @param accountCityCode         开户地市    传code
 @param accountBankNameId       银行名称    传名称
 @param alliedBankCode          银联号     支行的code
 @param accountBankBranchName   支行名称    传名称
 @param account                 开户银行帐号
 @param accountName             开户账号名称
 @param contactMobilePhone      预留手机号
 @param qrcodeId                二维码     商户入住时必传
 @param merchantId              主键      商户修改时必传
 @param imgs                    图片集合    证件照集合，同证件资料获取
 @param remark                  备注
 @param callback                回调
 */
+ (void)commitMerchantInfoWithMerchantCategory:(NSString *)merchantCategory
                            certificateImgType:(NSString *)certificateImgType
                                  merchantName:(NSString *)merchantName
                             merchantShortName:(NSString *)merchantShortName
                          registerProvinceCode:(NSString *)registerProvinceCode
                              registerCityCode:(NSString *)registerCityCode
                          registerDistrictCode:(NSString *)registerDistrictCode
                               registerAddress:(NSString *)registerAddress
                                  industryType:(NSString *)industryType
                                           mcc:(NSString *)mcc
                                    industryNo:(NSString *)industryNo
                               legalPersonName:(NSString *)legalPersonName
                                      username:(NSString *)username
                                 accountIdcard:(NSString *)accountIdcard
                                   accountType:(NSString *)accountType
                           accountProvinceCode:(NSString *)accountProvinceCode
                               accountCityCode:(NSString *)accountCityCode
                             accountBankNameId:(NSString *)accountBankNameId
                                alliedBankCode:(NSString *)alliedBankCode
                         accountBankBranchName:(NSString *)accountBankBranchName
                                       account:(NSString *)account
                                   accountName:(NSString *)accountName
                            contactMobilePhone:(NSString *)contactMobilePhone
                                      qrcodeId:(NSString *)qrcodeId
                                    merchantId:(NSString *)merchantId
                                          imgs:(id)imgs
                                        remark:(NSString *)remark
                                    qrcodeFlag:(NSString *)qrcodeFlag
                                      appPhone:(NSString *)appPhone
                                      callback:(JPNetCallback)callback;

+ (void)commitMerchantInfoWithMerchantCategory:(NSString *)merchantCategory
                            certificateImgType:(NSString *)certificateImgType
                                  merchantName:(NSString *)merchantName
                             merchantShortName:(NSString *)merchantShortName
                          registerProvinceCode:(NSString *)registerProvinceCode
                              registerCityCode:(NSString *)registerCityCode
                          registerDistrictCode:(NSString *)registerDistrictCode
                               registerAddress:(NSString *)registerAddress
                                  industryType:(NSString *)industryType
                                           mcc:(NSString *)mcc
                                    industryNo:(NSString *)industryNo
                               legalPersonName:(NSString *)legalPersonName
                                      username:(NSString *)username
                                 accountIdcard:(NSString *)accountIdcard
                                   accountType:(NSString *)accountType
                           accountProvinceCode:(NSString *)accountProvinceCode
                               accountCityCode:(NSString *)accountCityCode
                             accountBankNameId:(NSString *)accountBankNameId
                                alliedBankCode:(NSString *)alliedBankCode
                         accountBankBranchName:(NSString *)accountBankBranchName
                                       account:(NSString *)account
                                   accountName:(NSString *)accountName
                            contactMobilePhone:(NSString *)contactMobilePhone
                                      qrcodeId:(NSString *)qrcodeId
                                    merchantId:(NSString *)merchantId
                                          imgs:(id)imgs
                                        remark:(NSString *)remark
                                      callback:(JPNetCallback)callback;

// 检测号码唯一性
+ (void)checkIsOnlyPhone:(NSString *)phoneNumber
                 account:(NSString *)account
                callback:(JPNetCallback)callback;

// 发送验证码
+ (void)sendSmsPhoneCode:(NSString *)phoneNumber
                 account:(NSString *)account
                callback:(JPNetCallback)callback;
// 校验短信验证码
+ (void)checkIsOKPhoneCode:(NSString *)code
                  appPhone:(NSString *)appPhone
                    userId:(NSString *)userId
                   account:(NSString *)account
                  callback:(JPNetCallback)callback;
@end
