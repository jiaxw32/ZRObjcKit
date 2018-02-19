//
//  ZRWebViewContentHeightCalculateConstant.h
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2018/2/1.
//  Copyright © 2018年 jiaxw. All rights reserved.
//

#ifndef ZRWebViewContentHeightCalculateConstant_h
#define ZRWebViewContentHeightCalculateConstant_h

typedef NS_ENUM(NSUInteger, ZRWebViewDataType) {
    ZRWebViewDataTypeLocalPDF,
    ZRWebViewDataTypeURL,
    ZRWebViewDataTypeHTMLString
};

#define kZR_WebView_ReloadData_Notification @"ZRWebViewReloadDataNotification"

#define kZR_WebView_Resource_PDF_URL [[NSBundle mainBundle] URLForResource:@"invoice.pdf" withExtension:nil]

#define kZR_WebView_Resource_Web_URL @"http://modeprice.m.ziroom.com/index.php?r=login/login&blonger_group=%E7%89%A1%E4%B8%B9%E5%9B%AD%E5%A4%A7%E5%8C%BA&agent_name=20082339&agent_part=%E4%B8%9A%E5%8A%A1%E6%80%BB%E7%9B%91&city_code=110000&timestamp=1517888010&user_account=20082339&sign=5806073e0ea86528392e97ca1097034c&"

//@"https://github.com/jiaxw32"
//@"https://www.windy.com/?gfs,40.162,116.796,7,m:eLMajov"
//@"http://skylineglobe.com/sg/TerraExplorerWeb/TerraExplorer.html"



#define kZR_WebView_Resource_HTML_String @"<img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFFVhvXSuAWoKQAAWeswdKUyo461.jpg\" width=\"100%\" /><img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFEVhvXTeAcvQjAASi8IU_nHQ866.jpg\" width=\"100%\" /><img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFFVhvXUGAfOMwAAYHbn2OECA814.jpg\" width=\"100%\" /><img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFEVhvXU6Aeyi6AAztw464Okg540.jpg\" width=\"100%\" /><img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFFVhvXVqAabJPAAVVehhgZqU002.jpg\" width=\"100%\" /><img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFEVhvXWuAInyuAARBUBUmdhI777.jpg\" width=\"100%\" /><img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFFVhvXXmACCOpAAS2eYAYEhk978.jpg\" width=\"100%\" /><img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFEVhvXZSAMEcRAAo0GsBF3x0755.jpg\" width=\"100%\" /><img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFFVhvXaSAT_x5AAhmIOSrBA0920.jpg\" width=\"100%\" /><img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFFVhvXbKAA7E-AAenZY9hQPk850.jpg\" width=\"100%\" /><img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFEVhvXc-ADHKQAAWJhLgvEFU078.jpg\" width=\"100%\" />"


#endif /* ZRWebViewContentHeightCalculateConstant_h */
