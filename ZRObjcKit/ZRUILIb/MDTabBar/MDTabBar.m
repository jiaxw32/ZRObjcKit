// The MIT License (MIT)
//
// Copyright (c) 2015 FPT Software
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MDTabBar.h"

#import <uiKit/UISegmentedControl.h>
#import <Foundation/Foundation.h>

#pragma mark - MDTabBar

@interface MDTabBar ()

- (void)updateSelectedIndex:(NSInteger)selectedIndex;

@end

#pragma mark - MDSegmentedControl

@interface MDSegmentedControl : UISegmentedControl

@property(nonatomic) CGFloat horizontalPadding;
@property(nonatomic) UIColor *rippleColor;
@property(nonatomic) UIColor *indicatorColor;
@property(nonatomic) NSMutableArray<UIView *> *tabs;
- (CGRect)getSelectedSegmentFrame;
- (void)setTextFont:(UIFont *)textFont withColor:(UIColor *)textColor;
@property (nonatomic,assign) CGFloat indicatorWidth;
@property (nonatomic,assign) CGFloat indicatorHeight;
@property (nonatomic, assign) CGFloat tabbarRealHeight;

@end

@implementation MDSegmentedControl {
  UIView *indicatorView;
  UIView *beingTouchedView;
  UIFont *font;
  MDTabBar *tabBar;
}

- (instancetype)initWithTabBar:(MDTabBar *)bar {
  if (self = [super init]) {
      _tabs = [NSMutableArray array];
      _tabbarRealHeight = bar.tabbarHeight;
      _indicatorHeight = 2;
    indicatorView = [[UIView alloc]
        initWithFrame:CGRectMake(0, _tabbarRealHeight - kMDIndicatorHeight, 0,
                                 kMDIndicatorHeight)];
    indicatorView.tag = NSIntegerMax;
    [self addSubview:indicatorView];
//    UIView *seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, _tabbarRealHeight-1, RSScreenWidth, 1)];
//    seperatorLine.backgroundColor = ZR_SeparatorColor;
//    [self addSubview:seperatorLine];
    [self addTarget:self
                  action:@selector(selectionChanged:)
        forControlEvents:UIControlEventValueChanged];
    tabBar = bar;
      
  }

  return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
  [super willMoveToSuperview:newSuperview];
  [newSuperview addObserver:self forKeyPath:@"frame" options:0 context:nil];
}

- (void)removeFromSuperview {
  [self.superview removeObserver:self forKeyPath:@"frame"];
  [super removeFromSuperview];
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
  [super setSelectedSegmentIndex:selectedSegmentIndex];
  [self moveIndicatorToSelectedIndexWithAnimated:YES];
}

- (void)selectionChanged:(id)sender {
  [self moveIndicatorToSelectedIndexWithAnimated:YES];
  [tabBar updateSelectedIndex:self.selectedSegmentIndex];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if (object == self.superview && [keyPath isEqualToString:@"frame"]) {
    [self resizeItems];
    [self moveIndicatorToSelectedIndexWithAnimated:NO];
  }
}

#pragma mark Override Methods

- (void)insertSegmentWithImage:(UIImage *)image
                       atIndex:(NSUInteger)segment
                      animated:(BOOL)animated {
  [super insertSegmentWithImage:image atIndex:segment animated:animated];
  [self resizeItems];
  [self updateSegmentsList];
//  [self addRippleLayers];
  [self performSelector:@selector(moveIndicatorToSelectedIndexWithAnimated:)
             withObject:[NSNumber numberWithBool:animated]
             afterDelay:.001f];
}

