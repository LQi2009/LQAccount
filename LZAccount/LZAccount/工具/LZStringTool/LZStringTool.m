//
//  LZStringTool.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/3.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZStringTool.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation LZStringTool

+ (NSString*)creatRedomMD5String {
    
    //随机生成36为字符串
    CFUUIDRef identifier = CFUUIDCreate(NULL);
    NSString* identifierString = (NSString*)CFBridgingRelease(CFUUIDCreateString(NULL, identifier));
    CFRelease(identifier);
    
    //    NSString *string = [identifierString MD5];
    
    const char *cStr = [identifierString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output;
}

@end
