//
//  ZRRoundImageTableViewCell.h
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2018/1/30.
//  Copyright © 2018年 jiaxw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZRRoundImageType) {
    ZRRoundImageTypeLayerRadius,
    ZRRoundImageTypeMaskLayer,
    ZRRoundImageTypeClipImage,
};

@interface ZRRoundImageTableViewCell : UITableViewCell

- (void)roundImageWithType:(ZRRoundImageType)roundImageType;

+ (CGFloat)cellHeight;

@end
