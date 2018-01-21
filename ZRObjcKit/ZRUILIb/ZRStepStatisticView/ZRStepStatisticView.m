//
//  ZRStepStatisticView.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/7/14.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "ZRStepStatisticView.h"

#define kGraphicViewTopMargin (136.0f - 45.0f)

#define kGraphicViewLeftMargin 25.0f

#define kGraphicViewBottomMargin 56.0f

#define kGraphicViewRightMargin 25.0f

//指示线宽度
#define kGraphicViewIndicatorLineWidth 0.5f

//当前点击业绩与顶部距离
#define kGraphicViewFocusLableTopOffset 75.0f

typedef CGFloat(^calculateMaxValueBlock)(NSArray *);

@interface ZRStepStatisticView ()

@property (nonatomic,strong) UIColor *startColor;

@property (nonatomic,strong) UIColor *endColor;

@property (nonatomic,strong) NSArray *data;

@property (nonatomic,strong) UILabel *lblTodaySteps;

@property (nonatomic,strong) UIButton *btnWeek;

@property (nonatomic,strong) UIButton *btnMonth;

@property (nonatomic,strong) UIView *selectIndicatorLine;

@property (nonatomic,strong) NSMutableArray *labelArray;

@property (nonatomic,strong) UILabel *lblCurrentSteps;

@property (nonatomic,strong) UIView *vStepsValueLine;

@property (nonatomic,copy) calculateMaxValueBlock calculateMaxValue;

@property (nonatomic,assign) CGFloat curPostionX;


/**
 业绩最小值，可能为负，最大为0
 */
@property (nonatomic,assign) CGFloat minDataValue;

@end

@implementation ZRStepStatisticView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialData];
        [self setupGesture];
        [self setupViews];
    }
    return self;
}


#pragma mark - property

- (calculateMaxValueBlock)calculateMaxValue{
    return  ^CGFloat(NSArray *numbers){
        CGFloat result = CGFLOAT_MIN;
        for (NSNumber *value in numbers) {
            if ([value floatValue] > result) {
                result = [value floatValue];
            }
        }
        return result;
    };
}

#pragma mark - UI

- (void)setupGesture{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGraphicView:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)setupViews{
    UIView *contentView = self;
    
    self.btnWeek = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = ZRStepStatisticTypeWeek;
        [btn setTitle:@"周" forState:UIControlStateNormal];
        [btn setTitleColor:RGBA(255, 255, 255, 0.6) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.selected = YES;
        [self addSubview:btn];
        btn;
    });
    [self.btnWeek mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self).offset(13);
        make.size.mas_equalTo(CGSizeMake(26, 30));
    }];
    
    self.btnMonth = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = ZRStepStatisticTypeMonth;
        [btn setTitle:@"月" forState:UIControlStateNormal];
        [btn setTitleColor:RGBA(255, 255, 255, 0.6) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn;
    });
    [self.btnMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self.btnWeek.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(26, 30));
    }];
    
    self.lblTodaySteps = ({
        UILabel *lbl = [UILabel new];
        lbl.textAlignment = NSTextAlignmentRight;
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont systemFontOfSize:14];
        [contentView addSubview:lbl];
        lbl;
    });
    [self.lblTodaySteps mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.btnWeek).offset(0);
        make.right.equalTo(contentView).offset(-16);
    }];
    
    self.selectIndicatorLine = ({
        UIView *v = [UIView new];
        v.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:v];
        v;
    });
    [self.selectIndicatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(26, 1.0f));
        make.top.equalTo(self.btnWeek.mas_bottom);
        make.centerX.equalTo(self.mas_left).offset(26);
    }];
    
    self.lblCurrentSteps = ({
        UILabel *lbl = [UILabel new];
        lbl.font = [UIFont systemFontOfSize:12];
        lbl.textColor = [UIColor whiteColor];
        [self addSubview:lbl];
        lbl;
    });
    [self.lblCurrentSteps mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(-100);
        make.top.equalTo(self).offset(-55);
    }];
    
    self.vStepsValueLine = ({
        UIView *v = [UIView new];
        v.backgroundColor = RGBA(255, 255, 255, 0.5);
        [self addSubview:v];
        v;
    });
    [self.lblCurrentSteps mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kGraphicViewIndicatorLineWidth);
        make.height.mas_equalTo(0.0f);
    }];
}


