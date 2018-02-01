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

#define kZR_WebView_Resource_Web_URL @"https://github.com/jiaxw32"

#define kZR_WebView_Resource_HTML_String @"<img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFFVhvXSuAWoKQAAWeswdKUyo461.jpg\" width=\"100%\" /><img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFEVhvXTeAcvQjAASi8IU_nHQ866.jpg\" width=\"100%\" /><img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFFVhvXUGAfOMwAAYHbn2OECA814.jpg\" width=\"100%\" /><img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFEVhvXU6Aeyi6AAztw464Okg540.jpg\" width=\"100%\" /><img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFFVhvXVqAabJPAAVVehhgZqU002.jpg\" width=\"100%\" /><img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFEVhvXWuAInyuAARBUBUmdhI777.jpg\" width=\"100%\" /><img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFFVhvXXmACCOpAAS2eYAYEhk978.jpg\" width=\"100%\" /><img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFEVhvXZSAMEcRAAo0GsBF3x0755.jpg\" width=\"100%\" /><img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFFVhvXaSAT_x5AAhmIOSrBA0920.jpg\" width=\"100%\" /><img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFFVhvXbKAA7E-AAenZY9hQPk850.jpg\" width=\"100%\" /><img src=\"https://raw.githubusercontent.com/jiaxw32/MMIMage/master/webview/ChAFEVhvXc-ADHKQAAWJhLgvEFU078.jpg\" width=\"100%\" />"


#endif /* ZRWebViewContentHeightCalculateConstant_h */
