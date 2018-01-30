//
//  UIImage+ZRRoundCorner.h
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2018/1/29.
//  Copyright © 2018年 jiaxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZRRoundCorner)

- (void)zr_roundImageWithRadius:(CGFloat)radius completionHandler:(void(^)(UIImage *rounedImage))completionHandler;

- (void)zr_roundImageWithRadius:(CGFloat)radius andCorners:(UIRectCorner)corners completionHandler:(void(^)(UIImage *roundedImage))completionHandler;

@end
