//
//  ZRTextViewAutoSizeExViewController.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/14.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "ZRTextViewAutoSizeExViewController.h"
#import "ZRTextViewAutoSizeConstant.h"
#import <Masonry/Masonry.h>

@interface ZRTextViewAutoSizeExViewController ()<UITextViewDelegate>

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) UIView *textContentView;

@end

@implementation ZRTextViewAutoSizeExViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupViews{
    UIView *contentView = self.view;
    contentView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    
    UIView *textContentView = ({
        UIView *v = [UIView new];
        v.backgroundColor = [UIColor whiteColor];
        v.layer.borderWidth = 1.0f;
        v.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [contentView addSubview:v];
        v;
    });
    [textContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(contentView);
        make.height.mas_equalTo(64);
    }];
    self.textContentView = textContentView;
    
    self.textView = ({
        UITextView *v = [[UITextView alloc] init];
        v.layer.cornerRadius = 4.0f;
//        v.contentInset = UIEdgeInsetsMake(kZRTextViewContentInsetTop, 0, 0, 0);
        v.textContainerInset = UIEdgeInsetsMake(kZRTextViewContentInsetTop, 0, 0, 0);
        v.layoutManager.allowsNonContiguousLayout = NO;
        v.font = [UIFont systemFontOfSize:16];
        v.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        v.delegate = self;
        [textContentView addSubview:v];
        v;
    });
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(textContentView).insets(UIEdgeInsetsMake(kZRTextViewVerticalMargin, 12, kZRTextViewVerticalMargin, 64));
    }];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)]];
}


- (void)keyBoardWillHide:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval time = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self.textContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(0);
    }];
    [UIView animateWithDuration:time animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyBoardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    
    CGRect frame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = frame.size.height;
    
    NSTimeInterval time = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self.textContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-height);
    }];
    [UIView animateWithDuration:time animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)onTap:(UIGestureRecognizer *)gesture{
    [self.textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView{
    
    CGFloat height = textView.contentSize.height + kZRTextViewContentInsetTop;
    CGFloat textContentViewHeight;
    if (height <= kZRTextViewMinHeight) {
        textContentViewHeight = kZRTextViewMinHeight + kZRTextViewVerticalMargin * 2;
    } else if (height > kZRTextViewMaxHeight){
        textContentViewHeight = kZRTextViewMaxHeight + kZRTextViewVerticalMargin * 2;
    } else {
        textContentViewHeight = height + kZRTextViewVerticalMargin * 2;
    }
    [self.textContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(textContentViewHeight);
    }];
    [UIView animateWithDuration:0.3f animations:^{
        [self.textContentView layoutIfNeeded];
    } completion:nil];
}

@end
