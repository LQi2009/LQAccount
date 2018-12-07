//
//  DrawPatternLockViewController.m
//  v1.0
//  by OYXJ, Hawking.HK@gmail.com

#import "DrawPatternLockViewController.h"
#import "GestureInternalViews.h"
#import "LFForgetPwdViewController.h"

#import "GestureDefine.h"
#import "GestureTool_Public.h"
#import "GestureTool_Private.h"

#import "TouchIdUnlock.h"

/**
 是否 显示手势轨迹
 */
#ifndef KEY_UserDefaults_isShowGestureTrace
    #define KEY_UserDefaults_isShowGestureTrace  @"KEY_UserDefaults_isShowGestureTrace"
#endif
/**
 当前的类，读取NSUserDefaults中的值：
 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 NSNumber * num = [defaults objectForKey:KEY_UserDefaults_isShowGestureTrace];
 */



#pragma mark - 页面

@interface DrawPatternLockViewController ()
{
    /*
     手势路径
     元素：[NSNumber numberWithInteger:touched.tag]]，
          其中touched是被触摸的imageView，即 矩阵中的dot点。
     */
    NSMutableArray * _paths;
    
    /**
     是否 显示手势轨迹
     */
    BOOL _isShowGestureTrace;
    
    /**
     界面，仿照 QQ的手势锁屏
     */
    GestureInternalViews * _gestureInternalViews;
    
    /**
     定时器
     */
    NSTimer * _timer;
    
    CGFloat addHeight;
}
@property(nonatomic, assign, getter=isPushed)BOOL isPushed;//push到当前页面
@property(nonatomic, assign, getter=isPopped)BOOL isPopped;//当前页面已经pop
@property(nonatomic, assign, getter=isModal) BOOL isModal; //模态到当前页面
/**
 设置新的手势密码 或 修改手势密码，是否 完成。
 */
@property(nonatomic, assign, readwrite) BOOL isSetupOrModifyGestureComplete;//设置新的手势密码 或 修改手势密码，完成。
/**
辅助信息
 */
@property(nonatomic, strong, readwrite) NSString *lastGesturePwdStr;//最后一次手势密码
@end


@implementation DrawPatternLockViewController
@synthesize delegate;


