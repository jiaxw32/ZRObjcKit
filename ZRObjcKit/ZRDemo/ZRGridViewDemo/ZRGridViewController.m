//
//  ZRGridViewController.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/16.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "ZRGridViewController.h"
#import "ZRGridView.h"
#import <Masonry.h>

@interface ZRGridViewController ()<ZRGridViewDelegate,ZRGridViewDataSource>

@end

@implementation ZRGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    ZRGridViewLayoutAndStyle *gridViewLayout = [[ZRGridViewLayoutAndStyle alloc] init];
    gridViewLayout.showGridLine = YES;
    gridViewLayout.headerBackgroudColor = [UIColor colorWithRed:38/255.0 green:184.0/255.0 blue:242/255.0 alpha:1];
    gridViewLayout.fieldTitleColor = [UIColor whiteColor];
    
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    ZRGridView *gridView = [[ZRGridView alloc] initWithGridViewLayoutAndStyle:gridViewLayout];
    gridView.gridViewDelegate = self;
    gridView.gridViewDataSource = self;
    [self.view addSubview:gridView];
    [gridView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(16, 16, 0, 16));
        make.height.mas_equalTo(self.view.mas_height).multipliedBy(3/4.0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ZRGridViewDataSource

- (NSInteger)numberOfColumnsInGridView:(ZRGridView *)gridView{
    return 10;
}

- (NSInteger)numberOfRowsInGridView:(ZRGridView *)gridView{
    return 100;
}

- (NSString *)gridView:(ZRGridView *)gridView titleOfColumnsAtIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"field_%lu",(long)index];
}

- (NSString *)gridView:(ZRGridView *)gridView valueAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex{
    return [NSString stringWithFormat:@"%lu*%lu",(long)rowIndex,(long)columnIndex];
}

- (UIColor *)gridView:(ZRGridView *)gridView itemBackgroudColorAtRow:(NSInteger)rowIndex column:(NSInteger)column{
    if (rowIndex%2) {
        return [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    } else {
        return [UIColor whiteColor];
    }
}

- (CGFloat)gridView:(ZRGridView *)gridView widthForColumn:(NSInteger)index{
    if (index%2) {
        return 100;
    } else {
        return 80;
    }
}


@end
