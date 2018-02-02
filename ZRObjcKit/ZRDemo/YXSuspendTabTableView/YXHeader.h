//
//  Header.h
//  仿造淘宝商品详情页
//
//  Created by yixiang on 16/3/29.
//  Copyright © 2016年 yixiang. All rights reserved.
//

#import "YXTabView.h"
#import "YXTabViewStyle.h"
#import "YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView.h"

#define YX_SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define YX_SCREEN_HEIGHT    [[UIScreen mainScreen] bounds].size.height

static NSString *const kYXScrollToTopNotificationName = @"YXScrollToTopNotification";//进入置顶命令
static NSString *const kYXLeaveTopNotificationName = @"YXLeaveTopNotification";//离开置顶命令