#pragma mark - 类方法 - 公开

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static DrawPatternLockViewController *sharedInstance;
    
    dispatch_once(&once, ^{
        
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


#pragma mark - lifecycle

- (id)init
{
    self = [super init];
    if (self)
    {
        /**
         是否 显示手势轨迹
         */
        _isShowGestureTrace = YES;
        
        _hiddenNavigationBar = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    /******* 视图 begin ******/
    /*
     创建内部使用的视图
     */
    [self createInternalViews];
    /*
     创建手势界面
     */
    [self createGestureViews];
    /******* 视图 end *******/
    
    if (!self.hiddenNavigationBar) {
        [self setupNavBar];
    }
    
    [self lzHiddenNavigationBar:self.hiddenNavigationBar];
    addHeight = self.hiddenNavigationBar?0:LZNavigationHeight;

    /*
     初始验证手势密码 最大失败次数
     */
    [self initVerifyGestureMaxFailTimes];
    
    /*
     是否 应该恢复手势密码
     */
    _isShouldRecoverGestureForLastAccountStr = YES;
}

- (void)setupNavBar {
    /*
     导航栏
     */
    switch (_drawPatternCtlType) {
        case kDrawPatternCtlTypeGesturePwdSetup:    //登录成功后 --- 设置 手势密码
        {
            
            [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [self lzSetNavigationTitle:@"新的手势密码"];
        }break;
            
        case kDrawPatternCtlTypeGesturePwdModify:   //设置页面的 --- 修改 手势密码
        {
            
            [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [self lzSetNavigationTitle:@"修改手势密码"];
        }break;
            
        case kDrawPatternCtlTypeGesturePwdVerify:   //已设过手势 --- 验证 手势密码
        {
        }break;
            
        default:
            break;
    }
}

/*
 创建内部使用的视图
 */
- (void)createInternalViews
{
    if (_gestureInternalViews)  return;
    
    
    _gestureInternalViews = [[GestureInternalViews alloc] init];
    
    [self.view addSubview: _gestureInternalViews.headImageView];
    [self.view addSubview: _gestureInternalViews.headLabel];
    
    _gestureInternalViews.autoDismissLabel.hidden = YES;
    [self.view addSubview: _gestureInternalViews.autoDismissLabel];
    
    [self.view addSubview: _gestureInternalViews.btnForgetGesturePwd];
    [self.view addSubview: _gestureInternalViews.lineView];
    [self.view addSubview: _gestureInternalViews.btnTouchIdUnlock];
    
    [_gestureInternalViews.btnForgetGesturePwd addTarget:self action:@selector(onBtnForgetGesturePwdClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [_gestureInternalViews.btnTouchIdUnlock    addTarget:self action:@selector(onBtnTouchIdUnlockClicked:) forControlEvents:UIControlEventTouchUpInside];
}

/*
 创建手势界面
 */
- (void)createGestureViews
{
    if (_v) return;
    
    
    /*
     手势：点矩阵，即，DrawPatternLockView包含子视图：dots。
     dots布局 --- begin
     */
    _v = [[DrawPatternLockView alloc] init];
    _v.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_v];
    
    _v.backgroundColor = [UIColor grayColor];
    for (int i=0; i<MATRIX_SIZE; i++)
    {//行
        for (int j=0; j<MATRIX_SIZE; j++)
        {//列
            UIImage *dotImage = [UIImage imageNamed:@"gesture_circle_nor"];
            UIImage *dotHImage = [UIImage imageNamed:@"gesture_circle_pre"];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:dotImage
                                                       highlightedImage:dotHImage];
            
            imageView.frame = CGRectMake(0, 0, dotImage.size.width, dotImage.size.height);
            imageView.userInteractionEnabled = YES;
            imageView.tag = i*MATRIX_SIZE + j + 1;
            
            [_v addSubview:imageView];
        }
    }
    /*
     手势：点矩阵，即，DrawPatternLockView包含子视图：dots。
     dots布局 --- end
     */
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _isPushed = [self isMovingToParentViewController];
//    self.navigationController.navigationBarHidden = NO;

#ifdef Gesture_Debug_NSLog
    NSLog(@"viewWillAppear  pushed   %d\n", _isPushed);
#endif
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _isPopped = [self isMovingFromParentViewController];
    
    _isShouldClose = NO;
    
    
    [self.view.layer removeAllAnimations];
    
//    self.navigationController.navigationBarHidden = YES;
    
#ifdef Gesture_Debug_NSLog
    NSLog(@"viewWillDisappear   popped   %d\n", _isPopped);
#endif
    
}


//- (void)dealloc
//{
//    if (_v) { //手势
//        _v = nil;
//    }
//    
//    if (_paths) {//手势路径
//        _paths = nil;
//    }
//    
//    if (_gestureInternalViews) {//内部使用的视图
//        _gestureInternalViews = nil;
//    }
//    
//    if (_timer && [_timer isValid]) {//定时器
//        [_timer invalidate];
//        _timer = nil;
//    }
//    
//    self.currentAccountStr = nil;
//    
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//}


/*
 根据_drawPatternCtlType，重新布局界面
 */
- (void)viewWillLayoutSubviews
{

#ifdef Gesture_Debug_NSLog
    NSLog(@"%@ %@",
          @"viewWillLayoutSubviews",
          @"重新布局");
#endif
    
    /**
     是否 显示手势轨迹
     */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber * num = [defaults objectForKey:KEY_UserDefaults_isShowGestureTrace];
    if (num) {
        /**
         是否 显示手势轨迹
         */
        _isShowGestureTrace = [num boolValue];
    }
    
    
    
    BOOL isPhone = ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone);
    BOOL isPad = ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad);
    
    //配置公共的frame -------------------------------- begin
    {
        //点图片的size
        UIImage *dotImage = [UIImage imageNamed:@"gesture_circle_nor"];
        float wDot = MIN(dotImage.size.width,  DotMaxWidthAndHeight);
        float hDot = MIN(dotImage.size.height, DotMaxWidthAndHeight);
        
        //DrawPatternLockView的size
        float wV = wDot*MATRIX_SIZE + PaddingBetweenDots*(MATRIX_SIZE-1) + DotsPaddingToParentView*2;
        float hV = wV;//正方形
        
        //DrawPatternLockView的origin
        float xIfCentered = (self.view.frame.size.width  - wV)/2;
        float yIfCentered = (self.view.frame.size.height - hV)/2;
        float xV = 0.0f;
        float yV = 0.0f;
        
        if (isPhone)
        {
            switch (_drawPatternCtlType) {
                case kDrawPatternCtlTypeGesturePwdSetup:    //登录成功后 --- 设置 手势密码
                    yV = 4.0/8.0 * (self.view.frame.size.height-hV);
                    break;
                    
                case kDrawPatternCtlTypeGesturePwdModify:   //设置页面的 --- 修改 手势密码
                    yV = 4.0/8.0 * (self.view.frame.size.height-hV);
                    break;
                    
                case kDrawPatternCtlTypeGesturePwdVerify:   //已设过手势 --- 验证 手势密码
                    yV = 6.0/8.0 * (self.view.frame.size.height-hV);
                    break;
                    
                default:
                    break;
            }
            
            xV = xIfCentered;
            yV = MAX(yV, yIfCentered);
        }
        else if (isPad)
        {
            switch (_drawPatternCtlType) {
                case kDrawPatternCtlTypeGesturePwdSetup:    //登录成功后 --- 设置 手势密码
                    yV = 4.0/8.0 * (self.view.frame.size.height-hV);
                    break;
                    
                case kDrawPatternCtlTypeGesturePwdModify:   //设置页面的 --- 修改 手势密码
                    yV = 4.0/8.0 * (self.view.frame.size.height-hV);
                    break;
                    
                case kDrawPatternCtlTypeGesturePwdVerify:   //已设过手势 --- 验证 手势密码
                    yV = 6.0/8.0 * (self.view.frame.size.height-hV);
                    break;
                    
                default:
                    break;
            }
            
            xV = xIfCentered;
            yV = MAX(yV, yIfCentered);
        }
        
        //DrawPatternLockView的frame
        _v.frame = CGRectMake(xV,yV + addHeight + 20, wV,hV);
        
        
        //每个点的frame(相对于父视图DrawPatternLockView)
        int i=0;
        for (UIView *view in _v.subviews)
        {
            if ([view isKindOfClass:[UIImageView class]])
            {
                int row  = i/MATRIX_SIZE; //行
                int rank = i%MATRIX_SIZE; //列
                int x = DotsPaddingToParentView + (wDot * rank) + (PaddingBetweenDots * rank);
                int y = DotsPaddingToParentView + (hDot * row)  + (PaddingBetweenDots * row);
                
                // view.center = CGPointMake(x, y);
                view.frame = CGRectMake(x, y , wDot, hDot);
                i++;
            }
        }
        
    }
    //配置公共的frame -------------------------------- end
    
    
    //配置项 ---------------------------------------- begin
    switch (_drawPatternCtlType) {
        case kDrawPatternCtlTypeGesturePwdSetup:    //登录成功后 --- 设置 手势密码
        {
            /**
             *  自动消失的提示语
             *  显示
             */
            _gestureInternalViews.autoDismissLabel.hidden = NO;
            
            /**
             *  顶部：图片，提示语
             *  显示
             */
            _gestureInternalViews.headImageView.hidden = NO;
            _gestureInternalViews.headLabel.hidden = NO;
            
            /**
             *  底部：忘记手势密码，指纹解锁
             *  隐藏
             */
            _gestureInternalViews.btnForgetGesturePwd.hidden = YES;
            _gestureInternalViews.lineView.hidden = YES;
            _gestureInternalViews.btnTouchIdUnlock.hidden = YES;
            
        }break;
            
        case kDrawPatternCtlTypeGesturePwdModify:   //设置页面的 --- 修改 手势密码
        {
            /**
             *  自动消失的提示语
             *  显示
             */
            _gestureInternalViews.autoDismissLabel.hidden = NO;
            
            /**
             *  顶部：图片，提示语
             *  显示
             */
            _gestureInternalViews.headImageView.hidden = NO;
            _gestureInternalViews.headLabel.hidden = NO;
            
            /**
             *  底部：忘记手势密码，指纹解锁
             *  隐藏
             */
            _gestureInternalViews.btnForgetGesturePwd.hidden = YES;
            _gestureInternalViews.lineView.hidden = YES;
            _gestureInternalViews.btnTouchIdUnlock.hidden = YES;
        }break;
        
        case kDrawPatternCtlTypeGesturePwdVerify:   //已设过手势 --- 验证 手势密码
        {
            /**
             *  自动消失的提示语
             *  隐藏
             */
            _gestureInternalViews.autoDismissLabel.hidden = YES;
            
            /**
             *  顶部：图片，提示语
             *  显示
             */
            _gestureInternalViews.headImageView.hidden = NO;
            _gestureInternalViews.headLabel.hidden = NO;
            
            /**
             *  底部：忘记手势密码，指纹解锁
             *  显示
             */
            _gestureInternalViews.btnForgetGesturePwd.hidden = NO;
            _gestureInternalViews.lineView.hidden = YES;
            _gestureInternalViews.btnTouchIdUnlock.hidden = NO;
        }break;
            
        default:
            break;
    }
    //配置项 ---------------------------------------- end
    
    
    //配置各自的frame -------------------------------- begin
    switch (_drawPatternCtlType) {
        case kDrawPatternCtlTypeGesturePwdSetup:    //登录成功后 --- 设置 手势密码
        {
            if (isPhone)
            {
                float wImage = self.view.frame.size.width/8;
                float hImage = wImage;
                float yImage = _v.frame.origin.y/3;
                
                _gestureInternalViews.headImageView.frame = CGRectMake(self.view.frame.size.width/2-wImage/2, yImage + addHeight/3.0, wImage, wImage);
                _gestureInternalViews.headImageView.layer.cornerRadius = 0.0;//default value
                _gestureInternalViews.headImageView.layer.masksToBounds = NO;//default value
                
                float hLabel = 20;
                _gestureInternalViews.headLabel.frame = CGRectMake(0, addHeight/2.0, 300, 20);
                _gestureInternalViews.headLabel.center = CGPointMake(self.view.center.x,yImage + hImage +yImage -hLabel/2);
                
                _gestureInternalViews.autoDismissLabel.frame = CGRectMake((1-250.0/320.0)/2.0 * self.view.frame.size.width,
                                                                          addHeight,
                                                                          250.0/320.0 * self.view.frame.size.width,
                                                                          0);
            }
            else if (isPad)
            {
                
            }
            
        }break;
        
        case kDrawPatternCtlTypeGesturePwdModify:   //设置页面的 --- 修改 手势密码
        {
            if (isPhone)
            {
                float wImage = self.view.frame.size.width/8;
                float hImage = wImage;
                float yImage = _v.frame.origin.y/3;
                
                _gestureInternalViews.headImageView.frame = CGRectMake(self.view.frame.size.width/2-wImage/2, yImage + addHeight/3.0, wImage, wImage);
                _gestureInternalViews.headImageView.layer.cornerRadius = 0.0;//default value
                _gestureInternalViews.headImageView.layer.masksToBounds = NO;//default value
                
                float hLabel = 20;
                _gestureInternalViews.headLabel.frame = CGRectMake(0, addHeight/2.0, 300, 20);
                _gestureInternalViews.headLabel.center = CGPointMake(self.view.center.x,
                                                                     yImage+hImage +yImage -hLabel/2);
                
                _gestureInternalViews.autoDismissLabel.frame = CGRectMake((1-250.0/320.0)/2.0 * self.view.frame.size.width,
                                                                          addHeight,
                                                                          250.0/320.0 * self.view.frame.size.width,
                                                                          0);
            }
            else if (isPad)
            {

            }
            
        }break;
            
        case kDrawPatternCtlTypeGesturePwdVerify:   //已设过手势 --- 验证 手势密码
        {
            if (isPhone)
            {
                float wImage = self.view.frame.size.width * (72.0/320.0);
                float hImage = wImage;
                float yImage = (_v.frame.origin.y-hImage)/2;
                
                _gestureInternalViews.headImageView.frame = CGRectMake(self.view.frame.size.width/2-wImage/2, yImage + addHeight/3.0, wImage, wImage);
                _gestureInternalViews.headImageView.layer.cornerRadius = wImage/2;
                _gestureInternalViews.headImageView.layer.masksToBounds = YES;
                
                float hLabel = 20;
                _gestureInternalViews.headLabel.frame = CGRectMake(0, addHeight/2.0, 300, hLabel);
                _gestureInternalViews.headLabel.center = CGPointMake(self.view.center.x,
                                                                     yImage+hImage +yImage/2);
                
                
                float wBtn = self.view.frame.size.width/3;
                float hBtn = 30;
                float yBtn = self.view.frame.size.height - hBtn -10;
                
                _gestureInternalViews.btnForgetGesturePwd.frame = CGRectMake(0,      yBtn, wBtn, hBtn);
                _gestureInternalViews.lineView.hidden = YES;
                _gestureInternalViews.btnTouchIdUnlock.frame    = CGRectMake(wBtn*2, yBtn, wBtn, hBtn);
                
                
                BOOL isTouchIdAllowBySystem = [[TouchIdUnlock sharedInstance] isTouchIdEnabledOrNotBySystem];
                if (!isTouchIdAllowBySystem) {
                    _gestureInternalViews.btnForgetGesturePwd.center = CGPointMake(self.view.center.x,
                                                                                   _gestureInternalViews.btnTouchIdUnlock.center.y);
                    _gestureInternalViews.lineView.hidden = YES;
                    _gestureInternalViews.btnTouchIdUnlock.hidden = YES;
                }
                
            }
            else if (isPad)
            {
                
            }
            
            
        }break;
            
        default:
            break;
    }
    //配置各自的frame -------------------------------- end
    
    
    //配置各自的内容 -------------------------------- end
    switch (_drawPatternCtlType) {
        case kDrawPatternCtlTypeGesturePwdSetup:    //登录成功后 --- 设置 手势密码
        {
            if (!_gestureInternalViews.headImageView.image) {
                _gestureInternalViews.headImageView.image = [self getGestureImage];
            }
            if (_gestureInternalViews.headLabel.text.length <= 0) {
                _gestureInternalViews.headLabel.text = @"绘制解锁图案";
            }
        }break;
            
        case kDrawPatternCtlTypeGesturePwdModify:   //设置页面的 --- 修改 手势密码
        {
            if (!_gestureInternalViews.headImageView.image) {
                _gestureInternalViews.headImageView.image = [self getGestureImage];
            }
            if (_gestureInternalViews.headLabel.text.length <= 0) {
                _gestureInternalViews.headLabel.text = @"绘制解锁图案";
            }
        }break;
            
        case kDrawPatternCtlTypeGesturePwdVerify:   //已设过手势 --- 验证 手势密码
        {
            UIImage * icon = [UIImage imageNamed:@"Icon"];
            if (!icon) {icon = [UIImage imageNamed:@"icon"];}
            
            _gestureInternalViews.headImageView.image = icon;
            if (_gestureInternalViews.headLabel.text.length <= 0) {
                _gestureInternalViews.headLabel.text = @"绘制解锁图案";
            }
        }break;
            
        default:
            break;
    }
    //配置各自的内容 -------------------------------- end
    
    
    //关闭页面时，两个按钮 不允许交互。在这里恢复允许交互。
    _gestureInternalViews.btnForgetGesturePwd.userInteractionEnabled = YES;//忘记手势密码，允许交互
    _gestureInternalViews.btnTouchIdUnlock.userInteractionEnabled = YES;//指纹解锁，允许交互
}


#pragma mark - setters
/*
 页面样式
 */
- (void)setDrawPatternCtlType:(DrawPatternCtlType)drawPatternCtlType
{
    _drawPatternCtlType = drawPatternCtlType;
    [self.view setNeedsLayout];
    
    
    /*
     是否应该恢复手势密码
     */
    _isShouldRecoverGestureForLastAccountStr = YES;
    
    
    if (drawPatternCtlType == kDrawPatternCtlTypeGesturePwdSetup ||
        drawPatternCtlType == kDrawPatternCtlTypeGesturePwdModify )
    {//设置新的手势密码
     //修改手势密码
        self.lastGesturePwdStr = nil;
    }
    
    if ( 0 < _remainedCountThatAllowVerifyFail &&
             _remainedCountThatAllowVerifyFail <= Verify_Gesture_MAX_Fail_Times)
    {//do nothing
    }
    else
    {//初始验证手势密码 最大失败次数
        [self initVerifyGestureMaxFailTimes];
    }
    
}

/*
 页面标题
 */
- (void)setTitle:(NSString *)title
{
    /**
     显示导航栏中间的标题
     */
    [self showCustomNavigationMiddleTitle:title];
}

/*
 当前登录帐号
 */
- (void)setCurrentAccountStr:(NSString *)currentAccountStr
{
    if (_currentAccountStr != currentAccountStr)
    {
//        NSObject* savedObject = _currentAccountStr; // LF delete
        _currentAccountStr = currentAccountStr;
    }
    /*
     备份 账号
     */
    [GestureTool_Private saveLastAccountStringInUserDefaults: _currentAccountStr];
}


#pragma mark - getter
/*
 是否 模态显示当前页面
 */
- (BOOL)isModal
{
    if([self presentingViewController])
        return YES;
    if([[self presentingViewController] presentedViewController] == self)
        return YES;
    if([[[self navigationController] presentingViewController] presentedViewController] == [self navigationController])
        return YES;
    if([[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]])
        return YES;
    
    return NO;
}



#pragma mark - 自定义方法

/*! @brief
 初始验证手势密码 最大失败次数
 */
- (void)initVerifyGestureMaxFailTimes
{
    if (_drawPatternCtlType == kDrawPatternCtlTypeGesturePwdVerify)
    {//验证手势密码
        
        _remainedCountThatAllowVerifyFail = 0;
        _remainedCountThatAllowVerifyFail = Verify_Gesture_MAX_Fail_Times;
        
        /*
         验证 手势密码 --- 最大 失败次数；
                         只能是正整数(即1,2,3...等)，才算有效；若为0或负整数，则失败次数为无穷大；
                         达到最大失败次数，则会默认选择"忘记手势密码"。
         */
        if (_remainedCountThatAllowVerifyFail > 0)
        {//有效
            //do nothing
        }
        else  /*  <= 0  */
        {//无效
         //异常处理
            _remainedCountThatAllowVerifyFail = -1000;//特殊数字，请勿更改
        }
    }
}

/*! @brief
 显示导航栏中间的标题
 */
- (void)showCustomNavigationMiddleTitle:(NSString *)title
{
    if ( ! _gestureInternalViews.titleLabel)
    {
        if ( ! _gestureInternalViews) {
            /*
             创建内部使用的视图
             */
            [self createInternalViews];
        }
        _gestureInternalViews.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        
        _gestureInternalViews.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
        _gestureInternalViews.titleLabel.backgroundColor = [UIColor clearColor];
        _gestureInternalViews.titleLabel.textColor = [UIColor whiteColor];
        _gestureInternalViews.titleLabel.textAlignment = NSTextAlignmentCenter;
        _gestureInternalViews.titleLabel.text = title;;
        
        self.navigationItem.titleView = _gestureInternalViews.titleLabel;
    }
    else
    {
        _gestureInternalViews.titleLabel.text = title;
        _gestureInternalViews.titleLabel.textColor = [UIColor whiteColor];
        
        self.navigationItem.titleView = _gestureInternalViews.titleLabel;
    }
}

/*! @brief
 显示导航栏左侧的按钮
 */
- (void)showCustomNavigationLeftButtonWithTitle:(NSString *)aTitle
                                          image:(UIImage *)aImage
                                hightlightImage:(UIImage *)hImage
{
    //导航栏的左边按钮
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] init];
    [leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
    [leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    if (aTitle.length > 0)
    {
        NSString * titleStr = aTitle;
        if ([titleStr length] < 3)
        {
            titleStr = [NSString stringWithFormat:@"   %@",aTitle];
        }
        
        [leftBarButtonItem setTitle:titleStr];
        
        NSMutableDictionary *titleTextAttributes = [[NSMutableDictionary alloc] init];
        [titleTextAttributes setObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName];
        [titleTextAttributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [leftBarButtonItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    
    if (aImage)
    {
        /*
        [leftBarButtonItem setBackgroundImage:aImage forState:UIControlStateNormal barMetrics:UIBarMetricsCompactPrompt];
         */
        [leftBarButtonItem setImage:aImage];
    }
    
    if (hImage)
    {
        /*
        [leftBarButtonItem setBackgroundImage:hImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsCompactPrompt];
         */
    }
    

    [leftBarButtonItem setTarget:self];
    [leftBarButtonItem setAction:@selector(onNavigationLeftButtonClicked:)];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

/*!@brief
 手势绘制区域截图
 */
- (UIImage *)getGestureImage
{//手势绘制区域截图
    
    //这里可以设置想要截图的区域
    UIView * targetView = _v;
    CGRect rect = _v.frame;//手势绘制区域
    
    CGSize size = _gestureInternalViews.headImageView.bounds.size;
    
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [targetView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


/*! @brief
 设置_gestureInternalViews.headLabel.text，并添加抖动效果
 */
- (void)headLabelShowText:(NSString *)text
{
    /*
     抖动效果
     */
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim.values = @[ [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-8.0f, 0.0f, 0.0f)],
                     [NSValue valueWithCATransform3D:CATransform3DMakeTranslation( 8.0f, 0.0f, 0.0f)],
                     [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f)],
                     [NSValue valueWithCATransform3D:CATransform3DMakeTranslation( 5.0f, 0.0f, 0.0f)],
                     [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-2.0f, 0.0f, 0.0f)],
                     [NSValue valueWithCATransform3D:CATransform3DMakeTranslation( 2.0f, 0.0f, 0.0f)] ];
    anim.autoreverses = NO;
    anim.repeatCount = 1.0f;
    anim.duration = 0.6f;
    

    UILabel * targetLabel = _gestureInternalViews.headLabel;
    
    [self.view bringSubviewToFront:targetLabel];
    
    targetLabel.text = text;
    
 
    if ([targetLabel.text rangeOfString:@"至少"].location != NSNotFound)
    {//文本包含"至少"，则 黑色。
        targetLabel.textColor = [UIColor blackColor];//黑色
    }
    else if ([targetLabel.text rangeOfString:@"错误"].location != NSNotFound)
    {//文本包含"错误"，则 红色 并 抖动。
        targetLabel.textColor = [UIColor redColor];//红色
        
        /**
         屏蔽抖动
        [targetLabel.layer addAnimation:anim forKey:nil];//抖动
         */
    }
    else if ([targetLabel.text rangeOfString:@"成功"].location != NSNotFound)
    {//文本包含"成功"，则 绿色 并 不抖动。
        targetLabel.textColor = [UIColor colorWithRed:34.0/255.0 green:177.0/255.0 blue:89.0/255.0 alpha:1.0];//绿色
        
        /**
         清除，以免下次进入该页面(考虑到当前页面可能是单例)，出现上次的提示语
         动画时间0.6秒
         */
        NSTimeInterval timeInSec = 0.5;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeInSec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            targetLabel.text = nil;
            targetLabel.textColor = [UIColor blackColor];
            
        });
        
        
        switch (_drawPatternCtlType) {
            case kDrawPatternCtlTypeGesturePwdSetup:    //登录成功后 --- 设置 手势密码
            {
                
            }break;
                
            case kDrawPatternCtlTypeGesturePwdModify:   //设置页面的 --- 修改 手势密码
            {
                
            }break;
                
            case kDrawPatternCtlTypeGesturePwdVerify:   //已设过手势 --- 验证 手势密码
            {
                _gestureInternalViews.btnForgetGesturePwd.userInteractionEnabled = NO;
                _gestureInternalViews.btnTouchIdUnlock.userInteractionEnabled = NO;
                
                NSTimeInterval timeInSec = 0.5;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeInSec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    
                    _gestureInternalViews.btnForgetGesturePwd.userInteractionEnabled = YES;
                    _gestureInternalViews.btnTouchIdUnlock.userInteractionEnabled = YES;
                    
                });
                
            }break;
                
            default:
                break;
        }//switch语句结束
        
    }//if语句结束
    
}

/*! @brief
 设置_gestureInternalViews.autoDismissLabel.text
 */
- (void)autoDismissLabelShowText:(NSString *)text
{
    _gestureInternalViews.autoDismissLabel.text = text;
    _gestureInternalViews.autoDismissLabel.hidden = NO;
    
    _gestureInternalViews.autoDismissLabel.layer.cornerRadius = 2.0f;
    _gestureInternalViews.autoDismissLabel.layer.masksToBounds = YES;
    _gestureInternalViews.autoDismissLabel.frame = CGRectMake((1-250.0/320.0)/2.0 * self.view.frame.size.width,
                                                              addHeight,
                                                              250.0/320.0 * self.view.frame.size.width,
                                                              0);
    CGRect rect = _gestureInternalViews.autoDismissLabel.frame;
    rect.size.height = 30;
    
    
    __weak DrawPatternLockViewController * __self = self;
    
    /**
     停止定时器
     */
    if (_timer && [_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
    
    _gestureInternalViews.autoDismissLabel.alpha = 0.2;
    [UIView animateWithDuration:0.5 animations:^{
        
        _gestureInternalViews.autoDismissLabel.frame = rect;
        _gestureInternalViews.autoDismissLabel.alpha = 0.8;
        
    } completion:^(BOOL finished) {
        if (finished) {
        
            /*
             启动定时器
             */
            [__self startTimer];
            
        }
    }];
    
}

/*! @brief
 隐藏_gestureInternalViews.autoDismissLabel
 */
- (void)autoDismissLabelHide
{
    CGRect rect = _gestureInternalViews.autoDismissLabel.frame;
    rect.size.height = 0;
    
    _gestureInternalViews.autoDismissLabel.alpha = 0.8;
    [UIView animateWithDuration:0.5 animations:^{
        
        _gestureInternalViews.autoDismissLabel.frame = rect;
        _gestureInternalViews.autoDismissLabel.alpha = 0.2;
        
    } completion:^(BOOL finished) {
        if (finished) {
        
            _gestureInternalViews.autoDismissLabel.text = @"";
            _gestureInternalViews.autoDismissLabel.hidden = YES;
        }
    }];
    
}

/*
 启动定时器
 */
- (void)startTimer
{
    /**
     停用定时器
     */
    if (_timer && [_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1.5]
                                      interval:1.5
                                        target:self
                                      selector:@selector(timerWillTerminate:)
                                      userInfo:nil
                                       repeats:NO];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

/*
 定时器调用
 */
- (void)timerWillTerminate:(NSTimer *)timer
{
    /*
     隐藏_gestureInternalViews.autoDismissLabel
     */
    [self autoDismissLabelHide];
}


/*! @brief 关闭当前页面
 */
- (void)closeCurrentViewController
{//关闭当前页面

    if (!_isShouldClose)
    {
        return;
    }
    if ([self isPushed])
    {//push的
        if ([delegate respondsToSelector:@selector(drawPatternLockViewController:finishDrawPatternWithKey:)])
        {
            [delegate drawPatternLockViewController:self finishDrawPatternWithKey:[self getKey]];
        }

        
        {////
            /**
             停止定时器
             */
            if (_timer && [_timer isValid]) {
                [_timer invalidate];
                _timer = nil;
            }
            /*
             隐藏_gestureInternalViews.autoDismissLabel
             */
            [self autoDismissLabelHide];
        }////
        
        
        if (_isShouldClose && self.navigationController)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        _isShouldClose = NO;
        _isSetupOrModifyGestureComplete = NO;
    }
    else if([self isModal])
    {//模态的
        if ([delegate respondsToSelector:@selector(drawPatternLockViewController:finishDrawPatternWithKey:)])
        {
            [delegate drawPatternLockViewController:self finishDrawPatternWithKey:[self getKey]];
        }
        
        
        {////
            /**
             停止定时器
             */
            if (_timer && [_timer isValid]) {
                [_timer invalidate];
                _timer = nil;
            }
            /*
             隐藏_gestureInternalViews.autoDismissLabel
             */
            [self autoDismissLabelHide];
        }////
        
        
        if (_isShouldClose && self.presentingViewController)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                [self.view removeFromSuperview];
                [self removeFromParentViewController];
            }];
        }
        _isShouldClose = NO;
    }
    
    _isBtnForgetGesturePwdClicked = NO;//忘记手势密码
    _isBtnTouchIdUnlockClicked = NO;//指纹解锁
    
    
    //关闭页面时，两个按钮 不允许交互。将在其他代码段中恢复允许交互。
    _gestureInternalViews.btnForgetGesturePwd.userInteractionEnabled = NO;//忘记手势密码，不允许交互
    _gestureInternalViews.btnTouchIdUnlock.userInteractionEnabled = NO;//指纹解锁，不允许交互
    
    NSTimeInterval timeInSec = 0.5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeInSec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        _gestureInternalViews.headLabel.text = nil;
        _gestureInternalViews.headLabel.textColor = [UIColor blackColor];
        
        _gestureInternalViews.btnForgetGesturePwd.userInteractionEnabled = YES;//忘记手势密码，允许交互
        _gestureInternalViews.btnTouchIdUnlock.userInteractionEnabled = YES;//指纹解锁，允许交互
        
    });
    
    /*
     初始验证手势密码 最大失败次数
     */
    [self initVerifyGestureMaxFailTimes];
}


