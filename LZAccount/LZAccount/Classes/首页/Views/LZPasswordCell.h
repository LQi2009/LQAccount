//
//  LZPasswordCell.h
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/1.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *passwordShowNotificationKey = @"passwordShowNotification";
typedef void(^showPasswordBlock)(BOOL show);
typedef void(^longPressGestureBlock)(NSString *string);
@interface LZPasswordCell : UITableViewCell

@property (copy,nonatomic)NSString *title;
@property (copy,nonatomic)NSString *detailTitle;
@property (assign,nonatomic)BOOL editEnabled;
@property (assign,nonatomic)BOOL showPSW;
@property (copy,nonatomic)showPasswordBlock showBlock;
@property (strong, nonatomic)UITextField *detailField;
@property (copy,nonatomic)longPressGestureBlock longPressBlock;
@end
