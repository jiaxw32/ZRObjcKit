//
//  ZRObjcKit.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/11/29.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "ZRTrackingManager.h"
#import "FMDBHelpers.h"
#import "FMDatabaseQueue+ZRSharedDBQueue.h"
#import "UIApplication+ZRTracking.h"
#import "OpenUDID.h"
#import "ZRTracking.h"

static NSString *const kZR_Track_App_Table = @"zr_track_app";

static NSString *const kZR_Track_Page_Table = @"zr_track_page";

static NSString *const kZR_Track_Event_Table = @"zr_track_event";

static NSString *const kZR_Track_Func_Invoke_Table = @"zr_track_func_invoke";

//设备类型，0 Android,1 iOS
static const NSInteger kZR_Device_Type_iOS  = 1;


@interface ZRTrackingManager (){
    dispatch_queue_t _trackingQueue;
    
    
}

@property (nonatomic,assign) BOOL uploadfinished;

@end

@implementation ZRTrackingManager

+ (instancetype)sharedInstance{
    static ZRTrackingManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [ZRTrackingManager new];
    });
    return sharedInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        _trackingQueue = dispatch_queue_create("com.ziroom.tracking", NULL);
        _uploadfinished = YES;
        [self createTable];
#if ZRTrackingUploadDataEnable
        [self uploadTrackingData];
#endif
        
    }
    return self;
}


/**
 上传跟踪数据
 */
- (void)uploadTrackingData{
    WeakSelf(weakSelf)
    
    //即将休眠
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopBeforeWaiting, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        if (weakSelf.uploadfinished) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                weakSelf.uploadfinished = NO;
                
                //查询一分钟前的数据
                NSTimeInterval timestamp = [ZRTrackingHelper getCurrentTimestamp] - 60;
                NSDictionary *records = [weakSelf queryTrackingRecordBefore:timestamp];
                if (records) {
                    //上传数据到服务器
                    /*
                    [ZRTrackingService uploadTrackingDataWithParams:records success:^(id result, NSString *message) {
                        //删除本地数据库数据
                        [weakSelf deleteTrackingRecordBefore:timestamp];
                    } failure:^(NSString *message) {
                        weakSelf.uploadfinished = YES;
                        ZRTrackingLog(@"upload failure:%@",message);
                    }];
                     */
                } else {
                    weakSelf.uploadfinished = YES;
                }
            });
        }
    });
    
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
}


- (void)createTable{
    [[FMDatabaseQueue shareInstance] inDatabase:^(FMDatabase *db) {
        NSError *error;
        if (NO == [db tableExists:kZR_Track_App_Table]) {
            BOOL result = [db createTableWithName:kZR_Track_App_Table
                                          columns:@[
                                                    @"app_id TEXT PRIMARY KEY",
                                                    @"device INTEGER",
                                                    @"device_token TEXT",
                                                    @"app_version TEXT",
                                                    @"system_version REAL",
                                                    @"user_code TEXT",
                                                    @"begin_time REAL",
                                                    @"end_time REAL",
                                                    @"latitude REAL",
                                                    @"longitude REAL",
                                                    @"launch_options TEXT"
                                                    ]
                                      constraints:nil
                                            error:&error];
            if (!result && error) {
                ZRTrackingLog(@"create table 【%@】 failure:%@",kZR_Track_App_Table,error.description);
            } else {
                ZRTrackingLog(@"create table 【%@】 success",kZR_Track_App_Table);
            }
        }
        
        if (NO == [db tableExists:kZR_Track_Page_Table]) {
            BOOL result = [db createTableWithName:kZR_Track_Page_Table
                                          columns:@[
                                                    @"page_id TEXT PRIMARY KEY",
                                                    @"pre_page_id TEXT",
                                                    @"app_id TEXT",
                                                    @"title TEXT",
                                                    @"class_name TEXT",
                                                    @"user_code TEXT",
                                                    @"begin_time REAL",
                                                    @"end_time REAL",
                                                    ]
                                      constraints:nil
                                            error:&error];
            if (!result && error) {
                ZRTrackingLog(@"create table 【%@】 failure:%@",kZR_Track_Page_Table,error.description);
            } else {
                ZRTrackingLog(@"create table 【%@】 success",kZR_Track_Page_Table);
            }
        }
        
        
        if (NO == [db tableExists:kZR_Track_Event_Table]) {
            BOOL result = [db createTableWithName:kZR_Track_Event_Table
                                          columns:@[
                                                    @"event_id TEXT PRIMARY KEY",
                                                    @"page_id TEXT",
                                                    @"title TEXT",
                                                    @"type TEXT",
                                                    @"path TEXT",
                                                    @"user_code TEXT",
                                                    @"click_time REAL"
                                                    ]
                                      constraints:nil
                                            error:&error];
            if (!result && error) {
                ZRTrackingLog(@"create table 【%@】 failure:%@",kZR_Track_Event_Table,error.description);
            } else {
                ZRTrackingLog(@"create table 【%@】 success",kZR_Track_Event_Table);
            }
        }
        
        if (NO == [db tableExists:kZR_Track_Func_Invoke_Table]) {
            BOOL result = [db createTableWithName:kZR_Track_Func_Invoke_Table
                                          columns:@[
                                                    @"fid TEXT PRIMARY KEY",
                                                    @"app_id TEXT",
                                                    @"application_state INTEGER",
                                                    @"class_name TEXT",
                                                    @"func_name TEXT",
                                                    @"func_invoke_time REAL",
                                                    @"params TEXT",
                                                    @"tag TEXT",
                                                    @"memo TEXT"
                                                    ]
                                      constraints:nil
                                            error:&error];
            if (!result && error) {
                ZRTrackingLog(@"create table 【%@】 failure:%@",kZR_Track_Func_Invoke_Table,error.description);
            } else {
                ZRTrackingLog(@"create table 【%@】 success",kZR_Track_Func_Invoke_Table);
            }
        }
    }];
}

