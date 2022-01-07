//
//  FileManager.h
//  ZXartApp
//
//  Created by mac  on 2017/8/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DocumentsPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject
#define LibraryPath NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject
#define CachesPath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

@interface FileCenter : NSObject

@property (nonatomic,   copy) NSString *documentsPath;

@property (nonatomic,   copy) NSString *libraryPath;

@property (nonatomic,   copy) NSString *cachePath;

@property (nonatomic,   copy) NSString *tmpPath;

+ (FileCenter *)fileCenter;

+ (void)attempDealloc;

+ (NSString *)fileSize;

+ (void)fileSizeValueWithCompleteHandler:(void(^)(unsigned long long fileTotalSize))handler;

- (NSString *)pathForCachesDirectory;

- (NSString *)pathForDocumentsDirectory;

- (NSString *)pathForLibraryDirectory;

- (NSString *)pathForTemporaryDirectory;

- (NSString *)fullPathOf:(NSString *)path;

- (NSString *)fileExtention:(NSString *)filePath;

- (NSString *)fileName:(NSString *)filePath;

- (NSString *)fileNameWithoutExtension:(NSString *)filePath;

- (BOOL)isFileDirectoryExist:(NSString *)directoryName;

- (BOOL)isFileDirectoryExist:(NSString *)directoryName atPath:(NSString *)path;

- (BOOL)isFileExistWithFilePath:(NSString *)filePath;

- (BOOL)isFileExistWithFileName:(NSString *)fileName;

- (BOOL)isFileExistWithFileName:(NSString *)fileName atPath:(NSString *)path;

- (unsigned long long)fileSizeWithError:(NSError **)error;

- (unsigned long long)fileSizeAtPath:(NSString *)path error:(NSError **)error;

- (NSDictionary *)sepecificFileSizeAtPath:(NSString *)path error:(NSError **)error;

- (NSString *)fileSizeStrDescription:(unsigned long long)size;


/**
 *  创建文件路径
 *
 */
//+ (NSString *)createFilePathWithFileName:(NSString *)fileName;
//
//+ (NSString *)createFilePathWithFileName:(NSString *)fileName fileDirectory:(NSString *)fileDirectory;

/**
 *  在Document中创建目录
 *
 *  @param directoryName 目录名称
 *
 *  @return 目录路径
 */
- (NSString *)createFileDirectoryForDirectoryName:(NSString *)directoryName;

- (NSString *)createFileDirectoryForDirectoryName:(NSString *)directoryName error:(NSError **)error;

/**
 *  在目录中创建目录
 *
 *  @param directoryPath 目录路径
 *
 *  @return 目录路径
 */
- (NSString *)createFileDirectory:(NSString *)directoryName atDirectoryPath:(NSString *)directoryPath;

- (NSString *)createFileDirectory:(NSString *)directoryName atDirectoryPath:(NSString *)directoryPath error:(NSError **)error;

/**
 *  在Document中删除目录
 *
 *  @param directoryName 目录名称
 *
 *  @return 删除返回结果
 */
- (BOOL)removeFileDirectoryForDirectoryName:(NSString *)directoryName;

- (BOOL)removeFileDirectoryForDirectoryName:(NSString *)directoryName error:(NSError **)error;

- (BOOL)removeFileDirectoryForDirectoryName:(NSString *)directoryName atPath:(NSString *)path;

- (BOOL)removeFileDirectoryForDirectoryName:(NSString *)directoryName atPath:(NSString *)path error:(NSError **)error;

/**
 *  获取目录路径
 *
 *  @param directoryName 目录名称
 *
 *  @return 目录路径
 */
- (NSString *)fileDirectoryPathWithDirectoryName:(NSString *)directoryName;

- (NSString *)fileDirectoryPathWithDirectoryName:(NSString *)directoryName atPath:(NSString *)path;

/**
 *  获取文件路径
 *
 *  @param fileName 文件名称
 *
 *  @return 文件路径
 */
- (NSString *)filePathWithFileName:(NSString *)fileName;

/**
 *  获取文件路径
 *
 *  @param fileName 文件名称
 *  @param path     指定路径
 *
 *  @return 文件路径
 */
- (NSString *)filePathWithFileName:(NSString *)fileName atPath:(NSString *)path;

/**
 *  数据写入本地
 *
 *  @param fileData 数据
 *  @param fileName 文件名
 *  @param atPath   路径
 *
 *  @return 是否成功
 */ 
- (BOOL)writeFile:(id)fileData fileName:(NSString *)fileName shouldOverWrite:(BOOL)shouldOverWrite error:(NSError **)error;

- (BOOL)writeFile:(id)fileData fileName:(NSString *)fileName atPath:(NSString *)path shouldOverWrite:(BOOL)shouldOverWrite error:(NSError **)error;

- (BOOL)archiveFile:(id)fileData fileName:(NSString *)fileName shouldOverWrite:(BOOL)shouldOverWrite error:(NSError **)error;

- (BOOL)archiveFile:(id)fileData fileName:(NSString *)fileName atPath:(NSString *)path shouldOverWrite:(BOOL)shouldOverWrite error:(NSError **)error;

- (id)unarchiveFileName:(NSString *)fileName error:(NSError **)error;

- (id)unarchiveFileName:(NSString *)fileName atPath:(NSString *)path error:(NSError **)error;


/**
 *  删除数据
 *
 *  @param fileData 数据
 *  @param fileName 文件名
 *  @param atPath   路径
 *  @param error    错误
 *
 *  @return 是否成功
 */

- (BOOL)removeFile:(NSString *)fileName;

- (BOOL)removeFile:(NSString *)fileName error:(NSError **)error;

- (BOOL)removeFile:(NSString *)fileName atPath:(NSString *)path;

- (BOOL)removeFile:(NSString *)fileName atPath:(NSString *)path error:(NSError **)error;

- (BOOL)removeFileAt:(NSString *)filePath error:(NSError **)error;

- (void)clearDatasExcept:(NSArray *)exceptArray finishHandler:(void(^)(void))finishHandler;

- (void)clearDatasAtPath:(NSString *)path except:(NSArray *)exceptArray finishHandler:(void(^)(void))finishHandler;

/**
 *  拷贝
 *
 *  @param orignalPath    原始路径
 *  @param destnationPath 目标路径
 *  @param error          错误
 *
 *  @return 成功与否
 */
- (BOOL)copyFromPath:(NSString *)orignalPath toPath:(NSString *)destnationPath error:(NSError **)error;

/**
 *  移动
 *
 *  @param orignalPath    原始路径
 *  @param destnationPath 目标路径
 *  @param error          错误
 *
 *  @return 成功与否
 */
- (BOOL)moveFromPath:(NSString *)orignalPath toPath:(NSString *)destnationPath error:(NSError **)error;

- (NSDictionary *)attributesForFilePath:(NSString *)path error:(NSError **)error;
@end
