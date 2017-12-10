//
//  UNUserNotificationCenter+ZRTracking.m
//  ZRTrackingManager
//
//  Created by jiaxw-mac on 2017/12/7.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "UNUserNotificationCenter+ZRTracking.h"
#import "ZRTrackingHelper.h"
#import "ZRTrackingManager.h"

@implementation UNUserNotificationCenter (ZRTracking)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalSel = @selector(setDelegate:);
        SEL swizzledSel = @selector(zr_tracking_setDelegate:);
        [ZRTrackingHelper zr_exchangeClassMethod:[self class] orginalSelector:originalSel swizzledSelector:swizzledSel];
    });
}


- (void)zr_tracking_setDelegate:(id<UNUserNotificationCenterDelegate>)delegate{
    [self zr_tracking_setDelegate:delegate];
    
    if ([delegate respondsToSelector:@selector(userNotificationCenter:willPresentNotification:withCompletionHandler:)]) {
        [ZRTrackingHelper zr_exchangeMethod:[delegate class]
                              orginalSelector:@selector(userNotificationCenter:willPresentNotification:withCompletionHandler:)
                                swizzledClass:[self class]
                             swizzledSelector:@selector(zr_tracking_userNotificationCenter:willPresentNotification:withCompletionHandler:)
         ];
    }
    
    
    if ([delegate respondsToSelector:@selector(userNotificationCenter:willPresentNotification:withCompletionHandler:)]) {
        [ZRTrackingHelper zr_exchangeMethod:[delegate class]
                              orginalSelector:@selector(userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:)
                                swizzledClass:[self class]
                             swizzledSelector:@selector(zr_tracking_userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:)
         ];
    }
}


#pragma mark - UNUserNotificationCenterDelegate


- (void)zr_tracking_userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    [[ZRTrackingManager sharedInstance] funcInvokeTrackingWithName:[NSString stringWithUTF8String:__func__]
                                                           className:NSStringFromClass([self class])
                                                              params:notification.request.content.userInfo
                                                                 tag:@"notification"];
    [self zr_tracking_userNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
}

- (void)zr_tracking_userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
    
    [[ZRTrackingManager sharedInstance] funcInvokeTrackingWithName:[NSString stringWithUTF8String:__func__]
                                                           className:NSStringFromClass([self class])
                                                              params:response.notification.request.content.userInfo
                                                                 tag:@"notification"];
    
    [self zr_tracking_userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
}

@end
