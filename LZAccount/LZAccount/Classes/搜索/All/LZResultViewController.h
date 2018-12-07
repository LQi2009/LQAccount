//
//  LZResultViewController.h
//  LZAccount
//
//  Created by Artron_LQQ on 2016/12/17.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZBaseViewController.h"

@class LZDataModel;
typedef void(^searchSelectBlock)(LZDataModel *model);
@interface LZResultViewController : LZBaseViewController<UISearchResultsUpdating>

@property (nonatomic, copy) searchSelectBlock selectResult;
@end
