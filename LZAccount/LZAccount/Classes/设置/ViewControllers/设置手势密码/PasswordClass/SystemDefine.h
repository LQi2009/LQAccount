//
//  SystemDefine.h
//  GestureSDK_Demo
//
//  Created by OYXJ on 15/8/9.
//  Copyright (c) 2015年 OYXJ. All rights reserved.
//

#ifndef GestureSDK_Demo_SystemDefine_h
#define GestureSDK_Demo_SystemDefine_h

//--- 颜色 ---//
#define SystemBlue              [UIColor blueColor]
#define SystemRed               [UIColor redColor]
#define SystemGray              [UIColor grayColor]
#define SystemBackGroundGray    [UIColor lightGrayColor]


/**
 用户是否 想使用手势锁屏，这个配置，保存在NSUserDefaults。
 */
#ifndef KEY_UserDefaults_isGestureLockEnabledOrNotByUser
    #define KEY_UserDefaults_isGestureLockEnabledOrNotByUser @"KEY_UserDefaults_isGestureLockEnabledOrNotByUser"
#endif


/**
 显示手势轨迹
 */
#ifndef KEY_UserDefaults_isShowGestureTrace
    #define KEY_UserDefaults_isShowGestureTrace              @"KEY_UserDefaults_isShowGestureTrace"
#endif

/**
 用户是否 想使用touchID解锁，这个配置，保存在NSUserDefaults。
 */
#ifndef KEY_UserDefaults_isTouchIdEnabledOrNotByUser
    #define KEY_UserDefaults_isTouchIdEnabledOrNotByUser     @"KEY_UserDefaults_isTouchIdEnabledOrNotByUser"
#endif


#endif
