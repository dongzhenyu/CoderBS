//
//  HttpRequest.h
//  budejie
//
//  Created by dzy on 16/1/3.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface HttpRequest : NSObject

+ (void)get:(NSString *)url params:(NSDictionary *)params sucess:(void(^)(id json))sucess failure:(void(^)(NSError *error))failure;

+ (void)post:(NSString *)url params:(NSDictionary *)params sucess:(void(^)(id json))sucess failure:(void(^)(NSError *error))failure;
/**
 *  获取网络状态
 */
+ (AFNetworkReachabilityStatus)getNetWorkState;

@end
