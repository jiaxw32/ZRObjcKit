//
//  UIControl+ZRTracking.m
//  ZRTrackingManager
//
//  Created by jiaxw-mac on 2017/12/1.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "UIControl+ZRTracking.h"
#import "UIViewController+ZRTracking.h"
#import "ZRTrackingManager.h"
#import "ZRTrackingHelper.h"

@implementation UIControl (ZRTracking)

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        SEL originalSel = @selector(sendAction:to:forEvent:);
        SEL swizzledSel = @selector(zr_tracking_sendAction:to:forEvent:);
        
        [ZRTrackingHelper zr_exchangeClassMethod:class orginalSelector:originalSel swizzledSelector:swizzledSel];
        
    });
}

- (void)zr_tracking_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    __block NSString *title;
    __block NSString *pageID;
    __block NSString *senderType;
    __block NSString *fullPath;
    [[event allTouches] enumerateObjectsUsingBlock:^(UITouch * _Nonnull obj, BOOL * _Nonnull stop) {
        UIView *touchView = obj.view;
        
        senderType = NSStringFromClass([touchView class]);
        
        if ([touchView isKindOfClass:[UIButton class]]) {
            UIButton *touchButton = (UIButton *)touchView;
            title = touchButton.currentTitle;
        } else if([NSStringFromClass([touchView class]) isEqualToString:@"UITabBarButton"] ){
            
//            UITabBar *tabBar = (UITabBar *)touchView.superview;
//            title = tabBar.selectedItem.title;
        }else {
            if ([touchView respondsToSelector:@selector(title)]) {
                title = [touchView valueForKey:@"title"];
            }
        }
        
        if (title == nil || title.length == 0) {
            title = NSStringFromClass([touchView class]);
        }
        
        //find the controller of the touch view
        UIViewController *vc = [ZRTrackingHelper findTheViewControllerOf:touchView];
        pageID = vc.zr_pageTrackingID;
        fullPath = [ZRTrackingHelper findThePathOfView:touchView inViewController:vc];
        *stop = YES;
    }];
    
    [[ZRTrackingManager sharedInstance] eventTrackingWithTitle:title path:fullPath pageID:pageID type:senderType];
    [self zr_tracking_sendAction:action to:target forEvent:event];
}

@end
