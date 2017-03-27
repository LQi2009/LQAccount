//
//  GestureLockScreen.m
//  v1.0
//  by OYXJ, Hawking.HK@gmail.com

#import "GestureLockScreen.h"
#import "GestureTool_Public.h"
#import "TouchIdUnlock.h"

#import "AppDelegate.h"

@interface GestureLockScreen ()

@property (nonatomic, copy)checkStatus success;
@end

@implementation GestureLockScreen

#pragma mark - 公开方法

/**
 单例
 */
+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static GestureLockScreen *sharedInstance;
    
    dispatch_once(&once, ^{
        
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
- (void)showGestureWindowByType:(GestureLockScreenType)aGestureLockScreenType checkResult:(checkStatus)success {
    
    self.success = success;
    
    [self showGestureWindowByType:aGestureLockScreenType];
}

- (void)showGestureWindowByType:(GestureLockScreenType)aGestureLockScreenType
{
    _gestureWindow.windowLevel = UIWindowLevelStatusBar;
    _gestureWindow.hidden = NO;
    
    if (!_gestureViewCtl.presentingViewController) {
        [_gestureWindow.rootViewController presentViewController:_gestureViewCtl
                                                        animated:NO
                                                    completion:^{
                                                  }];
    }
    
    
    /*
     默认: 设置 手势密码
     */
    DrawPatternCtlType drawPatternCtlType = kDrawPatternCtlTypeGesturePwdSetup;
    
    /*
     在NSUserDefaults中，是否 已经保存了手势密码
     */
    BOOL isHasGesturePwdString = [GestureTool_Public isHasGesturePwdStringWhichSavedInNSUserDefaults];
    if (!isHasGesturePwdString)
    {//还没有设置手势密码，那么 去设置 手势密码
        drawPatternCtlType = kDrawPatternCtlTypeGesturePwdSetup;    //设置 手势密码
    }
    else
    {//已经设置过手势，那么 去验证 手势密码
        drawPatternCtlType = kDrawPatternCtlTypeGesturePwdVerify;   //验证 手势密码
        
        if (aGestureLockScreenType == kDrawPatternCtlTypeGesturePwdModify)
        {//外部调用当前方法，去修改 手势密码
            drawPatternCtlType = kDrawPatternCtlTypeGesturePwdModify;   //修改 手势密码
        }
    }
    
    
    switch (aGestureLockScreenType) {
        case GestureLockScreenTypeGesturePwdSetup:
        {//登录成功后 --- 设置 手势密码
            //do nothing
        }break;
            
        case GestureLockScreenTypeGesturePwdModify:
        {//设置页面的 --- 修改 手势密码
            //do nothing
        }break;
            
        case GestureLockScreenTypeGesturePwdVerify:
        {//已设过手势 --- 验证 手势密码
            //do nothing
        }break;
            
        default:
            break;
    }
    
    /*
     手势界面样式
     */
    _gestureViewCtl.drawPatternCtlType = drawPatternCtlType;
    _gestureViewCtl.currentAccountStr = self.currentAccountStr;
}

- (void)hide
{
    
    [_gestureWindow.rootViewController dismissViewControllerAnimated:_gestureViewCtl completion:^{
        
        _gestureWindow.windowLevel = UIWindowLevelNormal;
        _gestureWindow.hidden = YES;
    }];
}



#pragma mark - life cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        _gestureWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _gestureViewCtl = [DrawPatternLockViewController sharedInstance];
        _gestureViewCtl.hiddenNavigationBar = YES;
        UIViewController * vc = [[UIViewController alloc] init];
        _gestureWindow.rootViewController = vc;
        
        vc.view.frame = _gestureWindow.bounds;
        _gestureViewCtl.view.frame = _gestureWindow.bounds;
        
        _gestureWindow.windowLevel = UIWindowLevelStatusBar;
        _gestureViewCtl.delegate = self;
        
        _login = NO;
    }
    return self;
}

- (void)dealloc
{
    if (_gestureWindow) {
        _gestureWindow = nil;
    }
    if (_gestureViewCtl) {
        _gestureViewCtl = nil;
    }
    
    
}




#pragma mark - 手势委托

/**
 *  完成手势绘制
 *
 *  @param drawPatternCtl 手势界面
 *  @param key            手势密码
 */
