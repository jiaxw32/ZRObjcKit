//
//  ZRTrackingHelper.m
//  ZRTrackingManager
//
//  Created by jiaxw-mac on 2017/12/1.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "ZRTrackingHelper.h"
#import <objc/runtime.h>

#define kZRAppTrackingIDKey @"ZRAppTrackingID"

@implementation ZRTrackingHelper

+ (void)zr_exchangeClassMethod:(Class)cls orginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector{
    
    
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(cls,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)zr_exchangeMethod:(Class)originalClass orginalSelector:(SEL)originalSelector swizzledClass:(Class)swizzledClass swizzledSelector:(SEL)swizzledSelector{
    
    Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(originalClass,
                    swizzledSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
//        class_replaceMethod(originalClass,
//                            swizzledSelector,
//                            method_getImplementation(originalMethod),
//                            method_getTypeEncoding(originalMethod));
        
        Method newMethod = class_getInstanceMethod(originalClass, swizzledSelector);
        method_exchangeImplementations(originalMethod, newMethod);

    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }

}

+ (UIViewController *)findTheViewControllerOf:(UIView *)view{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
            break;
        }
    }
    return nil;
}

+ (NSString *)createUUID{
    NSString *uuid = [[[NSUUID new] UUIDString] lowercaseString];
    return [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

+ (NSString *)findThePathOfView:(UIView *)view inViewController:(UIViewController *)viewController{
    NSString *path;
    if (view) {
        path = NSStringFromClass([view class]);
        UIView *superView = view.superview;
        while ([superView nextResponder] != viewController) {
            path = [NSString stringWithFormat:@"%@\\%@",NSStringFromClass([superView class]),path];
            superView = superView.superview;
        }
        path = [NSString stringWithFormat:@"\\%@\\%@",NSStringFromClass([superView class]),path];
    }
    return path;
}

+ (NSString *)convertToJsonStringFromObject:(id)obj{
    if ([NSJSONSerialization isValidJSONObject:obj]) {
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    return nil;
}

+ (NSString *)deviceTokenWithData:(NSData *)data{
    if (data && data.length > 0) {
        NSString *token = [NSString stringWithFormat:@"%@",data];
        token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
        token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
        token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
        return token;
    }
    return nil;
}

+ (NSString *)getCurrentDateTimeString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:[NSDate new]];
}

+ (NSTimeInterval)getCurrentTimestamp{
    return [[NSDate new] timeIntervalSince1970];
}

+ (NSString *)getAppVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

/**
 数据库字段命名转驼峰命名
 
 @param key 输入名称
 @return 转换后的名称
 */
+ (NSString *)convertToCamelCaseFromSnakeCase:(NSString *)key{
    NSMutableString *str = [NSMutableString stringWithString:key];
    while ([str containsString:@"_"]) {
        NSRange range = [str rangeOfString:@"_"];
        if (range.location + 1 < [str length]) {
            char c = [str characterAtIndex:range.location+1];
            [str replaceCharactersInRange:NSMakeRange(range.location, range.length+1) withString:[[NSString stringWithFormat:@"%c",c] uppercaseString]];
        }
    }
    return str;
}

@end
