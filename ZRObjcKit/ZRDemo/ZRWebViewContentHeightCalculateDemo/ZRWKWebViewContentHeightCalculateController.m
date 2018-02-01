//
//  OPWKWebViewController.m
//  OPKitDemo
//
//  Created by jiaxw-mac on 2017/2/8.
//  Copyright © 2017年 jiaxw-mac. All rights reserved.
//

#import "ZRWKWebViewContentHeightCalculateController.h"
#import <WebKit/WebKit.h>
#import "ZRWebViewContentHeightCalculateConstant.h"

@interface ZRWKWebViewContentHeightCalculateController ()<WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation ZRWKWebViewContentHeightCalculateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViews];
    
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:kZR_WebView_ReloadData_Notification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSDictionary *userInfo = note.userInfo;
        ZRWebViewDataType type = [userInfo[@"type"] integerValue];
        switch (type) {
            case ZRWebViewDataTypeURL:
                [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kZR_WebView_Resource_Web_URL]]];
                break;
            case ZRWebViewDataTypeLocalPDF:
                [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:kZR_WebView_Resource_PDF_URL]];
                break;
            case ZRWebViewDataTypeHTMLString:{
                NSString *html = kZR_WebView_Resource_HTML_String;
                NSString * div = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", html];
                [self.webView loadHTMLString:div baseURL:nil];
                break;
            }
            default:
                break;
        }
    }];
    
    //默认加载本地pdf文件
    [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:kZR_WebView_Resource_PDF_URL]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"loading"];
    [self.webView removeObserver:self forKeyPath:@"scrollView.contentSize"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI

- (void)setupViews{
    UIView *contentView = self.view;
    self.webView = ({
        WKWebView *v = [[WKWebView alloc] init];
        [v addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
        [v addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
        v.navigationDelegate = self;
        [v sizeToFit];
        [contentView addSubview:v];
        v;
    });
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];
}


#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
//    NSLog(@"%s",__func__);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    NSLog(@"%s",__func__);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
//    NSLog(@"%s",__func__);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == self.webView) {
        if ([keyPath isEqualToString:@"loading"]) {
            NSNumber *newValue = change[NSKeyValueChangeNewKey];
            if(![newValue boolValue]) {
                
                //若WebVeiw加载的是字符串，使用这种方式计算结果正确
//                document.getElementById("webview_content_wrapper").scrollHeight
                [self.webView evaluateJavaScript: @"document.body.scrollHeight" completionHandler: ^(id response, NSError *error) {
                    float clientheight = [response floatValue];
                    NSLog(@"js webview height:%f",clientheight);
                    NSLog(@"scroll height:%f",self.webView.scrollView.contentSize.height);
                }];
            }
        } else if ([keyPath isEqualToString:@"scrollView.contentSize"]){
            if (!self.webView.isLoading) {
                NSNumber *newValue = change[NSKeyValueChangeNewKey];
                NSLog(@"scrollView contentSize:%@", newValue);
            }
        }
    }
}

@end
