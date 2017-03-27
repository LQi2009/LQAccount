//
//  GestureTool_Private.h
//  v1.0
//  by OYXJ, Hawking.HK@gmail.com

#import <UIKit/UIKit.h>

/**
 私用的工具
 */
@interface GestureTool_Private : NSObject
/*! @brief
 备份 账号
 */
+ (void)saveLastAccountStringInUserDefaults:(NSString *)accountString;
/*! @brief
 备份 手势密码
 */
+ (void)saveLastGestureStringInUserDefaults:(NSString *)gestureString;
@end
