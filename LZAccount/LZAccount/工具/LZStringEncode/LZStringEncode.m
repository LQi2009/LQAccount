//
//  LZStringEncode.m
//  字符串编码
//
//  Created by Artron_LQQ on 16/5/14.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZStringEncode.h"
#import <CommonCrypto/CommonCrypto.h>
#import "AESCrypt.h"
#import "NSData+Base64.h"
#import "NSData+CommonCrypto.h"
#import "NSString+Base64.h"
#import "LZSqliteTool.h"

@implementation LZStringEncode
+ (NSString *)encode:(NSString *)str {
    
    NSString *key = [self createKey];
    
    NSData *password = [[key dataUsingEncoding:NSUTF8StringEncoding] MD5Sum];
    CCCryptorStatus status = kCCSuccess;
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    //加密
    NSData *result = [data dataEncryptedUsingAlgorithm:kCCAlgorithmAES128 key:password options:kCCOptionPKCS7Padding|kCCOptionECBMode error:&status];
    
    NSString *encodeStr = [result base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    return encodeStr;
}

+ (NSString *)decode:(NSString *)str {
    
    
    NSData *encodeData = [NSData base64DataFromString:str ];
    
    NSString *key = [self createKey];
    
    NSData *password = [[key dataUsingEncoding:NSUTF8StringEncoding] MD5Sum];
    CCCryptorStatus status = kCCSuccess;
    
    //解密
    NSData *encrpted = [encodeData decryptedDataUsingAlgorithm:kCCAlgorithmAES128 key:password options:kCCOptionPKCS7Padding|kCCOptionECBMode error:&status];
    
    NSString * plainString = [[NSString alloc]initWithData:encrpted encoding:NSUTF8StringEncoding];
    
    
    return plainString;
}

+ (NSString *)createKey {
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    NSString *key = [df objectForKey:@"redomSavedKey"];
    
    if (key.length > 0) {
        
        return key;
    }
    
    NSString *sqlPsw = [LZSqliteTool LZSelectPswFromTable:LZSqliteDataPasswordKey passwprdKey:LZSqliteDataPasswordKey];
    
    if (sqlPsw.length > 0) {
        
        [df setObject:sqlPsw forKey:@"redomSavedKey"];
        return sqlPsw;
    }
    
    //随机生成36为字符串
    CFUUIDRef identifier = CFUUIDCreate(NULL);
    NSString* identifierString = (NSString*)CFBridgingRelease(CFUUIDCreateString(NULL, identifier));
    CFRelease(identifier);
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy年MM月dd日 HH时mm分ss秒";
    
    NSString *dateStr = [format stringFromDate:date];
    
    NSString *result = [NSString stringWithFormat:@"%@%@",identifierString, dateStr];
    
    //    NSString *string = [identifierString MD5];
    
    const char *cStr = [result UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    [LZSqliteTool LZInsertToPswTable:LZSqliteDataPasswordKey passwordKey:LZSqliteDataPasswordKey passwordValue:output];
    [df setObject:output forKey:@"redomSavedKey"];
    return output;
}

@end
