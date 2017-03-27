//
//  LZGroupViewController.h
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/4.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZBaseViewController.h"

typedef void(^callBackBlock)(id model);
@interface LZGroupViewController : LZBaseViewController

@property (copy, nonatomic)callBackBlock callBack;
@end
