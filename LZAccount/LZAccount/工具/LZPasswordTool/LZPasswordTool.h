//
//  LZPasswordTool.h
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/2.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^pswResult)(BOOL);
@interface LZPasswordTool : NSObject

//查看分组信息是否需要验证
+ (void)setShouldVerifyPasswordWhenShowGroup:(BOOL)show;
+ (BOOL)getShouldVerifyPasswordWhenShowGroup;

//查看详细信息是否需要验证
+ (void)setShouldVerifyPasswordWhenShowDetail:(BOOL)show;
+ (BOOL)getShouldVerifyPasswordWhenShowDetail;

//查看密码明文是否需要验证
+ (void)setShouldVerifyPasswordWhenShowPassword:(BOOL)show;
+ (BOOL)getShouldVerifyPasswordWhenShowPassword;

// 手势及指纹验证

// 数字密码验证
@end
