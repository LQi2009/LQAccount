//
//  DrawPatternLockViewController.h
//  v1.0
//  by OYXJ, Hawking.HK@gmail.com

#import <UIKit/UIKit.h>
#import "DrawPatternLockView.h"
#import "LZBaseViewController.h"

@class   DrawPatternLockViewController;


#pragma mark - 委托

@protocol DrawPatternLockViewControllerDelegate <NSObject>
@optional
/*! @brief 完成手势绘制
 *
 *  @prama key 手势密码
 */
- (void)drawPatternLockViewController:(DrawPatternLockViewController *)aViewController
             finishDrawPatternWithKey:(NSString *)key;
/*! @brief
 忘记手势密码
 */
- (void)drawPatternLockViewController:(DrawPatternLockViewController *)aViewController
                     forgetGesturePwd:(UIButton *)btn;
/*! @brief
 指纹解锁
 */
- (void)drawPatternLockViewController:(DrawPatternLockViewController *)aViewController
                        touchIdUnlock:(UIButton *)btn;
@end



#pragma mark - 页面

typedef enum {
    kDrawPatternCtlTypeGesturePwdSetup = 0, //登录成功后 --- 设置 手势密码
    kDrawPatternCtlTypeGesturePwdModify,    //设置页面的 --- 修改 手势密码
    kDrawPatternCtlTypeGesturePwdVerify,    //已设过手势 --- 验证 手势密码
} DrawPatternCtlType;

/*! @brief
 手势界面，其他界面可以push或者present这个viewcontroller显示。
 界面，仿照 QQ的手势锁屏。
 */
@interface DrawPatternLockViewController : LZBaseViewController
{
    @private
    DrawPatternLockView * _v;
}
@property(nonatomic, weak) id<DrawPatternLockViewControllerDelegate> delegate;
@property(nonatomic, assign) DrawPatternCtlType drawPatternCtlType;
/**
 其它属性
 */
@property(nonatomic, strong, readonly) NSString * lastGesturePwdStr;//最后一次手势密码
/**
 辅助信息
 */
@property(nonatomic, assign, readonly) BOOL isShouldClose;//当前页面，是否 需要被关闭
@property(nonatomic, assign, readonly) BOOL isBtnForgetGesturePwdClicked;//忘记手势密码 的按钮，被点击了
@property(nonatomic, assign, readonly) BOOL isBtnTouchIdUnlockClicked;//指纹解锁 的按钮，被点击了
@property(nonatomic, assign, readonly) BOOL isShouldRecoverGestureForLastAccountStr;//是否应该恢复手势密码---登出 和 登录的账号相同时，才恢复。
@property(nonatomic, assign, readonly) NSUInteger remainedCountThatAllowVerifyFail;//剩余的次数---验证手势密码，剩余的能够验证失败的次数。
/**
 设置新的手势密码 或 修改手势密码，是否 完成。
 */
@property(nonatomic, assign, readonly) BOOL isSetupOrModifyGestureComplete;
/**
 辅助信息
 */
@property(nonatomic, strong) NSString * currentAccountStr;//当前登录帐号

@property (nonatomic,assign)BOOL hiddenNavigationBar;
/**
 单例
 */
+ (instancetype)sharedInstance;

@end
