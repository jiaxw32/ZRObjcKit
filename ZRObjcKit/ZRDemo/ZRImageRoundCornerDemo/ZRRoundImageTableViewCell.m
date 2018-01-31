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



- (void)roundImageWithType:(ZRRoundImageType)roundImageType{
    switch (roundImageType) {
        case ZRRoundImageTypeLayerRadius:
            [self roundImageViewWithLayerRadius];
            break;
        case ZRRoundImageTypeMaskLayer:
            [self roundImageWithMaskLayer];
            break;
        case ZRRoundImageTypeClipImage:
            [self roundImage];
            break;
        default:
            break;
    }
}

- (void)roundImageViewWithLayerRadius{
    CGFloat radius = self.firstImageView.bounds.size.width / 2.0f;
    
    void(^roundImageView)(UIImageView *) = ^(UIImageView *imageView){
        NSString *imageName = [NSString stringWithFormat:@"avatar_%@", @(arc4random() % 3 + 1)];
        imageView.image = [UIImage imageNamed:imageName];
        imageView.layer.cornerRadius = radius;
        imageView.layer.masksToBounds = YES;
    };
    
    roundImageView(_firstImageView);
    roundImageView(_secondImageView);
    roundImageView(_thirdImageView);
    roundImageView(_fourthImageView);
}

- (void)roundImageWithMaskLayer{
    CGFloat radius = self.firstImageView.bounds.size.width / 2.0f;
    
    void(^maskImageView)(UIImageView *) = ^(UIImageView *imageView){
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
    };
    
    maskImageView(_firstImageView);
    maskImageView(_secondImageView);
    maskImageView(_thirdImageView);
    maskImageView(_fourthImageView);
}

- (void)roundImage{
    
    void(^clipImage)(UIImageView *) = ^(UIImageView *imageView){
        NSString *imageName = [NSString stringWithFormat:@"avatar_%@",@(arc4random()%3 + 1)];
        UIImage *image = [UIImage imageNamed:imageName];
        CGFloat radius = image.size.width / 2.0f;
        [image zr_roundImageWithRadius:radius completionHandler:^(UIImage *roundedImage) {
            imageView.image = roundedImage;
        }];
    };
    
    clipImage(_firstImageView);
    clipImage(_secondImageView);
    clipImage(_thirdImageView);
    clipImage(_fourthImageView);
}

+ (CGFloat)cellHeight{
    return 80.f;
}

@end
