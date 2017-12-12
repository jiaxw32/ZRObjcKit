//
//  ZRFileTableViewCell.m
//  ZRTrackingManager
//
//  Created by jiaxw-mac on 2017/12/11.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#import "ZRFileTableViewCell.h"
#import "ZRFileInfoModel.h"
#import "ZRFileHelper.h"

@interface ZRFileTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *fileIcon;

@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UILabel *fileDesc;

@end

@implementation ZRFileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ZRFileInfoModel *)model{
    _model = model;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *fileCreateDate = [dateFormatter stringFromDate:_model.createDate];
    if (model.isDirectory) {
        _fileIcon.image = [UIImage imageNamed:@"zr_folder"];
        NSInteger subFilesCount = [ZRFileHelper subFilesCountOfDirectory:[NSURL fileURLWithPath:model.filePath]];
        _fileDesc.text = [NSString stringWithFormat:@"%lu项 | %@",subFilesCount,fileCreateDate];
    } else {
        _fileIcon.image = [UIImage imageNamed:@"zr_file"];
        NSString *fileSize = [ZRFileHelper formatFileSize:model.fileSize];
        _fileDesc.text = [NSString stringWithFormat:@"%@ | %@",fileSize,fileCreateDate];
    }
    
    _fileName.text = model.fileName;
    
}

+ (CGFloat)cellHeight{
    return 60;
}

@end
