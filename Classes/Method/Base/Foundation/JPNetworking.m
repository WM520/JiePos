//
//  JPNetworking.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/14.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPNetworking.h"

@implementation JPNetworking

+ (void)getUrl:(NSString *)url params:(NSDictionary *)params progress:(ZJNetProgress)progress callback:(ZJNetCallback)callback {
    if (url.length <= 0) {
        [IBProgressHUD showInfoWithStatus:@"Url格式不对！"];
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    
    // 因为传递过去和接收回来的数据都不是json类型的，所以在这里要设置为AFHTTPRequestSerializer和AFHTTPResponseSerializer
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];// 请求
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];// 响应
    
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    manager.requestSerializer.timeoutInterval = 10;
    //    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20;
    //    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(1.f * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!callback) {
            return ;
        }
        callback(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [IBProgressHUD showInfoWithStatus:@"网络异常，请稍后再试"];
        callback(error);
    }];
}

+ (void)postUrl:(NSString *)url params:(NSDictionary *)params progress:(ZJNetProgress)progress callback:(ZJNetCallback)callback {
    
//    JPLog(@"params - %@", params);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(1.f * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!callback) {
            return ;
        }
        callback(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JPLog(@"error - %@", error);
        callback (@"error");
        [IBProgressHUD showInfoWithStatus:@"网络异常，请稍后再试"];
    }];
}

+ (void)postUrl_V1_0_2:(NSString *)url params:(id)params callback:(JPNetCallback)callback {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 8;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if (callback) {
                callback(responseObject[@"resultCode"], responseObject[@"resultMsg"], responseObject[@"data"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JPLog(@"error - %@", error);
        NSString *timeout = [NSString stringWithFormat:@"%ld", (long)error.code];
        if (callback) {
            if ([timeout isEqualToString:@"-1001"]) {
                callback (@"-1001", @"网络超时", @{});
            } else {
                callback (@"-1", @"网络异常，请稍后再试", @{});
            }
        }
    }];
}

+ (void)uploadImagesAtUrl:(NSString *)path params:(NSDictionary *)params images:(NSArray<UIImage *> *)images progress:(ZJNetProgress)progress callback:(ZJNetCallback)callback
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 图片
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *imageName = [formatter stringFromDate:[NSDate date]];
        for(int i = 0; i < images.count; i ++) {
            UIImage *eachImg = [images objectAtIndex:i];
            //压缩方式
            //NSData *eachImgData = UIImagePNGRepresentation(eachImg);
            NSData *eachImgData = UIImageJPEGRepresentation(eachImg, 1);
            [formData appendPartWithFileData:eachImgData name:[NSString stringWithFormat:@"%@%d", imageName, i + 1] fileName:[NSString stringWithFormat:@"%@%d.jpg", imageName, i + 1] mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(1.f * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!callback) {
            return ;
        }
        //        NSString *returnCode = [responseObject objectForKey:@"returnCode"];
        //        BOOL success = [returnCode isEqualToString:@"0"];
        //        NSString *msg = [responseObject objectForKey:@"msg"];
        callback(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(error);
    }];
}

@end
