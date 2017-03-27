//
//  LZScreenViewController.m
//  LZAccount
//
//  Created by Artron_LQQ on 2016/10/21.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZScreenViewController.h"

@interface LZScreenViewController ()

@end

@implementation LZScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNaviBar];
}

- (void)setupNaviBar {
    [self lzSetNavigationTitle:@"关于我们"];
    [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
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
