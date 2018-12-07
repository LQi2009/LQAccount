//
//  LZGestureIntroduceViewController.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/2.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZGestureIntroduceViewController.h"
#import "LZGestureSettingViewController.h"

#import "TouchIdUnlock.h"//指纹解锁

// 10.18
#import "LZGestureTool.h"
#import "LZGestureViewController.h"

@interface LZGestureIntroduceViewController ()<LZGestureViewDelegate>
{
    UIImageView * _gestureImgView;
    UIButton    * _gestureButton;
}


@end

@implementation LZGestureIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    
    [self setupNaviBar];
    [self setupMainView];
}

- (void)dealloc
{
    if (_gestureImgView) {
        _gestureImgView = nil;
    }
    if (_gestureButton) {
        _gestureButton = nil;
    }
    
}


- (void)setupNaviBar {
    
    LZWeakSelf(ws)
    [self lzSetNavigationTitle:@"创建手势密码"];
    [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        
        [ws.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)setupMainView {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    if(appName.length <= 0)
        appName = @"";
    
    _gestureImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _gestureImgView.image = [UIImage imageNamed:@"gesture_introduce"];
    _gestureImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    _gestureButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _gestureButton.layer.cornerRadius = 5.0f;
    _gestureButton.layer.masksToBounds = YES;
    
    UIImage * aImg = [self imageWithColor:[UIColor colorWithRed:56.0/255.0 green:187.0/255.0 blue:204.0/255.0 alpha:1.0]];
    [_gestureButton setBackgroundImage:aImg forState:UIControlStateNormal];
    [_gestureButton setTitle:@"创建手势密码" forState:UIControlStateNormal];
    [_gestureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_gestureButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [_gestureButton addTarget:self action:@selector(onGestureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * lb = [[UILabel alloc] init];
    lb.text = [NSString stringWithFormat:@"你可以创建一个%@解锁图片，这样他人在借用你的手机时，将无法打开%@。", appName, appName];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = [UIFont systemFontOfSize:15.0];
    lb.numberOfLines = 0;
    
    
    [self.view addSubview: _gestureImgView];
    [self.view addSubview: _gestureButton];
    [self.view addSubview: lb];

    [_gestureImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(LZNavigationHeight + 30);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(@(LZSCREEN_WIDTH));
        make.bottom.mas_equalTo(lb.mas_top).offset(-40);
    }];
    
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_gestureImgView.mas_bottom).offset(40);
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(@40);
    }];
    
    [_gestureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lb.mas_bottom).offset(40);
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(@40);
        make.bottom.mas_equalTo(self.view).offset(-40);
    }];
}

#pragma mark - 按钮事件

- (void)onGestureButtonClicked:(UIButton *)sender
{
    
    LZGestureViewController *gestureVC = [[LZGestureViewController alloc]init];
    
    gestureVC.delegate = self;
    [gestureVC showInViewController:self type:LZGestureTypeSetting];
}


#pragma mark - <LZGestureViewDelegate>
- (void)gestureView:(LZGestureViewController *)vc didSetted:(NSString *)psw {
    
    [self.navigationController popViewControllerAnimated:NO];
    [LZGestureTool saveGesturePsw:psw];
    [LZGestureTool saveGestureEnableByUser:YES];
}

#pragma mark - 自定义

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
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