#pragma mark - 按钮事件
/*
 导航栏左边按钮
 */
- (void)onNavigationLeftButtonClicked:(UIButton *)sender
{
    if (_drawPatternCtlType == kDrawPatternCtlTypeGesturePwdSetup ||
        _drawPatternCtlType == kDrawPatternCtlTypeGesturePwdModify)
    {//设置新的手势
     //修改手势
        
        _isShouldClose = YES;
        [self closeCurrentViewController];
    }
}

/*
 忘记密码按钮
 */
- (void)onBtnForgetGesturePwdClicked:(UIButton *)sender
{
    _isShouldClose = YES;
    _isBtnForgetGesturePwdClicked = YES;//忘记手势密码
    
    /*
     是否应该恢复手势密码
     */
    _isShouldRecoverGestureForLastAccountStr = NO;
    if([delegate respondsToSelector:@selector(drawPatternLockViewController:forgetGesturePwd:)])
    {
       [delegate drawPatternLockViewController:self forgetGesturePwd:sender];
    }
    
//    [self closeCurrentViewController];//关闭当前页面.原代码
    
    // ... 忘记密码 执行什么操作.
    LFForgetPwdViewController *myforgetPwdVc = [[LFForgetPwdViewController alloc] init];
    [self presentViewController:myforgetPwdVc animated:YES completion:nil];
}

