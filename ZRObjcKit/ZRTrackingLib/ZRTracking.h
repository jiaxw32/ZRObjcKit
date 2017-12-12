//
//  ZRTracking.h
//  ZRTrackingManager
//
//  Created by jiaxw-mac on 2017/12/7.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#ifndef ZRTracking_h
#define ZRTracking_h

#define ZRTrackingLogVerbose 1

#define ZRTrackingUploadDataEnable 0

#if ZRTrackingLogVerbose
#define ZRTrackingLog(...) NSLog(__VA_ARGS__)
#else
#define ZRTrackingLog(...)
#endif

#define WeakSelf(weakSelf) __typeof(&*self) __weak weakSelf = self;

#define kZR_AppTrackingID [UIApplication sharedApplication].zr_appTrackingID

#import "ZRTrackingManager.h"
#import "ZRTrackingHelper.h"


#endif /* ZRTracking_h */
