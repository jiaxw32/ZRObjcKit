//
//  ViewController.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/10.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "ViewController.h"
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
#import "ZRBoss.h"
#import "ZRWorker.h"
#import "ZRStepStatisticViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
//    [ZRPerson zr_debugVariables:NO];
//    [ZRPerson zr_debugProperties:NO];
//    
//    [ZRPerson zr_debugInstanceMethods:NO];
//    [ZRPerson zr_debugClassMethods:NO];
    
    
//    ZRPerson *person = [[ZRPerson alloc] init];
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wundeclared-selector"
//    [person performSelector:@selector(eat)];
//    [person performSelector:@selector(swim)];
//    [person performSelector:@selector(fly)];
//    [person performSelector:@selector(program)];
//#pragma clang diagnostic pop
    
    [self kvo_test];

}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (IBAction)onButtonClick:(id)sender {
    
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

- (IBAction)onMainBundleButtonClick:(id)sender {
    UIStoryboard *fileStoryboard = [UIStoryboard storyboardWithName:@"ZRFileStoryboard" bundle:[NSBundle mainBundle]];
    ZRFileListViewController *fileListViewController = [fileStoryboard instantiateViewControllerWithIdentifier:@"fileListViewController"];
    fileListViewController.filePath = [NSBundle mainBundle].bundlePath;
    if (fileListViewController) {
        [self.navigationController pushViewController:fileListViewController animated:YES];
    }
}
- (IBAction)onTextViewAutoSizeButtonClickHandler:(id)sender {
//    UIStoryboard *fileStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    ZRTextViewAutoSizeViewController *textViewAutoSizeVC = [fileStoryboard instantiateViewControllerWithIdentifier:@"ZRTextViewAutoSizeScene"];
//    if (textViewAutoSizeVC) {
//        [self.navigationController pushViewController:textViewAutoSizeVC animated:YES];
//    }
    
//    ZRTextViewAutoSizeExViewController *vc = [[ZRTextViewAutoSizeExViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
//    ZRGridViewController *vc = [[ZRGridViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
//    ZRTabBarViewController *tabBarViewController = [[ZRTabBarViewController alloc] init];
//    [self.navigationController pushViewController:tabBarViewController animated:YES];
    
    ZRStepStatisticViewController *vc = [[ZRStepStatisticViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    /*
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
        //TODO: do you want to do
    };
    [pickerView show];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)kvo_test{
//    ZRBoss *boss = [[ZRBoss alloc] init];
    
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
    
//    ((objc_object *)obj).isa;
    
    
    
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

@end