/*
 指纹解锁
 */
- (void)onBtnTouchIdUnlockClicked:(UIButton *)sender
{
    _isShouldClose = YES;
    _isBtnTouchIdUnlockClicked = YES;//指纹解锁
    
    /*
     是否应该恢复手势密码
     */
    _isShouldRecoverGestureForLastAccountStr = NO;
    if([delegate respondsToSelector:@selector(drawPatternLockViewController:touchIdUnlock:)])
    {
        [delegate drawPatternLockViewController:self touchIdUnlock:sender];
    }
    
    /**
     //屏蔽此行代码
     [self closeCurrentViewController];//关闭当前页面
     */
}


#pragma mark - rotate Event
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_paths)
    {
        _paths = [[NSMutableArray alloc] init];
    }

    
    CGPoint pt = [[touches anyObject] locationInView:_v];
    UIView *touched = [_v hitTest:pt withEvent:event];
    

    [_v drawLineFromLastDotTo:pt];
    
    
    if ([touched isKindOfClass:[UIImageView class]])
    {
        // NSLog(@"touched view tag: %d ", touched.tag);
        if(touched.tag)
            [_paths addObject:[NSNumber numberWithInteger:touched.tag]];
        [_v addDotView:touched];
        
        
        UIImageView* iv = (UIImageView*)touched;
        if([iv isKindOfClass:[UIImageView class]])
            if (_isShowGestureTrace)
                iv.highlighted = YES;
        
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:_v];
    UIView *touched = [_v hitTest:pt withEvent:event];
    
    
    if(!CGRectContainsPoint(_v.bounds, pt))
    {
        /*
         return;
         */
    }
    
    [_v drawLineFromLastDotTo:pt];
    
    
    if ([touched isKindOfClass:[UIImageView class]])
    {
        BOOL found = NO;
        for (NSNumber *tag in _paths)
        {
            found = tag.integerValue==touched.tag;
            if (found)
                break;
        }
        
        if (found)
            return;
        if(touched.tag)
            [_paths addObject:[NSNumber numberWithInteger:touched.tag]];
        [_v addDotView:touched];
        
        UIImageView* iv = (UIImageView*)touched;
        if([iv isKindOfClass:[UIImageView class]])
            if (_isShowGestureTrace)
                iv.highlighted = YES;
    }
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    /**
     触摸结束，判断
     */
    [self endTouchAndJudgeAndUpdateHeadImageView];
    
    
    // clear up hilite
    [_v clearDotViews];
    
    
    for (UIView *view in _v.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]])
        {
            [(UIImageView*)view setHighlighted:NO];
        }
    }
    
    [_v setNeedsDisplay];
    
    
    
    switch (_drawPatternCtlType) {
        case kDrawPatternCtlTypeGesturePwdSetup:    //登录成功后 --- 设置 手势密码
        {
            if([_paths count] >= Gesture_Required_NumberOfDots)
            {
                /*
                 完成绘制手势
                 */
                [self finishDrawingGesturePassword:[self getKey]];
            }
        }break;
            
        case kDrawPatternCtlTypeGesturePwdModify:   //设置页面的 --- 修改 手势密码
        {
            if([_paths count] >= Gesture_Required_NumberOfDots)
            {
                /*
                 完成绘制手势
                 */
                [self finishDrawingGesturePassword:[self getKey]];
            }
        }break;
            
        case kDrawPatternCtlTypeGesturePwdVerify:   //已设过手势 --- 验证 手势密码
        {
            /*
             完成绘制手势
             */
            [self finishDrawingGesturePassword:[self getKey]];
        }break;
            
        default:
            break;
    }//switch语句结束
    
    
    
    _paths = nil;
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    /**
     触摸结束，判断
     */
    [self endTouchAndJudgeAndUpdateHeadImageView];
    
    
    // clear up hilite
    [_v clearDotViews];
    
    
    for (UIView *view in _v.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]])
        {
            [(UIImageView*)view setHighlighted:NO];
        }
    }
    
    [_v setNeedsDisplay];
    
    
    
    switch (_drawPatternCtlType) {
        case kDrawPatternCtlTypeGesturePwdSetup:    //登录成功后 --- 设置 手势密码
        {
            if([_paths count] >= Gesture_Required_NumberOfDots)
            {
                /*
                 完成绘制手势
                 */
                [self finishDrawingGesturePassword:[self getKey]];
            }
        }break;
            
        case kDrawPatternCtlTypeGesturePwdModify:   //设置页面的 --- 修改 手势密码
        {
            if([_paths count] >= Gesture_Required_NumberOfDots)
            {
                /*
                 完成绘制手势
                 */
                [self finishDrawingGesturePassword:[self getKey]];
            }
        }break;
            
        case kDrawPatternCtlTypeGesturePwdVerify:   //已设过手势 --- 验证 手势密码
        {
            /*
             完成绘制手势
             */
            [self finishDrawingGesturePassword:[self getKey]];
        }break;
            
        default:
            break;
    }//switch语句结束
    
    
    
    _paths = nil;
}


