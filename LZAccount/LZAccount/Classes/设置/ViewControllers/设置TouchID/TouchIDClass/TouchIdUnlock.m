//
//  TouchIdUnlock.m
//  v1.0
//  by OYXJ, Hawking.HK@gmail.com

#import "TouchIdUnlock.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <AudioToolbox/AudioToolbox.h>


@implementation TouchIdUnlock

/**
 单例
 */
+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static TouchIdUnlock *sharedInstance;
    
    dispatch_once(&once, ^{
        
        sharedInstance = [[self alloc] init];
        
    });
    
    return sharedInstance;
}


- (id)init
{
    self = [super init];
    if (self)
    {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        if(appName.length <= 0)
            appName = @"";
        
        _appName = [[NSString alloc] initWithString:appName];
    }
    return self;
}


#pragma mark - 公开方法 part 1

/*
 保存用户配置：用户是否 想使用touchID解锁
 */
- (void)save_TouchIdEnabledOrNotByUser_InUserDefaults:(BOOL)isEnabled
{
    NSNumber * isEnabledNum = [NSNumber numberWithBool:isEnabled];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:isEnabledNum forKey:KEY_UserDefaults_isTouchIdEnabledOrNotByUser];
    [userDefaults synchronize];
}

/**
 读取用户配置：用户是否 想使用touchID解锁
 */
- (BOOL)isTouchIdEnabledOrNotByUser
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber * isEnabledNum = [userDefaults objectForKey:KEY_UserDefaults_isTouchIdEnabledOrNotByUser];
    
    return [isEnabledNum boolValue];
}

/**
 iOS 操作系统：是否 能够使用touchID解锁
 */
- (BOOL)isTouchIdEnabledOrNotBySystem
{
#ifdef __IPHONE_8_0
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError])
    {
        /**
         可以验证指纹
         */
        return YES;
    }
    else
    {
        /**
         无法验证指纹
         */
        return NO;
    }
#else
    /**
     无法验证指纹
     */
    return NO;
#endif  /* __IPHONE_8_0 */
    
}


#pragma mark - 公开方法 part 2

/**
 能否 进行校验指纹(即，指纹解锁)
 */
- (BOOL)canVerifyTouchID
{
#ifdef __IPHONE_8_0
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError])
    {
        /**
         读取用户配置：用户是否 想使用touchID解锁
         */
        BOOL isEnabled = [self isTouchIdEnabledOrNotByUser];
        
        if (isEnabled) {
            
        /** 可以进行 验证指纹*/
            return YES;
            
        } else {
            
            /**不能进行 验证指纹*/
            return NO;
        }
        
    } else {
        /**
           无法验证指纹
         */
        return NO;
    }
#else
    /**
     无法验证指纹
     */
    return NO;
#endif /* __IPHONE_8_0 */
}

/**
 *  校验指纹(即，指纹解锁)
 *
 *  @param completionBlock 块，当校验手势密码成功之后，在主线程执行。
 */
- (void)startVerifyTouchID:(void (^)(void))completionBlock
{
    NSString *myLocalizedReasonString = [NSString stringWithFormat:@"通过验证指纹解锁%@", _appName];
    if (_reasonThatExplainAuthentication.length) {
        myLocalizedReasonString = _reasonThatExplainAuthentication;
    }
    

#ifdef __IPHONE_8_0
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    
    // Hide "Enter Password" button
    myContext.localizedFallbackTitle = @"";
    
    // show the authentication UI
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError])
    {
        /**
         读取用户配置：用户是否 想使用touchID解锁
         */
        BOOL isEnabled = [self isTouchIdEnabledOrNotByUser];
        
        if (!isEnabled) {
            
            /**
             如果用户拒绝使用touchID解锁，则 显示提醒。
             */
            [self showAlertIfUserDenied];
            
            return;
        }
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    // User authenticated successfully, take appropriate action
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        /**
                                         指纹校验 成功
                                         */
                                        [self authenticatedSuccessfully:completionBlock];
                                    });
                                    
                                } else {
                                    // User did not authenticate successfully, look at error and take appropriate action
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        /**
                                         指纹校验 失败
                                         */
                                        [self authenticatedFailedWithError:error];
                                    });
                            
                                }
                            }];
    }
    else
    {
        // Could not evaluate policy; look at authError and present an appropriate message to user
        
        dispatch_async(dispatch_get_main_queue(), ^{
            /**
             无法校验指纹
             */
            [self evaluatePolicyFailedWithError:nil];
        });
        
    }
    
#endif  /* __IPHONE_8_0 */
}


#pragma mark -



#pragma mark - 私有方法

/**
 如果用户拒绝使用touchID解锁，则 显示提醒。
 */
- (void)showAlertIfUserDenied
{
    NSString * title = [NSString stringWithFormat:@"未开启%@指纹解锁", _appName];
    NSString * msg = [NSString stringWithFormat:@"请在%@设置－开启Touch ID指纹解锁", _appName];
    if (_alertMessageToShowWhenUserDisableTouchID.length) {
        msg = _alertMessageToShowWhenUserDisableTouchID;
    }
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message: msg delegate: nil cancelButtonTitle: @"知道了" otherButtonTitles: nil, nil];
    
    [alertView show];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
    
#else
    
#endif
}


/**
 指纹校验 成功
 */
- (void)authenticatedSuccessfully:(void (^)(void))completionBlock
{
    if (completionBlock) {
        completionBlock();
    }
}

/**
 指纹校验 失败
 */
- (void)authenticatedFailedWithError:(NSError *)error
{
    
    if (error.code == -1)
    {
        /**
         震动
         */
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

/**
 无法校验指纹
 */
- (void)evaluatePolicyFailedWithError:(NSError *)error
{
    NSLog(@"无法校验指纹");
}


@end
