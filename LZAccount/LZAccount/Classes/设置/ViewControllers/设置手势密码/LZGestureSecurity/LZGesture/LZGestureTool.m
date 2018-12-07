//
//  LZGestureTool.m
//  LZGestureSecurity
//
//  Created by Artron_LQQ on 2016/10/17.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZGestureTool.h"
#import "LZGestureFile.h"

@implementation LZGestureTool

// 用户是否开启手势解锁
+ (void)saveGestureEnableByUser:(BOOL)isEnable {
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    [df setBool:isEnable forKey:kLZGestureEnableByUserKey];
    [df synchronize];
}

+ (BOOL)isGestureEnableByUser {
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    BOOL enable = [[df objectForKey:kLZGestureEnableByUserKey] boolValue];
    
    return enable;
}

// 保存 读取用户设置的密码
+ (void)saveGesturePsw:(NSString *)psw {
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setObject:psw forKey:kLZGesturePsw];
    [df synchronize];
}

+ (NSString *)getGesturePsw {
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSString *psw = [df objectForKey:kLZGesturePsw];
    
    return psw;
}

+ (BOOL)isGesturePswSavedByUser {
    
    NSString *psw = [self getGesturePsw];
    
    if (psw&& psw.length > 0) {
        
        return YES;
    }
    
    return NO;
}
+ (void)deleteGesturePsw {
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setObject:@"" forKey:kLZGesturePsw];
    [df synchronize];
}

+ (BOOL)isGesturePswEqualToSaved:(NSString *)psw {
    
    if (!psw || psw.length <= 0) {
        
        return NO;
    }
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSString *str = [df objectForKey:kLZGesturePsw];
    
    if (!str || str.length <= 0) {
        
        return NO;
    }
    
    if ([psw isEqualToString:str]) {
        
        return YES;
    } else {
        
        return NO;
    }
}

+ (BOOL)isGestureEnable {
    
    BOOL isEnableByUser = [self isGestureEnableByUser];
    
    NSString *psw = [self getGesturePsw];
    
    BOOL enable = isEnableByUser && psw && psw.length > 0 ;
    return enable;
}

+ (void)saveGestureResetEnableByTouchID:(BOOL)enable {
    
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    
    [us setBool:enable forKey:@"isCanUseTouchIDToResetGesture"];
    
    [us synchronize];
}

+ (BOOL)isGestureResetEnableByTouchID {
    
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    
    return [[us objectForKey:@"isCanUseTouchIDToResetGesture"] boolValue];
}
@end
