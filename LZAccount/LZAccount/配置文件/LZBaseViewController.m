//
//  LZBaseViewController.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/5/30.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZBaseViewController.h"
#import "AppDelegate.h"

@interface LZBaseViewController ()

@property (nonatomic,strong)UIView *customNavigationView;
@property (nonatomic,copy)lzButtonBlock leftButtonAction;
@property (nonatomic,copy)lzButtonBlock rightButtonAction;
@end

@implementation LZBaseViewController

- (void)dealloc {
    
    LZLog(@"%@--dealloc",NSStringFromClass([self class]));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createCustomView];
}

- (void)createCustomView {
    UIView *bgView = [UIView new];
//    bgView.backgroundColor = LZColorFromHex(0x0075a9);
    bgView.backgroundColor = LZColorBase;
    [self.view addSubview:bgView];
    self.customNavigationView = bgView;
    
    LZWeakSelf(ws)
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.mas_equalTo(ws.view);
        make.height.mas_equalTo(LZNavigationHeight);
    }];
    
//    UIView *line = [UIView new];
//    line.backgroundColor = [UIColor blackColor];
//    [bgView addSubview:line];
//    
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.and.bottom.mas_equalTo(bgView);
//        make.height.mas_equalTo(@1);
//    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    self.customTitleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView.mas_centerX);
        make.centerY.mas_equalTo(bgView.mas_centerY).offset(10);
    }];
    
//    titleLabel.text = @"首页";
//    titleLabel.backgroundColor = [UIColor greenColor];
    [titleLabel sizeToFit];
}

- (void)lzSetNavigationTitle:(NSString*)title {
    
    self.customTitleLabel.text = title;
    
    [self.customTitleLabel sizeToFit];
}

- (void)lzSetLeftButtonWithTitle:(NSString*)title selectedImage:(NSString*)selectImageName normalImage:(NSString*)normalImage actionBlock:(lzButtonBlock)block {
    if (self.leftButon == nil) {
        self.leftButon = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftButon.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.leftButon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.leftButon addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.customNavigationView addSubview:self.leftButon];
        
        LZWeakSelf(ws)
        [self.leftButon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.customNavigationView).offset(10);
            make.top.mas_equalTo(ws.customNavigationView).offset(20);
            make.bottom.mas_equalTo(ws.customNavigationView);
            make.width.mas_equalTo(@44);
        }];
    }
    
    [self.leftButon setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [self.leftButon setImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    [self.leftButon setTitle:title forState:UIControlStateNormal];
    self.leftButtonAction = block;
}

- (void)leftButtonClick:(UIButton*)button {
    button.selected = !button.selected;
    if (self.leftButtonAction != nil) {
        self.leftButtonAction(button);
    }
}

- (void)lzSetRightButtonWithTitle:(NSString*)title selectedImage:(NSString*)selectImageName normalImage:(NSString*)normalImage actionBlock:(lzButtonBlock)block {
    
    if (self.rightButton == nil) {
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.customNavigationView addSubview:self.rightButton];
        
        LZWeakSelf(ws)
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.customNavigationView).offset(-10);
            make.top.mas_equalTo(ws.customNavigationView).offset(20);
            make.bottom.mas_equalTo(ws.customNavigationView);
            make.width.mas_equalTo(@44);
        }];
    }
    
    [self.rightButton setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    [self.rightButton setTitle:title forState:UIControlStateNormal];
    self.rightButtonAction = block;
}

- (void)rightButtonClick:(UIButton*)button {
    
    if (self.rightButtonAction != nil) {
        self.rightButtonAction(button);
    }
}

- (void)lzHiddenNavigationBar:(BOOL)hidden {
    
    self.customNavigationView.hidden = hidden;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
