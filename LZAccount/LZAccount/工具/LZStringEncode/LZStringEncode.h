//
//  LZStringEncode.h
//  字符串编码
//
//  Created by Artron_LQQ on 16/5/14.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZStringEncode : NSObject

+ (NSString *)decode:(NSString *)str;
+ (NSString *)encode:(NSString *)str;

@end
