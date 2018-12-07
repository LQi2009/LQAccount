//
//  LZSettingViewController.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/5/30.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZSettingViewController.h"
#import "LZSettingTableViewCell.h"
#import "AppDelegate.h"

#import "LZAboutusViewController.h"
#import "LZNumSettingViewController.h"
#import "LZGroupViewController.h"
#import "LZGestureSetupViewController.h"
#import "LZiCloudViewController.h"

#import "TouchIdUnlock.h"
#import "LZTouchIDViewController.h"

@interface LZSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)UITableView *myTableView;
@property (strong, nonatomic)NSMutableArray *dataArray;
@end

@implementation LZSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self lzSetNavigationTitle:@"设置"];
    [self myTableView];
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        
        if ([[TouchIdUnlock sharedInstance] isTouchIdEnabledOrNotBySystem]) {
            
            _dataArray = [[NSMutableArray alloc]initWithObjects:@[@"设置手势密码",@"设置数字密码",@"设置TouchID"],@[@"分组管理"],@[@"iCloud同步"],@[@"关于我们"], nil];
        } else {
            
            _dataArray = [[NSMutableArray alloc]initWithObjects:@[@"设置手势密码",@"设置数字密码"],@[@"分组管理"],@[@"iCloud同步"],@[@"关于我们"], nil];
        }
        
//        ,@"设置数字密码"
        
//  ,@[@"开启分组验证",@"开启详情验证",@"开启显示密码验证"]
        //验证选项先不加
    }
    
    return _dataArray;
}

- (UITableView *)myTableView {
    if (_myTableView == nil) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        
        [self.view addSubview:table];
        _myTableView = table;
        
        
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(LZNavigationHeight);
            make.left.right.and.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view).offset(-LZTabBarHeight);
        }];
    }
    
    return _myTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataArray[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 1) {
//        LZSettingTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
//        if (cell == nil) {
//            cell = [[LZSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCell"];
//            cell.textLabel.textColor = LZColorFromHex(0x555555);
//            cell.textLabel.font = [UIFont systemFontOfSize:14];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        
//        NSArray *arr = self.dataArray[indexPath.section];
//        cell.textLabel.text = arr[indexPath.row];
//        return cell;
//    } else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCellID"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCellID"];
            cell.textLabel.textColor = LZColorFromHex(0x555555);
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSArray *arr = self.dataArray[indexPath.section];
        cell.textLabel.text = arr[indexPath.row];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *titles = @[@"安全设置",@"分组管理",@"iCloud设置",@"关于"];
//    NSArray *titles = @[@"安全设置",@"设置验证选项",@"关于"];
    return titles[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [app.sideMenu setMenuState:MFSideMenuStateClosed completion:nil];
    
    UINavigationController *nav = self.navigationController;
    
    if (indexPath.section == 3) {
        
        LZAboutusViewController *about = [[LZAboutusViewController alloc]init];
        
        [nav pushViewController:about animated:YES];
    } else if (indexPath.section == 2) {
        
        LZiCloudViewController *icloud = [[LZiCloudViewController alloc]init];
        
        [nav pushViewController:icloud animated:YES];
    } else if (indexPath.section == 1){
        
        LZGroupViewController *group = [[LZGroupViewController alloc]init];
        
        group.flog = @"setting";
        [nav pushViewController:group animated:YES];
//        [self presentViewController:group animated:YES completion:nil];
    } else {
        
        switch (indexPath.row) {
            case 0:
            {
                LZGestureSetupViewController *gesture = [[LZGestureSetupViewController alloc]init];
                [nav pushViewController:gesture animated:YES];
            } break;
            case 1:
            {
                LZNumSettingViewController *number = [[LZNumSettingViewController alloc]init];
                
                [nav pushViewController:number animated:YES];
            } break;
            case 2:
            {
                LZTouchIDViewController *vc = [[LZTouchIDViewController alloc]init];
                [nav pushViewController:vc animated:YES];
            } break;
            default:
                break;
        }
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
