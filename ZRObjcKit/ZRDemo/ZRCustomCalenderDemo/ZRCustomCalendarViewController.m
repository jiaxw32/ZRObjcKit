//
//  ZRCustomCalenerViewController.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2018/1/22.
//  Copyright © 2018年 jiaxw. All rights reserved.
//

#import "ZRCustomCalendarViewController.h"
#import "ZRCustomCalendarView.h"
#import "NSDate+MDExtension.h"
#import "NSDateHelper.h"

@interface ZRCustomCalendarViewController ()<ZRCustomCalendarViewDelegate>

@property (nonatomic,strong) ZRCustomCalendarView *calendarView;

@property (nonatomic,strong) NSDate *currentDate;

@property (nonatomic,strong) NSDate *selectedMonth;

@end

@implementation ZRCustomCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
    self.currentDate = [NSDate new];
    //默认选择当天日期
    self.selectedMonth = self.currentDate;
    
    [self configCalendarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (ZRCustomCalendarView *)calendarView{
    if (!_calendarView) {
        _calendarView = [[ZRCustomCalendarView alloc] init];
        _calendarView.delegate = self;
        _calendarView.currentDate = self.currentDate;
        
        _calendarView.minDate = [NSDateHelper mdDateWithYear:2000 month:1 day:1];
        _calendarView.maxDate = [NSDateHelper mdDateWithYear:2030 month:12 day:31];
        [self.view addSubview:_calendarView];
    }
    return _calendarView;
}

#pragma mark - UI


- (void)configCalendarView{
    
    //根据当前选择月份，计算日历高度
    CGFloat(^calculateHeight)(NSDate *) = ^CGFloat(NSDate *selectedDate){
        NSDate *firstDayOfMonth = [NSDateHelper mdDateWithYear:selectedDate.mdYear
                                                         month:selectedDate.mdMonth
                                                           day:1];
        NSUInteger firstWeekday = [[NSCalendar currentCalendar] firstWeekday];
        NSInteger dayDifference = firstDayOfMonth.mdWeekday - firstWeekday;
        NSUInteger count = selectedDate.mdNumberOfDaysInMonth + dayDifference;
        NSInteger dayCount = ceilf(count / 7.0) * 7;
        return  58 + 58 + dayCount / 7 * 48 + 11;
    };
    
    //随机生成高亮日期
    NSArray*(^randomHighlightDates)(NSDate *) = ^NSArray*(NSDate *seletedDate){
        NSInteger year = seletedDate.mdYear;
        NSInteger month = seletedDate.mdMonth;
        NSMutableArray *days = [NSMutableArray new];
        
        for (NSInteger i = 0; i < 7; i++) {
            NSInteger day = arc4random() % 28;
            if (0 == day) {
                ++day;
            }
            NSDate *date = [NSDateHelper mdDateWithYear:year month:month day:day];
            NSString *dateString = [date mdStringWithFormat:@"yyyy-MM-dd"];
            if (NO == [days containsObject:dateString]) {
                [days addObject:dateString];
            }
        }
        return days;
    };
    
    CGFloat height = calculateHeight(_selectedMonth);
    if (self.calendarView.frame.size.height != height) {
        self.calendarView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height);
    }
    
    NSArray *highlightDays = randomHighlightDates(_selectedMonth);
    [self.calendarView configSelectedMonth:self.selectedMonth andHighlightDays:highlightDays];
}

#pragma mark - ZRCustomCalenderViewDelegate

- (void)calendarView:(ZRCustomCalendarView *)calendarView onMonthChanged:(NSDate *)date{
    self.selectedMonth = date;
    [self configCalendarView];
}

- (void)calendarView:(ZRCustomCalendarView *)calendarView didSelectDay:(NSDate *)date{

}


@end
