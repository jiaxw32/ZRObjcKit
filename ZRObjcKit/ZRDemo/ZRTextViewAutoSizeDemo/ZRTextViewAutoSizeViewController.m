//
//  ZRTextViewAutoSizeViewController.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/14.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "ZRTextViewAutoSizeViewController.h"

#define kZRTextViewMinHeight 48
#define kZRTextViewMaxHeight 160
#define kZRTextViewVerticalMargin 8

@interface ZRTextViewAutoSizeViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *textContentView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textContentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textContentViewBottomConstraint;

@end

@implementation ZRTextViewAutoSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textView.textContainerInset = UIEdgeInsetsMake(6, 0, 6, 0);
    self.textView.layoutManager.allowsNonContiguousLayout = NO;
//    self.textView.contentInset = UIEdgeInsetsMake(2, 0, 0, 0);
    self.textView.font = [UIFont systemFontOfSize:14];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    NSLog(@"top:%f,bottom:%f",self.textView.contentInset.top,self.textView.contentInset.bottom);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Keyboard Notification

- (void)keyBoardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    
    CGRect frame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = frame.size.height;
    
    NSTimeInterval time = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.textContentViewBottomConstraint.constant = -height;
    [UIView animateWithDuration:time animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyBoardWillHide:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval time = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.textContentViewBottomConstraint.constant = 0;
    [UIView animateWithDuration:time animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Action

- (IBAction)tapViewHandler:(UITapGestureRecognizer *)sender {
    [self.textView resignFirstResponder];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    //textView输入时，contentInset.top自动改变😖
    CGFloat height = textView.contentSize.height + 6 * 2;
    if (height <= kZRTextViewMinHeight) {
        self.textContentViewHeightConstraint.constant = kZRTextViewMinHeight + kZRTextViewVerticalMargin * 2;
    } else if (height > kZRTextViewMaxHeight){
        self.textContentViewHeightConstraint.constant = kZRTextViewMaxHeight + kZRTextViewVerticalMargin * 2;
    } else {
        self.textContentViewHeightConstraint.constant = height + kZRTextViewVerticalMargin * 2;
    }
    [UIView animateWithDuration:0.3f animations:^{
        [self.textContentView.superview layoutIfNeeded];
    } completion:^(BOOL finished){
        NSLog(@"top:%f,bottom:%f",self.textView.contentInset.top,self.textView.contentInset.bottom);
    }];
}


@end
