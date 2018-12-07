//
//  LZNumberView.h
//  LZPasswordView
//
//  Created by Artron_LQQ on 2016/10/19.
//  Copyright © 2016年 Artup. All rights reserved.
//
// 绘制密码输入界面,含有输入字符处理逻辑
// 输入结束,或达到指定条件,返回输入结果
#import <UIKit/UIKit.h>

// 密码界面样式
typedef NS_ENUM(NSInteger, LZNumberViewStyle) {
    
    LZNumberViewStyleNumberFour,// 纯数字 4 位
    LZNumberViewStyleNumberSix, // 纯数字 6 位
    LZNumberViewStyleCustom, // 自定义 数字 + 字母 + 其他
};

@protocol LZNumberViewDelegate;
@interface LZNumberView : UIView

@property (nonatomic, assign) LZNumberViewStyle style;
@property (nonatomic, assign) id <LZNumberViewDelegate>delegate;

/**
 中间视图Y坐标,在整个视图的Y坐标的百分比
 默认 0.4 中心靠上位置
 */
@property (nonatomic, assign) CGFloat position;


/**
 提示label
 */
@property (nonatomic, strong) UILabel *warnLabel;

/**
 辅助提示信息
 */
@property (nonatomic, strong) UILabel *subWarnLabel;

- (instancetype)initWithStyle:(LZNumberViewStyle)style;
- (void)becomeFirstRespond;
- (BOOL)resignFirstRespond;
- (void)reset;
@end


/**
 回调结果时,实现其中一个即可
 */
@protocol LZNumberViewDelegate <NSObject>

@optional
/**
 输入为指定位数数字时的代理回调结果
 只在输入达到指定位数时回调一次
 当style为LZNumberViewStyleNumberFour,
 LZNumberViewStyleNumberSix时,使用此代理方法回调结果

 @param view   LZNumberView实例对象
 @param string 最终输入的数字密码字符串
 */
- (void)numberView:(LZNumberView *)view didInput:(NSString *)string;

/**
 输入为不定字符及位数时的代理回调结果
 在输入过程中多次回调,最后一次为实际输入字符
 当style为LZNumberViewStyleCustom时,使用此代理方法回调结果

 @param view   LZNumberView实例对象
 @param string 最终输入的密码字符串
 */
- (void)numberView:(LZNumberView *)view shouldInput:(NSString *)string;
@end

@interface CALayer (Anim)

/**
 摇动
 */
-(void)shake;

@end
