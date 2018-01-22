//
//  ZRCustomCalendarView.m
//  RSProject
//
//  Created by jiaxw-mac on 2017/11/6.
//  Copyright © 2017年 ziroomer. All rights reserved.
//

#import "ZRCustomCalendarView.h"
#import "ZRCustomCalendarDayCell.h"
#import "NSDateHelper.h"
#import "NSDate+MDExtension.h"
#import "NSCalendarHelper.h"

@interface ZRCustomCalendarView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
}

@property (nonatomic,strong) UIView *weekHeaderView;

@property (nonatomic,strong) UIView *monthHeaderView;

@property (nonatomic,strong) UILabel *monthLabel;

@property (nonatomic,strong) UIImageView *nextMonthImageView;

@property (nonatomic,strong) UIButton *nextMonthButton;

@property (nonatomic,strong) UIImageView *preMonthImageView;

@property (nonatomic,strong) UIButton *preMonthButton;

@property (nonatomic,strong) UIView *dayContentView;

@property (nonatomic,strong) UICollectionView *dayCollectionView;

@property (nonatomic,strong) NSDate *selectedMonth;

@property (nonatomic,copy) NSArray *highLightDays;

@property (nonatomic,assign) NSInteger dayCount;

@property (nonatomic,strong) UIView *bottomLine;

@property (nonatomic,strong) NSDate *selectedItemDate;

@end

@implementation ZRCustomCalendarView

- (instancetype)init{
    if (self = [super init]) {
        self.selectedItemDate = [NSDate distantFuture];
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    UIView *contentView = self;
    
    _monthHeaderView = ({
        UIView *v = [UIView new];
        v.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:v];
        v;
    });
    [_monthHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(contentView);
        make.height.mas_equalTo(58);
    }];
    
    _monthLabel = ({
        UILabel *lbl = [UILabel new];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:16];
        lbl.textColor = UIColorFromRGB(0x333333);
        [_monthHeaderView addSubview:lbl];
        lbl;
    });
    [_monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_monthHeaderView);
        make.height.mas_equalTo(22);
    }];
    
    _preMonthImageView = ({
        UIImageView *v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ms_blue_left_arrow"]];
        [_monthHeaderView addSubview:v];
        v;
    });
    [_preMonthImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(14, 14));
        make.centerY.equalTo(_monthHeaderView);
        make.right.equalTo(_monthLabel.mas_left).offset(-40);
    }];

    
    _preMonthButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 1;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_monthHeaderView addSubview:btn];
        btn;
    });
    [_preMonthButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_monthHeaderView);
        make.centerX.equalTo(_preMonthImageView);
        make.width.mas_equalTo(_monthHeaderView.mas_height);
    }];
    
    _nextMonthImageView = ({
        UIImageView *v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ms_blue_right_arrow"]];
        [_monthHeaderView addSubview:v];
        v;
    });
    [_nextMonthImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(14, 14));
        make.centerY.equalTo(_monthHeaderView);
        make.left.equalTo(_monthLabel.mas_right).offset(40);
    }];

    _nextMonthButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = 2;
        [btn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_monthHeaderView addSubview:btn];
        btn;
    });
    [_nextMonthButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_monthHeaderView);
        make.centerX.equalTo(_nextMonthImageView);
        make.width.mas_equalTo(_monthHeaderView.mas_height);
    }];
    
    _weekHeaderView = ({
        UIView *v = [UIView new];
        v.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [contentView addSubview:v];
        v;
    });
    [_weekHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(_monthHeaderView.mas_bottom);
        make.height.mas_equalTo(58);
    }];
    
    CGFloat itemWidth = [UIScreen mainScreen].bounds.size.width / 7.0f;
    for (NSUInteger i = 0; i < 7; i++) {
        UIButton *btnWeek = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitle:@[@"日",@"一",@"二",@"三",@"四",@"五",@"六"][i] forState:UIControlStateNormal];
            UIColor *color = (i == 0 || i == 6) ? UIColorFromRGB(0x71B2FF): UIColorFromRGB(0x333333);
            [btn setTitleColor:color forState:UIControlStateNormal];
            btn.backgroundColor = UIColorFromRGB(0xf6f6f6);
            [_weekHeaderView addSubview:btn];
            btn;
        });
        [btnWeek mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_weekHeaderView);
            make.width.mas_equalTo(itemWidth);
            make.left.equalTo(_weekHeaderView).offset(itemWidth * i);
        }];
    }

    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(itemWidth, 48);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _dayCollectionView = ({
        UICollectionView * v = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        v.backgroundColor = [UIColor whiteColor];
        v.delegate = self;
        v.dataSource = self;
        [v registerClass:[ZRCustomCalendarDayCell class] forCellWithReuseIdentifier:kZRCustomCalendarDayCellReuseIdentifier];
        [contentView addSubview:v];
        v;
    });
    [_dayCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weekHeaderView.mas_bottom);
        make.left.right.bottom.equalTo(contentView);
    }];
    
    _bottomLine = ({
        UIView *v = [UIView new];
        v.backgroundColor = UIColorFromRGB(0xf5f5f5);
        [contentView addSubview:v];
        v;
    });
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(contentView);
        make.height.mas_equalTo(1.0f);
    }];
}

