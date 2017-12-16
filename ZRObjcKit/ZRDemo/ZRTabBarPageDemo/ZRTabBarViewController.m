//
//  ZRTabBarViewController.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/16.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "ZRTabBarViewController.h"
#import "MDTabBarViewController.h"
#import "ZRTextViewAutoSizeViewController.h"
#import "ZRTextViewAutoSizeExViewController.h"


@interface ZRTabBarViewController ()<MDTabBarViewControllerDelegate>

@property (nonatomic,strong) MDTabBarViewController *tabBarViewController;

@end

@implementation ZRTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.tabBarViewController setItems:@[@"Storyboard",@"Masonry"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MDTabBarViewController *)tabBarViewController{
    if (!_tabBarViewController) {
        _tabBarViewController = [[MDTabBarViewController alloc] initWithDelegate:self tabbarHeight:48.0f];
        _tabBarViewController.view.backgroundColor = [UIColor whiteColor];
        _tabBarViewController.tabBar.textColor = UIColorFromRGB(0x71B2FF);
        _tabBarViewController.tabBar.normalTextColor = UIColorFromRGB(0x999999);
        _tabBarViewController.tabBar.textFont = [UIFont systemFontOfSize:16];
        _tabBarViewController.tabBar.backgroundColor = [UIColor whiteColor];
        _tabBarViewController.tabBar.indicatorColor = UIColorFromRGB(0x71B2FF);
        _tabBarViewController.tabBar.indicatorHeight = 2;
        _tabBarViewController.tabBar.indicatorWidth = 32;
        
        [self addChildViewController:_tabBarViewController];
        [self.view addSubview:_tabBarViewController.view];
        [_tabBarViewController didMoveToParentViewController:self];
        UIView *controllerView = _tabBarViewController.view;
        [controllerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tabBarViewController;
}

#pragma mark - MDTabBarViewControllerDelegate

- (UIViewController *)tabBarViewController:(MDTabBarViewController *)viewController viewControllerAtIndex:(NSUInteger)index {
    if (index == 0) {
        UIStoryboard *fileStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ZRTextViewAutoSizeViewController *textViewAutoSizeVC = [fileStoryboard instantiateViewControllerWithIdentifier:@"ZRTextViewAutoSizeScene"];
        return textViewAutoSizeVC;
    } else {
        ZRTextViewAutoSizeExViewController *vc = [[ZRTextViewAutoSizeExViewController alloc] init];
        return vc;
    }
}



@end
