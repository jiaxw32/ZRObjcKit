//
//  UIViewController+ZRTracking.m
//  ZRTrackingManager
//
//  Created by jiaxw-mac on 2017/11/30.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "UIViewController+ZRTracking.h"
#import <objc/runtime.h>
#import "ZRTracking.h"



@implementation UIViewController (ZRTracking)

static char kZRPageTrackingID;

static char kZRPrePageTrackingID;

@dynamic zr_pageTrackingID;

@dynamic zr_prePageTrackingID;

+ (void)load{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        //ViewWillAppear
        [ZRTrackingHelper zr_exchangeClassMethod:[self class] orginalSelector:@selector(viewWillAppear:) swizzledSelector:@selector(zr_viewWillAppear_Tracking:)];
        
        //ViewWillDisapper
        [ZRTrackingHelper zr_exchangeClassMethod:[self class] orginalSelector:@selector(viewWillDisappear:)swizzledSelector:@selector(zr_viewWillDisappear_Tracking:)];
        
        [ZRTrackingHelper zr_exchangeClassMethod:[self class] orginalSelector:@selector(presentViewController:animated:completion:) swizzledSelector:@selector(zr_tracking_presentViewController:animated:completion:)];
        
        [ZRTrackingHelper zr_exchangeClassMethod:[self class] orginalSelector:@selector(dismissViewControllerAnimated:completion:) swizzledSelector:@selector(zr_tracking_dismissViewControllerAnimated:completion:)];
    });
}

- (void)zr_viewWillAppear_Tracking:(BOOL)animated {
    
    self.zr_pageTrackingID = [ZRTrackingHelper createUUID];
    
    //if the previous page id null,the get the parent viewController page id
    NSString *prePageID = self.zr_prePageTrackingID ?: self.parentViewController.zr_pageTrackingID;
    
    //if necessary, don't tracking UITabbarViewController、UINavigationController、UISplitViewController
    [[ZRTrackingManager sharedInstance] beginPageTrackingWithPageID:self.zr_pageTrackingID prePageID:prePageID title:self.navigationItem.title className:NSStringFromClass([self class])];
    
    [self zr_viewWillAppear_Tracking:animated];
}

- (void)zr_viewWillDisappear_Tracking:(BOOL)animated {
    // insert tracking record in viewWillAppear and update in viewWillDisappear methd with concurrency queue maybe have a problem,so use serial queue.
    [[ZRTrackingManager sharedInstance] endPageTrackingWithPageID:self.zr_pageTrackingID];
    
    [self zr_viewWillDisappear_Tracking:animated];
}

#pragma mark - getter/setter

- (NSString *)zr_pageTrackingID{
    return objc_getAssociatedObject(self, &kZRPageTrackingID);
}

- (void)setZr_pageTrackingID:(NSString *)zr_pageTrackingID{
    objc_setAssociatedObject(self, &kZRPageTrackingID, zr_pageTrackingID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)zr_prePageTrackingID{
    return objc_getAssociatedObject(self, &kZRPrePageTrackingID);
}

- (void)setZr_prePageTrackingID:(NSString *)zr_prePageTrackingID{
    objc_setAssociatedObject(self, &kZRPrePageTrackingID, zr_prePageTrackingID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - navigation

- (void)zr_tracking_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    
    viewControllerToPresent.zr_prePageTrackingID = self.zr_pageTrackingID;
    [self zr_tracking_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)zr_tracking_dismissViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion{
    UIViewController *preViewController = [self findThePreViewController];
    preViewController.zr_prePageTrackingID = self.zr_pageTrackingID;
    [self zr_tracking_dismissViewControllerAnimated:flag completion:completion];
}

- (UIViewController *)findThePreViewController{
    if ([self.presentingViewController.zr_pageTrackingID isEqualToString:self.zr_prePageTrackingID]) {
        return self.presentingViewController;
    } else {
        if ([self.presentingViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabBarController = (UITabBarController *)self.presentingViewController;
            UIViewController *selectedViewController = tabBarController.selectedViewController;
            if ([selectedViewController.zr_pageTrackingID isEqualToString:self.zr_prePageTrackingID]) {
                return tabBarController.selectedViewController;
            } else {
                if ([selectedViewController isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *navigationController = (UINavigationController *)self.presentingViewController;
                    UIViewController *preViewController = navigationController.topViewController;
                    if ([preViewController.zr_pageTrackingID isEqualToString:self.zr_prePageTrackingID]) {
                        return preViewController;
                    }
                }
            }
        } else if ([self.presentingViewController isKindOfClass:[UINavigationController class]]){
            UINavigationController *navigationController = (UINavigationController *)self.presentingViewController;
//            navigationController.visibleViewController.zr_prePageTrackingID = self.zr_pageTrackingID;
            UIViewController *preViewController = navigationController.topViewController;
            if ([preViewController.zr_pageTrackingID isEqualToString:self.zr_prePageTrackingID]) {
                return preViewController;
            }
        } else if ([self.presentingViewController isKindOfClass:[UISplitViewController class]]){
            //TODO: handle splitViewController
        }
    }
    return nil;
}


@end