- (void)insertSegmentWithTitle:(NSString *)title
                       atIndex:(NSUInteger)segment
                      animated:(BOOL)animated {
  [super insertSegmentWithTitle:title atIndex:segment animated:animated];
  [self resizeItems];
  [self updateSegmentsList];
//  [self addRippleLayers];
  [self performSelector:@selector(moveIndicatorToSelectedIndexWithAnimated:)
             withObject:[NSNumber numberWithBool:animated]
             afterDelay:.001f];
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment {
  [super setTitle:title forSegmentAtIndex:segment];
  [self resizeItems];
  [self performSelector:@selector(moveIndicatorToSelectedIndexWithAnimated:)
             withObject:[NSNumber numberWithBool:YES]
             afterDelay:.001f];
}

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment {
  [super setImage:image forSegmentAtIndex:segment];
  [self resizeItems];
  [self performSelector:@selector(moveIndicatorToSelectedIndexWithAnimated:)
             withObject:[NSNumber numberWithBool:YES]
             afterDelay:.001f];
}

- (void)removeSegmentAtIndex:(NSUInteger)segment animated:(BOOL)animated {
  [super removeSegmentAtIndex:segment animated:animated];
  [self updateSegmentsList];
  [self resizeItems];
  [self performSelector:@selector(moveIndicatorToSelectedIndexWithAnimated:)
             withObject:[NSNumber numberWithBool:animated]
             afterDelay:.001f];
}

#pragma mark Setter
- (void)setIndicatorColor:(UIColor *)color {
  _indicatorColor = color;
  indicatorView.backgroundColor = color;
}

//- (void)setRippleColor:(UIColor *)rippleColor {
//  _rippleColor = rippleColor;
//  for (UIView *view in self.subviews) {
//    for (CALayer *layer in view.layer.sublayers) {
//      if ([layer isKindOfClass:[MDRippleLayer class]]) {
//        [((MDRippleLayer *)layer)setEffectColor:_rippleColor
//                                withRippleAlpha:.1f
//                                backgroundAlpha:.1f];
//        return;
//      }
//    }
//  }
//}

#pragma mark Public Methods

- (CGRect)getSelectedSegmentFrame {
  if (self.selectedSegmentIndex >= 0) {
    return ((UIView *)_tabs[self.selectedSegmentIndex]).frame;
  }
  return CGRectZero;
}

- (void)setTextFont:(UIFont *)textFont withColor:(UIColor *)textColor {
  font = textFont;
  CGFloat disabledTextAlpha = 0.6;
  UIColor *normalTextColor = tabBar.normalTextColor;
  if (normalTextColor == nil) {
    normalTextColor = [textColor colorWithAlphaComponent:disabledTextAlpha];
  }

  UIFont *normalTextFont = tabBar.normalTextFont;
  if (normalTextFont == nil) {
    normalTextFont = textFont;
  }
  NSDictionary *attributes = @{
    NSForegroundColorAttributeName : normalTextColor,
    NSFontAttributeName : normalTextFont
  };
  [self setTitleTextAttributes:attributes forState:UIControlStateNormal];
  NSDictionary *selectedAttributes = @{
    NSForegroundColorAttributeName : textColor,
    NSFontAttributeName : textFont
  };
  [self setTitleTextAttributes:selectedAttributes
                      forState:UIControlStateSelected];
}

- (void)moveIndicatorToFrame:(CGRect)frame withAnimated:(BOOL)animated {
  if (animated) {
    [UIView animateWithDuration:.2f
                     animations:^{
                         if (_indicatorWidth > 0) {
                             CGRect tempFrame = indicatorView.frame;
                             tempFrame.size = CGSizeMake(_indicatorWidth, kMDIndicatorHeight);
                             indicatorView.frame = tempFrame;
                             indicatorView.center = CGPointMake(frame.origin.x + frame.size.width/2, self.bounds.size.height - kMDIndicatorHeight/2);
                         } else {
                             indicatorView.frame =
                             CGRectMake(frame.origin.x, self.bounds.size.height -
                                        kMDIndicatorHeight,
                                        frame.size.width, kMDIndicatorHeight);
                         }
                     }];
  } else {
      if (_indicatorWidth > 0) {
          CGRect tempFrame = indicatorView.frame;
          tempFrame.size = CGSizeMake(_indicatorWidth, kMDIndicatorHeight);
          indicatorView.frame = tempFrame;
          indicatorView.center = CGPointMake(frame.origin.x + frame.size.width/2, self.bounds.size.height - kMDIndicatorHeight/2);
      } else {
          indicatorView.frame =
          CGRectMake(frame.origin.x, self.bounds.size.height -
                     kMDIndicatorHeight,
                     frame.size.width, kMDIndicatorHeight);
      }
  }
}

#pragma mark Private Methods
- (void)resizeItems {
  if (self.numberOfSegments <= 0)
    return;
  CGFloat maxItemSize = 0;
  CGFloat segmentedControlWidth = 0;

  NSDictionary *attributes = @{NSFontAttributeName : font};
  for (int i = 0; i < self.numberOfSegments; i++) {
    NSString *title = [self titleForSegmentAtIndex:i];
    CGSize itemSize = CGSizeZero;
    if (title) {
      itemSize = [title sizeWithAttributes:attributes];
    } else {
      UIImage *image = [self imageForSegmentAtIndex:i];
      CGFloat height = self.bounds.size.height;
      CGFloat width = height / image.size.height * image.size.width;
      itemSize = CGSizeMake(width, height);
    }

    itemSize.width += self.horizontalPadding * 2;
      
    [self setWidth:itemSize.width forSegmentAtIndex:i];

    segmentedControlWidth += (itemSize.width);

    maxItemSize = MAX(maxItemSize, itemSize.width);
  }

  CGFloat holderWidth =
      self.superview.bounds.size.width - tabBar.horizontalInset * 2;
  if (segmentedControlWidth < holderWidth) {
    if (self.numberOfSegments * maxItemSize < holderWidth) {
      maxItemSize = holderWidth / self.numberOfSegments;
    }

    segmentedControlWidth = 0;
    for (int i = 0; i < self.numberOfSegments; i++) {
      [self setWidth:maxItemSize forSegmentAtIndex:i];
      segmentedControlWidth += (maxItemSize);
    }
  }

  self.frame = CGRectMake(0, 0, segmentedControlWidth, _tabbarRealHeight);
}

- (NSArray *)getSegmentList {
  // WARNING: This function gets frame from UISegment objects, undocumented
  // subviews of UISegmentedControl.
  // May break in iOS updates.

  NSMutableArray *segments =
      [NSMutableArray arrayWithCapacity:self.numberOfSegments];
  for (UIView *view in self.subviews) {
    if ([NSStringFromClass([view class]) isEqualToString:@"UISegment"]) {
      [segments addObject:view];
    }
  }

  NSArray *sortedSegments = [segments
      sortedArrayUsingComparator:^NSComparisonResult(UIView *a, UIView *b) {
        if (a.frame.origin.x < b.frame.origin.x) {
          return NSOrderedAscending;
        } else if (a.frame.origin.x > b.frame.origin.x) {
          return NSOrderedDescending;
        }
        return NSOrderedSame;
      }];

  return sortedSegments;
}

- (void)moveIndicatorToSelectedIndexWithAnimated:(BOOL)animated {
  if (self.selectedSegmentIndex < 0 && self.numberOfSegments > 0) {
    self.selectedSegmentIndex = 0;
  }
  NSInteger index = self.selectedSegmentIndex;

  CGRect frame = CGRectZero;

  if (index >= 0) {
    if ((index >= self.numberOfSegments) || (index >= _tabs.count)) {
      return;
    }
    frame = ((UIView *)_tabs[index]).frame;
  }

  [self moveIndicatorToFrame:frame withAnimated:animated];
}



- (void)updateSegmentsList {
  _tabs = [self getSegmentList].mutableCopy;
}

#pragma mark Touch event


- (void)dealloc {
  [self removeObserver:self forKeyPath:@"bounds"];
}

@end

#pragma mark - MDTabBar

@implementation MDTabBar {
  MDSegmentedControl *segmentedControl;
  UIScrollView *scrollView;
    UIView *seperatorLine;
}

- (instancetype)init {
  if (self = [super init]) {
    //    [self initContent];
  }
  return self;
}

- (instancetype)initWithTabbarHeight:(CGFloat)tabbarHeight {
    if (self = [super init]) {
        self.tabbarHeight = tabbarHeight;
        [self initContent];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    [self initContent];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
      
  }
  return self;
}

- (instancetype)initWithItems:(NSArray *)items delegate:(id)delegate {
  if (self = [super init]) {
    [self initContent];
    _delegate = delegate;
    [self setItems:items];
  }

  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
    scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, _tabbarHeight);
  [scrollView setContentInset:UIEdgeInsetsMake(0, self.horizontalInset, 0,
                                               self.horizontalInset)];
  [scrollView setContentSize:segmentedControl.bounds.size];
    seperatorLine.frame = CGRectMake(0, _tabbarHeight - 1, self.frame.size.width, 1);
}

