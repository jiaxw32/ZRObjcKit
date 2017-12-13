//
//  ZRFileHelper.m
//  ZRTrackingManager
//
//  Created by jiaxw-mac on 2017/12/10.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "ZRFileHelper.h"
#import "ZRFileInfoModel.h"

@implementation ZRFileHelper

+ (NSString *)appDocumentPath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)appLibraryPath{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)appTempPath{
    return NSTemporaryDirectory();
}

+ (NSString *)appHomePath{
    return NSHomeDirectory();
}

+ (NSString *)mainBundlePath{
    return [[NSBundle mainBundle] bundlePath];
}

+ (NSInteger)subFilesCountOfDirectory:(NSURL *)fileURL{
    
    
    if (NO == [[self class] isDirectoryOfURL:fileURL]){
        return 0;
    }
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtURL:fileURL
                                   includingPropertiesForKeys:@[]
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:&error];
    return [contents count];
}

+ (NSArray *)subFilesOfDirectory:(NSString *)directory includeDirectory:(BOOL)includeDirectory filter:(NSString *)filter{
    
    if (NO == [[NSFileManager defaultManager] fileExistsAtPath:directory]) {
        return nil;
    }
    
    NSURL *fileURL = [NSURL fileURLWithPath:directory];
    if (![[self class] isDirectoryOfURL:fileURL]){
        return nil;
    }
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtURL:fileURL
                                   includingPropertiesForKeys:@[
                                                                NSURLPathKey,
                                                                NSURLNameKey,
                                                                NSURLFileResourceTypeKey,
                                                                NSURLFileSizeKey,
                                                                NSURLIsDirectoryKey,
                                                                NSURLCreationDateKey,
                                                                NSURLContentModificationDateKey,
                                                                ]
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:&error];
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pathExtension == 'png'"];
//    for (NSURL *fileURL in [contents filteredArrayUsingPredicate:predicate]) {
//        // 在目录中枚举 .png 文件
//    }

    NSMutableArray *fileInfoArray = [NSMutableArray new];
    [contents enumerateObjectsUsingBlock:^(NSURL*  _Nonnull url, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isDirectory = [[self class] isDirectoryOfURL:url];
        if (NO == includeDirectory && isDirectory) {
            //过滤文件目录
        } else {
            ZRFileInfoModel *model = [ZRFileInfoModel fileInfoModelWithURL:url];
            model.rootPath = directory;
            model.relationPath = [url.path substringFromIndex:directory.length];
            [fileInfoArray addObject:model];
        }
    }];
    return fileInfoArray;
}


- (void)traverseDirectory:(NSString *)directory completionHandler:(void(^)(NSArray<ZRFileInfoModel *> *))handler{
    NSURL *fileURL = [NSURL fileURLWithPath:directory];
    
    if (NO == [[NSFileManager defaultManager] fileExistsAtPath:directory]) {
        handler(nil);
    }
    
    if (![[self class] isDirectoryOfURL:fileURL]){
        handler(nil);
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:fileURL
                                          includingPropertiesForKeys:@[
                                                                       NSURLPathKey,
                                                                       NSURLNameKey,
                                                                       NSURLFileResourceTypeKey,
                                                                       NSURLFileSizeKey,
                                                                       NSURLIsDirectoryKey,
                                                                       NSURLCreationDateKey,
                                                                       NSURLContentModificationDateKey,
                                                                       ]
                                                             options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        errorHandler:^BOOL(NSURL *url, NSError *error)
    {
        if (error) {
            NSLog(@"[Error] %@ (%@)", error, url);
            return NO;
        }
        return YES;
    }];
    
    NSMutableArray *fileInfoArray = [NSMutableArray array];
    for (NSURL *fileURL in enumerator) {
        
        ZRFileInfoModel *model = [ZRFileInfoModel fileInfoModelWithURL:fileURL];
        model.rootPath = directory;
        model.relationPath = [fileURL.path substringFromIndex:directory.length];
        [fileInfoArray addObject:model];
        
        /*
         NSString *filename;
         [fileURL getResourceValue:&filename forKey:NSURLNameKey error:nil];
        
        NSNumber *isDirectory;
        [fileURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
        
        // Skip directories with '_' prefix, for example
        if ([filename hasPrefix:@"_"] && [isDirectory boolValue]) {
            [enumerator skipDescendants];
            continue;
        }
         */
    }
    handler(fileInfoArray);
}


+ (BOOL)isDirectoryOfURL:(NSURL *)fileURL{
    NSNumber *isDirectory;
    [fileURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
    return isDirectory.boolValue;
}

+ (BOOL)isDirectoryOfPath:(NSString *)path{
    BOOL isDirectory = NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    return isDirectory;
}

+ (NSString *)getFileName:(NSURL *)fileURL{
    NSString *filename;
    [fileURL getResourceValue:&filename forKey:NSURLNameKey error:nil];
    return filename;
}

+ (NSString *)getParentDirectory:(NSURL *)fileURL{
    NSURL *parentDirectory;
    [fileURL getResourceValue:&parentDirectory forKey:NSURLParentDirectoryURLKey error:nil];
    return parentDirectory.path;
}

+ (NSInteger)getFileSize:(NSURL *)fileURL{
    NSNumber *fileSize;
    [fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:nil];
    return fileSize.integerValue;
}

+ (NSDate *)getFileCreateDate:(NSURL *)fileURL{
    NSDate *createDate;
    [fileURL getResourceValue:&createDate forKey:NSURLCreationDateKey error:nil];
    return createDate;
}

+ (NSDate *)getFileModifyDate:(NSURL *)fileURL{
    NSDate *modifyDate;
    [fileURL getResourceValue:&modifyDate forKey:NSURLContentModificationDateKey error:nil];
    return modifyDate;
}

+ (NSString *)getFileType:(NSURL *)fileURL{
    NSString *fileType;
    [fileURL getResourceValue:&fileType forKey:NSURLFileResourceTypeKey error:nil];
    return fileType;
}

+ (NSString *)formatFileSize:(NSInteger)fileSize{
    NSString *result;
    if (fileSize < 1024) {//Byte
        result = [NSString stringWithFormat:@"%lu byte",fileSize];
    } else if (fileSize >= 1024 && fileSize < 1024 * 102){//KB
        result = [NSString stringWithFormat:@"%.2f KB",fileSize/1024.0];
    } else if (fileSize >= 1024 * 1024 && fileSize < 1024 * 1024 * 1024){//MB
        result = [NSString stringWithFormat:@"%.2f MB",fileSize/(1024.0/1024.0)];
    } else {//GB
        result = [NSString stringWithFormat:@"%.2f GB",fileSize/(1024.0 * 1024.0 * 1024.0)];
    }
    return result;
}
@end
