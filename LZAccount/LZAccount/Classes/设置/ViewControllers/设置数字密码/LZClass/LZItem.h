//
//  LZItem.h
//  LZPasswordView
//
//  Created by Artron_LQQ on 2016/10/19.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <UIKit/UIKit.h>
static CGFloat itemLineWidth = 16.0;
static CGFloat itemCicleRadius = 16.0;
typedef NS_ENUM(NSInteger, LZItemStyle) {
    
    LZItemStyleLine = 0,
    LZItemStyleCicle = 1,
};
@interface LZItem : UIView

@property (nonatomic, assign) LZItemStyle style;
@end
