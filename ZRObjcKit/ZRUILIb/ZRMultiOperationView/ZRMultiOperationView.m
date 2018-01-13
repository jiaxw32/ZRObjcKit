//
//  ZRMultiOperationView.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2016/10/11.
//  Copyright © 2016年 jiaxw. All rights reserved.
//

#import "ZRMultiOperationView.h"

#pragma mark - ZROperationItemConfig

@implementation ZROperationItemConfig

- (instancetype)init{
    if (self = [super init]) {
        _enableClick = YES;
        _enable = YES;
    }
    return self;
}

@end

#pragma mark - ZRMultiOperationView

@interface ZRMultiOperationView ()



@end

@implementation ZRMultiOperationView

- (void)setItemsConfig:(NSArray *)itemsConfig{
    _itemsConfig = itemsConfig;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setupViews];
}

- (instancetype)initWithItems:(NSArray<ZROperationItemConfig *> *)items{
    if (self = [super init]) {
        _itemsConfig = items;
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    UIView *contentView = self;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat itemWidth = screenWidth /_itemsConfig.count;
    for (NSInteger i = 0; i < _itemsConfig.count; i++) {
        ZROperationItemConfig *config = _itemsConfig[i];
        
        UIButton *btnItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [contentView addSubview:btnItem];
        btnItem.tag = i + 1;
        [btnItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(contentView);
            make.width.mas_equalTo(itemWidth);
            make.left.mas_equalTo(contentView.mas_left).offset(i*itemWidth);
        }];
        if (config.enableClick) {
            [btnItem addTarget:self action:@selector(onButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (config.showImage && config.imageName && config.imageName.length > 0) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:config.imageName]];
            [btnItem addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(config.imageSize);
                make.centerY.mas_equalTo(btnItem.mas_centerY);
                make.left.equalTo(btnItem.titleLabel.mas_right).offset(config.imageOffset);
            }];
            CGFloat titleLabelOffset = (config.imageSize.width + config.imageOffset)/2.0;
            btnItem.titleEdgeInsets = UIEdgeInsetsMake(0, -titleLabelOffset, 0, titleLabelOffset);
        }

        [self configOperationItemStyleWithIndex:i config:config];
    }
    
    self.topLine = ({
        UIView *line = [UIView new];
        line.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [contentView addSubview:line];
        line;
    });
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(contentView);
        make.height.mas_equalTo(.5f);
    }];
}

- (void)configOperationItemStyleWithIndex:(NSInteger)index config:(ZROperationItemConfig *)config{
    UIButton *btnItem = [self viewWithTag:(index+ 1)];
    if (btnItem && [btnItem isKindOfClass:[UIButton class]]) {
        btnItem.backgroundColor = config.backgroudColor;
        btnItem.enabled = config.enable;
        if (config.attributeString) {
            [btnItem setAttributedTitle:config.attributeString forState:UIControlStateNormal];
        } else {
            [btnItem setTitle:config.title forState:UIControlStateNormal];
            [btnItem setTitleColor:config.titleColor forState:UIControlStateNormal];
            btnItem.titleLabel.font = config.titleFont;
        }
        
    }
}

- (void)onButtonItemClicked:(UIButton *)sender{
    if (sender.tag > 0 && sender.tag <= _itemsConfig.count) {
        ZROperationItemConfig *itemConfig = _itemsConfig[sender.tag-1];
        if (itemConfig.operationItemClickBlock) {
            itemConfig.operationItemClickBlock(sender.tag);
        }
    }
}

@end
