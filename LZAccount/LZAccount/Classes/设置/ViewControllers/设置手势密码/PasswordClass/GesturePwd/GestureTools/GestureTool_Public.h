//
//  GestureTool_Public.h
//  v1.0
//  by OYXJ, Hawking.HK@gmail.com

#import <UIKit/UIKit.h>

/**
 公用的工具
 */
@interface GestureTool_Public : NSObject

/*! @brief
 在NSUserDefaults中，是否 已经保存了手势密码
 */
+ (BOOL)isHasGesturePwdStringWhichSavedInNSUserDefaults;

/*! @brief
 在NSUserDefaults中，清除手势密码
 */
+ (void)clearGesturePwdStringWhichSavedInNSUserDefaults;


/*! @brief
 上次账号(保存了手势密码的账号) 和 accountString，是否相同
 */
+ (BOOL)isLastAccountWhichSaveGestureSameWithAccountStr:(NSString *)accountString;

/*! @brief
 在isLastAccountWhichSaveGestureSameWithAccount为YES的情况下，才能够为LastAccount恢复手势密码
 */
+ (void)recoverGestureForLastAccountStr:(NSString *)accountString;

@end
