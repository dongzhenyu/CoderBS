//
//  DZYFileCacheManager.h
//  budejie
//
//  Created by dzy on 16/1/8.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZYFileCacheManager : NSObject

/**
 *  获取文件夹尺寸
 *
 *  @param directoryPath 文件夹路径
 *  @param completeBlock 计算完成回调
 *  @return 文件夹尺寸
 */

+ (void)getDirectoryCacheSize:(NSString *)directoryPath completeBlock:(void(^)(NSInteger total))completeBlock;

/**
 *  获取文件尺寸
 *
 *  @param filePath 文件路径
 *
 *  @return 文件尺寸
 */
+ (NSInteger)getFileCacheSize:(NSString *)filePath;

/**
 *  删除文件缓存
 *
 *  @param filePath 文件路径
 */
+ (void)deleteFilePath:(NSString *)filePath;

@end
