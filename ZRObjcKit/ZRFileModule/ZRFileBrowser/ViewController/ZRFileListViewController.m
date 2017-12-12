//
//  ZRFileListViewController.m
//  ZRTrackingManager
//
//  Created by jiaxw-mac on 2017/12/11.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "ZRFileListViewController.h"
#import "ZRFileTableViewCell.h"
#import "ZRFileInfoModel.h"
#import "ZRFileHelper.h"
#import <QuickLook/QuickLook.h>

@interface ZRFileListViewController ()<UITableViewDelegate,UITableViewDataSource,QLPreviewControllerDelegate,QLPreviewControllerDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *fileInfoArray;

@property (nonatomic,strong) QLPreviewController *previewController;

@property (nonatomic,strong) NSURL *selectedFileURL;

@end

@implementation ZRFileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter/setter

- (void)setFilePath:(NSString *)filePath{
    _filePath = filePath;
    self.fileInfoArray = [ZRFileHelper subFilesOfDirectory:_filePath includeDirectory:YES filter:nil];
    [self.tableView reloadData];
}

- (QLPreviewController *)previewController{
    if (!_previewController) {
        _previewController = [[QLPreviewController alloc] init];
        _previewController.delegate = self;
        _previewController.dataSource = self;
        _previewController.currentPreviewItemIndex = 0;
    }
    return _previewController;
}


#pragma mark - UITableView DataSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _fileInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * const identifier = @"ZRFileTableViewCell";
    ZRFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    ZRFileInfoModel *model = _fileInfoArray[indexPath.row];
    if (model.isDirectory) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZRFileInfoModel *model = _fileInfoArray[indexPath.row];
    if (model.isDirectory) {
        UIStoryboard *fileStoryboard = [UIStoryboard storyboardWithName:@"ZRFileStoryboard" bundle:[NSBundle mainBundle]];
        ZRFileListViewController *fileViewController = [fileStoryboard instantiateViewControllerWithIdentifier:@"fileListViewController"];
        fileViewController.filePath = model.filePath;
        if (fileViewController) {
            [self.navigationController pushViewController:fileViewController animated:YES];
        }
    } else {
        self.selectedFileURL =[NSURL fileURLWithPath: model.filePath];
        [self.previewController reloadData];
        [self presentViewController:self.previewController animated:YES completion:nil];
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - QLPreviewControllerDelegate and datasource

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx{
    return self.selectedFileURL;
}


@end
