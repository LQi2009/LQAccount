//
//  LZBaseNavigationController.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/5/30.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZBaseNavigationController.h"

@interface LZBaseNavigationController ()

@end

@implementation LZBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBarHidden = YES;
    
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
