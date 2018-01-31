//
//  UIImageView+ZRRoundCorner.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2018/1/31.
//  Copyright © 2018年 jiaxw. All rights reserved.
//

#import "UIImageView+ZRRoundCorner.h"

@implementation UIImageView (ZRRoundCorner)

//reference: https://stackoverflow.com/questions/34962103/how-to-set-uiimageview-with-rounded-corners-for-aspect-fit-mode#

- (void)zr_roundCornersForAspectFit:(CGFloat)radius{
    if (self.image) {
        CGFloat boundScale = self.bounds.size.width / self.bounds.size.height;
        CGFloat imageScale = self.image.size.width / self.image.size.height;
        
        CGRect drawRect = self.bounds;
        if (boundScale > imageScale) {//固定高度，按图像原始比例缩放宽度
            drawRect.size.width = self.bounds.size.height * imageScale;
            drawRect.origin.x = (self.bounds.size.width - drawRect.size.width) / 2.0f;
        } else {//固定宽度，按图像比例缩放高度
            drawRect.size.height = self.bounds.size.width / imageScale;
            drawRect.origin.y = (self.bounds.size.height - drawRect.size.height) / 2.0f;
        }
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:drawRect cornerRadius:radius];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
    }
}

@end
