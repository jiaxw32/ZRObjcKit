//
//  UIImage+ZRRoundCorner.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2018/1/29.
//  Copyright © 2018年 jiaxw. All rights reserved.
//

#import "UIImage+ZRRoundCorner.h"

@implementation UIImage (ZRRoundCorner)

- (UIImage *)zr_roundImageWithRadius:(CGFloat)radius{
    return [self zr_roundImageWithRadius:radius andCorners:UIRectCornerAllCorners];
}

/*
- (UIImage *)roundImageWithRadius:(CGFloat)radius{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, self.size.width, self.size.height);
    imageLayer.contents = (id) self.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    
    UIGraphicsBeginImageContext(self.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;

}
 */

- (UIImage *)zr_roundImageWithRadius:(CGFloat)radius andCorners:(UIRectCorner)corners{
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    
    [path addClip];
    [self drawInRect:rect];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return roundedImage;
}

- (void)zr_roundImageWithRadius:(CGFloat)radius andCorners:(UIRectCorner)corners completionHandler:(void(^)(UIImage *roundedImage))completionHandler{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *roundedImage = [self zr_roundImageWithRadius:radius andCorners:corners];
        dispatch_async( dispatch_get_main_queue(), ^{
            if (completionHandler) {
                completionHandler(roundedImage);
            }
        });
    });
}

- (void)zr_roundImageWithRadius:(CGFloat)radius completionHandler:(void(^)(UIImage *roundedImage))completionHandler{
    [self zr_roundImageWithRadius:radius andCorners:UIRectCornerAllCorners completionHandler:completionHandler];
}

@end