#pragma mark - password
// get key from the pattern drawn
// replace this method with your own key-generation algorithm
- (NSString*)getKey
{
    NSMutableString *key;
    key = [NSMutableString string];
    
    // simple way to generate a key
    for (NSNumber *tag in _paths) {
        // [key appendFormat:@"%02d", tag.integerValue];
        if(tag.integerValue)
            [key appendFormat:@"%ld", (long)tag.integerValue];
    }
    
    return key;
}


#pragma mark - 手势功能

/**
 触摸结束，判断。
 */
- (void)endTouchAndJudgeAndUpdateHeadImageView
{
    if ([_paths count] >= Gesture_Required_NumberOfDots)
    {
        switch (_drawPatternCtlType) {
            case kDrawPatternCtlTypeGesturePwdSetup:    //登录成功后 --- 设置 手势密码
            {
                _gestureInternalViews.headImageView.image = [self getGestureImage];
            }break;
                
            case kDrawPatternCtlTypeGesturePwdModify:   //设置页面的 --- 修改 手势密码
            {
                _gestureInternalViews.headImageView.image = [self getGestureImage];
            }break;
                
            case kDrawPatternCtlTypeGesturePwdVerify:   //已设过手势 --- 验证 手势密码
            {
            }break;
                
            default:
                break;
        }//switch语句结束
        
    }
    else if ([_paths count])
    {
        switch (_drawPatternCtlType) {
            case kDrawPatternCtlTypeGesturePwdSetup:    //登录成功后 --- 设置 手势密码
            {
                NSString * msg = [NSString stringWithFormat:@"⚠︎ 至少连接%d个点，请重新绘制", Gesture_Required_NumberOfDots];
                
                NSLog(@"%@", msg);
                /*
                 设置_gestureInternalViews.autoDismissLabel.text
                 */
                [self autoDismissLabelShowText: msg];
                
            }break;
                
            case kDrawPatternCtlTypeGesturePwdModify:   //设置页面的 --- 修改 手势密码
            {
                NSString * msg = [NSString stringWithFormat:@"⚠︎ 至少连接%d个点，请重新绘制", Gesture_Required_NumberOfDots];
                
                NSLog(@"%@", msg);
                /*
                 设置_gestureInternalViews.autoDismissLabel.text
                 */
                [self autoDismissLabelShowText: msg];
                
            }break;
                
            case kDrawPatternCtlTypeGesturePwdVerify:   //已设过手势 --- 验证 手势密码
            {
                /**
                NSString * msg = [NSString stringWithFormat:@"至少连接%d个点，请重新绘制", Gesture_Required_NumberOfDots];
                
                NSLog(@"%@", msg);

                //设置_gestureInternalViews.headLabel.text，并添加抖动效果
                [self headLabelShowText: msg];
                */
                
            }break;
                
            default:
                break;
        }//switch语句结束
        
    }
    
}

