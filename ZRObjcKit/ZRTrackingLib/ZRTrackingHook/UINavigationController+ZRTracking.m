//
//  UINavigationController+ZRTracking.m
//  ZRTrackingManager
//
//  Created by jiaxw-mac on 2017/12/2.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "UINavigationController+ZRTracking.h"
#import "ZRTrackingHelper.h"
#import "ZRTrackingManager.h"
#import "UIViewController+ZRTracking.h"

@implementation UINavigationController (ZRTracking)

+ (void)load{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        
        SEL originalPushViewControllerSel = @selector(pushViewController:animated:);
        SEL swizzledPushViewControllerSel = @selector(zr_tracking_pushViewController:animated:);
        
        [ZRTrackingHelper zr_exchangeClassMethod:[self class] orginalSelector:originalPushViewControllerSel swizzledSelector:swizzledPushViewControllerSel];
        
        SEL orignalPopToViewControllerSel = @selector(popToViewController:animated:);
        SEL swizzledPopToViewControllerSel = @selector(zr_tracking_popToViewController:animated:);
        [ZRTrackingHelper zr_exchangeClassMethod:[self class] orginalSelector:orignalPopToViewControllerSel swizzledSelector:swizzledPopToViewControllerSel];
        
        SEL orignalPopViewControllerSel = @selector(popViewControllerAnimated:);
        SEL swizzledPopViewControllerSel = @selector(zr_tracking_popViewControllerAnimated:);
        [ZRTrackingHelper zr_exchangeClassMethod:[self class] orginalSelector:orignalPopViewControllerSel swizzledSelector:swizzledPopViewControllerSel];
        
    });
}


- (void)zr_tracking_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    UIViewController *visibleViewController = self.visibleViewController;
    viewController.zr_prePageTrackingID = visibleViewController.zr_pageTrackingID;
    [self zr_tracking_pushViewController:viewController animated:YES];
}

- (nullable UIViewController *)zr_tracking_popViewControllerAnimated:(BOOL)animated{
    UIViewController *visibleViewController = self.visibleViewController;
    
    NSInteger index = [self.viewControllers indexOfObject:visibleViewController];
    if((index - 1) >= 0){
        UIViewController *popToViewController = self.viewControllers[index - 1];
        popToViewController.zr_prePageTrackingID = visibleViewController.zr_pageTrackingID;
    }
    
    return [self zr_tracking_popViewControllerAnimated:animated];
}

- (nullable NSArray<__kindof UIViewController *> *)zr_tracking_popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    UIViewController *visibleViewController = self.visibleViewController;
    viewController.zr_prePageTrackingID = visibleViewController.zr_pageTrackingID;
    
    return [self zr_tracking_popToViewController:viewController animated:animated];
}

@end
