//
//  ViewController.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/10.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "MainViewController.h"
#import "ZRFileHelper.h"
#import "ZRFileListViewController.h"
#import "ZRTextViewAutoSizeViewController.h"
#import "ZRTextViewAutoSizeExViewController.h"
#import "ZRGridViewController.h"
#import "ZRPickerView.h"
#import "ZRTabBarViewController.h"
#import "NSObject+ZRDebug.h"
#import "ZRPerson.h"
#import "NSObject+ZRDeallocObserve.h"
#import <objc/runtime.h>
#import "ZRWorker.h"
#import "ZRStepStatisticViewController.h"
#import "ZRCustomCalendarViewController.h"
#import "ZRImageRoundCornerViewController.h"
#import "ZRRoundImageViewCornerViewController.h"
#import "ZRWebViewContentHeightCalculateController.h"
#import "YXSuspendTabViewController.h"
#import "ZRWKWebViewContentHeightCalculateController.h"
#import "ZRSort.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACReturnSignal.h>
#import "ZRSingleton.h"

typedef NS_ENUM(NSUInteger, ZRFunctionType) {
    ZRFunctionTypeUnknown = 0,
    ZRFunctionTypeMessageForward,       //消息转发
    ZRFunctionTypeClassConstruction,    //类的构造
    ZRFunctionTypeKVOExplore,           //KVO原理
    ZRFunctionTypeSandboxBrowser,       //沙盒文件浏览
    ZRFunctionTypeMainBundleBrowser,    //Bundle文件浏览
    ZRFunctionTypeTextViewAutoSize,     //TextView高度自适应
    ZRFunctionTypeGridViewDemo,         //GridView
    ZRFunctionTypeCopyWeChatStepStatisticDemo, //仿微信运动步数统计图
    ZRFunctionTypeCustomCalendar,       //自定义日历组件
    ZRFunctionTypeOneDimensionPickerView,   //一维PickerView
    ZRFunctionTypeTwoDimensionPickerView,   //二维PikcerView
    ZRFunctionTypeObjectDealloc,    //对象销毁
    ZRFunctionTypeStringDealloc,    //字符串销毁
    ZRFunctionTypeRoundImage, //图像圆角
    ZRFunctionTypeRoundImageViewAspectFit,
    ZRFunctionTypeWebViewContentHeightCalculate, //WebView内容高度计算
    ZRFunctionTypeTest
};

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableivew;

@property (nonatomic,copy) NSArray *functionList;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadData];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DATA

