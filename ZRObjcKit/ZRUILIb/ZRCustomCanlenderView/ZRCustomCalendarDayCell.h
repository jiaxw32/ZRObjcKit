//
//  ZRCustomCalendarDayCell.h
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/11/6.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kZRCustomCalendarDayCellReuseIdentifier = @"ZRCustomCalendarDayCell";

@interface ZRCustomCalendarDayCell : UICollectionViewCell

- (void)configDisplayDate:(NSDate *)displayDate currentDate:(NSDate *)currentDate selectedDate:(NSDate *)selectedDate highlight:(BOOL)highlight isSelected:(BOOL)isSelected;

@end
