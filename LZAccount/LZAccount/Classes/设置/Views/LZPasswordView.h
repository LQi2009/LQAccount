//
//  LZPasswordView.h
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/1.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZPasswordView : UIView

@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) BOOL showWarning;

- (void)changeViewAtIndex:(NSInteger)index;
- (void)resetView;
- (void)showWarningWithString:(NSString*)string;
@end
