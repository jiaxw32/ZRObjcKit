//
//  ZRStepStatisticViewController.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2018/1/21.
//  Copyright © 2018年 jiaxw. All rights reserved.
//

#import "ZRStepStatisticViewController.h"
#import "ZRStepStatisticView.h"

@interface ZRStepStatisticViewController ()

@property (nonatomic,strong) ZRStepStatisticView *statisticView;

@end

@implementation ZRStepStatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI

- (void)setupViews{
    UIView *contentView = self.view;
    contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.statisticView = [[ZRStepStatisticView alloc] initWithFrame:CGRectMake(0, 0, width, 274)];
    
    id __weak weakSelf = self;
    self.statisticView.onStatisticTypeChangedHanlder = ^(ZRStepStatisticView *sender, ZRStepStatisticType selectedStatisticType) {
        if (selectedStatisticType == ZRStepStatisticTypeWeek) {
            sender.weekDataArray = [weakSelf createRandomWeekSteps];
        } else {
            sender.monthDataArray = [weakSelf createRandomMonthSteps];
        }
    };
    
    [contentView addSubview:self.statisticView];
    self.statisticView.weekDataArray = [self createRandomWeekSteps];
}

#pragma mark - DATA

- (NSArray *)createRandomStepsWithType:(ZRStepStatisticType)type{
    NSUInteger count = 0;
    switch (type) {
        case ZRStepStatisticTypeWeek:
            count = 7;
            break;
        case ZRStepStatisticTypeMonth:
            count = 30;
            break;
        default:
            count = 7;
            break;
    }
    NSMutableArray *array = [NSMutableArray new];
    
    //计算开始日期
    NSDate *beginDate = [self createDateWithOrginal:[NSDate new] addDays: (count - 1) * -1];
    
    for (NSInteger i = 0; i < count; i++) {
        //随机生成步数
        NSUInteger step = arc4random() % 20000;
        //计算日期
        NSDate *date = [self createDateWithOrginal:beginDate addDays:i];
        NSString *dateString = [self formatDate:date];
        
        NSDictionary *item = @{@"date" : dateString ?: @"", @"value" : @(step)};
        [array addObject: item];
    }
    return [array copy];

}

- (NSArray *)createRandomWeekSteps{
    return [self createRandomStepsWithType:ZRStepStatisticTypeWeek];
}

- (NSArray *)createRandomMonthSteps{
    return [self createRandomStepsWithType:ZRStepStatisticTypeMonth];
}

#pragma mark - Helper

- (NSString *)formatDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/dd";
    return [formatter stringFromDate:date];
}

- (NSDate *)createDateWithOrginal:(NSDate *)date addDays:(NSInteger)days{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    return [calendar dateByAddingComponents:components toDate:date options:0];
}

@end
