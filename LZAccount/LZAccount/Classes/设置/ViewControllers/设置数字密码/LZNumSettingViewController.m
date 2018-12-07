//
//  LZNumSettingViewController.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/2.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZNumSettingViewController.h"
#import "LZNumberTool.h"
#import "LZPasswordViewController.h"

#import "TouchIdUnlock.h"
#import "LZGestureTool.h"
#import "LZGestureViewController.h"

@interface LZNumSettingViewController ()<UITableViewDelegate,UITableViewDataSource,LZGestureViewDelegate>

@property (strong, nonatomic)UITableView *tableView;
@end

@implementation LZNumSettingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (![LZNumberTool isNumberPasswordEnable]) {
        
        [LZNumberTool saveNumberPasswordEnableByUser:NO];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNaviBar];
    [self tableView];
}

- (void)setupNaviBar {
    
    LZWeakSelf(ws)
    [self lzSetNavigationTitle:@"设置数字密码"];
    [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        
        [ws.navigationController popViewControllerAnimated:YES];
    }];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        table.delegate = self;
        table.dataSource = self;
        [self.view addSubview:table];
        _tableView = table;
        
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view).offset(LZNavigationHeight);
        }];
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1&&![[TouchIdUnlock sharedInstance] isTouchIdEnabledOrNotBySystem]) {
        
        return 0;
    }
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([LZNumberTool isNumberPasswordEnableByUser]) {
        
        return 4;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        cell.textLabel.textColor = LZColorFromHex(0x555555);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
//
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        
    }
    
    
    if (indexPath.section == 0) {
        
        UISwitch *sw = [[UISwitch alloc]init];
        [sw addTarget:self action:@selector(switchTurnOn:) forControlEvents:UIControlEventValueChanged];
        sw.on = [LZNumberTool isNumberPasswordEnableByUser];
        cell.accessoryView = sw;
        cell.textLabel.text = @"启用数字密码";
        
    } else if (indexPath.section == 1){
    
        UISwitch *sw = [[UISwitch alloc]init];
        [sw addTarget:self action:@selector(useTouchID:) forControlEvents:UIControlEventValueChanged];
        sw.on = [LZNumberTool isNumberResetEnableByTouchID];
        cell.accessoryView = sw;
        cell.textLabel.text = @"使用指纹重置手势密码";
    
    } else if (indexPath.section == 2){
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ([LZNumberTool isNumberPasswordEnable]) {
            
            cell.textLabel.text = @"修改数字密码";
        } else {
            cell.textLabel.text = @"设置数字密码";
        }
        
    } else {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"忘记数字密码";
    }
    
    return cell;
}

- (void)switchTurnOn:(UISwitch*)sw {
    
    if (sw.on == NO) {
        sw.on = YES;
        
        LZPasswordViewController *psV = [[LZPasswordViewController alloc]init];
        
        [psV showInViewController:self style:LZPasswordStyleVerity];
        
        [psV veritySuccess:^{
            
            sw.on = NO;
            [LZNumberTool saveNumberPasswordEnableByUser:NO];
            [self.tableView reloadData];
        }];
        
    } else {
        
        [LZNumberTool saveNumberPasswordEnableByUser:YES];
        [self.tableView reloadData];
    }
}

- (void)useTouchID:(UISwitch *)ws {
    
    if ([LZNumberTool isNumberResetEnableByTouchID]) {
        
        ws.on = YES;
    } else {
        
        ws.on = NO;
    }
    
    [[TouchIdUnlock sharedInstance] startVerifyTouchID:^{
        
        ws.on = !ws.on;
        [LZNumberTool saveNumberResetEnableByTouchID:ws.on];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        
        LZPasswordViewController *psV = [[LZPasswordViewController alloc]init];
        
        if ([LZNumberTool isNumberPasswordEnable]) {
            
            [psV showInViewController:self style:LZPasswordStyleUpdate];
        } else {
            
            [psV showInViewController:self style:LZPasswordStyleSetting];
        }
    } else if (indexPath.section == 3) {
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        if ([[TouchIdUnlock sharedInstance] isTouchIdEnabledOrNotBySystem]&&[LZNumberTool isNumberResetEnableByTouchID]) {
            
            UIAlertAction *touchID = [UIAlertAction actionWithTitle:@"使用指纹密码重置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[TouchIdUnlock sharedInstance] startVerifyTouchID:^{
                    
                    LZPasswordViewController *psV = [[LZPasswordViewController alloc]init];
                    
                    [psV showInViewController:self style:LZPasswordStyleSetting];
                }];
            }];
            
            [alert addAction:touchID];
        }
        
        if ([LZGestureTool isGestureEnable]) {
            
            UIAlertAction *number = [UIAlertAction actionWithTitle:@"使用手势密码重置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                LZGestureViewController *gesture = [[LZGestureViewController alloc]init];
                
                gesture.delegate = self;
                [gesture showInViewController:self type:LZGestureTypeVerifying];
            }];
            
            [alert addAction:number];
        }
        
        if (![LZGestureTool isGestureEnable]&&
            ![[TouchIdUnlock sharedInstance] isTouchIdEnabledOrNotBySystem]) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告⚠️" message:@"您没有设置手势密码,无法通过手势密码重置!" preferredStyle:UIAlertControllerStyleAlert];
            
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

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return @"说明: \n数字密码作为辅助密码,当您无法使用指纹解锁,又忘记手势密码时,可使用数字密码进行重置手势密码!";
    } else if (section == 1 && [[TouchIdUnlock sharedInstance] isTouchIdEnabledOrNotBySystem]) {
        
        return @"开启后,当您忘记手势密码时,可使用指纹密码来重置数字密码";
    } else if (section == 3) {
        
        if ([[TouchIdUnlock sharedInstance] isTouchIdEnabledOrNotBySystem]) {
            
            return @"如果您使用了手势密码或指纹密码,可使用其中之一来重置数字密码";
        }
        
        return @"如果您使用了手势密码,可使用手势密码重置手势密码";
    }
    
    return nil;
}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (section == 1) {
//        
//        UIView *bgV = [[UIView alloc]init];
//        
//        UILabel *label = [[UILabel alloc]init];
//        label.font = [UIFont systemFontOfSize:14];
//        label.textColor = [UIColor grayColor];
//        label.numberOfLines = 0;
//        label.text = @"说明: \n数字密码可作为辅助密码,当您无法使用指纹解锁,又忘记手势密码时,可使用数字密码进行重置手势密码!";
//        [bgV addSubview:label];
//        
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.edges.mas_equalTo(bgV).insets(UIEdgeInsetsMake(10, 20, 10, 20));
//        }];
//        
//        return bgV;
//    }
//    
//    return nil;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 1&&![[TouchIdUnlock sharedInstance] isTouchIdEnabledOrNotBySystem]) {
        
        return 1.0;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 20.0;
    }
    return 1.0;
}

- (void)gestureViewVerifiedSuccess:(LZGestureViewController *)vc {
    
    LZPasswordViewController *psV = [[LZPasswordViewController alloc]init];
    
    [psV showInViewController:self style:LZPasswordStyleSetting];
    
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
