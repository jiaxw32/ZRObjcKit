//
//  NSObject+ZRRuntime.h
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/23.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZRRuntime)

+ (void)zr_logIvarList:(BOOL)includeSuperIvars;

+ (void)zr_logInstanceVarInfoByName:(NSString *)name;

+ (void)zr_logClassVarInfoByName:(NSString *)name;

+ (void)zr_logPropertyList:(BOOL)includeSuperProperties;

+ (void)zr_logPropertyInfoByName:(NSString *)name;

+ (void)zr_logMethodList:(BOOL)includeSuperMethods;

+ (void)zr_logProtocolList:(BOOL)includeSuperProtocols;

@end
