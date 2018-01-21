//
//  ZRStepStatisticView.h
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/7/14.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZRStepStatisticType) {
    ZRStepStatisticTypeMonth,
    ZRStepStatisticTypeWeek,
};

@interface ZRStepStatisticView : UIView

@property (nonatomic,copy) NSArray<NSDictionary *> *weekDataArray;

@property (nonatomic,copy) NSArray<NSDictionary *> *monthDataArray;

@property (nonatomic,copy) void(^onStatisticTypeChangedHanlder)(ZRStepStatisticView *sender,ZRStepStatisticType selectedStatisticType);

@end
