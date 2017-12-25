//
//  NSObject+ZRDebug.h
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/23.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 用于查看类的实例变量、属性、实例方法、类方法、协议。
 更多用法，可参考：https://github.com/garnett/DLIntrospection
 */
@interface NSObject (ZRDebug)

+ (void)zr_debugVariables:(BOOL)includeSuperVariables;

+ (void)zr_debugProperties:(BOOL)includeSuperProperties;

+ (void)zr_debugInstanceMethods:(BOOL)includeSuperMethods;

+ (void)zr_debugClassMethods:(BOOL)includeSuperMethods;

+ (void)zr_debugProtocols:(BOOL)includeSuperProtocols;

@end
