//
//  YXTabTitleView.h
//  仿造淘宝商品详情页
//
//  Created by yixiang on 16/3/25.
//  Copyright © 2016年 yixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXTabViewStyle;

@interface YXTabTitleView : UIView


- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray style:(YXTabViewStyle *)style;

-(void)setItemSelected: (NSInteger)column;

typedef void (^YXTabTitleClickBlock)(NSInteger);

@property (nonatomic, copy) YXTabTitleClickBlock titleClickBlock;

@end
