//
//  ZRTrackingManager.h
//  ZRTrackingManager
//
//  Created by jiaxw-mac on 2017/11/29.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZRTrackingManager : NSObject


/**
 用于跟踪App运行的管理类，单例

 @return 返回
 */
+ (instancetype)sharedInstance;



/**
 App启动跟踪

 @param launchOptions App运行参数
 */
- (void)beginAppTrackingWithLauchOptions:(NSDictionary *)launchOptions;


/**
 App结束运行跟踪
 */
- (void)endAppTracking;


/**
 开始页面访问跟踪

 @param pageID 页面ID
 @param parentPageID 前一页面ID
 @param title 页面导航栏标题
 @param className ViewController类名
 */
- (void)beginPageTrackingWithPageID:(NSString *)pageID prePageID:(NSString *)parentPageID title:(NSString *)title className:(NSString *)className;


/**
 结束页面访问跟踪

 @param pageID 页面ID
 */
- (void)endPageTrackingWithPageID:(NSString *)pageID;


/**
 事件跟踪

 @param title 名称
 @param path 事件响应View文档路径
 @param pageID 页面ID
 @param senderType 响应事件View类名
 */
- (void)eventTrackingWithTitle:(NSString *)title path:(NSString *)path pageID:(NSString *)pageID type:(NSString *)senderType;


/**
 函数调用跟踪

 @param funcName 函数名
 @param className 类型
 @param params 函数参数
 @param tag 标签
 */
- (void)funcInvokeTrackingWithName:(NSString *)funcName
                         className:(NSString *)className
                            params:(NSDictionary *)params
                               tag:(NSString *)tag;

@end