- (void)loadData{
    self.functionList = @[
                          @{
                              @"header" : @"Reserved Test Demo",
                              @"functionItems" : @[
                                      @{
                                          @"title" : @"test",
                                          @"showIndicator" : @(YES),
                                          @"funtionType" : @(ZRFunctionTypeTest)
                                          },
                                      ],
                              },
                          @{
                              @"header" : @"File Manager",
                              @"functionItems" : @[
                                      @{
                                          @"title" : @"sandbox file browser",
                                          @"showIndicator" : @(YES),
                                          @"funtionType" : @(ZRFunctionTypeSandboxBrowser)
                                          },
                                      @{
                                          @"title" : @"main bundle file browser",
                                          @"showIndicator" : @(YES),
                                          @"funtionType" : @(ZRFunctionTypeMainBundleBrowser)
                                          },
                                      ],
                              },
                          @{
                              @"header" : @"UI components",
                              @"functionItems" : @[
                                      @{
                                          @"title" : @"copy WeChat step statistic graphic",
                                          @"showIndicator" : @(YES),
                                          @"funtionType" : @(ZRFunctionTypeCopyWeChatStepStatisticDemo)
                                          },
                                      @{
                                          @"title" : @"custom calendar demo",
                                          @"showIndicator" : @(YES),
                                          @"funtionType" : @(ZRFunctionTypeCustomCalendar)
                                          },
                                      @{
                                          @"title" : @"custom gridview demo",
                                          @"showIndicator" : @(YES),
                                          @"funtionType" : @(ZRFunctionTypeGridViewDemo)
                                          },
                                      @{
                                          @"title" : @"textview autosize demo",
                                          @"showIndicator" : @(YES),
                                          @"funtionType" : @(ZRFunctionTypeTextViewAutoSize)
                                          },
                                      @{
                                          @"title" : @"one dimension pickerview",
                                          @"showIndicator" : @(YES),
                                          @"funtionType" : @(ZRFunctionTypeOneDimensionPickerView)
                                          },
                                      @{
                                          @"title" : @"two dimension pickerview",
                                          @"showIndicator" : @(YES),
                                          @"funtionType" : @(ZRFunctionTypeTwoDimensionPickerView)
                                          },
                                      @{
                                          @"title" : @"round imageview for aspect fit",
                                          @"showIndicator" : @(YES),
                                          @"funtionType" : @(ZRFunctionTypeRoundImageViewAspectFit)
                                          },
                                      @{
                                          @"title" : @"webview content height calculate",
                                          @"showIndicator" : @(YES),
                                          @"funtionType" : @(ZRFunctionTypeWebViewContentHeightCalculate)
                                          },

                                      ],
                              },
                          @{
                              @"header" : @"Runtime",
                              @"functionItems" : @[
                                      @{
                                          @"title" : @"message forward (be careful crash 😂)",
                                          @"showIndicator" : @(NO),
                                          @"funtionType" : @(ZRFunctionTypeMessageForward)
                                          },
                                      @{
                                          @"title" : @"construction of class",
                                          @"showIndicator" : @(NO),
                                          @"funtionType" : @(ZRFunctionTypeClassConstruction)
                                          },
                                      @{
                                          @"title" : @"KVO principle explore",
                                          @"showIndicator" : @(NO),
                                          @"funtionType" : @(ZRFunctionTypeKVOExplore)
                                          },
                                      ],
                              },
                          @{
                              @"header" : @"Memory Manage",
                              @"functionItems" : @[
                                      @{
                                          @"title" : @"object dealloc",
                                          @"showIndicator" : @(NO),
                                          @"funtionType" : @(ZRFunctionTypeObjectDealloc)
                                          },
                                      @{
                                          @"title" : @"string dealloc",
                                          @"showIndicator" : @(NO),
                                          @"funtionType" : @(ZRFunctionTypeStringDealloc)
                                          },
                                      ],
                              },
                          @{
                              @"header" : @"Performance Analyze",
                              @"functionItems" : @[
                                      @{
                                          @"title" : @"FPS: round image demo",
                                          @"showIndicator" : @(YES),
                                          @"funtionType" : @(ZRFunctionTypeRoundImage)
                                          },
                                      ],
                              },
                          ];
}


#pragma mark - UITableViewDelgate and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.functionList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *function = _functionList[section];
    NSArray *functionItems = function[@"functionItems"];
    return functionItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 48.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *function = _functionList[indexPath.section];
    NSArray *functionItems = function[@"functionItems"];
    NSDictionary *functionItem = functionItems[indexPath.row];
    cell.textLabel.text = functionItem[@"title"];
    if ([functionItem[@"showIndicator"] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary *function = _functionList[section];
    NSString *header = function[@"header"];
    
    UIView *headerView = [[UIView alloc] init];
    UILabel *lblTitle = ({
        UILabel *lbl = [UILabel new];
        lbl.text = header;
        lbl.font = [UIFont systemFontOfSize:16];
        lbl.textColor = UIColorFromRGB(0x444444);
        [headerView addSubview:lbl];
        lbl;
    });
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.left.equalTo(headerView).offset(16);
    }];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *function = _functionList[indexPath.section];
    NSArray *functionItems = function[@"functionItems"];
    NSDictionary *functionItem = functionItems[indexPath.row];
    ZRFunctionType functionType = [functionItem[@"funtionType"] integerValue];
    switch (functionType) {
        case ZRFunctionTypeMessageForward:
            [self messageForwardTest];
            break;
        case ZRFunctionTypeClassConstruction:
            [self clsConstructionExplore];
            break;
        case ZRFunctionTypeKVOExplore:
            [self kvoExploreDemo];
            break;
        case ZRFunctionTypeGridViewDemo:
            [self customGridViewDemo];
            break;
        case ZRFunctionTypeCustomCalendar:
            [self customCalendarViewDemo];
            break;
        case ZRFunctionTypeSandboxBrowser:
            [self sandboxDirectoryBrowser];
            break;
        case ZRFunctionTypeTextViewAutoSize:
            [self textViewAutoSizeDemo];
            break;
        case ZRFunctionTypeMainBundleBrowser:
            [self mainBundleBrowser];
            break;
        case ZRFunctionTypeCopyWeChatStepStatisticDemo:
            [self copyWeiChatStepStatisticDemo];
            break;
        case ZRFunctionTypeOneDimensionPickerView:
            [self pickerViewDemoWithOneDimension];
            break;
        case ZRFunctionTypeTwoDimensionPickerView:
            [self pikerViewDemoWithTwoDimension];
            break;
        case ZRFunctionTypeObjectDealloc:
            [self objectDeallocTest];
            break;
        case ZRFunctionTypeStringDealloc:
            [self stringDeallocTest];
            break;
        case ZRFunctionTypeRoundImage:
            [self gotoImageRoundCornerDemo];
            break;
        case ZRFunctionTypeRoundImageViewAspectFit:
            [self gotoRoundImageViewAspectFitDemo];
            break;
        case ZRFunctionTypeWebViewContentHeightCalculate:
            [self gotoWebviewContentHeightCalculateDemo];
            break;
        case ZRFunctionTypeTest:
            [self actionTest];
            break;
        default:
            break;
    }
}


