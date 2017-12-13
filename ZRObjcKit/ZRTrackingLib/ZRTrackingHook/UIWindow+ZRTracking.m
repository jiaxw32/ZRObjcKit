//
//  UIWindow+ZRTracking.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/2.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "UIWindow+ZRTracking.h"
#import <objc/runtime.h>
#import "ZRTracking.h"

@implementation UIWindow (ZRTracking)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSel = @selector(sendEvent:);
        SEL swizzledSel = @selector(zr_tracking_sendEvent:);
        
        [ZRTrackingHelper zr_exchangeClassMethod:class orginalSelector:originalSel swizzledSelector:swizzledSel];
    });
}


- (void)zr_tracking_sendEvent:(UIEvent *)event{
    

    [[event allTouches] enumerateObjectsUsingBlock:^(UITouch * _Nonnull obj, BOOL * _Nonnull stop) {
        UIView *touchView = obj.view;
        if (obj.phase == UITouchPhaseEnded) {
            
            if ([touchView isKindOfClass:[UIControl class]]) {
                //UIButton、UIDatePicker、UIPageControl、UISegmentedControl、UITextField、UISlider、UISwitch
                
            } else {
                if (touchView.gestureRecognizers.count > 0) {
                    ZRTrackingLog(@"%@",touchView.gestureRecognizers);
                    [touchView.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull gesture, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        ZRTrackingLog(@"%@",gesture);
#if ZRTrackingLogVerbose
                        Ivar targetsIvar = class_getInstanceVariable([UIGestureRecognizer class], "_targets");
                        id targetActionPairs = object_getIvar(gesture, targetsIvar);
                        
                        Class targetActionPairClass = NSClassFromString(@"UIGestureRecognizerTarget");
                        Ivar targetIvar = class_getInstanceVariable(targetActionPairClass, "_target");
                        Ivar actionIvar = class_getInstanceVariable(targetActionPairClass, "_action");
                        

                        for (id targetActionPair in targetActionPairs){
                            id target = object_getIvar(targetActionPair, targetIvar);
                            SEL action = (__bridge void *)object_getIvar(targetActionPair, actionIvar);
                            ZRTrackingLog(@"target=%@; action=%@", target, NSStringFromSelector(action));
                        }
#endif
                    }];
                }
            }
        }
    }];
    
    [self zr_tracking_sendEvent:event];
}

@end
