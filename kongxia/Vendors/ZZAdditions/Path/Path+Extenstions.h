
#import <Foundation/Foundation.h>

@interface PathDir : NSObject

+ (NSString *)pathOfDoc;
+ (NSString *)pathofLib;
+ (NSString *)pathOfTmp;
+ (NSString *)pathInDoc:(NSString *)filename;
+ (NSString *)pathInLib:(NSString *)filename;
+ (NSString *)pathInTmp:(NSString *)filename;
+ (NSString *)pathInBundle:(NSString *)filename withExt:(NSString *)extname;

+ (void)removeContentsOfDir:(NSString *)dirName;

+ (BOOL)createPathIfNecessary:(NSString *)path; // 不存在则创建

+ (void)copyFromPath:(NSString *)fromPath toPath:(NSString *)toPath;

+ (BOOL)removeFileWithPath:(NSString *)filePath;

+ (BOOL)isFileExist:(NSString *)filePath;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef __cplusplus
extern "C" {
#endif
    
BOOL isBundleURL(NSString *URL);
BOOL isDocumentsURL(NSString *URL);

NSString *pathForBundleResource(NSString *relativePath);
NSString *pathForDocumentsResource(NSString *relativePath);

NSString *pathInDoc(NSString *filename);
NSString *pathInLib(NSString *filename);
NSString *pathInTmp(NSString *filename);

//  example:  filePathInApp(@"dir/dir",@"test.html")
//  results: file://...//dir//dir//test.html
NSString *filePathInApp(NSString *dirName, NSString *filename);

#ifdef __cplusplus
}
#endif