/**
 完成绘制手势
 */
- (void)finishDrawingGesturePassword:(NSString *)key
{
    NSLog(@"刚才绘制的手势密码 是 %@", key);
    
    
    NSString *curGesturePwdStr = [NSString stringWithString:(key.length > 0 ? key : @"")];//9个点以内，key.length才是正确的
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *gesturePwdStr = [userDefaults objectForKey:KEY_UserDefaults_GesturePassword];
    if (gesturePwdStr.length <= 0)
    {//登录成功后 --- 设置 手势密码

        if (_drawPatternCtlType == kDrawPatternCtlTypeGesturePwdSetup)
        {
            [self setOrModifyGesturePassword:curGesturePwdStr];
        }
    }
    else
    {//设置页面的 --- 修改 手势密码
     //已设过手势 --- 验证 手势密码
        
        if (_drawPatternCtlType == kDrawPatternCtlTypeGesturePwdModify)
        {
            [self setOrModifyGesturePassword:curGesturePwdStr];
        }
        else if (_drawPatternCtlType == kDrawPatternCtlTypeGesturePwdVerify)
        {
            [self verifyGesturePassword:curGesturePwdStr];
        }
    }
}

/*! @brief
 登录成功后 --- 设置 手势密码
 设置页面的 --- 修改 手势密码
 */
