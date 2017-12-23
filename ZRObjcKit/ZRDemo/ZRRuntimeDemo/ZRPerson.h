//
//  ZRPerson.h
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/23.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 消息转发测试Demo，详细原理，参考《Effective Objective-C 2.0》第十二条，测试代码如下：
 ZRPerson *person = [[ZRPerson alloc] init];
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wundeclared-selector"
 [person performSelector:@selector(eat)];
 [person performSelector:@selector(swim)];
 [person performSelector:@selector(fly)];
 [person performSelector:@selector(program)];
 #pragma clang diagnostic pop
 */
@interface ZRPerson : NSObject

@property (nonatomic,copy) NSString *name;

@property (nonatomic,assign) NSUInteger age;

@property (nonatomic,assign) BOOL sex;

@end
