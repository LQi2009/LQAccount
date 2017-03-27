//
//  GestureTool_Public.m
//  v1.0
//  by OYXJ, Hawking.HK@gmail.com

#import "GestureTool_Public.h"
#import "GestureDefine.h"


#pragma mark - 类

@implementation GestureTool_Public


#pragma mark - 公开方法

/*! @brief
 在NSUserDefaults中，是否 已经保存了手势密码
 */
+ (BOOL)isHasGesturePwdStringWhichSavedInNSUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *gesturePwdStr = [userDefaults objectForKey:KEY_UserDefaults_GesturePassword];//取出手势密码（如果存在）
    
    if (gesturePwdStr.length > 0)
    {//有
        return YES;
    }
    else
    {//无
        return NO;
    }
}

/*! @brief
 在NSUserDefaults中，清除手势密码
 */
+ (void)clearGesturePwdStringWhichSavedInNSUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"" forKey:KEY_UserDefaults_GesturePassword]; //清除手势密码
    [userDefaults synchronize];
}


/*! @brief
 上次账号(保存了手势密码的账号) 和 accountString，是否相同
 */
+ (BOOL)isLastAccountWhichSaveGestureSameWithAccountStr:(NSString *)accountString
{
    if (accountString.length <= 0)
    {//传入的账号为空
        
#ifdef Gesture_Debug_NSLog
        NSLog(@"%@  %@",
              @"isLastAccountWhichSaveGestureSameWithAccountStr",
              @"传入的账号为空");
#endif
        
        return NO;
    }
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lastAccountStr = [userDefaults objectForKey:KEY_UserDefaults_backupAccountStr];//取出 备份的账号（如果存在）
    
    if (lastAccountStr.length <= 0)
    {//上次的账号为空
        return NO;
    }
    else
    {//上次的账号不为空
        if ([lastAccountStr isEqualToString:accountString])
        {//相同
            return YES;
        }
        else
        {//不同
            return NO;
        }
    }
}

/*! @brief
 在isLastAccountWhichSaveGestureSameWithAccount为YES的情况下，才能够为LastAccount恢复手势密码
 */
+ (void)recoverGestureForLastAccountStr:(NSString *)accountString
{
    if ([self isLastAccountWhichSaveGestureSameWithAccountStr:accountString])
    {//相同
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        /*
         取出 备份的手势密码（如果存在)
         */
        NSString *gesturePwdStr = [userDefaults objectForKey:KEY_UserDefaults_backupGesturePwdStr];
        
#ifdef Gesture_Debug_NSLog
        NSLog(@"%@ %@",
              @"recoverGestureForLastAccountStr",
              @"本次登录与上次登录的账号 是同一个，恢复账号对应的手势密码");
#endif
        
        if (gesturePwdStr.length > 0)
        {
            [userDefaults setObject:gesturePwdStr forKey:KEY_UserDefaults_GesturePassword];//恢复 手势密码
            [userDefaults synchronize];
        }
    }
    else
    {//不同
        
#ifdef Gesture_Debug_NSLog
        NSLog(@"%@ %@",
              @"recoverGestureForLastAccountStr",
              @"本次登录与上次登录的账号 不是同一个，不恢复账号对应的手势密码");
#endif
        
    }
}

@end
