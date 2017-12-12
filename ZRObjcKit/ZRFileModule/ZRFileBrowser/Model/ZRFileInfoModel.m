//
//  ZRFileInfoModel.m
//  ZRTrackingManager
//
//  Created by jiaxw-mac on 2017/12/11.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "ZRFileInfoModel.h"
#import "ZRFileHelper.h"

@implementation ZRFileInfoModel

+ (ZRFileInfoModel *)fileInfoModelWithURL:(NSURL *)url{
    ZRFileInfoModel *model = [[ZRFileInfoModel alloc] init];
    
    BOOL isDirectory = [ZRFileHelper isDirectoryOfURL: url];
    model.fileName = [ZRFileHelper getFileName:url];
    model.filePath = url.path;
    model.isDirectory = isDirectory;
    if (isDirectory) {
        model.subFilesCount = [ZRFileHelper subFilesCountOfDirectory:url];
    } else {
        model.fileSize = [ZRFileHelper getFileSize:url];
    }
    model.fileExtentsion = url.pathExtension;
    model.fileDirectory = [ZRFileHelper getParentDirectory:url];
    model.createDate = [ZRFileHelper getFileCreateDate:url];
    model.lastModifyDate = [ZRFileHelper getFileModifyDate:url];
    
    return model;
}

@end
