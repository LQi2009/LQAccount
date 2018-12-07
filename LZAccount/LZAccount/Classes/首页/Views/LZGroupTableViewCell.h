//
//  LZGroupTableViewCell.h
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/4.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZGroupTableViewCell : UITableViewCell

@property (copy,nonatomic)NSString *title;
@property (copy,nonatomic)NSString *detailTitle;
@property (assign,nonatomic)BOOL editEnabled;
@end
