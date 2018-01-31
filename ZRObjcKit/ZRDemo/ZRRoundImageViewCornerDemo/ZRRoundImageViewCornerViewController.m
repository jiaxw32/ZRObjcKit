//
//  ZRRoundImageViewCornerViewController.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2018/1/31.
//  Copyright © 2018年 jiaxw. All rights reserved.
//

#import "ZRRoundImageViewCornerViewController.h"
#import "UIImageView+ZRRoundCorner.h"

@interface ZRRoundImageViewCornerViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewOne;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewTwo;

@end

@implementation ZRRoundImageViewCornerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageViewOne.image = [UIImage imageNamed:@"avatar"];
    self.imageViewTwo.image = [UIImage imageNamed:@"avatar"];
    
//    _imageViewOne.contentMode = UIViewContentModeScaleAspectFill;
//    _imageViewTwo.contentMode = UIViewContentModeScaleToFill;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onSwitchValueChanged:(UISwitch *)sender {
    if (sender.on) {
        [self.imageViewOne zr_roundCornersForAspectFit:80];
        [self.imageViewTwo zr_roundCornersForAspectFit:80];
    } else {
        [self.imageViewOne.layer.mask removeFromSuperlayer];
        [self.imageViewTwo.layer.mask removeFromSuperlayer];
    }
}

@end
