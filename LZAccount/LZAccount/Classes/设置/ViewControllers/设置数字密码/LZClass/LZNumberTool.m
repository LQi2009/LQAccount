//
//  LZNumberTool.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/3.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZNumberTool.h"

static NSString *numberPasswordStateKey = @"numberPasswordStateKey";
static NSString *numberPasswordValueKey = @"numberPasswordValueKey";

@implementation LZNumberTool

+ (void)saveNumberPasswordEnableByUser:(BOOL)enable {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber * num = [NSNumber numberWithBool:enable];
//    if (enable == NO) {
//        
//        [defaults removeObjectForKey:numberPasswordValueKey];
//    }
    
    [defaults setObject:num forKey:numberPasswordStateKey];
    [defaults synchronize];
}

+ (BOOL)isNumberPasswordEnableByUser {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber * num = [defaults objectForKey:numberPasswordStateKey];
    BOOL show = [num boolValue];
    
    return show;
//    NSString *password = [self getNumberPasswordValue];
//    
//    if (password && show) {
//        return YES;
//    } else {
//        return NO;
//    }
}

+ (BOOL)isNumberPasswordEnable {
    
    BOOL enableByUser = [self isNumberPasswordEnableByUser];
    
    NSString *psw = [self getNumberPasswordValue];
    
    if (enableByUser && psw.length > 0) {
        
        return YES;
    }
    
    return NO;
}

+ (void)saveNumberPasswordValue:(NSString*)value {
    
    if ([self isNumberPasswordEnableByUser] == NO) {
        
        [self saveNumberPasswordEnableByUser:YES];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:numberPasswordValueKey];
    [defaults synchronize];
}

+ (NSString*)getNumberPasswordValue {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults objectForKey:numberPasswordValueKey];
    
    return value;
}

+ (BOOL)isEqualToSavedPassword:(NSString *)psw {
    
    NSString *string = [self getNumberPasswordValue];
    
    if ([psw isEqualToString:string]) {
        
        return YES;
    }
    
    return NO;
}

+ (void)saveNumberResetEnableByTouchID:(BOOL)enable {
    
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    
    [us setBool:enable forKey:@"isCanUseTouchIDToResetNumber"];
    
    [us synchronize];
}

+ (BOOL)isNumberResetEnableByTouchID {
    
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    
    return [[us objectForKey:@"isCanUseTouchIDToResetNumber"] boolValue];
}

@end
