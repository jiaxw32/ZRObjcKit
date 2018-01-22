//
//  ZRCustomCalendarDayCell.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/11/6.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "ZRCustomCalendarDayCell.h"
#import "NSDateHelper.h"
#import "NSDate+MDExtension.h"
#import "NSCalendarHelper.h"

@interface ZRCustomCalendarDayCell ()

@property (nonatomic,strong) UILabel *lblDay;

@property (nonatomic,strong) UIView *todayDotView;

@property (nonatomic,strong) UILabel *lblTrain;

@property (nonatomic,strong) UIView *trainTaskBackgroudView;

@end

@implementation ZRCustomCalendarDayCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    UIView *cellContentView = self.contentView;
    cellContentView.backgroundColor = [UIColor whiteColor];
    _trainTaskBackgroudView = ({
        UIView *v = [UIView new];
        v.hidden = YES;
        v.backgroundColor = UIColorFromRGB(0xB7D8FF);
        [cellContentView addSubview:v];
        v;
    });
    [_trainTaskBackgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cellContentView).with.insets(UIEdgeInsetsMake(8, 5, 2, 5));
    }];
    
    
    _lblDay = ({
        UILabel *lbl = [UILabel new];
        lbl.font = [UIFont systemFontOfSize:14];
        lbl.textColor = UIColorFromRGB(0x333333);
        [cellContentView addSubview:lbl];
        lbl;
    });
    [_lblDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cellContentView);
        make.top.equalTo(cellContentView).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    _todayDotView = ({
        UIView *v = [UIView new];
        v.backgroundColor = UIColorFromRGB(0x71B2FF);
        v.layer.cornerRadius = 2;
        v.hidden = YES;
        [cellContentView addSubview:v];
        v;
    });
    [_todayDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(4, 4));
        make.centerY.equalTo(_lblDay);
        make.right.equalTo(_lblDay.mas_left).offset(-3);
    }];
    
    _lblTrain = ({
        UILabel *lbl = [UILabel new];
        lbl.hidden = YES;
        lbl.text = @"培训";
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont systemFontOfSize:10];
        [cellContentView addSubview:lbl];
        lbl;
    });
    [_lblTrain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cellContentView);
        make.top.equalTo(_lblDay.mas_bottom).offset(0);
        make.height.mas_equalTo(14);
    }];
}


- (void)configDisplayDate:(NSDate *)displayDate currentDate:(NSDate *)currentDate selectedDate:(NSDate *)selectedDate highlight:(BOOL)highlight isSelected:(BOOL)isSelected{
    self.lblDay.text = [NSString stringWithFormat:@"%lu", displayDate.mdDay];
    
    if (displayDate.mdMonth != selectedDate.mdMonth) {//非本月
        self.lblDay.textColor = UIColorFromRGB(0xcccccc);
        _todayDotView.hidden = YES;
        _trainTaskBackgroudView.hidden = YES;
        _lblTrain.hidden = YES;
    } else {//本月
        if (highlight) {//高亮显示
            _lblTrain.hidden = NO;
            _lblDay.textColor = [UIColor whiteColor];
            _trainTaskBackgroudView.hidden = NO;
            
            if ([displayDate mdIsEqualToDateForDay:currentDate]) {//当天
                _todayDotView.hidden = NO;
                _todayDotView.backgroundColor = UIColorFromRGB(0xffffff);
            } else {
                _todayDotView.hidden = YES;
            }
            _trainTaskBackgroudView.backgroundColor = isSelected ? UIColorFromRGB(0x71B2FF) : UIColorFromRGB(0xB7D8FF) ;
        } else {
            _lblTrain.hidden = YES;
            if ([displayDate mdIsEqualToDateForDay:currentDate]) {//当天
                _todayDotView.hidden = NO;
                if (isSelected) {
                    _lblDay.textColor = [UIColor whiteColor];
                    
                    _trainTaskBackgroudView.hidden = NO;
                    _trainTaskBackgroudView.backgroundColor = UIColorFromRGB(0x71B2FF);
                    
                    _todayDotView.backgroundColor = UIColorFromRGB(0xffffff);
                } else {
                   _lblDay.textColor = UIColorFromRGB(0x71B2FF);
                    _trainTaskBackgroudView.hidden = YES;
                    _todayDotView.backgroundColor = UIColorFromRGB(0x71B2FF);
                }
            } else {//非当天
                _todayDotView.hidden = YES;
                if (isSelected) {
                    _lblDay.textColor = [UIColor whiteColor];
                    _trainTaskBackgroudView.hidden = NO;
                    _trainTaskBackgroudView.backgroundColor = UIColorFromRGB(0x71B2FF);
                } else {
                    _lblDay.textColor = UIColorFromRGB(0x333333);
                    _trainTaskBackgroudView.hidden = YES;
                }
            }
        }
    }
    
}



@end
