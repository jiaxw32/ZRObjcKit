//
//  ZRImageRoundCornerViewController.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2018/1/29.
//  Copyright © 2018年 jiaxw. All rights reserved.
//

#import "ZRImageRoundCornerViewController.h"
#import "UIImage+ZRRoundCorner.h"
#import "ZRRoundImageTableViewCell.h"

@interface ZRImageRoundCornerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *midImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ZRImageRoundCornerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *image = [UIImage imageNamed:@"avatar"];
    CGFloat radius = MIN(image.size.width, image.size.height) / 2.0f;
    __weak typeof(self) weakSelf = self;
    [image zr_roundImageWithRadius:radius completionHandler:^(UIImage *roundedImage) {
        weakSelf.midImageView.image = roundedImage;
    }];
    
//    [image zr_roundImageWithRadius:radius andCorners:UIRectCornerTopLeft | UIRectCornerTopRight completionHandler:^(UIImage *roundedImage) {
//        weakSelf.bottomImageView.image = roundedImage;
//    }];
    
    self.bottomImageView.image = image;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:
                self.bottomImageView.layer.bounds
                                     byRoundingCorners:UIRectCornerAllCorners
                                           cornerRadii:CGSizeMake(60.0f, 60.0f)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bottomImageView.layer.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bottomImageView.layer.mask = maskLayer;
    self.bottomImageView.layer.shouldRasterize = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2000;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ZRRoundImageTableViewCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZRRoundImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"roundImageCell"];
    [cell configImage];
    return cell;
}



@end
