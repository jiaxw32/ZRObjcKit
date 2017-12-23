//
//  NSObject+ZRRuntime.h
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/23.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZRRuntime)

+ (void)zr_debugVariables:(BOOL)includeSuperVariables;

+ (void)zr_debugProperties:(BOOL)includeSuperProperties;

+ (void)zr_debugInstanceMethods:(BOOL)includeSuperMethods;

+ (void)zr_debugClassMethods:(BOOL)includeSuperMethods;

+ (void)zr_debugProtocols:(BOOL)includeSuperProtocols;

@end
