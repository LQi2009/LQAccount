//
//  LZGestureScreen.h
//  LZGestureSecurity
//
//  Created by Artron_LQQ on 2016/10/17.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LZGestureScreen;
@protocol LZGestureScreenDelegate <NSObject>

- (void)screen:(LZGestureScreen *)screen didSetup:(NSString *)psw;
@end
@interface LZGestureScreen : NSObject

+ (instancetype)shared;
- (void)show;
- (void)dismiss;
@end
