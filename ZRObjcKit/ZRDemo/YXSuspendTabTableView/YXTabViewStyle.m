//
//  YXTabViewStyle.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2018/2/2.
//  Copyright © 2018年 jiaxw. All rights reserved.
//

#import "YXTabViewStyle.h"

@implementation YXTabViewStyle

- (instancetype)init{
    if (self = [super init]) {
        _topBarHeight = 60.0f;
        _bottomBarHeight = 60.0f;
        _tabBarHeight = 45.0f;
        _tabTitleColor = [UIColor blackColor];
        _tabTitleSelectedColor = [UIColor blueColor];
        _tabIndicatorLineHeight = 1.0f;
        _tabIndicatorLineColor = [UIColor blueColor];
        _tabBarBackgroundColor = [UIColor whiteColor];
    }
    return self;
}

+ (instancetype)defaultTabViewStyle{
    return [[YXTabViewStyle alloc] init];
}

@end
