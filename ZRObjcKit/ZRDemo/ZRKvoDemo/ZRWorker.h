//
//  ZRWorker.h
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/27.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZRWorker : NSObject


/**
 姓名
 */
@property (nonatomic,copy) NSString *name;


/**
 工号
 */
@property (nonatomic,copy) NSString *jobNumber;


/**
 工作状态
 */
@property (nonatomic,assign) NSInteger workStatus;


@end
