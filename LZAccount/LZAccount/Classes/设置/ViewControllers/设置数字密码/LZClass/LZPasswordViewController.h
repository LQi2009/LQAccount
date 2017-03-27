//
//  LZPasswordViewController.h
//  LZPasswordView
//
//  Created by Artron_LQQ on 2016/10/20.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^successBlock)();
typedef NS_ENUM(NSInteger, LZPasswordStyle) {
    
    LZPasswordStyleSetting, // 密码设置
    LZPasswordStyleVerity, // 密码验证
    LZPasswordStyleUpdate, // 密码重置
    LZPasswordStyleScreen, // 锁屏
};

@interface LZPasswordViewController : UIViewController

@property (nonatomic, assign) LZPasswordStyle style;

- (void)showInViewController:(UIViewController *)vc style:(LZPasswordStyle)style ;

- (void)veritySuccess:(successBlock)success;
@end

