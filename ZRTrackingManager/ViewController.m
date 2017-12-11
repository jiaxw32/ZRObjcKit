//
//  ViewController.m
//  ZRTrackingManager
//
//  Created by jiaxw-mac on 2017/12/10.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "ViewController.h"
#import "ZRFileHelper.h"
#import "ZRFileViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction)onButtonClick:(id)sender {
    
    UIStoryboard *fileStoryboard = [UIStoryboard storyboardWithName:@"ZRFileStoryboard" bundle:[NSBundle mainBundle]];
    NSLog(@"%@",fileStoryboard);
    ZRFileViewController *fileViewController = [fileStoryboard instantiateViewControllerWithIdentifier:@"fileViewController"];
    fileViewController.filePath = NSHomeDirectory();
    if (fileViewController) {
        [self.navigationController pushViewController:fileViewController animated:YES];
    }
    
    
//    NSString *path = [ZRFileHelper appLibraryPath];
//    
//    path = NSHomeDirectory();
//    
//    NSURL *fileURL = [NSURL fileURLWithPath:path];
//    
//    id parentDirectory;
//    [fileURL getResourceValue:&parentDirectory forKey:NSURLParentDirectoryURLKey error:nil];
//    NSLog(@"%@",parentDirectory);
    
//    path = [ZRFileManager mainBundlePath];
    
//    NSLog(@"path:%@",path);
    
//    NSLog(@"document path:%@",[ZRFileManager appDocumentPath]);
//    NSLog(@"library path:%@",[ZRFileManager appLibraryPath]);
//    NSLog(@"temp path:%@",[ZRFileManager appTempPath]);
    
//    [[ZRFileHelper subFilesOfDirectory:path];
//    
//    [[ZRFileHelper contentsOfDirectory:path];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