- (void)drawRect:(CGRect)rect{
    CGFloat height = rect.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //绘制图表渐变背景
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[2] = {0,1.0};
    CGFloat compoents[8]={
        90.0/255.0,
        107.0/255.0,
        238.0/255.0,
        1,
        70.0/255.0,
        178.0/255.0,
        254.0/255.0,
        1
    };
    
    CGGradientRef gradient= CGGradientCreateWithColorComponents(colorSpace, compoents, locations, 2);
    CGPoint startPoint = CGPointMake(0, rect.size.height);
    CGPoint endPoint = CGPointMake(rect.size.width, 0);
    CGContextDrawLinearGradient(context, gradient, startPoint,endPoint , kCGGradientDrawsAfterEndLocation);
    
    if (!_data || _data.count == 0) return;

    //绘制图表拆线
    [[UIColor whiteColor] setFill];
    [[UIColor whiteColor] setStroke];
    UIBezierPath *graphPath = [[UIBezierPath alloc] init];
    [graphPath moveToPoint:CGPointMake([self calculateXPosition:0], [self calCulateYPoint:[_data[0] floatValue]])];
    for (NSInteger i = 1; i < _data.count; i++) {
        CGPoint nextPoint = CGPointMake([self calculateXPosition:i], [self calCulateYPoint:[_data[i] floatValue]]);
        [graphPath addLineToPoint:nextPoint];
    }
    [graphPath stroke];
    CGContextSaveGState(context);
    
    //绘制拆线封闭路径，裁切区域
    UIBezierPath *clipPath = [graphPath copy];
    [clipPath addLineToPoint:CGPointMake([self calculateXPosition:(_data.count - 1)], height - kGraphicViewBottomMargin)];
    [clipPath addLineToPoint:CGPointMake([self calculateXPosition:0], height - kGraphicViewBottomMargin)];
    [clipPath closePath];
    [clipPath addClip];

    //裁切区域渐变
    CGFloat maxYPoint = [self calCulateYPoint:self.calculateMaxValue(_data)];
    startPoint = CGPointMake(kGraphicViewLeftMargin, maxYPoint);
    endPoint = CGPointMake(kGraphicViewLeftMargin, height - kGraphicViewBottomMargin);
    CGFloat compoents2[8]={
        78.0/255.0,
        194.0/255.0,
        247.0/255.0,
        1,
        78.0/255.0,
        194.0/255.0,
        247.0/255.0,
        0
    };
    CGGradientRef clipGradient= CGGradientCreateWithColorComponents(colorSpace, compoents2, locations, 2);
    CGContextDrawLinearGradient(context, clipGradient, startPoint,endPoint , kCGGradientDrawsAfterEndLocation);
    [graphPath stroke];
    CGContextRestoreGState(context);
    
    //绘制拆线上圆点
    //  [UIColorFromRGB(0x518CF5) setFill];
    //  [UIColorFromRGB(0x62CAFF) setStroke];
    CGFloat linePointSize = 5;
    for (NSInteger i = 0; i < _data.count; i++) {
        CGPoint pt = CGPointMake([self calculateXPosition:i], [self calCulateYPoint:[_data[i] floatValue]]);
        pt.x -= linePointSize / 2.0;
        pt.y -= linePointSize / 2.0;
        CGRect rect = CGRectMake(pt.x, pt.y, linePointSize, linePointSize);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:linePointSize / 2.0f];
        //  path.lineWidth = 4.0f;
        // [path stroke];
        [path fill];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.curPostionX > 0 && self.curPostionX < self.bounds.size.width) {
        CGFloat offset = 15;    //当前点击点与指示线垂直方向距离
        CGFloat height = self.bounds.size.height - kGraphicViewFocusLableTopOffset - kGraphicViewBottomMargin - offset;
        [UIView animateWithDuration:0.3 animations:^{
            self.lblCurrentSteps.center = CGPointMake(self.curPostionX, 75);
            self.vStepsValueLine.frame = CGRectMake(self.curPostionX, kGraphicViewFocusLableTopOffset + offset, kGraphicViewIndicatorLineWidth, height);
        }];
    }
}

#pragma mark - data

- (void)initialData{
    _startColor = UIColorFromRGB(0x5A6BEE);
    _endColor = UIColorFromRGB(0x46B2FE);
    _selectedPeriodType = ZRStepStatisticTypeWeek;
    _labelArray = [NSMutableArray new];
}

- (void)setWeekDataArray:(NSArray<NSDictionary *> *)weekDataArray{
    _weekDataArray = weekDataArray;
    self.vStepsValueLine.hidden = YES;
    self.lblCurrentSteps.hidden = YES;
    if (_weekDataArray && _weekDataArray.count > 0) {
        NSString *todayStep = (_weekDataArray.lastObject)[@"value"];
        self.lblTodaySteps.text = [NSString stringWithFormat:@"步数：%@", todayStep];
    } else {
        self.lblTodaySteps.text = @"";
    }
    [self loadGraphicData:_weekDataArray];
}

- (void)setMonthDataArray:(NSArray<NSDictionary *> *)monthDataArray{
    _monthDataArray = monthDataArray;
    self.vStepsValueLine.hidden = YES;
    self.lblCurrentSteps.hidden = YES;
    if (_monthDataArray && _monthDataArray.count > 0) {
        NSString *todayStep = (_monthDataArray.lastObject)[@"value"];
        self.lblTodaySteps.text = [NSString stringWithFormat:@"步数：%@", todayStep];
    } else {
        _lblTodaySteps.text = @"";
    }
    [self loadGraphicData:monthDataArray];
}

