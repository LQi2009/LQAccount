//
//  LZGestureScreen.m
//  LZGestureSecurity
//
//  Created by Artron_LQQ on 2016/10/17.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZGestureScreen.h"
#import "LZGestureViewController.h"

@interface LZGestureScreen ()<LZGestureViewDelegate>
{
    LZGestureViewController *_gestureVC;
}
@property (nonatomic, strong) UIWindow *window;
@end
@implementation LZGestureScreen

+ (instancetype)shared {
    
    static dispatch_once_t onceToken;
    static LZGestureScreen *share = nil;
    dispatch_once(&onceToken, ^{
        
        share = [[self alloc]init];
    });
    
    return share;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        _window.windowLevel = UIWindowLevelStatusBar;
        
        UIViewController *vc = [[UIViewController alloc]init];
        _window.rootViewController = vc;
    }
    
    return self;
}

- (void)show {
    
    self.window.hidden = NO;
    [self.window makeKeyWindow];
    self.window.windowLevel = UIWindowLevelStatusBar;
    
    
    LZGestureViewController *viV = [[LZGestureViewController alloc]init];
    viV.delegate = self;
    [viV showInViewController:self.window.rootViewController type:LZGestureTypeScreen];
    _gestureVC = viV;
}

- (void)dismiss {
    
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        
        [self.window resignKeyWindow];
        self.window.windowLevel = UIWindowLevelNormal;
        self.window.hidden = YES;
    }];
}

- (void)dealloc {
    if (self.window) {
        self.window = nil;
    }
}

- (void)gestureViewVerifiedSuccess:(LZGestureViewController *)vc {
    
    [self performSelector:@selector(hide) withObject:nil afterDelay:0.6];
    
}

- (void)hide {
    [self.window resignKeyWindow];
    self.window.windowLevel = UIWindowLevelNormal;
    self.window.hidden = YES;
}
@end
