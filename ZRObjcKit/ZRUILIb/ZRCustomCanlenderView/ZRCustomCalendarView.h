//
//  ZRCustomCalendarView.h
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/11/6.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZRCustomCalendarView;

@protocol ZRCustomCalendarViewDelegate <NSObject>

- (void)calendarView:(ZRCustomCalendarView *)calendarView onMonthChanged:(NSDate *)date;

- (void)calendarView:(ZRCustomCalendarView *)calendarView didSelectDay:(NSDate *)date;

@end

@interface ZRCustomCalendarView : UIView

@property (nonatomic,weak) id<ZRCustomCalendarViewDelegate> delegate;


/**
 当天日期
 */
@property (nonatomic,strong) NSDate *currentDate;


/**
 最小日期
 */
@property (nonatomic,strong) NSDate *minDate;


/**
 最大日期
 */
@property (nonatomic,strong) NSDate *maxDate;


/**
 设置当前选择月份与高亮日期

 @param selectedMonth 当前选择月
 @param highlightDays 需要高亮的日期
 */
- (void)configSelectedMonth:(NSDate *)selectedMonth andHighlightDays:(NSArray *)highlightDays;

@end
