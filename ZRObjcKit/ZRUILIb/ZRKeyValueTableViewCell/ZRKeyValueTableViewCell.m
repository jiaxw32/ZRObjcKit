//
//  ZRKeyValueTableViewCell.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2018/1/13.
//  Copyright © 2018年 jiaxw All rights reserved.
//

#import "ZRKeyValueTableViewCell.h"

@interface ZRKeyValueTableViewCell ()

@property (nonatomic,strong) UIImageView *imgIndicatorView;

@end

@implementation ZRKeyValueTableViewCell

+ (instancetype)keyValueTableViewCellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"ZRKeyValueTableViewCell";
    ZRKeyValueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ZRKeyValueTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    UIView *contentView = self.contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    
    self.labelKey = ({
        UILabel *lbl = [UILabel new];
        lbl.font = [UIFont systemFontOfSize:16];
        lbl.textColor = UIColorFromRGB(0x999999);
        [contentView addSubview:lbl];
        lbl;
    });
    
    self.labelValue = ({
        UILabel *lbl = [UILabel new];
        lbl.textAlignment = NSTextAlignmentRight;
        lbl.font = [UIFont systemFontOfSize:16];
        lbl.textColor = UIColorFromRGB(0x999999);
        [contentView addSubview:lbl];
        lbl;
    });
    
    self.imgIndicatorView = ({
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zr_right_arrow"]];
        img.hidden = YES;
        [contentView addSubview:img];
        img;
    });
    
    self.bottomLine = ({
        UIView *line = [UIView new];
        line.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [contentView addSubview:line];
        line;
    });

    
    [self.labelKey mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView.mas_centerY);
        make.left.equalTo(contentView.mas_left).offset(16).priorityHigh();
        make.right.equalTo(self.labelValue.mas_left).offset(-16);
    }];
    
    [self.labelValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView.mas_centerY);
        make.right.equalTo(contentView.mas_right).offset(-16).priorityHigh();
        make.width.priorityLow();
        make.width.greaterThanOrEqualTo(@16).priorityHigh();
    }];
    
    [self.imgIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView.mas_centerY);
        make.right.equalTo(contentView.mas_right).offset(-16);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView.mas_bottom);
        make.height.mas_equalTo(.5f);
        make.left.equalTo(contentView.mas_left).offset(16);
        make.right.equalTo(contentView.mas_right).offset(-16);
    }];
    
}

- (void)showIndicator:(BOOL)showIndicator{
    _showIndicator = showIndicator;
    if (_showIndicator) {//显示指示器
        self.imgIndicatorView.hidden = NO;
        [self.labelValue mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.imgIndicatorView.mas_left).offset(-16).priorityHigh();
            make.width.priorityLow();
            make.width.greaterThanOrEqualTo(@16).priorityHigh();
        }];
    } else {//隐藏指示器
        self.imgIndicatorView.hidden = YES;
        [self.labelValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-16).priorityHigh();
            make.width.priorityLow();
            make.width.greaterThanOrEqualTo(@16).priorityHigh();
        }];
    }
}

- (void)showIndicatorView:(BOOL)visible imageName:(NSString *)imageName{
    self.imgIndicatorView.image = [UIImage imageNamed:imageName];
    self.showIndicator = visible;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setKeyText:(NSString *)key andValueText:(NSString *)value{
    self.labelKey.text = key ?: @"";
    self.labelValue.text = value ?: @"";
}

- (void)setKeyAttributeText:(NSAttributedString *)key andValueAttributeText:(NSAttributedString *)value{
    self.labelKey.attributedText = key;
    self.labelValue.attributedText = value;
}

+ (CGFloat)cellHeight{
    return 48;
}

@end
