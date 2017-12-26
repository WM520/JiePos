//
//  IBPersonRequest.m
//  JiePos
//
//  Created by iBlocker on 2017/8/29.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "IBPersonRequest.h"

@implementation IBPersonRequest

/**
 二维码扫描结果
 
 @param codeID 二维码唯一标识  扫描二维码，取链接的qrcodeid参数
 @param callback 回调
 */
+ (void)scanQRCodeWithCodeID:(NSString *)codeID
                    callback:(JPNetCallback)callback {
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:codeID forKey:@"qrcodeid"];
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    [self postWithServiceCode:@"JBB07" account:nil
                         data:data
                     callback:^(NSString *code, NSString *msg, id resp) {
                         callback (code, msg, resp);
                     }];
}

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
                          callback:(JPNetCallback)callback {
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    if (parent) {
        [dataDic setObject:parent forKey:@"parent"];
    }
    if (level) {
        [dataDic setObject:level forKey:@"level"];
    }
    [dataDic setObject:qrcodeId forKey:@"qrcodeId"];
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    [self postWithServiceCode:@"JBB01" account:account
                         data:data
                     callback:^(NSString *code, NSString *msg, id resp) {
                         callback (code, msg, resp);
                     }];
}

/**
 开户省市
 
 @param account 账户
 @param parent 父级编码
 @param level 区域级别
 @param callback 回调
 */
+ (void)openCityWithAccount:(NSString *)account parent:(NSString *)parent level:(NSString *)level callback:(JPNetCallback)callback {
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    if (parent) {
        [dataDic setObject:parent forKey:@"parent"];
    }
    if (level) {
        [dataDic setObject:level forKey:@"level"];
    }
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    [self postWithServiceCode:@"JBB03" account:account
                         data:data
                     callback:^(NSString *code, NSString *msg, id resp) {
         callback (code, msg, resp);
     }];
}

/**
 行业类型获取
 
 @param account 账号
 @param name 行业类型名称 为空时，查询大类列表；反之查询小类列表
 @param callback 回调
 */
+ (void)industryWithAccount:(NSString *)account
                       name:(NSString *)name
                   callback:(JPNetCallback)callback {
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:name forKey:@"name"];
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    [self postWithServiceCode:@"JBB02" account:account
                         data:data
                     callback:^(NSString *code, NSString *msg, id resp) {
                         callback (code, msg, resp);
                     }];
}

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
                   callback:(JPNetCallback)callback {
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    if (province) {
        [dataDic setObject:province forKey:@"province"];
    }
    if (city) {
        [dataDic setObject:city forKey:@"city"];
    }
    if (bankName) {
        [dataDic setObject:bankName forKey:@"bankName"];
    }
    NSString *data = [JPTool dictionaryToJson:dataDic];
    [self postWithServiceCode:@"JBB04" account:account
                         data:data
                     callback:^(NSString *code, NSString *msg, id resp) {
                         callback (code, msg, resp);
                     }];
}

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
                    callback:(JPNetCallback)callback {
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    if (merchantId > 0) {
        [dataDic setObject:@(merchantId) forKey:@"merchantId"];
    }
    if (isUserName) {
        [dataDic setObject:@"02" forKey:@"checkCode"];
    } else {
        [dataDic setObject:@"01" forKey:@"checkCode"];
    }
    [dataDic setObject:content forKey:@"content"];
    if (qrCodeId) {
        [dataDic setObject:qrCodeId forKey:@"qrCodeId"];
    }
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    
    [self postWithServiceCode:@"JBB06" account:account
                         data:data
                     callback:^(NSString *code, NSString *msg, id resp) {
                         callback (code, msg, resp);
                     }];
}

/**
 获取证件资料列表信息
 
 @param account 账户
 @param type 商户类别   不传入或者传入0，获取企业类需要上传的证件；1-个体有执照；2-个体无执照
 @param callback 回调
 */
+ (void)getCertificateWithAccount:(NSString *)account
                             type:(NSString *)type
                         callback:(JPNetCallback)callback {
 
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    if (type) {
        [dataDic setObject:type forKey:@"type"];
    }
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    [self postWithServiceCode:@"JBB05" account:account
                         data:data
                     callback:^(NSString *code, NSString *msg, id resp) {
                         callback (code, msg, resp);
                     }];
}

/**
 查询商户自助进件状态
 
 @param account 账户
 @param callback 回调
 */