- (void)setOrModifyGesturePassword:(NSString *)curGesturePwdStr
{//登录成功后 --- 设置 手势密码
 //设置页面的 --- 修改 手势密码
    
    if (curGesturePwdStr.length < Gesture_Required_NumberOfDots)
    {
        NSString * msg = [NSString stringWithFormat:@"⚠︎ 至少连接%d个点，请重新绘制", Gesture_Required_NumberOfDots];
        
        NSLog(@"%@", msg);
        /*
         设置_gestureInternalViews.autoDismissLabel.text
         */
        [self autoDismissLabelShowText: msg];
    }
    else
    {
        if ( _lastGesturePwdStr.length <= 0)
        {
            NSLog(@"第一次 设置手势密码成功");//step.1
            
            NSLog(@"请再次绘制解锁图案");
            /*
             设置_gestureInternalViews.headLabel.text，并添加抖动效果
             */
            [self headLabelShowText: @"请再次绘制解锁图案"];
            
            
            /*
             记住第一次手势
             */
            [self setLastGesturePwdStr:curGesturePwdStr];
        }
        else if ( _lastGesturePwdStr.length > 0 &&
                ![_lastGesturePwdStr isEqualToString:curGesturePwdStr])
        {
            NSLog(@"与上次绘制的不一致，请重新绘制");
            /*
             设置_gestureInternalViews.headLabel.text，并添加抖动效果
             */
            [self headLabelShowText: @"与上次绘制的不一致，请重新绘制"];
            
            
            /*
             清空上次手势
             */
            [self setLastGesturePwdStr:nil];
            
            /**
             触摸结束，判断。
             */
            [self endTouchAndJudgeAndUpdateHeadImageView];
        }
        else if ( _lastGesturePwdStr.length > 0 &&
                 [_lastGesturePwdStr isEqualToString:curGesturePwdStr])
        {
            NSLog(@"第二次 设置手势密码成功");//step.2
            NSLog(@"两次设置的手势密码相同，保存");
            
            
            _isShouldClose = YES;
            _isSetupOrModifyGestureComplete = YES;

            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:_lastGesturePwdStr forKey:KEY_UserDefaults_GesturePassword];
            [userDefaults synchronize];
            
            /*
             备份 手势密码
             */
            [GestureTool_Private saveLastGestureStringInUserDefaults: _lastGesturePwdStr];
            
            
            /*
             设置_gestureInternalViews.autoDismissLabel.text
             */
            [self autoDismissLabelShowText: @"设置成功"];
            /**
             动画0.5秒
             autoDismissLabelShowText
             */
            [self performSelector:@selector(closeCurrentViewController) withObject:nil afterDelay:0.6f];//关闭当前页面
        }
        
    }
}

