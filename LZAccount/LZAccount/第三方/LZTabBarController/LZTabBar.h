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
@interface LZTabBar : UIView

@property (nonatomic, strong)NSArray<LZTabBarItem *> *items;
@property (nonatomic, assign)id <LZTabBarDelegate> delegate;
@end

@protocol LZTabBarDelegate <NSObject>

- (void)tabBar:(LZTabBar *)tab didSelectItem:(LZTabBarItem *)item atIndex:(NSInteger)index ;

@end
// ********************************************************
#pragma mark - LZTabBarItem

typedef enum : NSUInteger {
    
    LZTabBarItemTypeDefault,
    LZTabBarItemTypeImage,
    LZTabBarItemTypeText,
} LZTabBarItemType;

@protocol LZTabBarItemDelegate;
@interface LZTabBarItem : UIView

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) LZTabBarItemType type;
@property (nonatomic, assign) id <LZTabBarItemDelegate> delegate;
@end

@protocol LZTabBarItemDelegate <NSObject>

- (void)tabBarItem:(LZTabBarItem *)item didSelectIndex:(NSInteger)index;
@end