+ (void)getMerchantStateWithAccount:(NSString *)account
                           callback:(JPNetCallback)callback {
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:account forKey:@"userName"];
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    [self postWithServiceCode:@"JBB08" account:account
                         data:data
                     callback:^(NSString *code, NSString *msg, id resp) {
        callback (code, msg, resp);
    }];
}

/**
 商户自助
 
 @param account 商户
 @param callback 回调
 */
+ (void)getMerchantInfoWithAccount:(NSString *)account
                          callback:(JPNetCallback)callback {
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:account forKey:@"userName"];
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    [self postWithServiceCode:@"JBB09" account:account
                         data:data
                     callback:^(NSString *code, NSString *msg, id resp) {
        callback (code, msg, resp);
    }];
}

/**
 公告列表
 
 @param account 账号
 @param startRow 起始行数   Integer
 @param callback 回调
 */
+ (void)getNoticeListWithAccount:(NSString *)account
                        startRow:(NSInteger)startRow
                        callback:(JPNetCallback)callback {
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:@(startRow) forKey:@"startRow"];
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    
    [self postWithServiceCode:@"JBB26"
                      account:account
                         data:data
                     callback:^(NSString *code, NSString *msg, id resp) {
        callback (code, msg, resp);
    }];
}

/**
 公告详情

 @param account 账号
 @param noticeID 公告唯一标识
 @param callback 回调
 */
+ (void)getNoticeDetailWithAccount:(NSString *)account
                          noticeID:(NSString *)noticeID
                          callback:(JPNetCallback)callback {
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:noticeID forKey:@"id"];
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    
    [self postWithServiceCode:@"JBB27"
                      account:account
                         data:data
                     callback:^(NSString *code, NSString *msg, id resp) {
        callback (code, msg, resp);
    }];
}

