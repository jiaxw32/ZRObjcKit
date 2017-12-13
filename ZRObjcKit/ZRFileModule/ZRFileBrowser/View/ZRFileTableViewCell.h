//
//  ZRFileTableViewCell.h
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/11.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZRFileInfoModel;

@interface ZRFileTableViewCell : UITableViewCell

@property (nonatomic,strong) ZRFileInfoModel *model;

+ (CGFloat)cellHeight;

@end
