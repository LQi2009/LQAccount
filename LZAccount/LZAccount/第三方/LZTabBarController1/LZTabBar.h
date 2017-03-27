//
//  LZTabBar.h
//  LZTabBarController
//
//  Created by Artron_LQQ on 2016/12/12.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LZTabBarItem;
@protocol LZTabBarDelegate;
@interface LZTabBar : UITabBar

@property (nonatomic, strong)NSArray<LZTabBarItem *> *lzItems;
@property (nonatomic, assign)id <LZTabBarDelegate> lzDelegate;
@end

@protocol LZTabBarDelegate <NSObject>

- (void)tabBar:(LZTabBar *)tab didSelectItem:(LZTabBarItem *)item atIndex:(NSInteger)index ;

@end
// ********************************************************
#pragma mark - LZTabBarItem
@protocol LZTabBarItemDelegate;
@interface LZTabBarItem : UIView

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, assign) id <LZTabBarItemDelegate> delegate;
@end

@protocol LZTabBarItemDelegate <NSObject>

- (void)tabBarItem:(LZTabBarItem *)item didSelectIndex:(NSInteger)index;
@end