- (void)beginAppTrackingWithLauchOptions:(NSDictionary *)launchOptions{
    dispatch_async(_trackingQueue, ^{
        [[FMDatabaseQueue shareInstance] inDatabase:^(FMDatabase *db) {
            NSError *error;
            
            NSString *launchOptionJson;
            if (launchOptions) {
                launchOptionJson = [ZRTrackingHelper convertToJsonStringFromObject:launchOptions];
            }
            
            BOOL result =[db insertInto:kZR_Track_App_Table
                                columns:@[
                                          @"app_id",
                                          @"device",
                                          @"device_token",
                                          @"app_version",
                                          @"system_version",
                                          @"user_code",
                                          @"begin_time",
                                          @"end_time",
                                          @"latitude",
                                          @"longitude",
                                          @"launch_options"
                                          ]
                                 values:@[
                                          @[
                                              kZR_AppTrackingID ?: [ZRTrackingHelper createUUID],
                                              @(kZR_Device_Type_iOS),
                                              [OpenUDID value] ?: [NSNull null],
                                              [ZRTrackingHelper getAppVersion],
                                              [UIDevice currentDevice].systemVersion ?: [NSNull null],
                                              [NSNull null],
                                              @([ZRTrackingHelper getCurrentTimestamp]),
                                              [NSNull null],
                                              [NSNull null],
                                              [NSNull null],
                                              launchOptionJson ?: [NSNull null]
                                              ]
                                          ]
                                  error:&error
                          ];
            
            if (!result && error) {
                ZRTrackingLog(@"create app tracking record failure:%@",error.description);
            } else {
                ZRTrackingLog(@"insert app tracking record success.");
            }
        }];
    });
}

- (void)endAppTracking{
    dispatch_sync(_trackingQueue, ^{
        [[FMDatabaseQueue shareInstance] inDatabase:^(FMDatabase *db) {
            NSError *error;
            NSInteger row = [db update:kZR_Track_App_Table
                                values:@{@"end_time":@([ZRTrackingHelper getCurrentTimestamp])}
                                 where:@"app_id = ?"
                             arguments:@[kZR_AppTrackingID]
                                 error:&error
                             ];
            if (error || row == 0) {
                ZRTrackingLog(@"update app tracking record failure:%@",error.description);
            } else {
                ZRTrackingLog(@"update app tracking record success.");
            }
        }];
    });
}

- (void)beginPageTrackingWithPageID:(NSString *)pageID prePageID:(NSString *)parentPageID title:(NSString *)title className:(NSString *)className{
    dispatch_async(_trackingQueue, ^{
        [[FMDatabaseQueue shareInstance] inDatabase:^(FMDatabase *db) {
            NSError *error;
            
            
            
            BOOL result =[db insertInto:kZR_Track_Page_Table
                                columns:@[
                                          @"page_id",
                                          @"pre_page_id",
                                          @"app_id",
                                          @"title",
                                          @"class_name",
                                          @"user_code",
                                          @"begin_time",
                                          @"end_time",
                                          ]
                                 values:@[
                                          @[
                                              pageID,
                                              parentPageID ?: [NSNull null],
                                              kZR_AppTrackingID,
                                              title ?: [NSNull null],
                                              className,
                                              [NSNull null],
                                              @([ZRTrackingHelper getCurrentTimestamp]),
                                              [NSNull null],
                                              ]
                                          ]
                                  error:&error
                          ];
            
            if (!result && error) {
                ZRTrackingLog(@"create page tracking record failure:%@",error.description);
            } else {
                ZRTrackingLog(@"insert page tracking record success.");
            }
        }];
    });
}