/*! @brief
 已设过手势 --- 验证 手势密码
 */
- (void)verifyGesturePassword:(NSString *)curGesturePwdStr
{//已设过手势 --- 验证 手势密码
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *gesturePwdStr = [userDefaults objectForKey:KEY_UserDefaults_GesturePassword];
    if (curGesturePwdStr.length > 0 &&
        [curGesturePwdStr isEqualToString:gesturePwdStr])
    {
        NSLog(@"验证手势密码成功！");
        
        
        _isShouldClose = YES;
        
        /*
         设置_gestureInternalViews.headLabel.text，并添加抖动效果
         */
        [self headLabelShowText: @"解锁成功"];

        [self performSelector:@selector(closeCurrentViewController) withObject:nil afterDelay:0.6];//关闭当前页面
    }
    else
    {
        NSLog(@"验证手势密码错误，请重试。");
        
        if (_remainedCountThatAllowVerifyFail == -1000)
        {//允许失败次数，无穷大
            /*
             设置_gestureInternalViews.headLabel.text，并添加抖动效果
             */
            [self headLabelShowText: @"手势密码错误，请重试"];
        }
        else if (_remainedCountThatAllowVerifyFail >= 1)
        {//允许失败次数，正整数
            
            /*
             * 验证次数 处理
             */
            
            _remainedCountThatAllowVerifyFail --;
            
            NSString * msg = [NSString stringWithFormat:@"密码错误，还可以再输入%d次", (int)_remainedCountThatAllowVerifyFail];
            /*
             设置_gestureInternalViews.headLabel.text，并添加抖动效果
             */
            [self headLabelShowText: msg];
            
            if (_remainedCountThatAllowVerifyFail == 0)
            {
                NSLog(@"验证手势密码，失败次数用尽，默认选择'忘记手势密码'");
                
//                [GestureTool_Public clearGesturePwdStringWhichSavedInNSUserDefaults];//清除手势密码
                [self performSelector:@selector(onBtnForgetGesturePwdClicked:) withObject:nil afterDelay:0.35f];//默认选择'其他方式登录'
            }
        }
    }
    
}


@end
