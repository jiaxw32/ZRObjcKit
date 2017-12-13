//
//  AppDelegate.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/10.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "AppDelegate.h"

// iOS10注册APNs所需头 件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    CGFloat deviceVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (deviceVersion >= 10.0 ) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@", settings);
                    if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                    }
                }];
            } else {
                NSLog(@"%@",error.description);
            }
        }];
    } else {
        [application registerUserNotificationSettings:[UIUserNotificationSettings
                                                       settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound
                                                       categories:nil]];
        [application registerForRemoteNotifications];
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Notification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"device token:%@",deviceToken);
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    NSLog(@"%@",notificationSettings);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"register remote notification failure:%@",[error description]);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    /*
     iOS 10系统：
     1、若AppDelegate未实现UNUserNotificationCenterDelegate，则App未运行或处于后台时，则调用该方法，而不会调用-[UIApplication application:didReceiveRemoteNotification:fetchCompletionHandler:]方法，或许是iOS 10系统Bug
     2、iOS 10及以上版本，应实现UNUserNotificationCenterDelegate，简化处理
     */
    NSLog(@"receive notification:%@",userInfo);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    /*
     iOS 10以下系统:
     1、前台(Active)、后台（Inactive）或收到通知回调该方法
     */
    NSLog(@"receive notification:%@",userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}


#pragma UNUserNotificationCenterDelegate


- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    /*
     iOS 10及以上系统:
     1、App处于前台时，通知显示前调用
     2、App未运行(Inactive)或处于后台时，不调用该方法
     */
    NSLog(@"%@",notification.request.content.userInfo);
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    /*
     iOS 10及以上系统:
     1、App处于前台时，点击通知调用该方法，不点击不调用。
     2、App未运行或处于后台时，点击通知调用
     */
    
    NSLog(@"%@",response.notification.request.content.userInfo);
    completionHandler();
}



@end
