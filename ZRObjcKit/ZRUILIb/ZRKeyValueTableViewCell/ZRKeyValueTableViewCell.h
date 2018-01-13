//
//  ZRKeyValueTableViewCell.h
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2018/1/13.
//  Copyright © 2018年 jiaxw All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZRKeyValueTableViewCell : UITableViewCell

+ (instancetype)keyValueTableViewCellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) UILabel *labelKey;

@property (nonatomic,strong) UILabel *labelValue;

@property (nonatomic,strong) UIView *bottomLine;

@property (nonatomic,assign) BOOL showIndicator;

- (void)setKeyText:(NSString *)key andValueText:(NSString *)value;

- (void)setKeyAttributeText:(NSAttributedString *)key andValueAttributeText:(NSAttributedString *)value;

- (void)showIndicatorView:(BOOL)visible imageName:(NSString *)imageName;

+ (CGFloat)cellHeight;

@end
