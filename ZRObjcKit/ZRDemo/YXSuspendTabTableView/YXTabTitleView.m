//
//  YXTabTitleView.m
//  仿造淘宝商品详情页
//
//  Created by yixiang on 16/3/25.
//  Copyright © 2016年 yixiang. All rights reserved.
//

#import "YXTabTitleView.h"
#import "YXHeader.h"
#import "YXTabViewStyle.h"

@interface YXTabTitleView()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *titleBtnArray;
@property (nonatomic, strong) UIView  *indicateLine;

@property (nonatomic, strong) YXTabViewStyle *tabViewStyle;

@end

@implementation YXTabTitleView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray style:(YXTabViewStyle *)style{
    if (self = [super initWithFrame:frame]) {
        _tabViewStyle = style;
        self.backgroundColor = style.tabBarBackgroundColor;
        
        _titleArray = titleArray;
        _titleBtnArray = [NSMutableArray array];
        
        CGFloat btnWidth = CGRectGetWidth(self.frame) / titleArray.count;
        
        for (int i=0; i<titleArray.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*btnWidth, 0, btnWidth, _tabViewStyle.tabBarHeight)];
            [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
            if (i==0) {
                [btn setTitleColor:_tabViewStyle.tabTitleSelectedColor forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:_tabViewStyle.tabTitleColor forState:UIControlStateNormal];
            }
            btn.tag = i;
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchDown];
            
            [self addSubview:btn];
            [_titleBtnArray addObject:btn];
        }
        
        CGFloat indicatorLineHeight = _tabViewStyle.tabIndicatorLineHeight;
        _indicateLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - indicatorLineHeight, btnWidth, indicatorLineHeight)];
        _indicateLine.backgroundColor = _tabViewStyle.tabIndicatorLineColor;
        [self addSubview:_indicateLine];
    }
    return self;
}

-(void)clickBtn : (UIButton *)btn{
    NSInteger tag = btn.tag;
    [self setItemSelected:tag];
    
    if (self.titleClickBlock) {
        self.titleClickBlock(tag);
    }
}

-(void)setItemSelected: (NSInteger)column{
    for (int i=0; i<_titleBtnArray.count; i++) {
        UIButton *btn = _titleBtnArray[i];
        if (i==column) {
            [btn setTitleColor:_tabViewStyle.tabTitleSelectedColor forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:_tabViewStyle.tabTitleColor forState:UIControlStateNormal];
        }
    }
    CGFloat btnWidth = CGRectGetWidth(self.frame) / self.titleArray.count;
    
    CGFloat indicatorLineHeight = _tabViewStyle.tabIndicatorLineHeight;
    CGFloat orginY = CGRectGetHeight(self.frame) - indicatorLineHeight;
    _indicateLine.frame = CGRectMake(btnWidth*column, orginY, btnWidth, indicatorLineHeight);
}

@end
