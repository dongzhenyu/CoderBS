//
//  HttpRequest.m
//  budejie
//
//  Created by dzy on 16/1/3.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "HttpRequest.h"
#import <AFNetworking.h>

@implementation HttpRequest

static AFNetworkReachabilityStatus _status;

static AFNetworkReachabilityManager *_reachability;

+ (void)initialize
{
    // 检测网络
    _reachability = [AFNetworkReachabilityManager sharedManager];
    _status = _reachability.networkReachabilityStatus;
    [self Reachability];
}

/**
 *  网络检测
 */
+ (void)Reachability
{
    [_reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                _status=AFNetworkReachabilityStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                _status=AFNetworkReachabilityStatusReachableViaWiFi;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                _status=AFNetworkReachabilityStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusUnknown:
                _status=AFNetworkReachabilityStatusUnknown;
                break;
        }
    }];
}

+ (AFNetworkReachabilityStatus)getNetWorkState
{
    return _status;
}

+ (void)get:(NSString *)url params:(NSDictionary *)params sucess:(void (^)(id))sucess failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager.requestSerializer setTimeoutInterval:15];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    
    // 2.发送GET请求
    [manager GET:url parameters:dict progress:^(NSProgress *downloadProgress) {
        
    } success:
     ^(NSURLSessionDataTask *task, id responseObject) {

         if (sucess) {
             sucess(responseObject);
         }
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params sucess:(void (^)(id))sucess failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:15];
    
    // 以json格式相应
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 以json格式发送 如果是http请求 加上请求数据格式错误
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    
    [manager POST:url parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sucess) {
            sucess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

@end
