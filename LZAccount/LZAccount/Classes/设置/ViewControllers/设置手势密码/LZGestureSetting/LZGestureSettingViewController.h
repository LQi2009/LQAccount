//
//  LZGestureSettingViewController.h
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/2.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZBaseViewController.h"

typedef void (^PopBackBlock)(void);

@interface LZGestureSettingViewController : LZBaseViewController

/**
 返回上一级页面时调用。请使用的人，注意避免 block造成retain-cycle
 */
@property (nonatomic, copy) PopBackBlock popBackBlock;
@property (strong, nonatomic)UIView *contendView;
@end