- (void)loadGraphicData:(NSArray *)dataArray{
    NSMutableArray *array = [NSMutableArray new];
    NSMutableArray *labelTextArray = [NSMutableArray new];
    
    /*
    CGFloat(^calculateMinValue)(NSArray<NSDictionary *> *values) = ^CGFloat(NSArray<NSDictionary*> *values){
        CGFloat result = CGFLOAT_MAX;
        for (NSDictionary *item in values) {
            CGFloat value = [item[@"value"] floatValue];
            if (value < result) {
                result = value;
            }
        }
        return result;
    };
    CGFloat minValue = calculateMinValue(dataArray);
     */
    
    //使用KVC集合运算符，计算最小值
    CGFloat minValue = [[dataArray valueForKeyPath:@"@min.value"] floatValue];
    //存储全局最小值，用于点击某一天时，计算初始值
    self.minDataValue = MIN(minValue, 0);
    
    for (NSDictionary *item in dataArray) {
        CGFloat value = [item[@"value"] floatValue];
        if (minValue < 0) {
            value += fabs(minValue);
        }
        [array addObject:@(value)];
        
        NSString *text = item[@"date"] ?: @"";
        [labelTextArray addObject:text ?: @""];
    }
    _data = array;
    [self.labelArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSUInteger i = 0; i < labelTextArray.count; i++) {
        UILabel *lbl;
        if (i < self.labelArray.count) {
            lbl = self.labelArray[i];
        } else {
            lbl = [UILabel new];
            lbl.font = [UIFont systemFontOfSize:10];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.textColor = RGBA(255, 255, 255, 0.6);
            [self.labelArray addObject:lbl];
        }
        lbl.tag = i + 1;
        lbl.text = @"";
        if (self.btnMonth.selected) {
            if (i == 0 || i % 6 == 0 || (i == labelTextArray.count - 1)) {
                lbl.text = labelTextArray[i];
            }
        } else {
            lbl.text = labelTextArray[i];
        }
        [self addSubview:lbl];
        CGFloat offset = [self calculateXPosition:i];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-10);
            make.centerX.equalTo(self.mas_left).offset(offset);
        }];
    }
    [self setNeedsDisplay];
}

- (CGFloat)calculateXPosition:(NSInteger)idx{
    CGFloat colomnWidth = (self.bounds.size.width - kGraphicViewLeftMargin - kGraphicViewRightMargin) / (_data.count - 1);
    return idx*colomnWidth + kGraphicViewLeftMargin;
}


- (CGFloat)calCulateYPoint:(CGFloat)value{
    CGFloat graphHeight = self.bounds.size.height - kGraphicViewTopMargin - kGraphicViewBottomMargin;
    CGFloat maxY = self.calculateMaxValue(_data);
    CGFloat y = value / maxY * graphHeight;
    return kGraphicViewTopMargin + graphHeight - y;
}

#pragma mark - aciton


- (void)onTapGraphicView:(UITapGestureRecognizer *)gesture{
    CGPoint location = [gesture locationInView:self];
    CGFloat colomnWidth = (self.bounds.size.width - kGraphicViewLeftMargin - kGraphicViewRightMargin) / (_data.count - 1);
    NSUInteger idx =  (location.x - kGraphicViewLeftMargin) / colomnWidth + 0.5;
    
    
    if (idx < _data.count) {
        self.vStepsValueLine.hidden = NO;
        self.lblCurrentSteps.hidden = NO;
        CGFloat xPosition = [self calculateXPosition:idx];
        CGFloat yPosition = [self calCulateYPoint:[_data[idx] floatValue]];
        
        //计算原始值显示
        CGFloat originalDataValue = [_data[idx] floatValue] + _minDataValue;
        NSString *value = [NSString stringWithFormat:@" %.f", originalDataValue];
        self.lblCurrentSteps.text = value;
        
        self.curPostionX = xPosition;
        [self.lblCurrentSteps mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_left).offset(xPosition);
            make.centerY.equalTo(self.mas_top).offset(yPosition);
        }];
        
        [self.vStepsValueLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.lblCurrentSteps).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(-kGraphicViewBottomMargin);
            make.width.mas_equalTo(kGraphicViewIndicatorLineWidth);
            make.height.mas_equalTo(0.0f);
        }];
    }
}

- (void)onButtonClick:(UIButton *)sender{
    if (sender.tag == ZRStepStatisticTypeWeek && !sender.selected) {//本周
        self.selectedPeriodType = sender.tag;
        self.vStepsValueLine.hidden = YES;
        self.lblCurrentSteps.hidden = YES;
        self.btnWeek.selected = YES;
        self.btnMonth.selected = NO;
        [self.selectIndicatorLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_left).offset(26);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self loadGraphicData:self.weekDataArray];
        }];
        if (_onStatisticTypeChangedHanlder) {
            _onStatisticTypeChangedHanlder(self, sender.tag);
        }
    } else if (sender.tag == ZRStepStatisticTypeMonth && !sender.selected){//本月
        self.selectedPeriodType = sender.tag;
        self.vStepsValueLine.hidden = YES;
        self.lblCurrentSteps.hidden = YES;
        self.btnWeek.selected = NO;
        self.btnMonth.selected = YES;
        [self.selectIndicatorLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_left).offset(52);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self loadGraphicData:self.monthDataArray];
        }];
        if (_onStatisticTypeChangedHanlder) {
            _onStatisticTypeChangedHanlder(self, sender.tag);
        }
    }
}

@end
