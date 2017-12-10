//
//  UITableView+ZRDelegateTracking.m
//  ZRTrackingManager
//
//  Created by jiaxw-mac on 2017/12/1.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "UITableView+ZRDelegateTracking.h"
#import "ZRTrackingHelper.h"
#import "UIViewController+ZRTracking.h"
#import "ZRTrackingManager.h"

@implementation UITableView (ZRDelegateTracking)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalSel = @selector(setDelegate:);
        SEL swizzledSel = @selector(zr_tracking_setDelegate:);
        [ZRTrackingHelper zr_exchangeClassMethod:[self class] orginalSelector:originalSel swizzledSelector:swizzledSel];
    });
}

- (void)zr_tracking_setDelegate:(id<UITableViewDelegate>)delegate{
    [self zr_tracking_setDelegate:delegate];
    
    if ([delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        
        [ZRTrackingHelper zr_exchangeMethod:[delegate class]
                                  orginalSelector:@selector(tableView:didSelectRowAtIndexPath:) swizzledClass:[self class]
                                 swizzledSelector:@selector(zr_tracking_tableView:didSelectRowAtIndexPath:)];
    }
}

- (void)zr_tracking_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UIViewController *currentVC = [ZRTrackingHelper findTheViewControllerOf:tableView];
    NSString *pageID = currentVC.zr_pageTrackingID;
    NSString *path = [ZRTrackingHelper findThePathOfView:tableView inViewController:currentVC];
    path = [NSString stringWithFormat:@"%@\\section:%lu\\row:%lu",path,indexPath.section,indexPath.row];
    [[ZRTrackingManager sharedInstance] eventTrackingWithTitle:nil path:path pageID:pageID type:NSStringFromClass([UITableViewCell class])];
    
    [self zr_tracking_tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
