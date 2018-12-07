//
//  LZGestureSettingViewController.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/2.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZGestureSettingViewController.h"

// 10.18
#import "LZGestureViewController.h"
#import "LZGestureTool.h"
#import "LZNumberTool.h"
#import "LZPasswordViewController.h"
#import "LZGestureIntroduceViewController.h"

// 10.23
#import "TouchIdUnlock.h"

@interface CMSwitch : UISwitch
@property (nonatomic, strong) NSIndexPath * indexPath;
@end
@implementation CMSwitch
@end


@interface LZGestureSettingViewController ()<
UITableViewDataSource,
UITableViewDelegate,LZGestureViewDelegate>
{
    UITableView * _tableView;
    BOOL          _isShowOther;
    CMSwitch * _stateSwitch;
}


@end

@implementation LZGestureSettingViewController

- (void)dealloc
{
    if (_tableView) {
        _tableView = nil;
    }
    
    if (_popBackBlock) {
        _popBackBlock = nil;
    }
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _contendView = [UIView new];
        [self.view addSubview:_contendView];
        
        [_contendView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view).offset(LZNavigationHeight);
        }];
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupMainView];
    [self setupNaviBar];
    
}

- (void)setupNaviBar {
    
    LZWeakSelf(ws)
    [self lzSetNavigationTitle:@"手势设置"];
    [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        
        [ws.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)setupMainView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor clearColor];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    
    [_contendView addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(self.contendView);
        make.top.mas_equalTo(self.contendView);
    }];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    _isShowOther = [LZGestureTool isGestureEnable];
    
    if (_isShowOther) {
        
        return 4;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        
//        return 2;
//    }
    
    if (section == 1&&![[TouchIdUnlock sharedInstance] isTouchIdEnabledOrNotBySystem]) {
        
        return 0;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    
    switch (indexPath.section)
    {
        case 0:
        {
            CMSwitch * sw = [[CMSwitch alloc] init];
            
            [sw addTarget:self action:@selector(sw:) forControlEvents:UIControlEventValueChanged];
            _stateSwitch = sw;
            cell.accessoryView = sw;
            sw.indexPath = indexPath;
            cell.textLabel.text = @"开启密码锁定";
            sw.on = [LZGestureTool isGestureEnableByUser];
        }break;
            
        case 1:
        {
            CMSwitch * sw = [[CMSwitch alloc] init];
            
            [sw addTarget:self action:@selector(sw:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = sw;
            sw.indexPath = indexPath;
            cell.textLabel.text = @"使用指纹重置手势密码";
            sw.on = [LZGestureTool isGestureResetEnableByTouchID];
            
        }break;
        case 2:
        {
            cell.textLabel.text = @"修改手势密码";
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        } break;
            
        case 3:
        {
            cell.textLabel.text = @"忘记手势密码";
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        } break;
        default:
        {
            cell.textLabel.text = nil;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }break;
    }
    
    return cell;
}


#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (![[TouchIdUnlock sharedInstance] isTouchIdEnabledOrNotBySystem] && section == 1) {
        
        return 1.;
    }
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 20.0;
    }
    
    return 1.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if (section == 1 && [[TouchIdUnlock sharedInstance] isTouchIdEnabledOrNotBySystem]) {
        
        return @"开启后,当您忘记手势密码时,可使用指纹密码来重置手势密码";
    } else if (section == 3) {
        
        if ([[TouchIdUnlock sharedInstance] isTouchIdEnabledOrNotBySystem]) {
            
            return @"如果您使用了数字密码或指纹密码,可使用其中之一来重置手势密码";
        }
        
        return @"如果您使用了数字密码,可使用数字密码重置手势密码";
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LZWeakSelf(ws)
    [tableView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:0.5];
    
    // 修改手势密码
    if (indexPath.section == 2) {
        
        LZGestureViewController *gestureVC = [[LZGestureViewController alloc]init];
        [gestureVC showInViewController:self type:(LZGestureTypeUpdate)];
        
        // 忘记手势密码
    } else if (indexPath.section == 3) {
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        if ([[TouchIdUnlock sharedInstance] isTouchIdEnabledOrNotBySystem]&&[LZGestureTool isGestureResetEnableByTouchID]) {
            
            UIAlertAction *touchID = [UIAlertAction actionWithTitle:@"使用指纹密码重置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[TouchIdUnlock sharedInstance] startVerifyTouchID:^{
                    
                    LZGestureIntroduceViewController *info = [[LZGestureIntroduceViewController alloc]init];
                    
                    [ws.navigationController pushViewController:info animated:YES];
                }];
            }];
            
            [alert addAction:touchID];
        }
        
        if ([LZNumberTool isNumberPasswordEnable]) {
            
            UIAlertAction *number = [UIAlertAction actionWithTitle:@"使用数字密码重置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                LZPasswordViewController *psV = [[LZPasswordViewController alloc]init];
                [psV showInViewController:self style:LZPasswordStyleVerity];
                [psV veritySuccess:^{
                    
                    LZGestureIntroduceViewController *info = [[LZGestureIntroduceViewController alloc]init];
                    
                    [ws.navigationController pushViewController:info animated:YES];
                }];
            }];
            
            [alert addAction:number];
        }
        
        if (![LZNumberTool isNumberPasswordEnable]&&
            ![[TouchIdUnlock sharedInstance] isTouchIdEnabledOrNotBySystem]) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告⚠️" message:@"您没有设置数字密码,无法通过数字密码重置!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

#pragma mark - 事件

- (void)sw:(CMSwitch *)sender
{
    if (sender.indexPath.section == 0) {
        
        BOOL isON = sender.isOn;
        
        if ([LZGestureTool isGestureEnableByUser]) {
            
            sender.on = YES;
            LZGestureViewController *gesture = [[LZGestureViewController alloc]init];
            
            gesture.delegate = self;
            [gesture showInViewController:self type:LZGestureTypeVerifying];
        } else {
            
            [LZGestureTool saveGestureEnableByUser:isON];
            
            _isShowOther = isON;
            [_tableView reloadData];
        }
    } else if (sender.indexPath.section == 1){
     
        if ([LZGestureTool isGestureResetEnableByTouchID]) {
            
            sender.on = YES;
        } else {
            
            sender.on = NO;
        }
        
        [[TouchIdUnlock sharedInstance] startVerifyTouchID:^{
            
            sender.on = !sender.on;
            [LZGestureTool saveGestureResetEnableByTouchID:sender.on];
        }];
    }
}

- (void)gestureViewVerifiedSuccess:(LZGestureViewController *)vc {
    
    [LZGestureTool saveGestureEnableByUser:NO];
    _isShowOther = NO;
    [_tableView reloadData];
    _stateSwitch.on = NO;
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
