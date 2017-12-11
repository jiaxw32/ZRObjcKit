//
//  ZRFileHelper.h
//  ZRTrackingManager
//
//  Created by jiaxw-mac on 2017/12/10.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZRFileHelper : NSObject

+ (NSString *)appDocumentPath;

+ (NSString *)appLibraryPath;

+ (NSString *)appTempPath;

+ (NSString *)appHomePath;

+ (NSString *)mainBundlePath;

+ (BOOL)isDirectoryOfURL:(NSURL *)fileURL;

+ (BOOL)isDirectoryOfPath:(NSString *)path;

+ (NSString *)getFileName:(NSURL *)fileURL;

+ (NSString *)getParentDirectory:(NSURL *)fileURL;

+ (NSArray *)subFilesOfDirectory:(NSString *)directory includeDirectory:(BOOL)includeDirectory filter:(NSString *)filter;

+ (NSInteger)subFilesCountOfDirectory:(NSURL *)fileURL;

+ (NSInteger)getFileSize:(NSURL *)fileURL;

+ (NSDate *)getFileCreateDate:(NSURL *)fileURL;

+ (NSDate *)getFileModifyDate:(NSURL *)fileURL;

+ (NSString *)getFileType:(NSURL *)fileURL;

+ (NSString *)formatFileSize:(NSInteger)fileSize;

@end
