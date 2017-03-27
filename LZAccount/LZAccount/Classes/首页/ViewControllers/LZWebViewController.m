//
//  LZWebViewController.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/9/21.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZWebViewController.h"

@interface LZWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong)UIWebView *webView;
@end

@implementation LZWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNaviBar];
    [self setupWebView];
}

- (void)setupWebView {
    
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, LZNavigationHeight, LZSCREEN_WIDTH, LZSCREEN_HEIGHT - LZNavigationHeight)];
    web.delegate = self;
    [self.view addSubview:web];
    self.webView = web;
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [SVProgressHUD showWithStatus:@"loading..."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [SVProgressHUD showSuccessWithStatus:@"Success"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [SVProgressHUD showErrorWithStatus:@"Error"];
}

- (void)setupNaviBar {
    
    LZWeakSelf(ws)
    [self lzSetNavigationTitle:@"网址详情"];
    [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui@" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        
        [ws.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if ([self.webView isLoading]) {
        
        [self.webView stopLoading];
    }
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
