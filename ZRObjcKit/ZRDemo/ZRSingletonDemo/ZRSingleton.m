//
//  ZRSingleton.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2018/3/15.
//  Copyright © 2018年 jiaxw. All rights reserved.
//

#import "ZRSingleton.h"



@implementation ZRSingleton

+ (instancetype)sharedInstance{
    static ZRSingleton *singleton;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        singleton = [[ZRSingleton alloc] init];
    });
    return singleton;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    static ZRSingleton *singleton;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if(singleton == nil){
            singleton = [super allocWithZone:zone];
        }
    });
    return singleton;
}

/**
 覆盖该方法主要确保当用户通过copy方法产生对象时对象的唯一性
 */
- (id)copy{
    return self;
}

/**
 覆盖该方法主要确保当用户通过mutableCopy方法产生对象时对象的唯一性
 */
- (id)mutableCopy{
    return self;
}


@end
