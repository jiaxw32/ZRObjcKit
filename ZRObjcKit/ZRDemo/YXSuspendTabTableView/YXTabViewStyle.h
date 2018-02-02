//
//  YXTabViewStyle.h
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2018/2/2.
//  Copyright © 2018年 jiaxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXTabViewStyle : NSObject

@property (nonatomic,assign) CGFloat topBarHeight;

@property (nonatomic,assign) CGFloat bottomBarHeight;

@property (nonatomic,assign) CGFloat tabBarHeight;

@property (nonatomic, strong) UIColor *tabTitleColor;

@property (nonatomic, strong) UIColor *tabTitleSelectedColor;

@property (nonatomic, strong) UIColor *tabIndicatorLineColor;

@property (nonatomic, assign) CGFloat tabIndicatorLineHeight;

@property (nonatomic, strong) UIColor *tabBarBackgroundColor;

+ (instancetype)defaultTabViewStyle;


@end
