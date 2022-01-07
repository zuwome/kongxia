//
//  FileManager.m
//  ZXartApp
//
//  Created by mac  on 2017/8/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "FileCenter.h"
#import <pthread.h>

static inline void GCDMain(void (^block)(void)) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

static inline void GCDGlobal(void (^block)(void)) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}


@interface FileCenter ()

@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation FileCenter

static FileCenter *_instance = nil;
static dispatch_once_t predicate;

#pragma mark - Class Method
+ (FileCenter *)fileCenter {
    WeakSelf
    dispatch_once(&predicate, ^{
        if (!_instance) {
            _instance = [[weakSelf alloc] init];
        }
    });
    return _instance;
}

+ (void)attempDealloc {
    predicate = 0; // 只有置成0,GCD才会认为它从未执行过.它默认为0.这样才能保证下次再次调用shareInstance的时候,再次创建对象.
    _instance = nil;
}

+ (NSString *)fileSize {
    unsigned long long size = [[FileCenter fileCenter] fileSizeWithError:nil];
    return  [[FileCenter fileCenter] fileSizeStrDescription:size];
}

+ (void)fileSizeValueWithCompleteHandler:(void (^)(unsigned long long))handler {
    GCDGlobal(^{
        unsigned long long fileTotalSize = [[FileCenter fileCenter] fileSizeWithError:nil];
        GCDMain(^{
            if (handler) {
                handler(fileTotalSize);
            }
        });
    });

}

#pragma mark - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}

#pragma mark - Public Method
- (NSString *)pathForCachesDirectory {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}

