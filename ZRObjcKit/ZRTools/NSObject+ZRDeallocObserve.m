//
//  NSObject+ZRDeallocObserve.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/25.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "NSObject+ZRDeallocObserve.h"
#import <objc/runtime.h>

#pragma mark - ZRObjectDeallocObserver

@interface ZRObjectDeallocObserver : NSObject

@property (nonatomic,copy) ZRObjectDeallocObserveBlock blk;

@end

@implementation ZRObjectDeallocObserver

- (instancetype)initWithBlock:(ZRObjectDeallocObserveBlock)aBlock{
    if (self = [super init]) {
        _blk = [aBlock copy];
    }
    return self;
}

- (void)dealloc{
    if (_blk) {
        _blk();
    }
}

@end

#pragma mark - NSObject+ZRDeallocObserve

@implementation NSObject (ZRDeallocObserve)

static char kZRObjectDeallocObserver;

- (void)observeDeallocWithBlock:(ZRObjectDeallocObserveBlock)aBlock{
    if (aBlock) {
        ZRObjectDeallocObserver *observer = [[ZRObjectDeallocObserver alloc] initWithBlock:aBlock];
        objc_setAssociatedObject(self, &kZRObjectDeallocObserver, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
