//
//  ZRPickerView.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2016/10/27.
//  Copyright © 2016年 jiaxw. All rights reserved.
//

#import "ZRPickerView.h"

@interface ZRPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

/**
 标题
 */
@property (nonatomic,strong)UILabel *lblTitle;


/**
 取消按钮
 */
@property (nonatomic,strong)UIButton *btnCancel;


/**
 确认按钮
 */
@property (nonatomic,strong)UIButton *btnOK;

@property (nonatomic,strong)UIPickerView *pickerView;


/**
 分隔线
 */
@property (nonatomic,strong)UIView *splitLine;

@end

@implementation ZRPickerView

- (instancetype)init{
    if (self = [super init]) {
        [self initialData];
        [self setupViews];
        [self bindData];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //隐藏pickerview分隔线
    if (self.pickerView && self.pickerView.subviews.count > 2) {
        [[self.pickerView.subviews objectAtIndex:1] setHidden:YES];
        [[self.pickerView.subviews objectAtIndex:2] setHidden:YES];
    }
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"pickerViewTitle"];
    [self removeObserver:self forKeyPath:@"numberOfComponents"];
    [self removeObserver:self forKeyPath:@"levelOneDataSource"];
    [self removeObserver:self forKeyPath:@"levelTwoDataSource"];
}

- (void)initialData{
    self.pickerViewTitle = @"请选择";
    self.firstComponentSelectRow = 0;
    self.secondComponentSelectRow = 0;
    self.numberOfComponents = 1;
    self.pickerViewHeight = 215;
}

- (void)setPickerViewTitle:(NSString *)pickerViewTitle{
    _pickerViewTitle = pickerViewTitle;
    self.lblTitle.text = _pickerViewTitle;
}

- (void)bindData{
    [self addObserver:self forKeyPath:@"pickerViewTitle" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"numberOfComponents" options:NSKeyValueObservingOptionNew context:nil];
    
    [self addObserver:self forKeyPath:@"levelOneDataSource" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"levelTwoDataSource" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setupViews{
    self.type = MMPopupTypeSheet;
    UIView *superView = self;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.backgroundColor = [UIColor whiteColor];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(screenWidth);
        make.height.mas_equalTo(_pickerViewHeight);
    }];
    
    
    UIView *titleContentView = ({
        UIView *v = [UIView new];
        [superView addSubview:v];
        v;
    });
    [titleContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(superView);
        make.height.mas_equalTo(52);
    }];
    
    //取消
    self.btnCancel = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [titleContentView addSubview:btn];
        btn;
    });
    [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(titleContentView);
        make.width.mas_equalTo(16*2 + 35);
    }];
    [self.btnCancel addTarget:self action:@selector(onButtonCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //确定
    self.btnOK = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [titleContentView addSubview:btn];
        btn;
    });
    [self.btnOK mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(titleContentView);
        make.width.mas_equalTo(16*2 + 35);
    }];
    
    [self.btnOK addTarget:self action:@selector(onButtonOKClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //标题
    self.lblTitle = ({
        UILabel *lbl = [UILabel new];
        lbl.text = self.pickerViewTitle;
        lbl.font = [UIFont systemFontOfSize:17];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = [UIColor blackColor];
        [titleContentView addSubview:lbl];
        lbl;
    });
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_btnCancel.mas_right);
        make.right.equalTo(_btnOK.mas_left);
        make.centerY.equalTo(titleContentView.mas_centerY);
    }];
    
    self.splitLine = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        view;
    });
    [superView addSubview:self.splitLine];
    [self.splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superView);
        make.top.equalTo(titleContentView.mas_bottom);
        make.height.mas_equalTo(1.0);
    }];
    
    
    self.pickerView = ({
        UIPickerView *pickerView = [UIPickerView new];
        pickerView.backgroundColor = [UIColor whiteColor];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        [superView addSubview:pickerView];
        pickerView;
    });
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(superView);
        make.top.equalTo(self.splitLine.mas_bottom);
    }];
}

#pragma mark - UIPickerViewDelegate 

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.numberOfComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return _levelOneDataSource.count;
    } else  if(component == 1){
        if (_firstComponentSelectRow < _levelTwoDataSource.count) {
            NSArray *array = _levelTwoDataSource[_firstComponentSelectRow];
            if (array && [array isKindOfClass:[NSArray class]]) {
                return array.count;
            }
        }
    };
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        _firstComponentSelectRow = row;
        if (_numberOfComponents > 1) {
            [pickerView reloadComponent:1];
            if (_secondComponentSelectRow >= [pickerView numberOfRowsInComponent:1]) {
                _secondComponentSelectRow = 0;
                [pickerView selectRow:0 inComponent:1 animated:YES];
            } else {
                [pickerView selectRow:_secondComponentSelectRow inComponent:1 animated:YES];
            }
        }
    } else if (component == 1){
        _secondComponentSelectRow = row;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return screenWidth / _numberOfComponents;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *lable = (UILabel *)view;
    if (!lable) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        lable = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, screenWidth, 40))];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = @"";
        lable.font = [UIFont fontWithName:@"Heiti SC" size:16];
    }
    if (component == 0) {
        lable.text = self.levelOneDataSource[row];
    } else if (component == 1){
        NSArray *array = _levelTwoDataSource[_firstComponentSelectRow];
        if (array && [array isKindOfClass:[NSArray class]]) {
            lable.text = array[row];
        }
    }
    return lable;
}

- (void)onButtonOKClick:(UIButton *)sender{
     if (_okClickBlock) {
        _okClickBlock(self,_firstComponentSelectRow,_secondComponentSelectRow);
    }
    [self hide];
}

- (void)onButtonCancelClicked:(UIButton *)sender{
    [self hide];
}

- (void)show{
    for (NSInteger i = 0;self.pickerView && i < self.pickerView.numberOfComponents;i++) {
        switch (i) {
            case 0:
                _firstComponentSelectRow = (_firstComponentSelectRow >= 0 && _firstComponentSelectRow < [self.pickerView numberOfRowsInComponent:0]) ? _firstComponentSelectRow : 0;
                [self.pickerView selectRow:_firstComponentSelectRow inComponent:i animated:NO];
                break;
            case 1:
                _secondComponentSelectRow = (_secondComponentSelectRow >= 0 && _secondComponentSelectRow <  [self.pickerView numberOfRowsInComponent:1]) ? _secondComponentSelectRow : 0;
                [self.pickerView selectRow:_secondComponentSelectRow inComponent:i animated:NO];
                break;
            default:
                [self.pickerView selectRow:0 inComponent:i animated:NO];
                break;
        }
    }
    [super show];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"pickerViewTitle"]) {
        self.lblTitle.text = change[NSKeyValueChangeNewKey];
    } else if ([keyPath isEqualToString:@"numberOfComponents"] || [keyPath isEqualToString:@"levelOneDataSource"] || [keyPath isEqualToString:@"levelTwoDataSource"]){
        [self.pickerView reloadAllComponents];
    }
}

@end
