//
//  AppDelegate.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/5/24.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "AppDelegate.h"
#import "LZMainViewController.h"
#import "LZSettingViewController.h"
#import "LZBaseNavigationController.h"
#import "LZAllViewController.h"
#import "LZSqliteTool.h"

// 10.18
#import "LZGestureTool.h"
#import "LZGestureScreen.h"
#import "TouchIdUnlock.h"

// 12.26
#import "LZTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    self.window.backgroundColor = [UIColor whiteColor];
    
    
    [self verifyPassword];
    [self createSqlite];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    
    [self setTabbarControllerWithIdentifier:nil];
    [self configShortCutItems];
    return YES;
}

/** 创建shortcutItems ----------abner */
- (void)configShortCutItems
{
    
    NSMutableArray *shortcutItems = [NSMutableArray array];
//    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"1" localizedTitle:@"添加账号"];
    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd];
    UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc]initWithType:@"1" localizedTitle:@"添加账号" localizedSubtitle:nil icon:icon userInfo:nil];
    [shortcutItems addObject:item];
    [[UIApplication sharedApplication] setShortcutItems:shortcutItems];
}

/** 处理shortcutItem */
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    switch (shortcutItem.type.integerValue)
    {
        case 1:
        {
            /*
             这个地方可以直接设置成想要的 vc 但是这个用起来不够爽 体验不好
             
             这个地方实际上我建议使用通知来控制
             [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoViewController" object:self userInfo:@{@"type":@"添加账号"}];
             
             最好做个双保险的  先检查 rootVC 是否已经存在  不存在的话创建 rootVC 再到以创建的rootVC里面处理跳转逻辑
             
             ps: 因为现在的支付宝还有微信都是这么处理的  在特定的页面打开以后  依然可以继续玩其他的功能
             */
            
            [self setTabbarControllerWithIdentifier:@"shortcut"];
        }
        default:
            break;
    }
}

- (void)createSqlite {
    
    [LZSqliteTool LZCreateSqliteWithName:LZSqliteName];
    [LZSqliteTool LZDefaultDataBase];
    [LZSqliteTool LZCreateDataTableWithName:LZSqliteDataTableName];
    [LZSqliteTool LZCreateGroupTableWithName:LZSqliteGroupTableName];
    [LZSqliteTool createPswTableWithName:LZSqliteDataPasswordKey];
    
    NSInteger groups = [LZSqliteTool LZSelectElementCountFromTable:LZSqliteGroupTableName];
    NSInteger count = [LZSqliteTool LZSelectElementCountFromTable:LZSqliteDataTableName];
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    BOOL isDataInit = [[us objectForKey:@"dataAlreadyInit"] boolValue];
    if (count <= 0 && groups <= 0 && !isDataInit) {
        
        [self creatData];
    }
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    BOOL isPswAlreadySaved = [[df objectForKey:@"pswAlreadySavedKey"] boolValue];
    
    if (!isPswAlreadySaved) {
        NSString *psw = [df objectForKey:@"redomSavedKey"];
        
        if (psw.length > 0) {
            
            [LZSqliteTool LZInsertToPswTable:LZSqliteDataPasswordKey passwordKey:LZSqliteDataPasswordKey passwordValue:psw];
        }
        
        [df setBool:YES forKey:@"pswAlreadySavedKey"];
    }
}

- (void)creatData {
    
    LZGroupModel *group = [[LZGroupModel alloc]init];
    group.groupName = @"未分组";
    
    [LZSqliteTool LZInsertToGroupTable:LZSqliteGroupTableName model:group];
    
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    [us setBool:YES forKey:@"dataAlreadyInit"];
    [us synchronize];
    
    return;
    LZGroupModel *group1 = [[LZGroupModel alloc]init];
    group1.groupName = @"社交";
    
    [LZSqliteTool LZInsertToGroupTable:LZSqliteGroupTableName model:group1];
    
    LZGroupModel *group2 = [[LZGroupModel alloc]init];
    group2.groupName = @"博客";
    
    [LZSqliteTool LZInsertToGroupTable:LZSqliteGroupTableName model:group2];
    
    LZDataModel *model = [[LZDataModel alloc]init];
    model.userName = @"lqq200912408";
    model.nickName = @"流火绯瞳";
    model.password = @"123456789";
    model.urlString = @"http://blog.csdn.net/lqq200912408";
    model.groupName = @"博客";
    model.email = @"lqq200912408@163.com";
    model.dsc = @"CSDN博客";
    model.groupID = group2.identifier;
    
    [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model];
    
    LZDataModel *model1 = [[LZDataModel alloc]init];
    model1.userName = @"302934443";
    model1.nickName = @"麦的守护";
    model1.password = @"123456789";
    model1.groupID = group1.identifier;
    model1.groupName = @"社交";
    model1.email = @"302934443@qq.com";
    model1.dsc = @"QQ号";
    
    [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model1];
    
    LZDataModel *model2 = [[LZDataModel alloc]init];
    model2.userName = @"lqq200912408";
    model2.nickName = @"追梦";
    model2.password = @"123456789";
    
    model2.groupName = @"未分组";
    model2.email = @"lqq200912408@163.com";
    model2.groupID = group.identifier;
    
    [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model2];
    
    LZDataModel *model3 = [[LZDataModel alloc]init];
    model3.userName = @"lqq200912408";
    model3.nickName = @"简书";
    model3.password = @"123456789";
    model3.urlString = @"http://blog.csdn.net/lqq200912408";
    model3.groupName = @"未分组";
    model3.groupID = group.identifier;
    
    [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model3];
}

- (void)setTabbarControllerWithIdentifier:(NSString *)identifier {
    
//    self.window.rootViewController = tabbar;
    
    LZMainViewController *main = [[LZMainViewController alloc]init];
    if (identifier!=nil)
    {
        main.flog = identifier;
    }
    
//    LZBaseNavigationController *mainNav = [[LZBaseNavigationController alloc]initWithRootViewController:main];
    
    LZSettingViewController *setting = [[LZSettingViewController alloc]init];
//    LZBaseNavigationController *setNav = [[LZBaseNavigationController alloc]initWithRootViewController:setting];
    
    LZAllViewController *all = [[LZAllViewController alloc]init];
    
//    LZBaseNavigationController *allNav = [[LZBaseNavigationController alloc]initWithRootViewController:all];
    
    
    LZTabBarController *tabbar = [LZTabBarController createTabBarController:^LZTabBarConfig *(LZTabBarConfig *config) {
        
        config.viewControllers = @[main, all, setting];
        config.titles = @[@"分组", @"搜索", @"设置"];
        config.isNavigation = NO;
        
        config.selectedImages = @[@"main_selected", @"search_selected", @"setting_selected"];
        config.normalImages = @[@"main_unselected", @"search_unselected", @"setting_unselected"];
        config.selectedColor = LZColorBase;
        return config;
    }];
    
    
    LZBaseNavigationController *nav = [[LZBaseNavigationController alloc]initWithRootViewController:tabbar];
    
    nav.hidesBottomBarWhenPushed = YES;
    
    self.window.rootViewController = nav;
}

- (void)verifyPassword {
    
    if ([LZGestureTool isGestureEnable]) {
        
        [[LZGestureScreen shared] show];
        
        if ([[TouchIdUnlock sharedInstance] canVerifyTouchID]) {
            
            [[TouchIdUnlock sharedInstance] startVerifyTouchID:^{
                
                [[LZGestureScreen shared] dismiss];
            }];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
//    [self verifyPassword];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self verifyPassword];
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
