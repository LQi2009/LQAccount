//
//  LZAboutusViewController.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/1.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZAboutusViewController.h"
#import <StoreKit/StoreKit.h>
#import "LZIntroduceViewController.h"

NSString const * _Nonnull appID = @"1123570268";

@interface LZAboutusViewController ()<SKStoreProductViewControllerDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activity;
@end

@implementation LZAboutusViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNaviBar];
    [self setupUI];
}

- (void)setupNaviBar {
    
    LZWeakSelf(ws)
    [self lzSetNavigationTitle:@"关于我们"];
    [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    
//        [self lzSetRightButtonWithTitle:nil selectedImage:@"warn" normalImage:@"warn" actionBlock:^(UIButton *button) {
//            
//            LZIntroduceViewController *introduce = [[LZIntroduceViewController alloc]init];
//            
//            [self.navigationController pushViewController:introduce animated:YES];
//        }];
}

- (void)setupUI {
    UIImageView *iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon"]];
    iconImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:iconImage];
    
    UILabel *label = [[UILabel alloc]init];
    label.textColor = LZColorFromHex(0x555555);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.text = [self getAPPVerson];
    [self.view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:@"去评价" forState:UIControlStateNormal];
    [button setTitleColor:LZColorFromHex(0x0075a9) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UILabel *lab = [[UILabel alloc]init];
    lab.text = @"Copyright© 2016 \nthe APP Developer All Rights Reserved";
    lab.font = [UIFont systemFontOfSize:12];
    lab.textColor = LZColorFromHex(0x555555);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 2;
    [self.view addSubview:lab];
    
    self.activity.frame = CGRectMake(0, 0, 80, 80);
    self.activity.center = self.view.center;
    [self.view addSubview:self.activity];
    
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(3*LZNavigationHeight);
        make.centerX.mas_equalTo(self.view);
        make.height.and.with.mas_equalTo(@100);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconImage.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.height.mas_equalTo(@30);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(lab.mas_top).offset(-LZNavigationHeight);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@100);
    }];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.left.and.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50);
        make.height.mas_equalTo(@40);
    }];
}

- (void)buttonClick:(UIButton* )button {
    
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/zhang-hao-zhu-shou/id1123570268?mt=8"];
    
    UIApplication *application = [UIApplication sharedApplication];
    
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        
        [application openURL:url options:@{}
           completionHandler:^(BOOL success) {
               
           }];
    } else {
        [application openURL:url];
    }
    
    return;
    
    SKStoreProductViewController *appStoreVc = [[SKStoreProductViewController alloc] init];
    
    appStoreVc.delegate = self;
    
//    [SVProgressHUD show];
//    [self.activity startAnimating];
//    [SVProgressHUD setDefaultStyle:<#(SVProgressHUDStyle)#>];
    [SVProgressHUD show];
    [appStoreVc loadProductWithParameters:
     
     @{SKStoreProductParameterITunesItemIdentifier : appID} completionBlock:^(BOOL result, NSError *error) {
         //block回调
         if(error){
             NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
         }else{
             
             [SVProgressHUD dismiss];
//             [self.activity stopAnimating];
             LZLog(@">>>>>%@",[NSThread currentThread]);
             //模态弹出appstore
             [self presentViewController:appStoreVc animated:YES completion:^{
                 
             }
              ];
         }
     }];
}

// 取消监听按钮
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIActivityIndicatorView *)activity {
    
    if (_activity == nil) {
        _activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activity.hidesWhenStopped = YES;
    }
    
    return _activity;
}

- (NSString *)getAPPVerson {
    
    NSDictionary *infoDic = [[NSBundle mainBundle]infoDictionary];
    
    NSString *app_verson = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return [NSString stringWithFormat:@"账号助手 v%@",app_verson];
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
