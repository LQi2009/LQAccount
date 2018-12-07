//
//  LZPasswordTool.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/2.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZPasswordTool.h"
//#import "SystemDefine.h"
//#pragma mark - 手势
//#import "TouchIdUnlock.h"           //指纹解锁
//#import "GestureLockScreen.h"       //手势锁屏
//#import "GestureTool_Public.h"      //手势工具

static NSString *groupPassword = @"showGroupByPassword";
static NSString *detailPassword = @"showDetailByPassword";
static NSString *PSWPassword = @"showPSWByPassword";

static NSString *numberPasswordEnabled = @"numberPasswordEnabled";
static NSString *numberPasswordKey = @"numberPasswordKey";

static pswResult verifySuccess;
static pswResult verufyFaild;

@implementation LZPasswordTool

+ (void)verGestureAndTouchPsw:(pswResult)success {
    
    
}

+ (void)verifyPassword {
    
    
}


//查看分组信息是否需要验证
+ (void)setShouldVerifyPasswordWhenShowGroup:(BOOL)show {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber * num = [NSNumber numberWithBool:show];
    [defaults setObject:num forKey:groupPassword];
    [defaults synchronize];
}

+ (BOOL)getShouldVerifyPasswordWhenShowGroup {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [defaults objectForKey:groupPassword];
    return [number boolValue];
}

//查看详细信息是否需要验证
+ (void)setShouldVerifyPasswordWhenShowDetail:(BOOL)show {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber * num = [NSNumber numberWithBool:show];
    [defaults setObject:num forKey:detailPassword];
    [defaults synchronize];
}

+ (BOOL)getShouldVerifyPasswordWhenShowDetail {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber * num = [defaults objectForKey:detailPassword];
    return [num boolValue];
}

//查看密码明文是否需要验证
+ (void)setShouldVerifyPasswordWhenShowPassword:(BOOL)show {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber * num = [NSNumber numberWithBool:show];
    [defaults setObject:num forKey:PSWPassword];
    [defaults synchronize];
}

+ (BOOL)getShouldVerifyPasswordWhenShowPassword {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber * num = [defaults objectForKey:PSWPassword];
    return [num boolValue];
}

@end
