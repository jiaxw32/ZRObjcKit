//
//  NSObject+ZRDeallocObserve.h
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/25.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ZRObjectDeallocObserveBlock)();


/**
 该扩展用于监测对象释放，实现思路：
 1. 给对象发消息observeDeallocWithBlock:
 2. 为对象obj动态设置关联对象ZRObjectDeallocObserver
 3. 对象obj释放时，释放关联对象，调用传入的block
 参考：https://blog.slaunchaman.com/2011/04/11/fun-with-the-objective-c-runtime-run-code-at-deallocation-of-any-object/
 */
@interface NSObject (ZRDeallocObserve)


/**
 监测对象释放

 @param aBlock 释放回调Block
 */
- (void)observeDeallocWithBlock:(ZRObjectDeallocObserveBlock)aBlock;

@end
