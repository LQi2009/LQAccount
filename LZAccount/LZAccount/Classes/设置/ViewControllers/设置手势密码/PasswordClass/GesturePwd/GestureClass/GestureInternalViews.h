//
//  GestureInternalViews.h
//  v1.0
//  by OYXJ, Hawking.HK@gmail.com

#import <UIKit/UIKit.h>

/*
 界面，仿照 QQ的手势锁屏
 */
@interface GestureInternalViews : NSObject

@property(nonatomic, strong) UILabel     * titleLabel;         //页面标题

@property(nonatomic, strong) UIImageView * headImageView;      //顶部图片
@property(nonatomic, strong) UILabel     * headLabel;          //顶部文字

@property(nonatomic, strong) UILabel     * autoDismissLabel;   //自动消失的提示语

@property(nonatomic, strong) UIButton    * btnForgetGesturePwd; //忘记手势密码
@property(nonatomic, strong) UIView      * lineView;            //细线
@property(nonatomic, strong) UIButton    * btnTouchIdUnlock;    //指纹解锁

@end
