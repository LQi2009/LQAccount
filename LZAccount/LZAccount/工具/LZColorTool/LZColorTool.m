//
//  LZColorTool.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/5/30.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZColorTool.h"

@implementation LZColorTool

+ (UIImage *)imageFromColor:(UIColor *)color {
    
    // 使用颜色创建UIImage
    CGSize imageSize = CGSizeMake(300, 300);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *colorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return colorImg;
}
@end
