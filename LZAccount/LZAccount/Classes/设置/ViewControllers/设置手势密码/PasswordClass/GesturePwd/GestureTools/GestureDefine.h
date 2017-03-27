//
//  GestureDefine.h
//  v1.0
//  by OYXJ, Hawking.HK@gmail.com


/*
 验证 手势密码 --- 最大 失败次数；
                 只能是正整数(即1,2,3...等)，才算有效；若为0或负整数，则失败次数为无穷大；
                 达到最大失败次数，则会默认选择"忘记手势密码"。
 */
#define Verify_Gesture_MAX_Fail_Times    5

/*
 手势密码 --- 要求的 连接点数：
             建议：>= 3 且 <= 9
 */
#define Gesture_Required_NumberOfDots    3


/*
 界面配置
 */
#define MATRIX_SIZE                 3       //3维矩阵(共9个点---9个Dots)
//#define DotMaxWidthAndHeight        64      //每个点的 最大宽度 最大高度
//#define PaddingBetweenDots          35      //点矩阵(即9个Dots) 点与点之间的 上下左右的边距
//#define DotsPaddingToParentView     30      //点矩阵(即9个Dots) 相对于父视图(即DrawPatternLockView)的 上下左右的边距
#define DotMaxWidthAndHeight        (CGRectGetWidth([UIScreen mainScreen].bounds) * 0.255)
#define PaddingBetweenDots          (DotMaxWidthAndHeight * 0.36)
#define DotsPaddingToParentView     (CGRectGetWidth([UIScreen mainScreen].bounds) - DotMaxWidthAndHeight*3 - PaddingBetweenDots*2)




/*
 输出日志
 */
#define Gesture_Debug_NSLog                     @"define_Gesture_Debug_NSLog"   //用于条件编译，输出debug日记


/*
 手势密码
 */
#define KEY_UserDefaults_GesturePassword        @"KEY_UserDefaults_GesturePassword"

/*
 备份 手势密码
 */
#define KEY_UserDefaults_backupGesturePwdStr    @"KEY_UserDefaults_backupGesturePwdStr"
/*
 备份 账号
 */
#define KEY_UserDefaults_backupAccountStr       @"KEY_UserDefaults_backupAccountStr"

