//
//  ZRPickerView.h
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2016/10/27.
//  Copyright © 2016年 jiaxw. All rights reserved.
//

#import "MMAlertView.h"

@class ZRPickerView;

typedef void(^RSPickerViewOkClickHandler)(ZRPickerView *sender,NSInteger firstColSelectedIndex,NSInteger secondColSelectedIndex);

@interface ZRPickerView : MMAlertView


/**
 业务标识
 */
@property (nonatomic,assign) NSInteger businessTag;


/**
 pickerView标题
 */
@property (nonatomic,copy) NSString *pickerViewTitle;


/**
 高度
 */
@property (nonatomic,assign) CGFloat pickerViewHeight;


/**
 pickerView列数
 */
@property (nonatomic,assign) NSInteger numberOfComponents;

@property (nonatomic,strong)NSArray *levelOneDataSource;

@property (nonatomic,strong)NSArray *levelTwoDataSource;

@property (nonatomic,assign) NSInteger firstComponentSelectRow;


@property (nonatomic,assign) NSInteger secondComponentSelectRow;


@property (nonatomic,copy) RSPickerViewOkClickHandler okClickBlock;



@end
