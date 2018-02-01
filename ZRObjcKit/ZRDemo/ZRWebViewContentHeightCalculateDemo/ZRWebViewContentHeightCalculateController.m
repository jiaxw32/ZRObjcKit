//
//  ZRWebViewContentHeightCalculateViewController.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2018/2/1.
//  Copyright © 2018年 jiaxw. All rights reserved.
//

#import "ZRWebViewContentHeightCalculateController.h"
#import "MDTabBarViewController.h"
#import "ZRWKWebViewContentHeightCalculateController.h"
#import "ZRUIWebViewContentHeightCalculateController.h"
#import "ZRWebViewContentHeightCalculateConstant.h"

@interface ZRWebViewContentHeightCalculateController ()<MDTabBarViewControllerDelegate>{
    NSArray* _tabItems;
}

@property (nonatomic,strong) MDTabBarViewController *tabBarViewController;

@property (nonatomic,strong) ZRUIWebViewContentHeightCalculateController *uiWebViewController;

@property (nonatomic,strong) ZRWKWebViewContentHeightCalculateController *wkWebViewController;

@end

@implementation ZRWebViewContentHeightCalculateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"select" style:UIBarButtonItemStyleDone target:self action:@selector(actionSelectRoundType)];
    
    _tabItems = @[@"UIWebView",@"WKWebView"];
    [self.tabBarViewController setItems: _tabItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MDTabBarViewController *)tabBarViewController{
    if (!_tabBarViewController) {
        _tabBarViewController = [[MDTabBarViewController alloc] initWithDelegate:self tabbarHeight:48.0f];
        _tabBarViewController.tabBar.textFont = [UIFont systemFontOfSize:16];
        _tabBarViewController.tabBar.indicatorColor = UIColorFromRGB(0x71B2FF);
        CGFloat width = [UIScreen mainScreen].bounds.size.width / _tabItems.count * 0.6f;
        _tabBarViewController.tabBar.indicatorWidth = width;
        
        [self addChildViewController:_tabBarViewController];
        [self.view addSubview:_tabBarViewController.view];
        [_tabBarViewController didMoveToParentViewController:self];
        [_tabBarViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tabBarViewController;
}

- (ZRUIWebViewContentHeightCalculateController *)uiWebViewController{
    if (!_uiWebViewController) {
        _uiWebViewController = [[ZRUIWebViewContentHeightCalculateController alloc] init];
    }
    return _uiWebViewController;
}

- (ZRWKWebViewContentHeightCalculateController *)wkWebViewController{
    if (!_wkWebViewController) {
        _wkWebViewController = [[ZRWKWebViewContentHeightCalculateController alloc] init];
    }
    return _wkWebViewController;
}

#pragma mark - MDTabBarViewControllerDelegate

- (UIViewController *)tabBarViewController:(MDTabBarViewController *)viewController viewControllerAtIndex:(NSUInteger)index {
    if (index == 0) {
        return self.uiWebViewController;
    } else {
        return self.wkWebViewController;
    }
}

#pragma mark - Action

- (void)actionSelectRoundType{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *actionLoadHTMLString = [UIAlertAction actionWithTitle:@"load html string" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kZR_WebView_ReloadData_Notification object:nil userInfo:@{@"type" : @(ZRWebViewDataTypeHTMLString)}];
    }];
    
    UIAlertAction *actionLoadPdfFile = [UIAlertAction actionWithTitle:@"load local pdf file" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kZR_WebView_ReloadData_Notification object:nil userInfo:@{@"type" : @(ZRWebViewDataTypeLocalPDF)}];
    }];
    
    
    UIAlertAction *actionLoadURLRequest = [UIAlertAction actionWithTitle:@"load url request" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kZR_WebView_ReloadData_Notification object:nil userInfo:@{@"type" : @(ZRWebViewDataTypeURL)}];
    }];
    
    [alertController addAction:actionCancel];
    
    [alertController addAction:actionLoadURLRequest];
    [alertController addAction: actionLoadHTMLString];
    [alertController addAction: actionLoadPdfFile];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
