//
//  LZEditViewController.h
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/1.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZBaseViewController.h"
#import "LZDataModel.h"
#import "LZGroupModel.h"

@interface LZEditViewController : LZBaseViewController

@property (strong, nonatomic)LZDataModel *model;
@property (strong, nonatomic)LZGroupModel *defaultGroup;
@end
