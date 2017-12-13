//
//  UICollectionView+ZRTracking.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/2.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "UICollectionView+ZRTracking.h"
#import "ZRTrackingHelper.h"
#import "ZRTrackingManager.h"
#import "UIViewController+ZRTracking.h"

@implementation UICollectionView (ZRTracking)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalSel = @selector(setDelegate:);
        SEL swizzledSel = @selector(zr_tracking_setDelegate:);
        [ZRTrackingHelper zr_exchangeClassMethod:[self class] orginalSelector:originalSel swizzledSelector:swizzledSel];
    });
}

- (void)zr_tracking_setDelegate:(id<UICollectionViewDelegate>)delegate{
    [self zr_tracking_setDelegate:delegate];
    
    if ([delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        
        [ZRTrackingHelper zr_exchangeMethod:[delegate class]
                             orginalSelector:@selector(collectionView:didSelectItemAtIndexPath:) swizzledClass:[self class]
                            swizzledSelector:@selector(zr_tracking_collectionView:didSelectItemAtIndexPath:)];
    }
}

- (void)zr_tracking_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *vc = [ZRTrackingHelper findTheViewControllerOf:collectionView];
    NSString *pageID = vc.zr_pageTrackingID;
    NSString *path = [ZRTrackingHelper findThePathOfView:collectionView inViewController:vc];
    path = [NSString stringWithFormat:@"\\section:%lu\\item:%lu",indexPath.section,indexPath.item];
    
    [[ZRTrackingManager sharedInstance] eventTrackingWithTitle:nil path:path pageID:pageID type:NSStringFromClass([UICollectionViewCell class])];
    
    [self zr_tracking_collectionView:collectionView didSelectItemAtIndexPath:indexPath];

}

@end
