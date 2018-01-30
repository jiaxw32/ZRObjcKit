//
//  ZRRoundImageTableViewCell.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2018/1/30.
//  Copyright © 2018年 jiaxw. All rights reserved.
//

#import "ZRRoundImageTableViewCell.h"
#import "UIImage+ZRRoundCorner.h"

@interface ZRRoundImageTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fourthImageView;

@end

@implementation ZRRoundImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configImage{
    CGFloat radius = self.firstImageView.bounds.size.width / 2.0f;
    
//    [self roundImageView:_firstImageView radius:radius];
//    [self roundImageView:_secondImageView radius:radius];
//    [self roundImageView:_thirdImageView radius:radius];
//    [self roundImageView:_fourthImageView radius:radius];
    
//    [self maskImageView:_firstImageView radius:radius];
//    [self maskImageView:_secondImageView radius:radius];
//    [self maskImageView:_thirdImageView radius:radius];
//    [self maskImageView:_fourthImageView radius:radius];
    
    [self roundImageView:_firstImageView];
    [self roundImageView:_secondImageView];
    [self roundImageView:_thirdImageView];
    [self roundImageView:_fourthImageView];
}

- (void)roundImageView:(UIImageView *)imageView radius:(CGFloat)radius{
    
    NSString *imageName = [NSString stringWithFormat:@"avatar_%@",@(arc4random()%3 + 1)];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.layer.cornerRadius = radius;
    imageView.layer.masksToBounds = YES;
}

- (void)roundImageView:(UIImageView *)imageView{
    NSString *imageName = [NSString stringWithFormat:@"avatar_%@",@(arc4random()%3 + 1)];
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat radius = image.size.width / 2.0f;
    [image zr_roundImageWithRadius:radius completionHandler:^(UIImage *roundedImage) {
        imageView.image = roundedImage;
    }];
}

- (void)maskImageView:(UIImageView *)imageView radius:(CGFloat)radius{
    NSString *imageName = [NSString stringWithFormat:@"avatar_%@",@(arc4random()%3 + 1)];
    imageView.image = [UIImage imageNamed:imageName];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:
                              imageView.layer.bounds
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = imageView.layer.bounds;
    maskLayer.path = maskPath.CGPath;
    imageView.layer.mask = maskLayer;
    imageView.layer.shouldRasterize = YES;

}

+ (CGFloat)cellHeight{
    return 80.f;
}

@end
