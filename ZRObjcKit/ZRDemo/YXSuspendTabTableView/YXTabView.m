//
//  YXTabView.m
//  仿造淘宝商品详情页
//
//  Created by yixiang on 16/3/25.
//  Copyright © 2016年 yixiang. All rights reserved.
//

#import "YXTabView.h"
#import "YXTabTitleView.h"
#import "YXTabItemBaseView.h"
#import "YXHeader.h"

@interface YXTabView()<UIScrollViewDelegate>

@property (nonatomic, strong) YXTabTitleView *tabTitleView;
@property (nonatomic, strong) UIScrollView *tabContentView;

@property (nonatomic,strong) YXTabViewStyle *tabViewStyle;

@end

@implementation YXTabView

- (instancetype)initWithFrame:(CGRect)frame tabConfigArray:(NSArray *)tabConfigArray style:(YXTabViewStyle *)style{
    self = [super initWithFrame:frame];
    if (self) {
        _tabViewStyle = style;
        
        NSMutableArray *titleArray = [NSMutableArray array];
        for (int i=0; i<tabConfigArray.count; i++) {
            NSDictionary *itemDic = tabConfigArray[i];
            [titleArray addObject:itemDic[@"title"]];
        }
        
        CGRect tabBarFrame = CGRectMake(0, 0, CGRectGetWidth(self.frame), _tabViewStyle.tabBarHeight);
        _tabTitleView = [[YXTabTitleView alloc] initWithFrame:tabBarFrame titleArray:titleArray style:self.tabViewStyle];
        
        __weak typeof(self) weakSelf = self;
        _tabTitleView.titleClickBlock = ^(NSInteger row){
            if (weakSelf.tabContentView) {
                weakSelf.tabContentView.contentOffset = CGPointMake(CGRectGetWidth(self.frame) * row, 0);
            }
        };
        
        [self addSubview:_tabTitleView];
        
        CGRect tabContentViewFrame = CGRectMake(0, _tabViewStyle.tabBarHeight, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - _tabViewStyle.tabBarHeight);
        
        _tabContentView = [[UIScrollView alloc] initWithFrame:tabContentViewFrame];
        _tabContentView.contentSize = CGSizeMake(CGRectGetWidth(_tabContentView.frame) * titleArray.count, CGRectGetHeight(_tabContentView.frame));
        _tabContentView.pagingEnabled = YES;
        _tabContentView.bounces = NO;
        _tabContentView.showsHorizontalScrollIndicator = NO;
        _tabContentView.delegate = self;
        [self addSubview:_tabContentView];
        
        for (int i=0; i<tabConfigArray.count; i++) {
            NSDictionary *info = tabConfigArray[i];
            NSString *clazzName = info[@"view"];
            Class clazz = NSClassFromString(clazzName);
            YXTabItemBaseView *itemBaseView = [[clazz alloc] init];
            CGRect frame = CGRectMake(i * CGRectGetWidth(_tabContentView.frame), 0 , CGRectGetWidth(_tabContentView.frame), CGRectGetHeight(_tabContentView.frame));
            [itemBaseView configViewWithFrame:frame andData:tabConfigArray[i]];
            [_tabContentView addSubview:itemBaseView];
        }
        
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger pageNum = offsetX / CGRectGetWidth(self.frame);
    [_tabTitleView setItemSelected:pageNum];
}

@end
