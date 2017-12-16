//
//  ViewController.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/10.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "ViewController.h"
#import "ZRFileHelper.h"
#import "ZRFileListViewController.h"
#import "ZRTextViewAutoSizeViewController.h"
#import "ZRTextViewAutoSizeExViewController.h"
#import "ZRGridViewController.h"
#import "ZRPickerView.h"
#import "ZRTabBarViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction)onButtonClick:(id)sender {
    
    UIStoryboard *fileStoryboard = [UIStoryboard storyboardWithName:@"ZRFileStoryboard" bundle:[NSBundle mainBundle]];
    ZRFileListViewController *fileListViewController = [fileStoryboard instantiateViewControllerWithIdentifier:@"fileListViewController"];
    fileListViewController.filePath = NSHomeDirectory();
    if (fileListViewController) {
        [self.navigationController pushViewController:fileListViewController animated:YES];
    }
}

- (IBAction)onMainBundleButtonClick:(id)sender {
    UIStoryboard *fileStoryboard = [UIStoryboard storyboardWithName:@"ZRFileStoryboard" bundle:[NSBundle mainBundle]];
    ZRFileListViewController *fileListViewController = [fileStoryboard instantiateViewControllerWithIdentifier:@"fileListViewController"];
    fileListViewController.filePath = [NSBundle mainBundle].bundlePath;
    if (fileListViewController) {
        [self.navigationController pushViewController:fileListViewController animated:YES];
    }
}
- (IBAction)onTextViewAutoSizeButtonClickHandler:(id)sender {
//    UIStoryboard *fileStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    ZRTextViewAutoSizeViewController *textViewAutoSizeVC = [fileStoryboard instantiateViewControllerWithIdentifier:@"ZRTextViewAutoSizeScene"];
//    if (textViewAutoSizeVC) {
//        [self.navigationController pushViewController:textViewAutoSizeVC animated:YES];
//    }
    
//    ZRTextViewAutoSizeExViewController *vc = [[ZRTextViewAutoSizeExViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
//    ZRGridViewController *vc = [[ZRGridViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    ZRTabBarViewController *tabBarViewController = [[ZRTabBarViewController alloc] init];
    [self.navigationController pushViewController:tabBarViewController animated:YES];
    
    /*
    ZRPickerView *pickerView = [[ZRPickerView alloc] init];
    pickerView.pickerViewHeight = 480;
    pickerView.numberOfComponents = 2;
    pickerView.levelOneDataSource = @[@"河北",@"山西",@"河南",@"山东"];
    pickerView.levelTwoDataSource = @[
                                      @[@"石家庄",@"唐山",@"张家口",@"邯郸",@"承德",@"衡水",@"邢台"],
                                      @[@"阳泉",@"太原",@"大同",@"五台",@"朔州",@"吕梁",@"临汾"],
                                      @[@"郑州",@"洛阳",@"周口",@"开封",@"平顶山",@"安阳",@"商丘",@"信阳"],
                                      @[@"济南",@"青岛",@"威海",@"蓬莱",@"泰安",@"烟台"],
                                      ];
    pickerView.okClickBlock = ^(ZRPickerView *sender, NSInteger firstColSelectedIndex, NSInteger secondColSelectedIndex) {
        //TODO: do you want to do
    };
    [pickerView show];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