- (NSString *)pathForDocumentsDirectory {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

- (NSString *)pathForLibraryDirectory {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
}

-( NSString *)pathForTemporaryDirectory {
    return NSTemporaryDirectory();
}

- (NSString *)fullPathOf:(NSString *)path {
    return [NSURL fileURLWithPath:path].absoluteString;
}

- (NSString *)fileExtention:(NSString *)filePath {
    return [filePath pathExtension];
}

- (NSString *)fileName:(NSString *)filePath {
    return [filePath lastPathComponent];
}

- (NSString *)fileNameWithoutExtension:(NSString *)filePath {
    return  [[self fileName:filePath] stringByDeletingPathExtension];
}

- (unsigned long long)fileSizeWithError:(NSError **)error {
    return [self fileSizeAtPath:DocumentsPath error:error];
}

- (unsigned long long)fileSizeAtPath:(NSString *)path error:(NSError **)error {
    NSDictionary *attributes = [self attributesForFilePath:path error:error];
    if (attributes == nil) return 0.00;
    if ([attributes.fileType isEqualToString:NSFileTypeDirectory]) {
        return [self directorySize:path];
    }
    else {
        return [self fileSize:path];
    }
}

- (NSDictionary *)sepecificFileSizeAtPath:(NSString *)path error:(NSError **)error {
    NSArray             *array              = [self fetchAllFilesAndDirectoriesAtPath:path];
    NSMutableDictionary *fileSizeMutbaleDic = @{}.mutableCopy;

    for (NSString *subPath in array) {
        NSString     *fullSubPath       = [path stringByAppendingPathComponent:subPath];
        NSString     *sizeText          = nil;
        NSDictionary *subPathAttributes = [_fileManager attributesOfItemAtPath:fullSubPath error:nil];

        if (!subPathAttributes || [subPath isEqualToString:@".DS_Store"]) {
            continue;
        }
        if ([subPathAttributes.fileType isEqualToString:NSFileTypeDirectory]) {
            sizeText = [self fileSizeStrDescription:[self directorySize:fullSubPath]];
        }
        else {
            sizeText = [self fileSizeStrDescription:[self directorySize:fullSubPath]];
        }
        [fileSizeMutbaleDic setObject:sizeText forKey:subPath];
    }
    return fileSizeMutbaleDic.copy;
}

#pragma mark -FileDirectory
- (BOOL)isFileDirectoryExist:(NSString *)directoryName {
    return [self isFileDirectoryExist:directoryName atPath:DocumentsPath];
}

- (BOOL)isFileDirectoryExist:(NSString *)directoryName
                      atPath:(NSString *)path {
    NSString *directoryPath = [DocumentsPath stringByAppendingPathComponent:directoryName];
    return [self isPathExist:directoryPath isDirectory:YES];
}

- (NSString *)createFileDirectoryForDirectoryName:(NSString *)directoryName {
    return [self createFileDirectoryForDirectoryName:directoryName error:nil];
}

- (NSString *)createFileDirectoryForDirectoryName:(NSString *)directoryName
                                            error:(NSError **)error {
    return [self createFileDirectory:directoryName atDirectoryPath:DocumentsPath error:error];
}

- (NSString *)createFileDirectory:(NSString *)directoryName
                  atDirectoryPath:(NSString *)directoryPath {
    return [self createFileDirectory:directoryName atDirectoryPath:directoryPath error:nil];
}

- (NSString *)createFileDirectory:(NSString *)directoryName
                  atDirectoryPath:(NSString *)directoryPath
                            error:(NSError **)error  {
    NSString *subDirectoryPath = [directoryPath stringByAppendingPathComponent:directoryName];
    if ([self isPathExist:directoryPath isDirectory:YES]) {
        if (![self isPathExist:subDirectoryPath isDirectory:YES]) {
            return [_fileManager createDirectoryAtPath:subDirectoryPath withIntermediateDirectories:NO attributes:nil error:error] ?subDirectoryPath : nil;
        }
        else {
            return subDirectoryPath;
        }
    }
    else {
        return nil;
    }
}

- (BOOL)removeFileDirectoryForDirectoryName:(NSString *)directoryName {
    return [self removeFileDirectoryForDirectoryName:directoryName error:nil];
}

- (BOOL)removeFileDirectoryForDirectoryName:(NSString *)directoryName
                                      error:(NSError **)error {
    return [self removeFileDirectoryForDirectoryName:directoryName atPath:DocumentsPath error:error];
}

- (BOOL)removeFileDirectoryForDirectoryName:(NSString *)directoryName
                                     atPath:(NSString *)path {
    return [self removeFileDirectoryForDirectoryName:directoryName atPath:path error:nil];
}

- (BOOL)removeFileDirectoryForDirectoryName:(NSString *)directoryName
                                     atPath:(NSString *)path
                                      error:(NSError **)error {
    NSString *directoryPath = [path stringByAppendingPathComponent:directoryName];
    if ([self isPathExist:path isDirectory:YES]) {
        if ([self isPathExist:directoryPath isDirectory:YES]) {
            return [_fileManager removeItemAtPath:directoryPath error:error];
        }
        else {
            return YES;
        }
    }
    else {
        return YES;
    }
}

- (NSString *)fileDirectoryPathWithDirectoryName:(NSString *)directoryName {
    return [self fileDirectoryPathWithDirectoryName:directoryName atPath:DocumentsPath];
}

- (NSString *)fileDirectoryPathWithDirectoryName:(NSString *)directoryName
                                          atPath:(NSString *)path {
    return [path stringByAppendingPathComponent:directoryName];
}

#pragma mark - File
- (BOOL)isFileExistWithFilePath:(NSString *)filePath {
    return [_fileManager fileExistsAtPath:filePath];
}

- (BOOL)isFileExistWithFileName:(NSString *)fileName {
    return [self isFileExistWithFileName:fileName atPath:DocumentsPath];
}

- (BOOL)isFileExistWithFileName:(NSString *)fileName
                         atPath:(NSString *)path {
    NSString *filePath = [DocumentsPath stringByAppendingPathComponent:fileName];
    return [self isPathExist:filePath isDirectory:NO];
}

- (NSString *)filePathWithFileName:(NSString *)fileName {
    return [self filePathWithFileName:fileName atPath:DocumentsPath];
}

- (NSString *)filePathWithFileName:(NSString *)fileName
                            atPath:(NSString *)path {
    return [path stringByAppendingPathComponent:fileName];
}

- (BOOL)writeFile:(id)fileData
         fileName:(NSString *)fileName
  shouldOverWrite:(BOOL)shouldOverWrite
            error:(NSError *__autoreleasing *)error {
    return [self writeFile:fileData fileName:fileName atPath:DocumentsPath shouldOverWrite:shouldOverWrite error:error];
}

- (BOOL)writeFile:(id)fileData
         fileName:(NSString *)fileName
           atPath:(NSString *)path
  shouldOverWrite:(BOOL)shouldOverWrite
            error:(NSError *__autoreleasing *)error {
    if (!fileData) {
        return NO;;
    }
    
    if (shouldOverWrite) {
        [self removeFile:fileName atPath:path];
    }
    
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    if ([fileData isKindOfClass:[NSString class]]) {
        return [((NSString *)fileData) writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:error];
    }
    else if ([fileData isKindOfClass:[NSArray class]]) {
        return [((NSArray *)fileData) writeToFile:filePath atomically:YES];
    }
    else if ([fileData isKindOfClass:[NSDictionary class]]) {
        return [((NSDictionary *)fileData) writeToFile:filePath atomically:YES];
    }
    else if ([fileData isKindOfClass:[NSData class]]) {
        return [((NSData *)fileData) writeToFile:filePath atomically:YES];
    }
    else {
        return [self archiveFile:fileData fileName:fileName atPath:path shouldOverWrite:shouldOverWrite error:error];
    }
}

- (BOOL)archiveFile:(id)fileData
           fileName:(NSString *)fileName
    shouldOverWrite:(BOOL)shouldOverWrite
              error:(NSError *__autoreleasing *)error {
    return [self archiveFile:fileData
                    fileName:fileName
                      atPath:DocumentsPath
             shouldOverWrite:shouldOverWrite
                       error:error];
}

- (BOOL)archiveFile:(id)fileData
           fileName:(NSString *)fileName
             atPath:(NSString *)path
    shouldOverWrite:(BOOL)shouldOverWrite
              error:(NSError *__autoreleasing *)error {
    if (![fileData conformsToProtocol:@protocol(NSCoding)]) {
        if (error) {
            *error  = [NSError errorWithDomain:@"FileCenter.zxart"
                                          code:-100
                                      userInfo:@{NSLocalizedDescriptionKey : @"对象不遵守NSCoding协议"}];
        }
        return NO;
    }
    
    if (shouldOverWrite) {
        [self removeFile:fileName atPath:path];
    }

    NSString *filePath = [path stringByAppendingPathComponent:fileName];

//    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject]stringByAppendingPathComponent:@"VideoIndexData.archiver"];
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //编码
    [archiver encodeObject:fileData forKey:fileName];
    [archiver finishEncoding];
    // 完成编码，将上面的归档数据填充到data中，此时data中已经存储了归档对象的数据
//    BOOL isSuccess = [data writeToFile:filePath atomically:YES];
    
    return [data writeToFile:filePath atomically:YES];
}

- (id)unarchiveFileName:(NSString *)fileName
                  error:(NSError *__autoreleasing *)error {
    return [self unarchiveFileName:fileName
                            atPath:DocumentsPath
                             error:error];
}

- (id)unarchiveFileName:(NSString *)fileName
                 atPath:(NSString *)path
                  error:(NSError *__autoreleasing *)error {
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    // 解档
    id fileData = [unarchiver decodeObjectForKey:fileName];
    if (!fileData && error) {
        *error  = [NSError errorWithDomain:@"FileCenter.zxart"
                                      code:-100
                                  userInfo:@{NSLocalizedDescriptionKey : @"无数据"}];
    }
    return fileData;
}

- (BOOL)removeFile:(NSString *)fileName {
    return [self removeFile:fileName atPath:DocumentsPath];
}

- (BOOL)removeFile:(NSString *)fileName
             error:(NSError **)error {
    return [self removeFile:fileName atPath:DocumentsPath error:error];
}

- (BOOL)removeFile:(NSString *)fileName
            atPath:(NSString *)path {
    return [self removeFile:fileName atPath:path error:nil];
}

- (BOOL)removeFile:(NSString *)fileName
            atPath:(NSString *)path
             error:(NSError **)error {
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    return [self removeFileAt:filePath error:error];
}

- (BOOL)removeFileAt:(NSString *)filePath error:(NSError *__autoreleasing *)error {
    if ([self isPathExist:filePath isDirectory:NO]) {
        return [_fileManager removeItemAtPath:filePath error:error];
    }
    return YES;
}

- (void)clearDatasExcept:(NSArray *)exceptArray finishHandler:(void (^)(void))finishHandler {
    [self clearDatasAtPath:DocumentsPath except:exceptArray finishHandler:finishHandler];
}

- (void)clearDatasAtPath:(NSString *)path
                  except:(NSArray *)exceptArray
           finishHandler:(void (^)(void))finishHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *pathArray = [self fetchAllFilesAndDirectoriesAtPath:path];
        NSMutableArray *exceptions = exceptArray.mutableCopy;
        [pathArray enumerateObjectsUsingBlock:^(NSString * _Nonnull subPath, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![exceptions containsObject:subPath]) {
                NSString *filePath = [path stringByAppendingPathComponent:subPath];
                [_fileManager removeItemAtPath:filePath error:nil];
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(),^{
            if (finishHandler) {
                finishHandler();
            }
        });
    });
}

