//
//  DrawPatternLockView.h
//  v1.0
//  by OYXJ, Hawking.HK@gmail.com

#import <UIKit/UIKit.h>

/**
 是否 显示手势轨迹
 */
#ifndef KEY_UserDefaults_isShowGestureTrace
    #define KEY_UserDefaults_isShowGestureTrace  @"KEY_UserDefaults_isShowGestureTrace"
#endif
/**
 当前的类，读取NSUserDefaults中的值：
 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 NSNumber * num = [defaults objectForKey:KEY_UserDefaults_isShowGestureTrace];
 */


@interface DrawPatternLockView : UIView {
    @private
    BOOL _canDraw;
    CGPoint _trackPoint;
    NSMutableArray *_dotViews;
}


- (void)clearDotViews;
- (void)addDotView:(UIView*)view;
- (void)drawLineFromLastDotTo:(CGPoint)pt;
@end
