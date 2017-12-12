//
//  FMDatabaseQueue+ZRSharedDBQueue.h
//  ZRTrackingManager
//
//  Created by jiaxw-mac on 2017/11/29.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import <FMDB/FMDB.h>

@interface FMDatabaseQueue (ZRSharedDBQueue)

+ (instancetype)shareInstance;

@end
