//
//  LZTabBarController.h
//  LZTabBarController
//
//  Created by Artron_LQQ on 2016/12/12.
//  Copyright © 2016年 Artup. All rights reserved.
//
/*
 底部tabBar自定义的tabBarController
 只需调用给出的类方法, 配置相关参数即可创建tabBarController实例对象
 
 */

#import <UIKit/UIKit.h>

@class LZTabBarConfig;
typedef LZTabBarConfig*(^tabBarBlock)(LZTabBarConfig *config);
@interface LZTabBarController : UITabBarController

/**
 是否可用自动旋转屏幕
 */
@property (nonatomic, assign) BOOL isAutoRotation;

/**
 创建tabBarController

 @param block 配置创建tabBarController所需的参数
 @return 返回tabBarController实例对象
 */
+ (instancetype)createTabBarController:(tabBarBlock)block;

/**
 获取当前的tabBarController实例, 实例创建后可通过此方法获取当前实例

 @return 返回tabBarController实例对象
 */
+ (instancetype)defaultTabBarController;

/**
 隐藏底部tabBar的方法

 @param isAnimation 是否需要动画
 */
- (void)hiddenTabBarWithAnimation:(BOOL)isAnimation;

/**
 显示底部tabBar的方法

 @param isAnimation 是否需要动画
 */
- (void)showTabBarWithAnimation:(BOOL)isAnimation;
@end


#pragma mark - LZTabBarConfig
@interface LZTabBarConfig : NSObject

/**
 控制器数组, 必须设置
 */
@property (nonatomic, strong) NSArray *viewControllers;

/**
 item标题数组, 选择设置
 */
@property (nonatomic, strong) NSArray *titles;

/**
 是否是导航, 默认 YES
 */
@property (nonatomic, assign) BOOL isNavigation;

/**
 选中状态下的图片数组
 */
@property (nonatomic, strong) NSArray *selectedImages;

/**
 正常状态下的图片数组
 */
@property (nonatomic, strong) NSArray *normalImages;

/**
 选中状态下的标题颜色 默认: red
 */
@property (nonatomic, strong) UIColor *selectedColor;

/**
 正常状态下的标题颜色 默认: gray
 */
@property (nonatomic, strong) UIColor *normalColor;
@end
