

#import "Path+Extenstions.h"
#import "NSString+Extensions.h"
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation PathDir
+ (NSString *)pathOfDoc {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

+ (NSString *)pathofLib {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
}

+ (NSString *)pathOfTmp {
    return NSTemporaryDirectory();
}

+ (NSString *)pathInDoc:(NSString *)filename {
    NSString *s = [PathDir pathOfDoc];
    return [s stringByAppendingPathComponent:filename];
}

+ (NSString *)pathInLib:(NSString *)filename {
    NSString *s = [PathDir pathofLib];
    return [s stringByAppendingPathComponent:filename];
}

+ (NSString *)pathInTmp:(NSString *)filename {
    return [[PathDir pathOfTmp] stringByAppendingPathComponent:filename];
}

+ (NSString *)pathInBundle:(NSString *)filename withExt:(NSString *)extname {
    return [[NSBundle mainBundle] pathForResource:filename ofType:extname];
}
+ (void)removeContentsOfDir:(NSString *)dirName {
    NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirName error:nil];
    for (NSString *s in arr) {
        NSString *contentsPath = [dirName stringByAppendingPathComponent:s];
        [[NSFileManager defaultManager] removeItemAtPath:contentsPath error:nil];
    }
}

+ (BOOL)createPathIfNecessary:(NSString *)path {
    BOOL succeeded = YES;

    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        succeeded = [fm createDirectoryAtPath:path
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:nil];
    }

    return succeeded;
}

+ (void)copyFromPath:(NSString *)fromPath toPath:(NSString *)toPath {

    BOOL copyOK = NO;
    
    // is the bundle www index.html there
    BOOL readable = [[NSFileManager defaultManager] isReadableFileAtPath:fromPath];
    
    if (readable) {
        // create the folder, if needed
        [[NSFileManager defaultManager] createDirectoryAtPath:toPath withIntermediateDirectories:YES attributes:nil error:nil];
        // copy
        NSError* error = nil;
        if ((copyOK = [self copyFrom:fromPath to:toPath error:&error])) {
        }

        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

+ (BOOL)removeFileWithPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        BOOL isDelete = [fileManager removeItemAtPath:filePath error:nil];
        return isDelete;
    }
    return NO;
}

+ (BOOL)isFileExist:(NSString *)filePath {
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:filePath];
}

+ (BOOL)copyFrom:(NSString *)src to:(NSString *)dest error:(NSError * __autoreleasing *)error {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:src]) {
        NSString *errorString = [NSString stringWithFormat:@"%@ file does not exist.", src];
        if (error != NULL) {
            (*error) = [NSError errorWithDomain:@"Whistle"
                                           code:1
                                       userInfo:[NSDictionary dictionaryWithObject:errorString
                                                                            forKey:NSLocalizedDescriptionKey]];
        }
        return NO;
    }
    
    // generate unique filepath in temp directory
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    NSString *tempBackup = [[NSTemporaryDirectory() stringByAppendingPathComponent:(__bridge NSString *)uuidString] stringByAppendingPathExtension:@"bak"];
    CFRelease(uuidString);
    CFRelease(uuidRef);
    
    BOOL destExists = [fileManager fileExistsAtPath:dest];
    
    // backup the dest
    if (destExists && ![fileManager copyItemAtPath:dest toPath:tempBackup error:error]) {
        return NO;
    }
    
    // remove the dest
    if (destExists && ![fileManager removeItemAtPath:dest error:error]) {
        return NO;
    }
    
    // create path to dest
    if (!destExists && ![fileManager createDirectoryAtPath:[dest stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:error]) {
        return NO;
    }
    
    // copy src to dest
    if ([fileManager copyItemAtPath:src toPath:dest error:error]) {
        // success - cleanup - delete the backup to the dest
        if ([fileManager fileExistsAtPath:tempBackup]) {
            [fileManager removeItemAtPath:tempBackup error:error];
        }
        return YES;
    } else {
        // failure - we restore the temp backup file to dest
        [fileManager copyItemAtPath:tempBackup toPath:dest error:error];
        // cleanup - delete the backup to the dest
        if ([fileManager fileExistsAtPath:tempBackup]) {
            [fileManager removeItemAtPath:tempBackup error:error];
        }
        return NO;
    }
}

@end
///////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL isBundleURL(NSString *URL) {
    return [URL hasPrefix:@"bundle://"];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL isDocumentsURL(NSString *URL) {
    return [URL hasPrefix:@"documents://"];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
NSString *pathForBundleResource(NSString *relativePath) {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    return [resourcePath stringByAppendingPathComponent:relativePath];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
NSString *pathForDocumentsResource(NSString *relativePath) {
    static NSString *documentsPath = nil;
    if (nil == documentsPath) {
        NSArray *dirs = NSSearchPathForDirectoriesInDomains(
            NSDocumentDirectory, NSUserDomainMask, YES);
        //    documentsPath = [[dirs objectAtIndex:0] retain];
        documentsPath = [dirs objectAtIndex:0];
    }
    return [documentsPath stringByAppendingPathComponent:relativePath];
}

NSString *pathInDoc(NSString *filename) {
    return [PathDir pathInDoc:filename];
}

NSString *pathInLib(NSString *filename) {
    return [PathDir pathInLib:filename];
}

NSString *pathInTmp(NSString *filename) {
    return [PathDir pathInTmp:filename];
}

NSString *filePathInApp(NSString *dirName, NSString *filename) {
    NSString *filePath = [[[[NSBundle mainBundle] resourcePath] stringByReplacingOccurrencesOfString:@"/"
                                                                                          withString:@"//"]
        stringByReplacingOccurrencesOfString:@" "
                                  withString:@"%20"];
    if (![dirName isContain:@"//"]) {
        dirName = [dirName stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    }
    return [NSString stringWithFormat:@"file:/%@//%@//%@", filePath, dirName, filename];
}
