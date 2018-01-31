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

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,assign) ZRRoundImageType roundImageType;
@end

@implementation ZRImageRoundCornerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [image zr_roundImageWithRadius:radius andCorners:UIRectCornerTopLeft | UIRectCornerTopRight completionHandler:^(UIImage *roundedImage) {
//        weakSelf.bottomImageView.image = roundedImage;
//    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"select" style:UIBarButtonItemStyleDone target:self action:@selector(actionSelectRoundType)];
    self.roundImageType = ZRRoundImageTypeLayerRadius;
    
    NSLog(@"%@", @(CGFLOAT_MIN));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setter

- (void)setRoundImageType:(ZRRoundImageType)roundImageType{
    _roundImageType = roundImageType;
    
    switch (_roundImageType) {
        case ZRRoundImageTypeLayerRadius:
            self.title = @"set layer radius";
            break;
        case ZRRoundImageTypeMaskLayer:
            self.title = @"mask layer";
            break;
        case ZRRoundImageTypeClipImage:
            self.title = @"clip layer";
            break;
        default:
            break;
    }
}

#pragma mark - UITableView delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5000;
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
    [cell roundImageWithType:_roundImageType];
    return cell;
}

#pragma mark - Action

- (void)actionSelectRoundType{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"please select round image type" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *actionLayerRadius = [UIAlertAction actionWithTitle:@"set layer radius" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.roundImageType = ZRRoundImageTypeLayerRadius;
    }];
    
    UIAlertAction *actionMaskLayer = [UIAlertAction actionWithTitle:@"mask layer" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.roundImageType = ZRRoundImageTypeMaskLayer;
    }];
    
    UIAlertAction *actionClipImage = [UIAlertAction actionWithTitle:@"clip image" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.roundImageType = ZRRoundImageTypeClipImage;
    }];
    
    [alertController addAction:actionCancel];
    [alertController addAction:actionLayerRadius];
    [alertController addAction:actionMaskLayer];
    [alertController addAction:actionClipImage];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
