//
//  UIApplication+ZRTracking.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/2.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "UIApplication+ZRTracking.h"
#import "ZRTrackingHelper.h"
#import "ZRTrackingManager.h"
#import "UIViewController+ZRTracking.h"
#import <objc/runtime.h>

@implementation UIApplication (ZRTracking)

static char kZRAppTrackingID;

@dynamic zr_appTrackingID;


+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalSel = @selector(setDelegate:);
        SEL swizzledSel = @selector(zr_tracking_setDelegate:);
        [ZRTrackingHelper zr_exchangeClassMethod:[self class] orginalSelector:originalSel swizzledSelector:swizzledSel];
    });
}

- (NSString *)zr_appTrackingID{
    return objc_getAssociatedObject(self, &kZRAppTrackingID);
}

- (void)setZr_appTrackingID:(NSString *)zr_appTrackingID{
    objc_setAssociatedObject(self, &kZRAppTrackingID, zr_appTrackingID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)zr_tracking_setDelegate:(id<UIApplicationDelegate>)delegate{
    [self zr_tracking_setDelegate:delegate];
    
    if ([delegate respondsToSelector:@selector(application:willFinishLaunchingWithOptions:)]) {
        [ZRTrackingHelper zr_exchangeMethod:[delegate class]
                            orginalSelector:@selector(application:willFinishLaunchingWithOptions:) swizzledClass:[self class]
                           swizzledSelector:@selector(zr_tracking_application:willFinishLaunchingWithOptions:)];
    }
    
    if ([delegate respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
        
        [ZRTrackingHelper zr_exchangeMethod:[delegate class]
                              orginalSelector:@selector(application: didFinishLaunchingWithOptions:) swizzledClass:[self class]
                             swizzledSelector:@selector(zr_tracking_application:didFinishLaunchingWithOptions:)];
    }
    
    if ([delegate respondsToSelector:@selector(applicationWillTerminate:)]) {
        [ZRTrackingHelper zr_exchangeMethod:[delegate class]
                              orginalSelector:@selector(applicationWillTerminate:)
                                swizzledClass:[self class]
                             swizzledSelector:@selector(zr_tracking_applicationWillTerminate:)];
    }
    
    
    if ([delegate respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)]) {
        [ZRTrackingHelper zr_exchangeMethod:[delegate class]
                              orginalSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)
                                swizzledClass:[self class]
                             swizzledSelector:@selector(zr_tracking_application:didRegisterForRemoteNotificationsWithDeviceToken:)
         ];
    }
    
    if ([delegate respondsToSelector:@selector(application:didFailToRegisterForRemoteNotificationsWithError:)]) {
        [ZRTrackingHelper zr_exchangeMethod:[delegate class]
                              orginalSelector:@selector(application:didFailToRegisterForRemoteNotificationsWithError:)
                                swizzledClass:[self class]
                             swizzledSelector:@selector(zr_tracking_application:didFailToRegisterForRemoteNotificationsWithError:)
         ];
    }
    
    if ([delegate respondsToSelector:@selector(application:didReceiveRemoteNotification:)]) {
        [ZRTrackingHelper zr_exchangeMethod:[delegate class]
                              orginalSelector:@selector(application:didReceiveRemoteNotification:)
                                swizzledClass:[self class]
                             swizzledSelector:@selector(zr_tracking_application:didReceiveRemoteNotification:)
         ];
    }

    
    if ([delegate respondsToSelector:@selector(application:didRegisterUserNotificationSettings:)]) {
        [ZRTrackingHelper zr_exchangeMethod:[delegate class]
                              orginalSelector:@selector(application:didRegisterUserNotificationSettings:)
                                swizzledClass:[self class]
                             swizzledSelector:@selector(zr_tracking_application:didRegisterUserNotificationSettings:)
         ];
    }
    
    if ([delegate respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)]) {
        [ZRTrackingHelper zr_exchangeMethod:[delegate class]
                              orginalSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)
                                swizzledClass:[self class]
                             swizzledSelector:@selector(zr_tracking_application:didReceiveRemoteNotification:fetchCompletionHandler:)
         ];
    }
}

#pragma mark - Application LifeCycle

- (BOOL)zr_tracking_application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
//    application.zr_appTrackingID = [ZRTrackingHelper createUUID];
    [self zr_tracking_application:application willFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (BOOL)zr_tracking_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    application.zr_appTrackingID = [ZRTrackingHelper createUUID];
    
    id notification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notification) {
        [[ZRTrackingManager sharedInstance] funcInvokeTrackingWithName:[NSString stringWithUTF8String:__func__]
                                                             className:NSStringFromClass([self class])
                                                                params:notification
                                                                   tag:@"notification"];
    }
    
    [[ZRTrackingManager sharedInstance] beginAppTrackingWithLauchOptions:launchOptions];
    
    return [self zr_tracking_application:application didFinishLaunchingWithOptions:launchOptions];
}


- (void)zr_tracking_applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[ZRTrackingManager sharedInstance] endAppTracking];
    [self zr_tracking_applicationWillTerminate:application];
}

#pragma mark - Remote Notification

- (void)zr_tracking_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString *token = [ZRTrackingHelper deviceTokenWithData:deviceToken];
    
    [[ZRTrackingManager sharedInstance] funcInvokeTrackingWithName:[NSString stringWithUTF8String:__func__]
                                                           className:NSStringFromClass([self class])
                                                              params:@{@"deviceToken": token ?: @""}
                                                                 tag:@"notification"];
    
    [self zr_tracking_application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
}

- (void)zr_tracking_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSString *errorDesc = [error description];
    [[ZRTrackingManager sharedInstance] funcInvokeTrackingWithName:[NSString stringWithUTF8String:__func__]
                                                           className:NSStringFromClass([self class])
                                                              params:@{@"error": errorDesc ?: @""}
                                                                 tag:@"notification"];
    
    [self zr_tracking_application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)zr_tracking_application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
    [[ZRTrackingManager sharedInstance] funcInvokeTrackingWithName:[NSString stringWithUTF8String:__func__]
                                                           className:NSStringFromClass([self class])
                                                              params:@{@"notificationSettings": [notificationSettings description]}
                                                                 tag:@"notification"];
    [self zr_tracking_application:application didRegisterUserNotificationSettings:notificationSettings];
}

- (void)zr_tracking_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [[ZRTrackingManager sharedInstance] funcInvokeTrackingWithName:[NSString stringWithUTF8String:__func__]
                                                           className:NSStringFromClass([self class])
                                                              params:userInfo
                                                                 tag:@"notification"];
    
    [self zr_tracking_application:application didReceiveRemoteNotification:userInfo];
}

- (void)zr_tracking_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [[ZRTrackingManager sharedInstance] funcInvokeTrackingWithName:[NSString stringWithUTF8String:__func__]
                                                           className:NSStringFromClass([self class])
                                                              params:userInfo
                                                                 tag:@"notification"];
    [self zr_tracking_application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

@end