- (void)setCurrentDate:(NSDate *)currentDate{
    _currentDate = currentDate;
    _selectedItemDate = currentDate;
}

- (void)configSelectedMonth:(NSDate *)selectedMonth andHighlightDays:(NSArray *)highlightDays{
    self.highLightDays = highlightDays;
    self.selectedMonth = selectedMonth;
    [self.dayCollectionView reloadData];
}

- (void)setSelectedMonth:(NSDate *)selectedMonth{
    _selectedMonth = selectedMonth;
    
    NSDate *firstDayOfMonth = [NSDateHelper mdDateWithYear:_selectedMonth.mdYear
                                                     month:_selectedMonth.mdMonth
                                                       day:1];
    NSUInteger firstWeekday = [[NSCalendar currentCalendar] firstWeekday];
    NSInteger dayDifference = firstDayOfMonth.mdWeekday - firstWeekday;

    NSUInteger count = self.selectedMonth.mdNumberOfDaysInMonth + dayDifference;
    _dayCount = ceilf(count / 7.0) * 7;
    
    BOOL isSelectedMonthEqualMinMonth = [_selectedMonth mdIsEqualToDateForMonth:_minDate];
    BOOL isSelectedMonthEqualMaxMonth = [_selectedMonth mdIsEqualToDateForMonth:_maxDate];
    
    self.preMonthButton.enabled = !isSelectedMonthEqualMinMonth;
    self.nextMonthButton.enabled = !isSelectedMonthEqualMaxMonth;
    self.preMonthImageView.hidden = isSelectedMonthEqualMinMonth;
    self.nextMonthImageView.hidden = isSelectedMonthEqualMaxMonth;
    self.monthLabel.text = [NSString stringWithFormat:@"%lu年%lu月",_selectedMonth.mdYear,_selectedMonth.mdMonth];
    
}

#pragma mark - UICollection Delegate and Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dayCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZRCustomCalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZRCustomCalendarDayCellReuseIdentifier forIndexPath:indexPath];
    NSDate *displayDate = [self dateForIndexPath:indexPath];
    NSString *strDisplyaDate = [displayDate mdStringWithFormat:@"yyyy-MM-dd"];
    BOOL highlight = [self.highLightDays containsObject:strDisplyaDate];
    BOOL selected = [displayDate mdIsEqualToDateForDay:_selectedItemDate];
    [cell configDisplayDate:displayDate currentDate:_currentDate selectedDate:_selectedMonth highlight:highlight isSelected:selected];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDate *displayDate = [self dateForIndexPath:indexPath];
    if ([displayDate isEqualToDate:_selectedItemDate]) {
        self.selectedItemDate = [NSDate distantFuture];
    } else {
        self.selectedItemDate = displayDate;
    }
    if ([displayDate mdIsLessThanDateForMonth:self.selectedMonth]){//上月数据
        if ([displayDate mdIsLessThanDateForMonth:_minDate]) {
            return;
        }
        [self gotoPreMonth];
    } else if ([displayDate mdIsEqualToDateForMonth:self.selectedMonth]) {//当月数据
        [self.dayCollectionView reloadData];
        if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDay:)]) {
            [self.delegate  calendarView:self didSelectDay:displayDate];
        }
    } else {//下月数据
        if ([displayDate mdIsGreaterThanDateForMonth:_maxDate]) {
            return;
        }
        [self gotoNextMonth];
    }
}


- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath {
    
    NSDate *firstDayOfMonth = [NSDateHelper mdDateWithYear:self.selectedMonth.mdYear
                                                     month:self.selectedMonth.mdMonth
                                                       day:1];
    NSUInteger firstWeekday = [[NSCalendar currentCalendar] firstWeekday];
    NSInteger dayDifference = firstDayOfMonth.mdWeekday - firstWeekday;
    
    NSDate *firstDateOfPage = [firstDayOfMonth mdDateBySubtractingDays:dayDifference];
    NSDate *date = [firstDateOfPage mdDateByAddingDays:indexPath.item];
    return date;
}


#pragma mark - action

- (void)onButtonClick:(UIButton *)sender{
    self.selectedItemDate = [NSDate distantFuture];
    if (sender.tag == 1) {
        [self gotoPreMonth];
    } else {
        [self gotoNextMonth];
    }
}

- (void)gotoNextMonth{
    if ([self.delegate respondsToSelector:@selector(calendarView:onMonthChanged:)]) {
        NSDate *nextMonth = [self.selectedMonth mdDateByAddingMonths:1];
        [self.delegate calendarView:self onMonthChanged:nextMonth];
    }
}

- (void)gotoPreMonth{
    if ([self.delegate respondsToSelector:@selector(calendarView:onMonthChanged:)]) {
        NSDate *preMonth = [self.selectedMonth mdDateBySubtractingMonths:1];
        [self.delegate calendarView:self onMonthChanged:preMonth];
    }
}

@end
