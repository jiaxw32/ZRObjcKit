//
//  ZRUIWebViewContentHeightCalculateController.m
//  OPKitDemo
//
//  Created by jiaxw-mac on 2017/2/8.
//  Copyright © 2017年 jiaxw-mac. All rights reserved.
//

#import "ZRUIWebViewContentHeightCalculateController.h"
#import "ZRWebViewContentHeightCalculateConstant.h"

@interface ZRUIWebViewContentHeightCalculateController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation ZRUIWebViewContentHeightCalculateController


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
                [weakSelf.webView loadHTMLString:kZR_WebView_Resource_HTML_String baseURL:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI

- (void)setupViews{
    UIView *contentView = self.view;
    self.webView = ({
        UIWebView *v = [[UIWebView alloc] init];
        v.delegate = self;
        v.scrollView.backgroundColor = [UIColor lightGrayColor];
        [contentView addSubview:v];
        v;
    });
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    float clientheight = [clientheight_str floatValue];
    NSLog(@"webview height:%f",clientheight);
}

@end