- (void)endPageTrackingWithPageID:(NSString *)pageID{
    if (pageID == nil) return;
    dispatch_async(_trackingQueue, ^{
        [[FMDatabaseQueue shareInstance] inDatabase:^(FMDatabase *db) {
            NSError *error;
            NSInteger row = [db update:kZR_Track_Page_Table
                                values:@{@"end_time":@([ZRTrackingHelper getCurrentTimestamp])}
                                 where:@"page_id = ?"
                             arguments:@[pageID]
                                 error:&error
                             ];
            if (error || row == 0) {
                ZRTrackingLog(@"update page tracking record failure:%@",error.description);
            } else {
                ZRTrackingLog(@"update page tracking record success.");
            }
        }];
    });
}

- (void)eventTrackingWithTitle:(NSString *)title path:(NSString *)path pageID:(NSString *)pageID type:(NSString *)senderType{
    dispatch_async(_trackingQueue, ^{
        
        [[FMDatabaseQueue shareInstance] inDatabase:^(FMDatabase *db) {
            NSError *error;
            NSString *eventID = [ZRTrackingHelper createUUID];
            BOOL result =[db insertInto:kZR_Track_Event_Table
                                columns:@[
                                          @"event_id",
                                          @"page_id",
                                          @"title",
                                          @"type",
                                          @"path",
                                          @"user_code",
                                          @"click_time"
                                          ]
                                 values:@[
                                          @[
                                              eventID,
                                              pageID ?: [NSNull null],
                                              title ?: [NSNull null],
                                              senderType ?: [NSNull null],
                                              path ?: [NSNull null],
                                              [NSNull null],
                                              @([ZRTrackingHelper getCurrentTimestamp]),
                                              ]
                                          ]
                                  error:&error
                          ];
            if (!result && error) {
                ZRTrackingLog(@"create event tracking record failure:%@",error.description);
            } else {
                ZRTrackingLog(@"insert event tracking record success.");
            }
        }];
    });
}

- (void)funcInvokeTrackingWithName:(NSString *)funcName
                         className:(NSString *)className
                            params:(NSDictionary *)params
                               tag:(NSString *)tag{
    NSString *state;
    switch ([UIApplication sharedApplication].applicationState) {
        case UIApplicationStateActive:
            state = @"Active";
            break;
        case UIApplicationStateInactive:
            state = @"Inactive";
            break;
        case UIApplicationStateBackground:
            state = @"Backgroud";
            break;
        default:
            break;
    }

    dispatch_async(_trackingQueue, ^{
        
        [[FMDatabaseQueue shareInstance] inDatabase:^(FMDatabase *db) {
            NSError *error;
            NSString *fid = [ZRTrackingHelper createUUID];
            NSString *jsonParams = [ZRTrackingHelper convertToJsonStringFromObject:params];
            
            BOOL result =[db insertInto:kZR_Track_Func_Invoke_Table
                                columns:@[
                                          @"fid",
                                          @"app_id",
                                          @"application_state",
                                          @"class_name",
                                          @"func_name",
                                          @"func_invoke_time",
                                          @"params",
                                          @"tag",
                                          @"memo"
                                          ]
                                 values:@[
                                          @[
                                              fid,
                                              kZR_AppTrackingID,
                                              state ?: [NSNull null],
                                              className,
                                              funcName,
                                              @([ZRTrackingHelper getCurrentTimestamp]),
                                              jsonParams ?: [NSNull null],
                                              tag ?: [NSNull null],
                                              [NSNull null]
                                              ]
                                          ]
                                  error:&error
                          ];
            if (!result && error) {
                ZRTrackingLog(@"create func invoke tracking record failure:%@",error.description);
            } else {
                ZRTrackingLog(@"insert func invoke record success.");
            }
        }];
    });
}

- (void)deleteTrackingRecordWithID:(NSString *)trackingID{
    [[FMDatabaseQueue shareInstance] inDatabase:^(FMDatabase *db) {
        NSError *error;
        [db deleteFrom:kZR_Track_App_Table where:@"app_id = ?" arguments:@[trackingID] error:&error];
        if (error) {
            ZRTrackingLog(@"update app tracking record failure:%@",error.description);
        } else {
            ZRTrackingLog(@"delete app tracking record success.");
        }
    }];
}


