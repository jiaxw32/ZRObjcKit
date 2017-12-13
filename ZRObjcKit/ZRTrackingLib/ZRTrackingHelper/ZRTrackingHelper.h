//
//  ZRTrackingHelper.h
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/1.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ZRTrackingHelper : NSObject

+ (void)zr_exchangeClassMethod:(Class)cls orginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

+ (void)zr_exchangeMethod:(Class)originalClass orginalSelector:(SEL)originalSelector swizzledClass:(Class)swizzledClass swizzledSelector:(SEL)swizzledSelector;

+ (UIViewController *)findTheViewControllerOf:(UIView *)view;

+ (NSString *)createUUID;

+ (NSString *)findThePathOfView:(UIView *)view inViewController:(UIViewController *)viewController;

+ (NSString *)convertToJsonStringFromObject:(id)obj;

+ (NSString *)deviceTokenWithData:(NSData *)data;

+ (NSString *)getCurrentDateTimeString;

+ (NSTimeInterval)getCurrentTimestamp;

+ (NSString *)convertToCamelCaseFromSnakeCase:(NSString *)key;


/**
 获取App版本

 @return 返回App版本号
 */
+ (NSString *)getAppVersion;

@end
