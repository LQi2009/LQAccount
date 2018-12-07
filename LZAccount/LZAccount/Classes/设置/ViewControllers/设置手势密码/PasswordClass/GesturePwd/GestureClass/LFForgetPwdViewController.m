//
//  LFForgetPwdViewController.m
//  CardManager
//
//  Created by MacBook_liufei on 16/1/11.
//  Copyright © 2016年 Madiffer. All rights reserved.
//

#import "LFForgetPwdViewController.h"

@interface LFForgetPwdViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation LFForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.backBtn.layer.cornerRadius = 3.f;
    self.backBtn.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtnClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
