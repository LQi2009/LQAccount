//
//  LZMainHeaderView.h
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/1.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickBlock)(BOOL select);
@interface LZMainHeaderView : UITableViewHeaderFooterView

@property (assign, nonatomic)BOOL select;
@property (copy, nonatomic)NSString *text;

- (void)lzHeaderViewClickedWithBlock:(clickBlock)block;
@end