#pragma mark - function

#pragma mark File


/**
 沙盒文件浏览
 */
- (void)sandboxDirectoryBrowser{
    UIStoryboard *fileStoryboard = [UIStoryboard storyboardWithName:@"ZRFileStoryboard" bundle:[NSBundle mainBundle]];
    ZRFileListViewController *fileListViewController = [fileStoryboard instantiateViewControllerWithIdentifier:@"fileListViewController"];
    [fileListViewController observeDeallocWithBlock:^{
        NSLog(@"ZRFileListViewController dealloced~");
    }];
    fileListViewController.filePath = NSHomeDirectory();
    if (fileListViewController) {
        [self.navigationController pushViewController:fileListViewController animated:YES];
    }
}


/**
 MainBundle文件浏览
 */
- (void)mainBundleBrowser{
    UIStoryboard *fileStoryboard = [UIStoryboard storyboardWithName:@"ZRFileStoryboard" bundle:[NSBundle mainBundle]];
    ZRFileListViewController *fileListViewController = [fileStoryboard instantiateViewControllerWithIdentifier:@"fileListViewController"];
    fileListViewController.filePath = [NSBundle mainBundle].bundlePath;
    if (fileListViewController) {
        [self.navigationController pushViewController:fileListViewController animated:YES];
    }
}

#pragma mark UI


/**
 TextView高度自适应Demo
 */
- (void)textViewAutoSizeDemo{
//    UIStoryboard *fileStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    ZRTextViewAutoSizeViewController *textViewAutoSizeVC = [fileStoryboard instantiateViewControllerWithIdentifier:@"ZRTextViewAutoSizeScene"];
//    if (textViewAutoSizeVC) {
//        [self.navigationController pushViewController:textViewAutoSizeVC animated:YES];
//    }
//    
//    ZRTextViewAutoSizeExViewController *vc = [[ZRTextViewAutoSizeExViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    ZRTabBarViewController *tabBarViewController = [[ZRTabBarViewController alloc] init];
    [self.navigationController pushViewController:tabBarViewController animated:YES];
}


/**
 自定义gridview，展示多行多列数据
 */