- (void)drawPatternLockViewController:(DrawPatternLockViewController *)drawPatternCtl
             finishDrawPatternWithKey:(NSString *)key
{
    switch (drawPatternCtl.drawPatternCtlType) {
        case kDrawPatternCtlTypeGesturePwdSetup:  //登录成功后 --- 设置 手势密码
        {//设置 新的手势密码，成功。

            
        }break;
            
        case kDrawPatternCtlTypeGesturePwdModify: //设置页面的 --- 修改 手势密码
        {//修改 手势密码，成功。
            
            
        }break;
            
        case kDrawPatternCtlTypeGesturePwdVerify: //已设过手势 --- 验证 手势密码
        {//验证手势密码，失败 或 成功。
            
            if (self.success) {
                
                self.success();
            }
            
            if (drawPatternCtl.isBtnForgetGesturePwdClicked)
            {//忘记手势密码。代码默认把isBtnForgetGesturePwdClicked设为YES。
                
                /**
                 验证手势密码，失败。
                 */
                
                [self hide];
                
                return;
            }
            else
            {//忘记手势密码，成功。
                
                //继续下面的代码。
                
                [self hide];
            }
            
            
            /**
             验证已有手势成功，则显示登录界面 或 显示主界面。具体如下:
             */
            
            /*
             
            if (![BusinessManager sharedManager].systemAccountManager.isLoginSuccess)
            {//app终止运行，则 自动登录。
               

                SystemAccount *lastSysAccount = [[BusinessManager sharedManager].systemAccountManager lastLoginSystemAccount];
                
                if (lastSysAccount) {
                    //自动登录
                    [self showLoginViewController:lastSysAccount autoLogin:YES];
                }

                
            }
            else
            {//app从后台进入前台
                
                NSDate *curDate = [NSDate date];
                NSDate *expireDate = [BusinessManager sharedManager].systemAccountManager.tokenExpireDate;
                if ([expireDate compare:curDate] == NSOrderedAscending)
                {//token已经失效，则 自动登录。
                    

                    SystemAccount *lastSysAccount = [[BusinessManager sharedManager].systemAccountManager lastLoginSystemAccount];
                    
                    if (lastSysAccount) {
                        //自动登录
                        [self showLoginViewController:lastSysAccount autoLogin:YES];
                    }

                    
                }
                else
                {//token没有失效，则 显示主界面。
                    

                     //显示主界面
                     [self showMainViewController];

                    
                    
                    //刷新aas token（服务器没有下发token的失效时间）
                    [[BusinessManager sharedManager].systemAccountManager refreshToken];
                    //重新启动计数器
                    [[BusinessManager sharedManager].systemAccountManager startRefreshTokenTimer];
                }
            }
             
             */
            
        }break;
            
        default:
            break;
    }
    
}

/**
 *  忘记手势密码
 *
 *  @param drawPatternCtl 手势界面
 *  @param btn            按钮
 */
- (void)drawPatternLockViewController:(DrawPatternLockViewController *)drawPatternCtl
                     forgetGesturePwd:(UIButton *)btn
{
    switch (drawPatternCtl.drawPatternCtlType) {
        case kDrawPatternCtlTypeGesturePwdSetup:  //登录成功后 --- 设置 手势密码
        {
            //do nothing
        }break;
            
        case kDrawPatternCtlTypeGesturePwdModify: //设置页面的 --- 修改 手势密码
        {
            //do nothing
        }break;
            
        case kDrawPatternCtlTypeGesturePwdVerify: //已设过手势 --- 验证 手势密码
        {
            /*
            SystemAccount * curSysAccount = [[BusinessManager sharedManager].systemAccountManager currentLoginSystemAccount];
            curSysAccount.password = nil;//清除密码
            curSysAccount.isSavePwd = [NSNumber numberWithBool:NO];//不记住密码
            [[BusinessManager sharedManager].systemAccountManager save];
            
            
            [[BusinessManager sharedManager].systemAccountManager logout];
            */
            
        }break;
            
        default:
            break;
    }
    
}

/**
 *  指纹解锁
 *
 *  @param drawPatternCtl 手势界面
 *  @param btn            按钮
 */
- (void)drawPatternLockViewController:(DrawPatternLockViewController *)drawPatternCtl
                        touchIdUnlock:(UIButton *)btn
{
    switch (drawPatternCtl.drawPatternCtlType) {
        case kDrawPatternCtlTypeGesturePwdSetup:  //登录成功后 --- 设置 手势密码
        {
            //do nothing
        }break;
            
        case kDrawPatternCtlTypeGesturePwdModify: //设置页面的 --- 修改 手势密码
        {
            //do nothing
        }break;
            
        case kDrawPatternCtlTypeGesturePwdVerify: //已设过手势 --- 验证 手势密码
        {
            //do nothing
            
            [[TouchIdUnlock sharedInstance] startVerifyTouchID:^{
                
                [[GestureLockScreen sharedInstance] hide];
                
            }];
            
        }break;
            
        default:
            break;
    }
    
}



@end
