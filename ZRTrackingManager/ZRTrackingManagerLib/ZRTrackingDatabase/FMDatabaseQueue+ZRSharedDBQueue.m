//
//  FMDatabaseQueue+ZRSharedDBQueue.m
//  ZRTrackingManager
//
//  Created by jiaxw-mac on 2017/11/29.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "FMDatabaseQueue+ZRSharedDBQueue.h"
#import "ZRTracking.h"

static NSString *const kZRTrackingDatabaseName = @"ZRTracking.db";

@implementation FMDatabaseQueue (ZRSharedDBQueue)

+ (instancetype)shareInstance{
    static FMDatabaseQueue *databaseQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [documentPath stringByAppendingPathComponent:kZRTrackingDatabaseName];
        ZRTrackingLog(@"db file path:%@",filePath);
        databaseQueue = [[FMDatabaseQueue alloc] initWithPath:filePath];
    });
    return databaseQueue;
}


@end