#pragma mark Private methods
- (void)initContent {
  self.horizontalInset = 0;

  segmentedControl = [[MDSegmentedControl alloc] initWithTabBar:self];
  [segmentedControl setTintColor:[UIColor clearColor]];

  scrollView = [[UIScrollView alloc] init];
  [scrollView setShowsHorizontalScrollIndicator:NO];
  [scrollView setShowsVerticalScrollIndicator:NO];
  scrollView.bounces = NO;

  [scrollView addSubview:segmentedControl];

  [self addSubview:scrollView];
    
  
  self.horizontalPaddingPerItem = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 24 : 12;
  segmentedControl.horizontalPadding = self.horizontalPaddingPerItem;

  [self setBackgroundColor:[UIColor whiteColor]];
//  self.layer.shadowColor = [UIColor blackColor].CGColor;
//  self.layer.shadowRadius = 1;
//  self.layer.shadowOpacity = .5;
//  self.layer.shadowOffset = CGSizeMake(0, .5);

  [self setTextColor:[UIColor blackColor]];
  [self setTextFont:[UIFont systemFontOfSize:14]];
  [self setIndicatorColor:[UIColor whiteColor]];
//  [self setRippleColor:[UIColor whiteColor]];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, screenWidth, 1)];
    seperatorLine.backgroundColor = [UIColor colorWithRed:229 / 255.0 green:229 / 255.0 blue:229 / 255.0 alpha:1];
    [self addSubview:seperatorLine];
    [self bringSubviewToFront:seperatorLine];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
  [super willMoveToSuperview:newSuperview];
  if (newSuperview) {
    [segmentedControl addObserver:self
                       forKeyPath:@"frame"
                          options:0
                          context:nil];
  }
}

