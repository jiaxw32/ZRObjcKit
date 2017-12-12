//
//  ZRFileInfoModel.h
//  ZRTrackingManager
//
//  Created by jiaxw-mac on 2017/12/11.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZRFileInfoModel : NSObject


+ (ZRFileInfoModel *)fileInfoModelWithURL:(NSURL *)url;


/**
 文件名
 */
@property (nonatomic,copy) NSString *fileName;


/**
 文件夹路径
 */
@property (nonatomic,copy) NSString *fileDirectory;


/**
 文件路径
 */
@property (nonatomic,copy) NSString *filePath;


/**
 是否为路径
 */
@property (nonatomic,assign) Boolean isDirectory;


/**
 根路径
 */
@property (nonatomic,copy) NSString *rootPath;


/**
 相对路径，即文件路径截取根路径后的路径
 */
@property (nonatomic,copy) NSString *relationPath;


/**
 文件扩展名
 */
@property (nonatomic,copy) NSString *fileExtentsion;


/**
 文件大小
 */
@property (nonatomic,assign) NSInteger fileSize;


/**
 当前文件为文件夹时，文件夹下的子文件数量
 */
@property (nonatomic,assign) NSInteger subFilesCount;


/**
 创建日期
 */
@property (nonatomic,strong) NSDate *createDate;


/**
 最后修改日期
 */
@property (nonatomic,strong) NSDate *lastModifyDate;

@end
