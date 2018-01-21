//
//  ZRObjcKitConstant.h
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2017/12/16.
//  Copyright © 2017年 jiaxw. All rights reserved.
//

#ifndef ZRObjcKitConstant_h
#define ZRObjcKitConstant_h

//十六进制颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


#endif /* ZRObjcKitConstant_h */
