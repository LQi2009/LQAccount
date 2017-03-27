//
//  LZWarnLabel.h
//  LZGestureSecurity
//
//  Created by Artron_LQQ on 2016/10/18.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CALayer (Anim)

/*
 *  摇动
 */
-(void)shake;

@end

@interface LZWarnLabel : UILabel

/*
 *  普通提示信息
 */
-(void)showNormalMsg:(NSString *)msg;


/*
 *  警示信息
 */
-(void)showWarnMsg:(NSString *)msg;

/*
 *  警示信息(shake)
 */
-(void)showWarnMsgAndShake:(NSString *)msg;

- (void)showSuccessMsg;
@end
