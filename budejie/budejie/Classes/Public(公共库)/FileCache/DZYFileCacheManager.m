//
//  DZYFileCacheManager.m
//  budejie
//
//  Created by dzy on 16/1/8.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYFileCacheManager.h"

@implementation DZYFileCacheManager

+ (NSInteger)getFileCacheSize:(NSString *)filePath
{
    // 1.创建文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 2.获取文件尺寸
    NSDictionary *attr = [mgr attributesOfItemAtPath:filePath error:nil];
    
    return [attr[NSFileSize] integerValue];
}

// 涉及到异步方法,这个方法没必要设置返回值,没有意义
// 异步方法:使用Block回调
+ (void)getDirectoryCacheSize:(NSString *)directoryPath completeBlock:(void(^)(NSInteger))completeBlock
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 1.创建文件管理者
        NSFileManager *mgr = [NSFileManager defaultManager];
        
        // 判断下传入路径是否是文件夹路径
        BOOL isDirectory;
        BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
        
        // 文件不存在 或者 传入不是文件夹,就不执行下面计算
        if (!isExist || !isDirectory) {
            // 创建异常对象
            NSException *excp = [NSException exceptionWithName:@"FileError" reason:@"传入文件不存在或者传入的不是文件夹" userInfo:nil];
            // 抛异常
            [excp raise];
        }
        
        // 计算文件夹尺寸
        // 2.获取文件夹尺寸 = 所有文件尺寸相加
        // 2.1 获取文件夹下所有子路径
        NSArray *subPaths = [mgr subpathsAtPath:directoryPath];
        
        NSInteger total = 0;
        // 2.2 遍历所有子路径
        for (NSString *subPath in subPaths) {
            // 2.3 文件全路径
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            
            // 2.3 判断下当前路径是否是文件夹
            BOOL isDirectory;
            BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
            if (isExist && ! isDirectory && ![filePath containsString:@"DS"]) { // 文件存在 并且 不是文件夹,而且也不是隐藏文件,才需要计算
                
                // 获取文件尺寸
                total += [self getFileCacheSize:filePath];
                
            }
            
        }
        
        // 回到主线程调用block
        dispatch_sync(dispatch_get_main_queue(), ^{
            // 计算完成
            if (completeBlock) {
                completeBlock(total);
                
            }
        });
        
    });
    
}

+ (void)deleteFilePath:(NSString *)filePath
{
    // 创建文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 判断是文件夹还是文件
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
    
    if (!isExist) return;
    
    if (isDirectory) {
        // 删文件夹
        // 遍历所有子路径 一个一个删除
        NSArray *subPaths = [mgr subpathsAtPath:filePath];
        
        for (NSString *subPath in subPaths) {
            // 文件全路径
            NSString *subfilePath = [filePath stringByAppendingPathComponent:subPath];
            
            // 删除文件
            [mgr removeItemAtPath:subfilePath error:nil];
        }
        
    } else {
        
        [mgr removeItemAtPath:filePath error:nil];
        
    }
    
}


@end
