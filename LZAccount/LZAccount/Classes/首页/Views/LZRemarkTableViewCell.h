//
//  LZRemarkTableViewCell.h
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/1.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZRemarkTableViewCell : UITableViewCell
//{
//    
//    NSString *detailTitle;
//}
@property (copy,nonatomic)NSString *title;
@property (copy,nonatomic)NSString *detailTitle;
@property (assign,nonatomic)BOOL editEnabled;

@property (strong, nonatomic)UITextView *textView;
@end
