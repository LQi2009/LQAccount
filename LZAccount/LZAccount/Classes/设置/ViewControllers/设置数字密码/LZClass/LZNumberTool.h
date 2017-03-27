//
//  LZNumberTool.h
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/3.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZNumberTool : NSObject

+ (void)saveNumberPasswordEnableByUser:(BOOL)enable ;
+ (BOOL)isNumberPasswordEnableByUser ;
+ (BOOL)isNumberPasswordEnable ;

+ (void)saveNumberPasswordValue:(NSString*)value ;
+ (NSString*)getNumberPasswordValue;

+ (BOOL)isEqualToSavedPassword:(NSString *)psw;

+ (void)saveNumberResetEnableByTouchID:(BOOL)enable;
+ (BOOL)isNumberResetEnableByTouchID;
@end
