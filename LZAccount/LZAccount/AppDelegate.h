//
//  AppDelegate.h
//  LZAccount
//
//  Created by Artron_LQQ on 16/5/24.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MFSideMenuContainerViewController *sideMenu;


- (void)setTabbarControllerWithIdentifier:(NSString *)identifier ;
@end

