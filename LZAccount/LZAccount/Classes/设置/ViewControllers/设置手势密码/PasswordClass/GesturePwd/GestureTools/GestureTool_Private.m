//
//  GestureTool_Private.m
//  v1.0
//  by OYXJ, Hawking.HK@gmail.com

#import "GestureTool_Private.h"
#import "GestureDefine.h"


#pragma mark - 类

@implementation GestureTool_Private


#pragma mark - 公开方法

/*! @brief
 备份 账号
 */
+ (void)saveLastAccountStringInUserDefaults:(NSString *)accountString
{//保存上次账号（如果不为空）
    if (accountString.length <= 0)
    {//传入的账号为空
        
#ifdef Gesture_Debug_NSLog
        NSLog(@"%@  %@",
              @"saveLastAccountStringInUserDefaults",
              @"传入的账号为空");
#endif
        
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:accountString forKey:KEY_UserDefaults_backupAccountStr];//保存上次账号（如果不为空）
    [userDefaults synchronize];
}

/*! @brief
 备份 手势密码
 */
+ (void)saveLastGestureStringInUserDefaults:(NSString *)gestureString
{//保存上次账号的手势（如果不为空）
    if (gestureString.length <= 0)
    {//传入的手势为空
        
#ifdef Gesture_Debug_NSLog
        NSLog(@"%@  %@",
              @"saveLastGestureStringInUserDefaults",
              @"传入的手势为空");
#endif
        
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:gestureString forKey:KEY_UserDefaults_backupGesturePwdStr];//上次手势密码(上次账号对应的手势密码)
    [userDefaults synchronize];
}

@end

