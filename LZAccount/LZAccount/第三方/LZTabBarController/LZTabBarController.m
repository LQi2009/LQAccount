//
//  LZTabBarController.m
//  LZTabBarController
//
//  Created by Artron_LQQ on 2016/12/12.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZTabBarController.h"
#import "LZTabBar.h"

static CGFloat lzTabBarHeight = 49.0;
@interface LZTabBarController ()<LZTabBarDelegate>

@property (nonatomic, strong) LZTabBar *customTabBar;
@property (nonatomic, strong) LZTabBarConfig *config;
@end

@implementation LZTabBarController
- (LZTabBar *)customTabBar {
    
    if (_customTabBar == nil) {
        _customTabBar = [[LZTabBar alloc]init];
        _customTabBar.delegate = self;
    }
    
    return _customTabBar;
}

+ (instancetype)createTabBarController:(tabBarBlock)block {
    static dispatch_once_t onceToken;
    static LZTabBarController *tabBar;
    dispatch_once(&onceToken, ^{
        
        tabBar = [[LZTabBarController alloc]initWithBlock:block];
    });
    
    return tabBar;
}

+ (instancetype)defaultTabBarController {
    
    return [LZTabBarController createTabBarController:nil];
}

- (void)hiddenTabBarWithAnimation:(BOOL)isAnimation {
    
    if (isAnimation) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.customTabBar.alpha = 0;
        }];
    } else {
        
        self.customTabBar.alpha = 0;
    }
}

- (void)showTabBarWithAnimation:(BOOL)isAnimation {
    
    if (isAnimation) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.customTabBar.alpha = 1.0;
        }];
    } else {
        
        self.customTabBar.alpha = 1.0;
    }
}

- (instancetype)initWithBlock:(tabBarBlock)block {
    
    self = [super init];
    if (self) {
        
        LZTabBarConfig *config = [[LZTabBarConfig alloc]init];
        
        NSAssert(block, @"Param 'block' in zhe function, can not be nil");
        if (block) {
            
            _config = block(config);
        }
        
        NSAssert(_config.viewControllers, @"Param 'viewControllers' in the 'config', can not be nil");
        [self setupViewControllers];
        [self setupTabBar];
        
        _isAutoRotation = YES;
    }
    
    return self;
}

- (void)setupViewControllers {
    
    if (_config.isNavigation) {
        
        NSMutableArray *vcs = [NSMutableArray arrayWithCapacity:_config.viewControllers.count];
        for (UIViewController *vc in _config.viewControllers) {
            if (![vc isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                [vcs addObject:nav];
            } else {
                [vcs addObject:vc];
            }
        }
        
        self.viewControllers = [vcs copy];
    } else {
        
        self.viewControllers = [_config.viewControllers copy];
    }
}

- (void)setupTabBar {
    
    NSMutableArray *items = [NSMutableArray array];
    
    LZTabBarItemType type;
    
    if ((_config.selectedImages.count > 0 || _config.normalImages.count > 0) && _config.titles.count > 0) {
        type = LZTabBarItemTypeDefault;
    } else if ((_config.selectedImages.count > 0 || _config.normalImages.count > 0) && _config.titles.count <= 0) {
        
        type = LZTabBarItemTypeImage;
    } else if ((_config.selectedImages.count <= 0 && _config.normalImages.count <= 0) && _config.titles.count > 0) {
        
        type = LZTabBarItemTypeText;
    } else {
        
        type = LZTabBarItemTypeDefault;
    }
    
    for (int i = 0; i < _config.viewControllers.count; i++) {
        LZTabBarItem *item = [[LZTabBarItem alloc]init];
        
        item.type = type;
        
        if (i == 0) {
            
            item.icon = _config.selectedImages[i];
            if (_config.titles.count > 0) {
                item.titleColor = _config.selectedColor;
            }
        } else {
            
            item.icon = _config.normalImages[i];
            if (_config.titles.count > 0) {
                
                item.titleColor = _config.normalColor;
            }
            
        }
        if (i < _config.titles.count) {
            
            item.title = _config.titles[i];
        }
        
        [items addObject:item];
        item.tag = i;
    }
    // 隐藏掉系统的tabBar
    self.tabBar.hidden = YES;
    self.customTabBar.items = [items copy];
    self.customTabBar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - lzTabBarHeight, CGRectGetWidth(self.view.frame), lzTabBarHeight);
    [self.view addSubview:self.customTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectedIndex = 0;
}

#pragma mark - LZTabBarDelegate
- (void)tabBar:(LZTabBar *)tab didSelectItem:(LZTabBarItem *)item atIndex:(NSInteger)index {
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
    for (UIView *view in tab.subviews) {
        if ([view isKindOfClass:[LZTabBarItem class]]) {
            
            [items addObject:view];
        }
    }
    
    for (int i = 0; i < items.count; i++) {
        
        UIView *view = items[i];
        if ([view isKindOfClass:[LZTabBarItem class]]) {
            LZTabBarItem *item = (LZTabBarItem *)view;
            item.icon = self.config.normalImages[i];
            if (self.config.titles.count > 0) {
                
                item.titleColor = _config.normalColor;
            }
            
        }
    }
    
    item.icon = self.config.selectedImages[index];
    
    if (self.config.titles.count > 0) {
        
        item.titleColor = self.config.selectedColor;
    }
    
    self.selectedIndex = index;
}

// 屏幕旋转时调整tabbar
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    self.customTabBar.frame = CGRectMake(0, size.height - lzTabBarHeight, size.width, lzTabBarHeight);
}

- (BOOL)shouldAutorotate {
    
    return self.isAutoRotation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.isAutoRotation) {
        
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        
        return UIInterfaceOrientationMaskPortrait;
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


@implementation LZTabBarConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        
        _isNavigation = YES;
        _normalColor = [UIColor grayColor];
        _selectedColor = [UIColor redColor];
    }
    
    return self;
}
@end
