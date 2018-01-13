//
//  ZRMultiOperationView.h
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2016/10/11.
//  Copyright © 2016年 jiaxw. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - ZROperationItemConfig

typedef void(^ZROperationItemClickHandler)(NSInteger index);

@interface ZROperationItemConfig : NSObject


/**
 标题
 */
@property (nonatomic,copy) NSString *title;


/**
 标题颜色
 */
@property (nonatomic,strong) UIColor *titleColor;


/**
 标题字体
 */
@property (nonatomic,strong) UIFont *titleFont;


/**
 标题富文本，如果定义了富文本，则优先使用富文本，忽略title、titleColor、titleFont属性
 */
@property (nonatomic,strong) NSAttributedString *attributeString;


/**
 item背景颜色
 */
@property (nonatomic,strong) UIColor *backgroudColor;


/**
 是否显示图片
 */
@property (nonatomic,assign) BOOL showImage;


/**
 图片名称
 */
@property (nonatomic,copy) NSString *imageName;


/**
 图片大小
 */
@property (nonatomic,assign) CGSize imageSize;


/**
 图片偏移文字距离
 */
@property (nonatomic,assign) CGFloat imageOffset;


/**
 是否允许点击
 */
@property (nonatomic,assign) BOOL enableClick;


/**
 是否可用
 */
@property (nonatomic,assign) BOOL enable;


@property (nonatomic,copy) ZROperationItemClickHandler operationItemClickBlock;

@end

#pragma mark - ZRMultiOperationView

@interface ZRMultiOperationView : UIView

@property (nonatomic,strong) NSArray *itemsConfig;

@property (nonatomic,strong) UIView *topLine;

- (instancetype)initWithItems:(NSArray<ZROperationItemConfig *> *)items;

- (void)configOperationItemStyleWithIndex:(NSInteger)index config:(ZROperationItemConfig *)config;


@end
