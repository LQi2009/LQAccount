//
//  LZFoldButton.h
//  LZFoldButton
//
//  Created by Artron_LQQ on 16/5/5.
//  Copyright © 2016年 Artup. All rights reserved.
//
/**
 说明:设置该view的属性时,请不要使用系统默认的,请使用我定义的,
     为避免与系统冲突,全部以lz开头,具体属性的功能,我都加了注释,
     请根据注释设置
     属性较多,不需要全部设置,根据自身需求进行设置即可,
     未设置的属性,我都设置了默认值,有的是系统默认值
     初始化的时候请使用我提供的初始化方法
 */

#import <UIKit/UIKit.h>

@class LZFoldButton;
@protocol LZFoldButtonDelegate <NSObject>

-(void)LZFoldButton:(LZFoldButton*)foldButton didSelectObject:(id)obj;
@end

//按钮的样式,图片在左侧和在右侧两种
typedef NS_ENUM(NSInteger,LZFoldButtonType) {
    LZFoldButtonTypeNormal = 0,//
    LZFoldButtonTypeRight  = 1,//图片在右
};
////展开的方向
//typedef NS_ENUM(NSInteger,LZUnfoldOrientation) {
//    LZUnfoldOrientationUp    = 0,
//    LZUnfoldOrientationLeft  = 1,
//    LZUnfoldOrientationRight = 2,
//    LZUnfoldOrientationDown  = 3,
//};

//block 回调返回选中结果
typedef void(^LZFoldButtonBlock)(id obj);

@interface LZFoldButton : UIView

/** 设置按钮的样式 */
@property (assign,nonatomic)LZFoldButtonType lzButtonType;

/** 设置按钮标题字号 */
@property (assign,nonatomic)CGFloat lzTitleFontSize;
/** 选择后是否改变title为选择的内容,默认YES */
@property (assign,nonatomic)BOOL lzTitleChanged;
/** 按钮的选中状态 */
@property (assign,nonatomic,readonly)BOOL lzSelected;
/** 设置按钮的代理 */
@property (weak,nonatomic) id <LZFoldButtonDelegate> lzDelegate;
/** 以block形式回调选中结果 */
@property (copy,nonatomic) LZFoldButtonBlock lzResultBlock;

#pragma mark - 以下是设置展开后的下拉列表相关信息
/** 设置展开的视图背景色 */
@property (strong,nonatomic)UIColor *lzColor;
/** 设置展开后的视图透明度 */
@property (assign,nonatomic)CGFloat lzAlpha;

/** 设置下拉列表文字大小 */
@property (assign,nonatomic)CGFloat lzFontSize;
/** 设置下拉列表文字颜色 */
@property (strong,nonatomic)UIColor *lzFontColor;
/** 展开列表的高度 默认 200 */
@property (assign,nonatomic)CGFloat lzHeight;


/**
 *  @author LQQ, 16-05-06 13:05:46
 *
 *  按钮的初始化方法
 *
 *  @param frame frame
 *  @param dataArray 需要在列表显示的数据源
 *
 *  @return 返回初始化的对象
 */
-(instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray<NSString *> *)dataArray;

/** 外部关闭列表的方法 */
- (void)LZCloseTable;

/** 外部打开列表的方法 */
- (void)LZOpenTable;

/** 设置按钮的标题 */
- (void)LZSetTitle:(NSString*)title forState:(UIControlState)state;
/** 设置按钮的标题颜色 */
-(void)LZSetTitleColor:(UIColor*)color forState:(UIControlState)state ;
/** 设置按钮的背景图片 */
- (void)LZSetBackgroundImage:(UIImage *)image forState:(UIControlState)state;
/** 设置按钮的图片 */
- (void)LZSetImage:(UIImage *)image forState:(UIControlState)state;

- (void)LZReloadData;
@end