- (BOOL)copyFromPath:(NSString *)orignalPath toPath:(NSString *)destnationPath error:(NSError **)error {
    return [_fileManager copyItemAtPath:orignalPath toPath:destnationPath error:error];
}

- (BOOL)moveFromPath:(NSString *)orignalPath toPath:(NSString *)destnationPath error:(NSError **)error {
    return [_fileManager moveItemAtPath:orignalPath toPath:destnationPath error:error];
}

#pragma mark - Private Method
- (BOOL)isPathExist:(NSString *)path
        isDirectory:(BOOL)isDirectory {
    return [_fileManager fileExistsAtPath:path isDirectory:&isDirectory];
}

- (NSArray<NSString *> *)fetchAllFilesAndDirectoriesAtPath:(NSString *)path {
   return [_fileManager contentsOfDirectoryAtPath:path error:nil];
}

- (NSArray<NSString *> *)fetchSubfilesAndSubdirectoriesAtPath:(NSString *)path {
    return [_fileManager subpathsAtPath:path];
}

#pragma mark -File/Directory Attributes
- (NSDictionary *)attributesForFilePath:(NSString *)path error:(NSError **)error {
    return [_fileManager attributesOfItemAtPath:path error:error];
}

#pragma mark -File/Directory Size
- (unsigned long long)directorySize:(NSString *)directioryPath {
    unsigned long long size = 0;
    NSDictionary *directoryAttributes = [_fileManager attributesOfItemAtPath:directioryPath error:nil];
    if ([directoryAttributes.fileType isEqualToString:NSFileTypeDirectory] ) {
        NSDirectoryEnumerator *enumerator = [_fileManager enumeratorAtPath:directioryPath];
        for (NSString *subPath in enumerator) {
            NSString *fullSubpath = [directioryPath stringByAppendingPathComponent:subPath];
            size += [_fileManager attributesOfItemAtPath:fullSubpath error:nil].fileSize;
        }
    }
    return size;
}

- (unsigned long long)fileSize:(NSString *)filePath {
    unsigned long long size = 0;
    NSDictionary *directoryAttributes = [_fileManager attributesOfItemAtPath:filePath error:nil];
    size = directoryAttributes.fileSize;
    return size;
}

- (NSString *)fileSizeStrDescription:(unsigned long long)size {
    NSString *sizeText;
    if (size >= pow(10, 9)) {
        // size >= 1GB
        sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
    }
    else if (size >= pow(10, 6)) {
        // 1GB > size >= 1MB
        sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
    }
    else if (size >= pow(10, 3)) {
        // 1MB > size >= 1KB
        sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
    }
    else {
        // 1KB > size
        sizeText = [NSString stringWithFormat:@"%lluuB", size];
    }
    return sizeText;
}

@end
