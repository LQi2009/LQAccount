//
//  LZIntroduceViewController.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/14.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZIntroduceViewController.h"

@interface LZIntroduceViewController ()

@end

@implementation LZIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNaviBar];
    [self setupMainView];
}

- (void)setupNaviBar {
    [self lzSetNavigationTitle:@"介绍"];
    [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)setupMainView {
    
    NSString *string = @"账号助手是一款用于保存日常注册账户信息的工具;工作,生活,学习中,我们需要注册各种账号:微博,博客,论坛等等;时间久了,往往会忘记用户名或者密码,账号助手就是为了解决这个问题而设计的.您可以保存完整的用户信息,当然,您也可以保存帮助您记忆的提示性信息.这是一个单机应用,您不必担心您的信息会被传到网上任何地方.也是因为这是一个单机应用,当您忘记本软件的开始密码时,也意味着您不能获取保存的任何信息.";
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
