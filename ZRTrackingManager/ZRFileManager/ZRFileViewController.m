//
//  ZRFileViewController.m
//  ZRTrackingManager
//
//  Created by jiaxw-mac on 2017/12/11.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "ZRFileViewController.h"
#import "ZRFileTableViewCell.h"
#import "ZRFileInfoModel.h"
#import "ZRFileHelper.h"

@interface ZRFileViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *fileInfoArray;

@end

@implementation ZRFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DATA

- (void)setFilePath:(NSString *)filePath{
    _filePath = filePath;
    self.fileInfoArray = [ZRFileHelper subFilesOfDirectory:_filePath includeDirectory:YES filter:nil];
    [self.tableView reloadData];
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
    if (model.isDirectory && [ZRFileHelper subFilesCountOfDirectory:[NSURL fileURLWithPath:model.filePath]] > 0) {
        UIStoryboard *fileStoryboard = [UIStoryboard storyboardWithName:@"ZRFileStoryboard" bundle:[NSBundle mainBundle]];
        NSLog(@"%@",fileStoryboard);
        ZRFileViewController *fileViewController = [fileStoryboard instantiateViewControllerWithIdentifier:@"fileViewController"];
        fileViewController.filePath = model.filePath;
        if (fileViewController) {
            [self.navigationController pushViewController:fileViewController animated:YES];
        }
    } else {
        NSLog(@"%@",model.fileExtentsion);
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}



@end