/** 图片上传*/
+ (void)uploadImageWithAccount:(NSString *)account image:(UIImage *)image isUpdate:(BOOL)isUpdate checkContent:(NSString *)checkContent tagStr:(NSString *)tagStr progress:(ZJNetProgress)progress callback:(JPNetCallback)callback {
    
    NSMutableDictionary *parameters = @{}.mutableCopy;
    NSMutableDictionary *header = @{}.mutableCopy;
    NSMutableDictionary *body = @{}.mutableCopy;
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    
    //  data里面需要存放string类型的字符串
    NSString *update = isUpdate ? @"true" : @"false";
    NSString *dataString = [NSString stringWithFormat:@"{\"checkContent\":\"%@\",\"isUpdate\":%@}", checkContent, update];
    
    /** 服务编码*/
    [dataDic setObject:@"JBB11" forKey:@"serviceCode"];
    [dataDic setObject:dataString forKey:@"data"];
    
    /** 终端设备号*/
    [header setObject:[IBUUIDManager getUUID] forKey:@"serialNo"];
    /** 登陆账号*/
    if (account) {
        [header setObject:account forKey:@"account"];
    }
    NSString *data = [JPTool dictionaryToJson:dataDic];
    
    NSString *random = [NSString random];
    /** 随机数*/
    [header setObject:random forKey:@"random"];
    /** 签名方式(1-MD5，2-RSA)*/
    [header setObject:@"2" forKey:@"signType"];
    /** 经过签名的业务参数*/
//    if ([JPUserEntity sharedUserEntity].isLogin) {
//        //  RSA加密
//        [body setObject:[GBEncodeTool rsaEncryptString:data publicKey:[JPUserEntity sharedUserEntity].publicKey] forKey:@"data"];
//    } else {
//        [body setObject:data forKey:@"data"];
//    }
    [body setObject:data forKey:@"data"];
    
    [parameters setObject:header forKey:@"header"];
    [parameters setObject:body forKey:@"body"];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/html", @"text/json", @"text/javascript,multipart/form-data", @"image/jpeg", @"application/octet-stream", nil];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    //上传图片/文字，只能同POST
    [manager POST:JPImgServerUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image,1);
        NSString *str = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyyMMddHHmmssFFF"];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        // 注意：这个name一定要和后台的参数字段一样 否则不成功
        [formData appendPartWithFileData:imageData
                                    name:@"imgFile"
                                fileName:fileName
                                mimeType:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(1.f * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        JPLog(@"Upload - %@", responseObject);
        //上传成功
        if (callback) {
            callback(responseObject[@"resultCode"], tagStr, responseObject[@"data"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //上传失败
        NSString *code = [NSString stringWithFormat:@"%ld", (long)error.code];
        if (callback) {
            if ([code isEqualToString:@"-1001"]) {
                callback (@"-1001", @"网络超时", nil);
            } else {
                callback (@"-1", @"网络异常，请稍后再试", nil);
            }
        }
    }];
}

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
                                      callback:(JPNetCallback)callback {
    
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    
    [dataDic setObject:merchantCategory forKey:@"merchantCategory"];
    [dataDic setObject:certificateImgType forKey:@"certificateImgType"];
    [dataDic setObject:merchantName forKey:@"merchantName"];
    [dataDic setObject:merchantShortName forKey:@"merchantShortName"];
    [dataDic setObject:registerProvinceCode forKey:@"registerProvinceCode"];
    [dataDic setObject:registerCityCode forKey:@"registerCityCode"];
    [dataDic setObject:registerDistrictCode forKey:@"registerDistrictCode"];
    [dataDic setObject:registerAddress forKey:@"registerAddress"];
    [dataDic setObject:industryType forKey:@"industryType"];
    [dataDic setObject:mcc forKey:@"mcc"];
    [dataDic setObject:industryNo forKey:@"industryNo"];
    [dataDic setObject:legalPersonName forKey:@"legalPersonName"];
    [dataDic setObject:username forKey:@"username"];
    [dataDic setObject:accountIdcard forKey:@"accountIdcard"];
    [dataDic setObject:accountType forKey:@"accountType"];
    [dataDic setObject:accountProvinceCode forKey:@"accountProvinceCode"];
    [dataDic setObject:accountCityCode forKey:@"accountCityCode"];
    [dataDic setObject:accountBankNameId forKey:@"accountBankNameId"];
    [dataDic setObject:alliedBankCode forKey:@"alliedBankCode"];
    [dataDic setObject:accountBankBranchName forKey:@"accountBankBranchName"];
    [dataDic setObject:account forKey:@"account"];
    [dataDic setObject:accountName forKey:@"accountName"];
    [dataDic setObject:contactMobilePhone forKey:@"contactMobilePhone"];
    if (qrcodeId) {
        [dataDic setObject:qrcodeId forKey:@"qrcodeId"];
    } else {
        [dataDic setObject:@"" forKey:@"qrcodeId"];
    }
    if (merchantId) {
        [dataDic setObject:merchantId forKey:@"merchantId"];
    } else {
        [dataDic setObject:@"" forKey:@"merchantId"];
    }
    [dataDic setObject:imgs forKey:@"imgs"];
    if (remark) {
        [dataDic setObject:remark forKey:@"remark"];
    } else {
        [dataDic setObject:@"" forKey:@"remark"];
    }
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    
    [self postWithServiceCode:@"JBB10"
                      account:account
                         data:data
                     callback:^(NSString *code, NSString *msg, id resp) {
                         callback (code, msg, resp);
                     }];
}

// 检测号码唯一性
+ (void)checkIsOnlyPhone:(NSString *)phoneNumber
                 account:(NSString *)account
                callback:(JPNetCallback)callback
{
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:phoneNumber forKey:@"appPhone"];
    NSString *data = [JPTool dictionaryToJson:dataDic];
    [self postWithServiceCode:@"JBB34"
                      account:account
                         data:data
                     callback:^(NSString *code, NSString *msg, id resp) {
                         callback (code, msg, resp);
                     }];
}

// 发送验证码
+ (void)sendSmsPhoneCode:(NSString *)phoneNumber
                 account:(NSString *)account
                callback:(JPNetCallback)callback
{
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:phoneNumber forKey:@"appPhone"];
    NSString *data = [JPTool dictionaryToJson:dataDic];
    [self postWithServiceCode:@"JBB35"
                      account:account
                         data:data
                     callback:^(NSString *code, NSString *msg, id resp) {
                         callback (code, msg, resp);
                     }];
}

// 校验短信验证码
+ (void)checkIsOKPhoneCode:(NSString *)code
                  appPhone:(NSString *)appPhone
                    userId:(NSString *)userId
                   account:(NSString *)account
                  callback:(JPNetCallback)callback
{
    NSMutableDictionary *dataDic = @{}.mutableCopy;
    [dataDic setObject:appPhone forKey:@"appPhone"];
    [dataDic setObject:code forKey:@"code"];
    [dataDic setObject:userId forKey:@"userId"];
    
    NSString *data = [JPTool dictionaryToJson:dataDic];
    [self postWithServiceCode:@"JBB36"
                      account:account
                         data:data
                     callback:^(NSString *code, NSString *msg, id resp) {
                         callback (code, msg, resp);
                     }];
}


@end