- (void)removeFromSuperview {
  [segmentedControl removeObserver:self forKeyPath:@"frame"];
  [super removeFromSuperview];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if (object == segmentedControl && [keyPath isEqualToString:@"frame"]) {
    [scrollView setContentSize:segmentedControl.bounds.size];
  }
}

- (void)updateItemAppearance {
  if (_textColor && _textFont) {
    [segmentedControl setTextFont:_textFont withColor:_textColor];
  }
}

- (void)scrollToSelectedIndex {
  CGRect frame = [segmentedControl getSelectedSegmentFrame];
  CGFloat horizontalInset = self.horizontalInset;
  CGFloat contentOffset = frame.origin.x + horizontalInset -
                          (self.frame.size.width - frame.size.width) / 2;
  if (contentOffset >
      scrollView.contentSize.width + horizontalInset - self.frame.size.width) {
    contentOffset =
        scrollView.contentSize.width + horizontalInset - self.frame.size.width;
  } else if (contentOffset < -horizontalInset) {
    contentOffset = -horizontalInset;
  }

  [scrollView setContentOffset:CGPointMake(contentOffset, 0) animated:YES];
}

#pragma mark Public methods

- (void)updateSelectedIndex:(NSInteger)selectedIndex {
  _selectedIndex = selectedIndex;
  [self scrollToSelectedIndex];
  if (_delegate) {
    [_delegate tabBar:self didChangeSelectedIndex:_selectedIndex];
  }
}

