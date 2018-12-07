//
//  LZGestureTool.h
//  LZGestureSecurity
//
//  Created by Artron_LQQ on 2016/10/17.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZGestureTool : NSObject

// 用户是否开启手势解锁
+ (void)saveGestureEnableByUser:(BOOL)isEnable;
+ (BOOL)isGestureEnableByUser;

// 保存 读取用户设置的密码
+ (void)saveGesturePsw:(NSString *)psw;
+ (NSString *)getGesturePsw;
+ (void)deleteGesturePsw;
+ (BOOL)isGesturePswEqualToSaved:(NSString *)psw;

+ (BOOL)isGestureEnable;
+ (BOOL)isGesturePswSavedByUser;

+ (void)saveGestureResetEnableByTouchID:(BOOL)enable;
+ (BOOL)isGestureResetEnableByTouchID;
@end