/**
 查询指定时间之前的跟踪记录

 @param timestamp 输入时间
 @return 返回查询结果
 */
- (NSDictionary *)queryTrackingRecordBefore:(NSTimeInterval)timestamp{
    
    NSString*(^transformObjectToJson)(NSArray *) = ^(NSArray *json){
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        return @"[]";
    };
    
    NSMutableDictionary *result = [NSMutableDictionary new];
    [[FMDatabaseQueue shareInstance] inDatabase:^(FMDatabase * _Nonnull db) {
        NSError *error;
       NSArray *appRecords = [db selectAllFrom:kZR_Track_App_Table
                                    where:@"begin_time <= ?"
                                arguments:@[@(timestamp)]
                                  orderBy:@"begin_time"
                                    error:&error
                         ];
        if (error) ZRTrackingLog(@"query app tracking records failure:%@",error.description);
        
        NSArray *pageRecords = [db selectAllFrom:kZR_Track_Page_Table
                                          where:@"begin_time <= ?"
                                      arguments:@[@(timestamp)]
                                        orderBy:@"begin_time"
                                          error:&error
                               ];
        if (error) ZRTrackingLog(@"query page tracking records failure:%@",error.description);
        
        NSArray *eventRecords = [db selectAllFrom:kZR_Track_Event_Table
                                          where:@"click_time <= ?"
                                      arguments:@[@(timestamp)]
                                        orderBy:@"click_time"
                                          error:&error
                               ];
        if (error) ZRTrackingLog(@"query event tracking records failure:%@",error.description);
        
        if (appRecords && appRecords.count > 0) {
            //数据库字段转驼峰
            NSMutableArray *appArray = [NSMutableArray new];
            [appRecords enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableDictionary *dic = [NSMutableDictionary new];
                [obj enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    NSString *convertKey= [ZRTrackingHelper convertToCamelCaseFromSnakeCase:key];
                    [dic setObject:obj forKey:convertKey];
                }];
                [appArray addObject:dic];
            }];
            [result setObject:transformObjectToJson(appArray) forKey:@"app"];
        }
        
        if (pageRecords && pageRecords.count > 0) {
            NSMutableArray *pageArray = [NSMutableArray new];
            [pageRecords enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableDictionary *dic = [NSMutableDictionary new];
                [obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    NSString *convertKey= [ZRTrackingHelper convertToCamelCaseFromSnakeCase:key];
                    [dic setObject:obj forKey:convertKey];
                }];
                [pageArray addObject:dic];
            }];
            [result setObject:transformObjectToJson(pageArray) forKey:@"page"];
        }
        
        if (eventRecords && eventRecords.count > 0) {
            NSMutableArray *eventArray = [NSMutableArray new];
            [eventRecords enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableDictionary *dic = [NSMutableDictionary new];
                [obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    NSString *convertKey= [ZRTrackingHelper convertToCamelCaseFromSnakeCase:key];
                    [dic setObject:obj forKey:convertKey];
                }];
                [eventArray addObject:dic];
            }];
            [result setObject:transformObjectToJson(eventArray) forKey:@"event"];
        }
    }];
#if ZRTrackingLogVerbose
    printf("%s",[[result description] UTF8String]);
#endif
    return (result.allKeys.count > 0) ? result : nil;
}




/**
 删除指定时间前的跟踪记录

 @param timestamp 输入时间
 */
- (void)deleteTrackingRecordBefore:(NSTimeInterval)timestamp{
    WeakSelf(weakSelf)
    [[FMDatabaseQueue shareInstance] inDatabase:^(FMDatabase * _Nonnull db) {
        NSError *error;
        [db deleteFrom:kZR_Track_App_Table
                 where:@"begin_time <= ?"
             arguments:@[@(timestamp)]
                 error:&error
         ];
        if (error) ZRTrackingLog(@"delele app tracking records failure:%@",error.description);
        
        [db deleteFrom:kZR_Track_Page_Table
                 where:@"begin_time <= ?"
             arguments:@[@(timestamp)]
                 error:&error
         ];
        if (error) ZRTrackingLog(@"delele page tracking records failure:%@",error.description);
        
        [db deleteFrom:kZR_Track_Event_Table
                 where:@"click_time <= ?"
             arguments:@[@(timestamp)]
                 error:&error
         ];
        if (error) ZRTrackingLog(@"delele event tracking records failure:%@",error.description);
        
        weakSelf.uploadfinished = YES;
    }];
}

@end