- (void)customGridViewDemo{
    ZRGridViewController *vc = [[ZRGridViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 仿微信运动拆线图
 */
- (void)copyWeiChatStepStatisticDemo{
    ZRStepStatisticViewController *vc = [[ZRStepStatisticViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 自定义日历组件
 */
- (void)customCalendarViewDemo{
    ZRCustomCalendarViewController *vc = [[ZRCustomCalendarViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 一维PickerView
 */
- (void)pickerViewDemoWithOneDimension{
    ZRPickerView *pickerView = [[ZRPickerView alloc] init];
    pickerView.levelOneDataSource = @[@"河北",@"山西",@"河南",@"山东"];
    pickerView.okClickBlock = ^(ZRPickerView *sender, NSInteger firstColSelectedIndex, NSInteger secondColSelectedIndex) {
        
    };
    [pickerView show];
}


/**
 二维PickerView
 */
- (void)pikerViewDemoWithTwoDimension{
    ZRPickerView *pickerView = [[ZRPickerView alloc] init];
    pickerView.pickerViewHeight = 480;
    pickerView.numberOfComponents = 2;
    pickerView.levelOneDataSource = @[@"河北",@"山西",@"河南",@"山东"];
    pickerView.levelTwoDataSource = @[
                                      @[@"石家庄",@"唐山",@"张家口",@"邯郸",@"承德",@"衡水",@"邢台"],
                                      @[@"阳泉",@"太原",@"大同",@"五台",@"朔州",@"吕梁",@"临汾"],
                                      @[@"郑州",@"洛阳",@"周口",@"开封",@"平顶山",@"安阳",@"商丘",@"信阳"],
                                      @[@"济南",@"青岛",@"威海",@"蓬莱",@"泰安",@"烟台"],
                                      ];
    pickerView.okClickBlock = ^(ZRPickerView *sender, NSInteger firstColSelectedIndex, NSInteger secondColSelectedIndex) {
        //TODO: do something here
    };
    [pickerView show];
}

- (void)gotoImageRoundCornerDemo{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ZRImageRoundCornerViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ZRImageRoundCornerStoryboard"];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)gotoRoundImageViewAspectFitDemo{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ZRRoundImageViewCornerViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ZRRoundImageViewCornerAspectFit"];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)gotoWebviewContentHeightCalculateDemo{
    ZRWebViewContentHeightCalculateController *vc = [[ZRWebViewContentHeightCalculateController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark KVO Explore


/**
 KVO实现原理
 */
- (void)kvoExploreDemo{
    ZRWorker *normalWorker = [[ZRWorker alloc] init];
    ZRWorker *observedWorkerA = [[ZRWorker alloc] init];
    ZRWorker *observedWorkerB = [[ZRWorker alloc] init];
    ZRWorker *observedWorkerC = [[ZRWorker alloc] init];
    
    [observedWorkerA addObserver:observedWorkerA forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    [observedWorkerB addObserver:observedWorkerB forKeyPath:@"workStatus" options:NSKeyValueObservingOptionNew context:nil];
    [observedWorkerC addObserver:observedWorkerC forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    [observedWorkerC addObserver:observedWorkerC forKeyPath:@"workStatus" options:NSKeyValueObservingOptionNew context:nil];
    
    printDescription(@"normalWorker", normalWorker);
    printDescription(@"observedWorkerA", observedWorkerA);
    printDescription(@"observedWorkerB", observedWorkerB);
    printDescription(@"observedWorkerC", observedWorkerC);
    
    printf("Using NSObject methods, normal setName: is %p, overridden setName: is %p\n",
           [normalWorker methodForSelector:@selector(setName:)],
           [observedWorkerA methodForSelector:@selector(setName:)]);
    printf("Using libobjc functions, normal setName: is %p, overridden setName: is %p\n",
           method_getImplementation(class_getInstanceMethod(object_getClass(normalWorker),
                                                            @selector(setName:))),
           method_getImplementation(class_getInstanceMethod(object_getClass(observedWorkerA),
                                                            @selector(setName:))));
    
    
    [observedWorkerA removeObserver:observedWorkerA forKeyPath:@"name"];
    [observedWorkerB removeObserver:observedWorkerB forKeyPath:@"workStatus"];
    [observedWorkerC removeObserver:observedWorkerC forKeyPath:@"name"];
    [observedWorkerC removeObserver:observedWorkerC forKeyPath:@"workStatus"];
}


static NSArray *ClassMethodNames(Class c)
{
    NSMutableArray *array = [NSMutableArray array];
    
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(c, &methodCount);
    unsigned int i;
    for(i = 0; i < methodCount; i++)
        [array addObject: NSStringFromSelector(method_getName(methodList[i]))];
    free(methodList);
    
    return array;
}

static void printDescription(NSString *name, id obj){
    
    NSString *str = [NSString stringWithFormat:
                     @"%@: %@\n\tNSObject class %s\n\tlibobjc class %s\n\timplements methods <%@>",
                     name,
                     obj,
                     class_getName([obj class]),
                     class_getName(object_getClass(obj)),
                     ClassMethodNames(object_getClass(obj))
                     ];
    printf("%s\n", [str UTF8String]);
}

#pragma mark Runtime


/**
 类的构造之属性、变量、方法
 */
- (void)clsConstructionExplore{
    [ZRPerson zr_debugVariables:NO];
    [ZRPerson zr_debugProperties:NO];
    
    [ZRPerson zr_debugInstanceMethods:NO];
    [ZRPerson zr_debugClassMethods:NO];
}


/**
 消息转发测试
 */
- (void)messageForwardTest{
    ZRPerson *person = [[ZRPerson alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [person performSelector:@selector(eat)];
    [person performSelector:@selector(swim)];
    [person performSelector:@selector(fly)];
    [person performSelector:@selector(program)];
#pragma clang diagnostic pop
}

#pragma mark Memory Manage

ZRPerson *personA;



- (void)objectDeallocTest{
    
    NSLog(@"%s", __func__);
    
    personA = [[ZRPerson alloc] init];
    [personA observeDeallocWithBlock:^{
        NSLog(@"Person A dealloc");
    }];
    
    @autoreleasepool {
        ZRPerson *personB = [[ZRPerson alloc] init];
        [personB observeDeallocWithBlock:^{
            NSLog(@"Person B dealloc");
        }];
    }
    
    ZRPerson *personC = [[ZRPerson alloc] init];
    [personC observeDeallocWithBlock:^{
        NSLog(@"Person C dealloc");
    }];
    
}

NSString *stringA;

- (void)stringDeallocTest{
    NSLog(@"%s", __func__);
    
    stringA = @"String A";
    [stringA observeDeallocWithBlock:^{
        NSLog(@"%@ dealloc", stringA);
    }];
    
    @autoreleasepool {
        NSString *stringB = @"String B";
        [stringB observeDeallocWithBlock:^{
            NSLog(@"%@ dealloc", stringB);
        }];
    };

    NSString *stringC = @"String C";
    [stringC observeDeallocWithBlock:^{
        NSLog(@"%@ dealloc", stringC);
    }];
    
}

#pragma mark - Test

- (void)actionTest{
//    YXSuspendTabViewController *vc = [[YXSuspendTabViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    ZRWKWebViewContentHeightCalculateController *vc = [[ZRWKWebViewContentHeightCalculateController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    ZRSingleton *singleton1 = [[ZRSingleton alloc] init];
    
    
    ZRSingleton *singleton2 = [[ZRSingleton alloc] init];
    
    ZRSingleton *singleton3 = [ZRSingleton sharedInstance];
    
    ZRSingleton *singleton4 = [singleton1 copy];
    
    NSLog(@"\nsingleton one:%@\n singleton two: %@\n singleton three: %@\n singleton four: %@\n", [singleton1 description], [singleton2 description], [singleton3 description], [singleton4 description]);
    
    return;
    
    NSURL *url = [NSURL URLWithString:@"https://github.com/jiaxw32?uid=jiaxw32&token=666"];
    NSLog(@"url scheme: %@", url.scheme);
    NSLog(@"url host: %@", url.host);
    NSLog(@"url path: %@", url.path);
    NSLog(@"url query: %@", url.query);
    NSLog(@"url absolute string: %@", url.absoluteString);
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"invoke disposable block");
        }];
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"next: %@", x);
    } completed:^{
        NSLog(@"complete");
    }];
    
    RACSignal *returnSignal = [RACReturnSignal return:@"bye"];
    [returnSignal subscribeNext:^(id x) {
        NSLog(@"next: %@", x);
    } completed:^{
        NSLog(@"complete");
    }];
}



@end
