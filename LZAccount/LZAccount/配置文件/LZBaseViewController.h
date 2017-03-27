//
//  LZBaseViewController.h
//  LZAccount
//
//  Created by Artron_LQQ on 16/5/30.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^lzButtonBlock)(UIButton* button);
@interface LZBaseViewController : UIViewController

@property (nonatomic,strong)UIButton *leftButon;
@property (nonatomic,strong)UIButton *rightButton;
@property (nonatomic,strong)UILabel *customTitleLabel;

@property (nonatomic,copy)NSString *flog;

- (void)lzSetNavigationTitle:(NSString*)title;
- (void)lzSetLeftButtonWithTitle:(NSString*)title
                   selectedImage:(NSString*)selectImageName
                     normalImage:(NSString*)normalImage
                     actionBlock:(lzButtonBlock)block;

- (void)lzSetRightButtonWithTitle:(NSString*)title
                    selectedImage:(NSString*)selectImageName
                      normalImage:(NSString*)normalImage
                      actionBlock:(lzButtonBlock)block;

- (void)lzHiddenNavigationBar:(BOOL)hidden;
@end