- (void)setIndicatorWidth:(CGFloat)indicatorWidth{
    _indicatorWidth = indicatorWidth;
    if (segmentedControl) {
        segmentedControl.indicatorWidth = self.indicatorWidth;
    }
}

- (void)setItems:(NSArray *)items {
  [segmentedControl removeAllSegments];
  NSUInteger index = 0;
  for (id item in items) {
    [self insertItem:item atIndex:index animated:NO];
    index++;
  }

  self.selectedIndex = 0;
}

- (void)insertItem:(id)item atIndex:(NSUInteger)index animated:(BOOL)animated {
  if ([item isKindOfClass:[NSString class]]) {
    [segmentedControl insertSegmentWithTitle:item
                                     atIndex:index
                                    animated:animated];
  } else if ([item isKindOfClass:[UIImage class]]) {
    [segmentedControl insertSegmentWithImage:item
                                     atIndex:index
                                    animated:animated];
  }
}

- (void)removeItemAtIndex:(NSUInteger)index animated:(BOOL)animated {
  [segmentedControl removeSegmentAtIndex:index animated:animated];
}

- (void)replaceItem:(id)item atIndex:(NSUInteger)index {
  if ([item isKindOfClass:[NSString class]]) {
    [segmentedControl setTitle:item forSegmentAtIndex:index];

  } else if ([item isKindOfClass:[UIImage class]]) {
    [segmentedControl setImage:item forSegmentAtIndex:index];
  }
}

- (void)moveIndicatorToFrame:(CGRect)frame withAnimated:(BOOL)animated {
  [segmentedControl moveIndicatorToFrame:frame withAnimated:animated];
}

- (void) setHorizontalPaddingPerItem:(CGFloat)padding;
{
  _horizontalPaddingPerItem = padding;
  segmentedControl.horizontalPadding = padding;
}

#pragma mark Setters

- (void)setBackgroundColor:(UIColor *)backgroundColor {
  _backgroundColor = backgroundColor;
  [scrollView setBackgroundColor:backgroundColor];
}

- (void)setTextColor:(UIColor *)textColor {
  _textColor = textColor;
  [self updateItemAppearance];
}

- (void)setNormalTextColor:(UIColor *)normalTextColor;
{
  _normalTextColor = normalTextColor;
  [self updateItemAppearance];
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
  _indicatorColor = indicatorColor;
  [segmentedControl setIndicatorColor:_indicatorColor];
}

//- (void)setRippleColor:(UIColor *)rippleColor {
//  _rippleColor = rippleColor;
//  [segmentedControl setRippleColor:_rippleColor];
//}

- (void)setTextFont:(UIFont *)textFont {
  _textFont = textFont;
  [self updateItemAppearance];
}

- (void)setNormalTextFont:(UIFont *)normalTextFont {
  _normalTextFont = normalTextFont;
  [self updateItemAppearance];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
  if (selectedIndex < segmentedControl.numberOfSegments) {
    _selectedIndex = selectedIndex;
    if (segmentedControl.selectedSegmentIndex != _selectedIndex) {
      [segmentedControl setSelectedSegmentIndex:_selectedIndex];
      [self scrollToSelectedIndex];
    }
  }
}

- (void)setHorizontalInset:(CGFloat)horizontalInset;
{
  _horizontalInset = horizontalInset;
  [self setNeedsLayout];
}

- (NSInteger)numberOfItems {
  return segmentedControl.numberOfSegments;
}

- (NSArray<UIView *> *)tabs {
  return [segmentedControl.tabs copy];
}

@end
