//
//  ZRImageRoundCornerViewController.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2018/1/29.
//  Copyright © 2018年 jiaxw. All rights reserved.
//

#import "ZRImageRoundCornerViewController.h"
#import "UIImage+ZRRoundCorner.h"

@interface ZRImageRoundCornerViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *midImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;

@end

@implementation ZRImageRoundCornerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.topImageView.image = [UIImage imageNamed:@"avatar"];
    self.topImageView.layer.cornerRadius = 60;
    self.topImageView.layer.masksToBounds = YES;
    
    UIImage *image = [UIImage imageNamed:@"avatar"];
    CGFloat radius = MIN(image.size.width, image.size.height) / 2.0f;
    __weak typeof(self) weakSelf = self;
    [image zr_roundImageWithRadius:radius completionHandler:^(UIImage *roundedImage) {
        weakSelf.midImageView.image = roundedImage;
    }];
    
    [image zr_roundImageWithRadius:radius andCorners:UIRectCornerTopLeft | UIRectCornerTopRight completionHandler:^(UIImage *roundedImage) {
        weakSelf.bottomImageView.image = roundedImage;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
