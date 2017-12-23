//
//  ZRPerson.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/23.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "ZRPerson.h"
#import <objc/runtime.h>

#pragma mark - Fish

@interface ZRFish : NSObject

@end

@implementation ZRFish

- (void)swim{
    NSLog(@"%s: I like swimming",__func__);
}

@end

#pragma mark - Bird

@interface ZRBird : NSObject

@end

@implementation ZRBird

- (void)fly{
    NSLog(@"%s: I like flying",__func__);
}

@end

#pragma mark - Person

@implementation ZRPerson

//  1. 消息转发第一步：
//  1.1 对象收到无法响应的消息后，首先调用resolveInstanceMethod方法，若类收到无法响应的消息后，则调用resolveClassMethod。
//  1.2 使用该办法的前提是：相关的实现方法已写好，动态添加到类中
//  1.3 此方案常用来实现@dynamic属性

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    if (sel == NSSelectorFromString(@"eat")) {
        class_addMethod([self class], sel, (IMP)dynamicMethodEat, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel{
    return [super resolveClassMethod:sel];
}

void dynamicMethodEat(id self, SEL _cmd){
    NSLog(@"%s: I like eating",__func__);
}


//  2. 消息转发第二步
//  2.1 将消息转发给其他对象
//  2.2 通过此方案，可以用“组合”模拟出多重继承的特性
//  2.3 这一步，我们无法操作所转发的消息，若要在消息发送给备援接收者之前修改消息内容，可在第三步实现

- (id)forwardingTargetForSelector:(SEL)aSelector{
    
    if (aSelector == NSSelectorFromString(@"swim")) {
        return [ZRFish new];
    }
    return [super forwardingTargetForSelector:aSelector];
}

//  3 消息转发第三步
//  3.1 至此，启用完整的消息转发机制，首先创建NSInvocation对象，封装消息有关的信息，包括选择子、目标、参数
//  3.2 触发NSIvocation对象时，消息派发系统，把消息指派给目标对象
//  3.3 若只改变调用目标，这样实现与第二步方法等效，很少这样做
//  3.4 比较有用的实现方式为：触发消息前，以某种方法改变消息的内容，如追加参数或者改换选择子等

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    if (aSelector == NSSelectorFromString(@"fly")) {
//        return [NSMethodSignature methodSignatureForSelector:aSelector];
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    if (anInvocation.selector == NSSelectorFromString(@"fly")) {
        [anInvocation invokeWithTarget:[ZRBird new]];
    }
    [super forwardInvocation:anInvocation];
}

//  4. 消息未处理，抛出异常
- (void)doesNotRecognizeSelector:(SEL)aSelector{
    NSLog(@"not recognized selector, crash happened");
}

@end
